Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99FB45BC2D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:23:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242696AbhKXM0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:26:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:42146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245170AbhKXMYo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:24:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3DD466120D;
        Wed, 24 Nov 2021 12:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756126;
        bh=lRPTUS005ve+oBZofRJLmAVkhHWw52d0yc4ha8/kfyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wEGG4WR59kwNShwbxY3TX/TMTXKQHsnvkrrRgwSkCOjSmSVyaduLAQg0zr9b6UhWU
         KHKBxieos3IQrgVpCpDnSA9S4ek4mOE8oj2xPQLfxqybvfum3vqma2yzaPjaeSTZx5
         WnhwaHNuCdrdkjD2inEKa8a5xD4qvwBlUlLq2xIM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 181/207] net: bnx2x: fix variable dereferenced before check
Date:   Wed, 24 Nov 2021 12:57:32 +0100
Message-Id: <20211124115709.834270267@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115703.941380739@linuxfoundation.org>
References: <20211124115703.941380739@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit f8885ac89ce310570e5391fe0bf0ec9c7c9b4fdc ]

Smatch says:
	bnx2x_init_ops.h:640 bnx2x_ilt_client_mem_op()
	warn: variable dereferenced before check 'ilt' (see line 638)

Move ilt_cli variable initialization _after_ ilt validation, because
it's unsafe to deref the pointer before validation check.

Fixes: 523224a3b3cd ("bnx2x, cnic, bnx2i: use new FW/HSI")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
index 1835d2e451c01..fc7fce642666c 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_init_ops.h
@@ -635,11 +635,13 @@ static int bnx2x_ilt_client_mem_op(struct bnx2x *bp, int cli_num,
 {
 	int i, rc;
 	struct bnx2x_ilt *ilt = BP_ILT(bp);
-	struct ilt_client_info *ilt_cli = &ilt->clients[cli_num];
+	struct ilt_client_info *ilt_cli;
 
 	if (!ilt || !ilt->lines)
 		return -1;
 
+	ilt_cli = &ilt->clients[cli_num];
+
 	if (ilt_cli->flags & (ILT_CLIENT_SKIP_INIT | ILT_CLIENT_SKIP_MEM))
 		return 0;
 
-- 
2.33.0



