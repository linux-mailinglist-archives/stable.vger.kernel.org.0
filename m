Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 870C0318E67
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbhBKP0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:50520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230147AbhBKPJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:09:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A3DC64ED6;
        Thu, 11 Feb 2021 15:03:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055835;
        bh=ECBiNusZ6x2h9HYHwiSqB6jmDGduRAqvrEGM7641/rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oP+152q9bCj59ToDlPjvr0jMbPEZrrqOkJV6UgpTz3GFtj1AL7165FAZt7b0GDwh9
         4RQ3Nc5acuQPhihqpUmq+xxBhfrDO0X/X4lbMwbpMO8u8ieg8F3iNvIso+qRTfEBe9
         LkAq5YT1/oZZNLyw+vTtMaf01nXYwRcBN/UYnzXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 25/54] chtls: Fix potential resource leak
Date:   Thu, 11 Feb 2021 16:02:09 +0100
Message-Id: <20210211150153.975475316@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

[ Upstream commit b6011966ac6f402847eb5326beee8da3a80405c7 ]

The dst entry should be released if no neighbour is found. Goto label
free_dst to fix the issue. Besides, the check of ndev against NULL is
redundant.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Link: https://lore.kernel.org/r/20210121145738.51091-1-bianpan2016@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c    | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
index 5beec901713fb..a262c949ed76b 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/chtls/chtls_cm.c
@@ -1158,11 +1158,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 #endif
 	}
 	if (!n || !n->dev)
-		goto free_sk;
+		goto free_dst;
 
 	ndev = n->dev;
-	if (!ndev)
-		goto free_dst;
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
@@ -1249,7 +1247,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 free_csk:
 	chtls_sock_release(&csk->kref);
 free_dst:
-	neigh_release(n);
+	if (n)
+		neigh_release(n);
 	dst_release(dst);
 free_sk:
 	inet_csk_prepare_forced_close(newsk);
-- 
2.27.0



