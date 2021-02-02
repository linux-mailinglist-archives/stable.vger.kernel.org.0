Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028F330C483
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 16:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235865AbhBBPyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 10:54:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:39434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234314AbhBBPMZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 10:12:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 872EE64F83;
        Tue,  2 Feb 2021 15:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612278418;
        bh=Xoc3D3Vb9QytZoLID/45JrYSj/6qztyL6T52HDnzfL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7BCvTFPxIKAV7uWXKBwrExnfjFqErGgmZ6DoP0CN7wL8wRh+GB6v6O5fEIlK1tgj
         mGUAEKcg7iQatOr5Y9aDnpnykHxaLaKuqtaS+LHkQCjT/E7SpQd5zxoZrpy1tvCxlW
         IA2F6ZKRU6AWBOx8/AliFoypwTEspVnFwVtYiutauCFlge4WXbMY4QfoyrLGAL94JZ
         tY6Gyc9jPPcvM8wsAmNG+daIp23B1TVnUHkJjHsy79IflROzRiBI8Gc81j8eUNefma
         l4pnRXRfh1JiJZ5VLhsBtOLv+Lvvzqe4RLBeLX70c5gdCVb3TtEeB4iSYulTUfuSZL
         I9Tv/tY4EzWhA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pan Bian <bianpan2016@163.com>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 05/17] chtls: Fix potential resource leak
Date:   Tue,  2 Feb 2021 10:06:39 -0500
Message-Id: <20210202150651.1864426-5-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210202150651.1864426-1-sashal@kernel.org>
References: <20210202150651.1864426-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
 drivers/crypto/chelsio/chtls/chtls_cm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index eddc6d1bdb2d1..82b76df43ae57 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1047,11 +1047,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 
 	n = dst_neigh_lookup(dst, &iph->saddr);
 	if (!n || !n->dev)
-		goto free_sk;
+		goto free_dst;
 
 	ndev = n->dev;
-	if (!ndev)
-		goto free_dst;
 	if (is_vlan_dev(ndev))
 		ndev = vlan_dev_real_dev(ndev);
 
@@ -1117,7 +1115,8 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
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

