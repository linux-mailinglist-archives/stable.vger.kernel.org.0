Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B98F418967
	for <lists+stable@lfdr.de>; Sun, 26 Sep 2021 16:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhIZOX4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Sep 2021 10:23:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:42080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231743AbhIZOX4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 26 Sep 2021 10:23:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2CF360FDC
        for <stable@vger.kernel.org>; Sun, 26 Sep 2021 14:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632666139;
        bh=JZiOmeMEne0+ieeZRx/tw5/jDice06r2mrsqT8Ypo6c=;
        h=From:To:Subject:Date:From;
        b=enDXDKHyu+1XLdR5+a0d2qH9Cpb+Y9Zj+dI0Nu7+MdtigukB4yZdlg8+A0HOVwU14
         KHdl+olEaK8Hf0orV4Av9RGzcxlx67I293qgefMDYJjui0iK4tkzK6hZ/mT3E8FD3W
         DhEP7keNyKrKEDQ3QQh01YdDUwlF7Y2kxiAOCmu6DoTm2pLax7Noe2P1rFT2zwwltk
         BxBqmmkEwZFmCboCm5kSy5Br6NkFK5n6b33lHAilxvdj4kei80E8/Iuc3c1VUOyNwV
         Vfy9+z3wDYCydbmjOC+x1y3jLqmFRT4S0uX/Tq7xAASdxAiH04bCoytKGoXmt6jSjm
         ZW1BMe+AxtiMg==
Received: by pali.im (Postfix)
        id 89F1A60D; Sun, 26 Sep 2021 16:22:17 +0200 (CEST)
From:   =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>
To:     stable@vger.kernel.org
Subject: [PATCH stable-4.14] PCI: aardvark: Fix checking for PIO Non-posted Request
Date:   Sun, 26 Sep 2021 16:22:11 +0200
Message-Id: <20210926142212.1701-1-pali@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 8ceeac307a79f68c0d0c72d6e48b82fa424204ec upstream.

PIO_NON_POSTED_REQ for PIO_STAT register is incorrectly defined. Bit 10 in
register PIO_STAT indicates the response is to a non-posted request.

Link: https://lore.kernel.org/r/20210624213345.3617-2-pali@kernel.org
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Reviewed-by: Marek Behún <kabel@kernel.org>
Cc: stable@vger.kernel.org
[pali: Backported to 4.14 version]
---
 drivers/pci/host/pci-aardvark.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/host/pci-aardvark.c b/drivers/pci/host/pci-aardvark.c
index f84166f99517..149d7bddb2a4 100644
--- a/drivers/pci/host/pci-aardvark.c
+++ b/drivers/pci/host/pci-aardvark.c
@@ -55,7 +55,7 @@
 #define   PIO_COMPLETION_STATUS_UR		1
 #define   PIO_COMPLETION_STATUS_CRS		2
 #define   PIO_COMPLETION_STATUS_CA		4
-#define   PIO_NON_POSTED_REQ			BIT(0)
+#define   PIO_NON_POSTED_REQ			BIT(10)
 #define PIO_ADDR_LS				(PIO_BASE_ADDR + 0x8)
 #define PIO_ADDR_MS				(PIO_BASE_ADDR + 0xc)
 #define PIO_WR_DATA				(PIO_BASE_ADDR + 0x10)
-- 
2.20.1

