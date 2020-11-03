Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC19A2A5918
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 23:05:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730132AbgKCWEt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 17:04:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730678AbgKCUnQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:43:16 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A21A223AC;
        Tue,  3 Nov 2020 20:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604436196;
        bh=zjRG7D7u1rm0+nJsHPV8BElnQS5qBn3harx2yIna1Xs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQWSzbOy3sU2nOx8hwMmVSM6g6ZbNaQMrieE/miVcf5kBB+l2MxDgmkiWnquD/C+4
         Sm8wEhMU3UB+If5A+ngg6euMG3jUvQTsP/LIeLHuwjKuxCFEy5J7N8ljSABpOpTQEC
         Sjxrils9J85ZLTQBxIu78VSOVb2j1y+jhgqNtoF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 106/391] nfc: s3fwrn5: Add missing CRYPTO_HASH dependency
Date:   Tue,  3 Nov 2020 21:32:37 +0100
Message-Id: <20201103203353.976625694@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203348.153465465@linuxfoundation.org>
References: <20201103203348.153465465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 4aa62c62d4c41d71b2bda5ed01b78961829ee93c ]

The driver uses crypto hash functions so it needs to select CRYPTO_HASH.
This fixes build errors:

  arc-linux-ld: drivers/nfc/s3fwrn5/firmware.o: in function `s3fwrn5_fw_download':
  firmware.c:(.text+0x152): undefined reference to `crypto_alloc_shash'

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nfc/s3fwrn5/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nfc/s3fwrn5/Kconfig b/drivers/nfc/s3fwrn5/Kconfig
index af9d18690afeb..3f8b6da582803 100644
--- a/drivers/nfc/s3fwrn5/Kconfig
+++ b/drivers/nfc/s3fwrn5/Kconfig
@@ -2,6 +2,7 @@
 config NFC_S3FWRN5
 	tristate
 	select CRYPTO
+	select CRYPTO_HASH
 	help
 	  Core driver for Samsung S3FWRN5 NFC chip. Contains core utilities
 	  of chip. It's intended to be used by PHYs to avoid duplicating lots
-- 
2.27.0



