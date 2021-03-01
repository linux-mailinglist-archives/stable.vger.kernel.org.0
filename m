Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB74732870A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 18:20:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235306AbhCARSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 12:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:46226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237032AbhCARMN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 12:12:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23AC165028;
        Mon,  1 Mar 2021 16:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614617014;
        bh=usgMplVX90ivNkRsImqL027UgTVzYrCSbe9iO0GmNVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lUJyJXhFRACaqvIUnR0d4IoBLCoqd0dNoEpGTVK2PmCushZyxtrsTILkm6f9Z1X3L
         2ItDNsk4mdwVeT061NLGokdBPumM06z/EKkPnHiayW0BCfa8RYWS0kcJ2ggCadzqZU
         lrliYG4ZYs3re8fVtJsrXwe+qB5/mUOBXVGI5FhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Josef=20O=C5=A1kera?= <joskera@redhat.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 173/247] r8169: fix jumbo packet handling on RTL8168e
Date:   Mon,  1 Mar 2021 17:13:13 +0100
Message-Id: <20210301161040.131205594@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161031.684018251@linuxfoundation.org>
References: <20210301161031.684018251@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 6cf739131a15e4177e58a1b4f2bede9d5da78552 ]

Josef reported [0] that using jumbo packets fails on RTL8168e.
Aligning the values for register MaxTxPacketSize with the
vendor driver fixes the problem.

[0] https://bugzilla.kernel.org/show_bug.cgi?id=211827

Fixes: d58d46b5d851 ("r8169: jumbo fixes.")
Reported-by: Josef Oškera <joskera@redhat.com>
Tested-by: Josef Oškera <joskera@redhat.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://lore.kernel.org/r/b15ddef7-0d50-4320-18f4-6a3f86fbfd3e@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169.c b/drivers/net/ethernet/realtek/r8169.c
index 6b901bf1cd54d..6fd1a639ec533 100644
--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -4365,7 +4365,7 @@ static void r8168dp_hw_jumbo_disable(struct rtl8169_private *tp)
 
 static void r8168e_hw_jumbo_enable(struct rtl8169_private *tp)
 {
-	RTL_W8(tp, MaxTxPacketSize, 0x3f);
+	RTL_W8(tp, MaxTxPacketSize, 0x24);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) | Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) | 0x01);
 	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_512B);
@@ -4373,7 +4373,7 @@ static void r8168e_hw_jumbo_enable(struct rtl8169_private *tp)
 
 static void r8168e_hw_jumbo_disable(struct rtl8169_private *tp)
 {
-	RTL_W8(tp, MaxTxPacketSize, 0x0c);
+	RTL_W8(tp, MaxTxPacketSize, 0x3f);
 	RTL_W8(tp, Config3, RTL_R8(tp, Config3) & ~Jumbo_En0);
 	RTL_W8(tp, Config4, RTL_R8(tp, Config4) & ~0x01);
 	rtl_tx_performance_tweak(tp, PCI_EXP_DEVCTL_READRQ_4096B);
-- 
2.27.0



