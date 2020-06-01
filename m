Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012C51EAC3B
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731800AbgFASRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:17:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:38322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731256AbgFASRP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:17:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F1CA206E2;
        Mon,  1 Jun 2020 18:17:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035435;
        bh=Q+bRuituz91riDfVExULSdjxiY/t16izRsR7ZhFvuOc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k/zkmG1ffpUSP5pdwyoWKCmP+xsJebeftDmUmaOLI5Tu9onqcz3df1XY1TxPDq1n+
         aYHy/DkKQz8xMFdbFY3RGl4nR8Vy55WkEX9yl+Y4UsSULcG6Apg0bTvDW5E4N/Fp8n
         ABqgv9yx72ip40EtpBKpCO1AlpbSfAUfJF/S5XsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.6 157/177] netfilter: nfnetlink_cthelper: unbreak userspace helper support
Date:   Mon,  1 Jun 2020 19:54:55 +0200
Message-Id: <20200601174101.415428279@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 703acd70f2496537457186211c2f03e792409e68 upstream.

Restore helper data size initialization and fix memcopy of the helper
data size.

Fixes: 157ffffeb5dc ("netfilter: nfnetlink_cthelper: reject too large userspace allocation requests")
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/netfilter/nfnetlink_cthelper.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netfilter/nfnetlink_cthelper.c
+++ b/net/netfilter/nfnetlink_cthelper.c
@@ -103,7 +103,7 @@ nfnl_cthelper_from_nlattr(struct nlattr
 	if (help->helper->data_len == 0)
 		return -EINVAL;
 
-	nla_memcpy(help->data, nla_data(attr), sizeof(help->data));
+	nla_memcpy(help->data, attr, sizeof(help->data));
 	return 0;
 }
 
@@ -240,6 +240,7 @@ nfnl_cthelper_create(const struct nlattr
 		ret = -ENOMEM;
 		goto err2;
 	}
+	helper->data_len = size;
 
 	helper->flags |= NF_CT_HELPER_F_USERSPACE;
 	memcpy(&helper->tuple, tuple, sizeof(struct nf_conntrack_tuple));


