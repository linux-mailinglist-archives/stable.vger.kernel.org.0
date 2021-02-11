Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3343318E6C
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhBKP0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230438AbhBKPWi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:22:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 68E3C64F3B;
        Thu, 11 Feb 2021 15:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613056049;
        bh=oJfyoLsy9Z5KwuKPh05Zd9pPRALtStDgdIMxx2am3yQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQx8d/GD1kpGSoCvXLOwl/7jlA5X93tGTtXHYvdPYAEPGZ+uYuC4+vta5fw/FO+AN
         GusEpc/hb8ZeZZrXvZHFQO2ELzRM/LorC8HRf5gXQod4LXvQEOweqYQrmpdzME0tSN
         HTZbivX8F5jhX0AVxkEBcfnCOmX40YjimJmU7FhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 08/24] chtls: Fix potential resource leak
Date:   Thu, 11 Feb 2021 16:02:42 +0100
Message-Id: <20210211150148.119070392@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150147.743660073@linuxfoundation.org>
References: <20210211150147.743660073@linuxfoundation.org>
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
 drivers/crypto/chelsio/chtls/chtls_cm.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/crypto/chelsio/chtls/chtls_cm.c b/drivers/crypto/chelsio/chtls/chtls_cm.c
index fd3092a4378e4..08ed3ff8b255f 100644
--- a/drivers/crypto/chelsio/chtls/chtls_cm.c
+++ b/drivers/crypto/chelsio/chtls/chtls_cm.c
@@ -1051,11 +1051,9 @@ static struct sock *chtls_recv_sock(struct sock *lsk,
 	tcph = (struct tcphdr *)(iph + 1);
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



