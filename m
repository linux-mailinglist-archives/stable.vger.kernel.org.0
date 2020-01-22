Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 182CC14563A
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgAVNXR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:23:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:41400 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729410AbgAVNXQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:23:16 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A4192468A;
        Wed, 22 Jan 2020 13:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699395;
        bh=Gf87LfOv9JacYdKcx/n23gu/OfWb61p8ecz42/mVdus=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2gf7HW723E/WGLK0/iqQWcTzF37FtSH/7NxtMubrFpW5a2ETJhfqchfFkcowMQia4
         wbArYcrWBVkLyfittLITpVhVtaKFyjyMmuJ1OWfyMg16uc9QWCh9SSRFIlK2byY93A
         TXtr7RBd9nzMOfByTKVqyysAfymBlPj1maCKn4aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.4 131/222] netfilter: nf_tables: fix flowtable list del corruption
Date:   Wed, 22 Jan 2020 10:28:37 +0100
Message-Id: <20200122092843.127326322@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

commit 335178d5429c4cee61b58f4ac80688f556630818 upstream.

syzbot reported following crash:

  list_del corruption, ffff88808c9bb000->prev is LIST_POISON2 (dead000000000122)
  [..]
  Call Trace:
   __list_del_entry include/linux/list.h:131 [inline]
   list_del_rcu include/linux/rculist.h:148 [inline]
   nf_tables_commit+0x1068/0x3b30 net/netfilter/nf_tables_api.c:7183
   [..]

The commit transaction list has:

NFT_MSG_NEWTABLE
NFT_MSG_NEWFLOWTABLE
NFT_MSG_DELFLOWTABLE
NFT_MSG_DELTABLE

A missing generation check during DELTABLE processing causes it to queue
the DELFLOWTABLE operation a second time, so we corrupt the list here:

  case NFT_MSG_DELFLOWTABLE:
     list_del_rcu(&nft_trans_flowtable(trans)->list);
     nf_tables_flowtable_notify(&trans->ctx,

because we have two different DELFLOWTABLE transactions for the same
flowtable.  We then call list_del_rcu() twice for the same flowtable->list.

The object handling seems to suffer from the same bug so add a generation
check too and only queue delete transactions for flowtables/objects that
are still active in the next generation.

Reported-by: syzbot+37a6804945a3a13b1572@syzkaller.appspotmail.com
Fixes: 3b49e2e94e6eb ("netfilter: nf_tables: add flow table netlink frontend")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nf_tables_api.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -981,12 +981,18 @@ static int nft_flush_table(struct nft_ct
 	}
 
 	list_for_each_entry_safe(flowtable, nft, &ctx->table->flowtables, list) {
+		if (!nft_is_active_next(ctx->net, flowtable))
+			continue;
+
 		err = nft_delflowtable(ctx, flowtable);
 		if (err < 0)
 			goto out;
 	}
 
 	list_for_each_entry_safe(obj, ne, &ctx->table->objects, list) {
+		if (!nft_is_active_next(ctx->net, obj))
+			continue;
+
 		err = nft_delobj(ctx, obj);
 		if (err < 0)
 			goto out;


