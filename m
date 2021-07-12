Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2044C3C5505
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347094AbhGLIIq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:44252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1348540AbhGLH5z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:57:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C62261879;
        Mon, 12 Jul 2021 07:52:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076367;
        bh=LJbD7DrUYPmRZAMlDFkz4WBP7lE88JkaDf4HFPrxDdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BanBOhyInTW1Y152MM/nXMaM8q2c0PpwTkNijmAJQXQ4WLoQBhguQyVONemo89NOX
         C+XeCGySI0s9ELWAOS6adxxxd1uqU+UcQIvvYdUdKBvI7Rnvcuhnp0fv1iQZbkZylw
         UwIEIL6Ll+9HTRmaQaHGk7Tva/dN2syvZoZRXKEg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lior Nahmanson <liorna@nvidia.com>,
        Antoine Tenart <atenart@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 570/800] net: phy: mscc: fix macsec key length
Date:   Mon, 12 Jul 2021 08:09:53 +0200
Message-Id: <20210712061028.046164014@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Antoine Tenart <atenart@kernel.org>

[ Upstream commit c309217f91f2d2097c2a0a832d9bff50b88c81dc ]

The key length used to store the macsec key was set to MACSEC_KEYID_LEN
(16), which is an issue as:
- This was never meant to be the key length.
- The key length can be > 16.

Fix this by using MACSEC_MAX_KEY_LEN instead (the max length accepted in
uAPI).

Fixes: 28c5107aa904 ("net: phy: mscc: macsec support")
Reported-by: Lior Nahmanson <liorna@nvidia.com>
Signed-off-by: Antoine Tenart <atenart@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/mscc/mscc_macsec.c | 2 +-
 drivers/net/phy/mscc/mscc_macsec.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/mscc/mscc_macsec.c b/drivers/net/phy/mscc/mscc_macsec.c
index 10be266e48e8..b7b2521c73fb 100644
--- a/drivers/net/phy/mscc/mscc_macsec.c
+++ b/drivers/net/phy/mscc/mscc_macsec.c
@@ -501,7 +501,7 @@ static u32 vsc8584_macsec_flow_context_id(struct macsec_flow *flow)
 }
 
 /* Derive the AES key to get a key for the hash autentication */
-static int vsc8584_macsec_derive_key(const u8 key[MACSEC_KEYID_LEN],
+static int vsc8584_macsec_derive_key(const u8 key[MACSEC_MAX_KEY_LEN],
 				     u16 key_len, u8 hkey[16])
 {
 	const u8 input[AES_BLOCK_SIZE] = {0};
diff --git a/drivers/net/phy/mscc/mscc_macsec.h b/drivers/net/phy/mscc/mscc_macsec.h
index 9c6d25e36de2..453304bae778 100644
--- a/drivers/net/phy/mscc/mscc_macsec.h
+++ b/drivers/net/phy/mscc/mscc_macsec.h
@@ -81,7 +81,7 @@ struct macsec_flow {
 	/* Highest takes precedence [0..15] */
 	u8 priority;
 
-	u8 key[MACSEC_KEYID_LEN];
+	u8 key[MACSEC_MAX_KEY_LEN];
 
 	union {
 		struct macsec_rx_sa *rx_sa;
-- 
2.30.2



