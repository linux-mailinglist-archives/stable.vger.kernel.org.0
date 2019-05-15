Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6022F1F0E0
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731050AbfEOLXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:23:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:34342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731719AbfEOLXv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:23:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F14622089E;
        Wed, 15 May 2019 11:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919430;
        bh=Th/uojqknXw/gYmff2+5+Z5x0G5vVyhroDrFNnzDGc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nrzm5A4rYF7AXo7KTwE0WsOylCoHdYmQsirdpOcalTJ58T3tGdIVwmEt2K8oOBI7e
         SWUEU1NZhxU0RWkMgpStOkBsExt2Yf3OA33rAwBQcEGKBpb2WknIrUOBivdRdi4mBU
         hSgTpCbvqQW3ATjVQ9+3ECtwdpYgSfn1xwRopsaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.19 071/113] netfilter: nf_tables: add missing ->release_ops() in error path of newrule()
Date:   Wed, 15 May 2019 12:56:02 +0200
Message-Id: <20190515090658.915490527@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090652.640988966@linuxfoundation.org>
References: <20190515090652.640988966@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b25a31bf0ca091aa8bdb9ab329b0226257568bbe ]

->release_ops() callback releases resources and this is used in error path.
If nf_tables_newrule() fails after ->select_ops(), it should release
resources. but it can not call ->destroy() because that should be called
after ->init().
At this point, ->release_ops() should be used for releasing resources.

Test commands:
   modprobe -rv xt_tcpudp
   iptables-nft -I INPUT -m tcp   <-- error command
   lsmod

Result:
   Module                  Size  Used by
   xt_tcpudp              20480  2      <-- it should be 0

Fixes: b8e204006340 ("netfilter: nft_compat: use .release_ops and remove list of extension")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 net/netfilter/nf_tables_api.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ef7ff13a7b992..ebfcfe1dcbdbb 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2719,8 +2719,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	nf_tables_rule_release(&ctx, rule);
 err1:
 	for (i = 0; i < n; i++) {
-		if (info[i].ops != NULL)
+		if (info[i].ops) {
 			module_put(info[i].ops->type->owner);
+			if (info[i].ops->type->release_ops)
+				info[i].ops->type->release_ops(info[i].ops);
+		}
 	}
 	kvfree(info);
 	return err;
-- 
2.20.1



