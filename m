Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 80412EA149
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 17:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbfJ3QA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 12:00:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:56368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727862AbfJ3Pyu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Oct 2019 11:54:50 -0400
Received: from sasha-vm.mshome.net (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E1E12173E;
        Wed, 30 Oct 2019 15:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572450889;
        bh=X39QoiUNcdlxe6a7mbnH/4RYg5FRPgmaxjD8Yo95tP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bsvL9ldCpr87VcF0s/5MiUTSPDMS1U61ofwdwrGS+6jdzylbtMxq3zN4Knozp1GDJ
         feVcmyZrfx0nkVKP9hCF6cipHKP9LMG/Sg0P2jkj2HeVcCRUpG3mMXlSfjbRz7f+xz
         VbI1vaV8pqff8WwSviGIuzZsQXGAb/TgF9auhbsE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Bogendoerfer <tbogendoerfer@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 17/38] scsi: fix kconfig dependency warning related to 53C700_LE_ON_BE
Date:   Wed, 30 Oct 2019 11:53:45 -0400
Message-Id: <20191030155406.10109-17-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191030155406.10109-1-sashal@kernel.org>
References: <20191030155406.10109-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Bogendoerfer <tbogendoerfer@suse.de>

[ Upstream commit 8cbf0c173aa096dda526d1ccd66fc751c31da346 ]

When building a kernel with SCSI_SNI_53C710 enabled, Kconfig warns:

WARNING: unmet direct dependencies detected for 53C700_LE_ON_BE
  Depends on [n]: SCSI_LOWLEVEL [=y] && SCSI [=y] && SCSI_LASI700 [=n]
  Selected by [y]:
  - SCSI_SNI_53C710 [=y] && SCSI_LOWLEVEL [=y] && SNI_RM [=y] && SCSI [=y]

Add the missing depends SCSI_SNI_53C710 to 53C700_LE_ON_BE to fix it.

Link: https://lore.kernel.org/r/20191009151128.32411-1-tbogendoerfer@suse.de
Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 7c097006c54db..a8ac480276323 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -862,7 +862,7 @@ config SCSI_SNI_53C710
 
 config 53C700_LE_ON_BE
 	bool
-	depends on SCSI_LASI700
+	depends on SCSI_LASI700 || SCSI_SNI_53C710
 	default y
 
 config SCSI_STEX
-- 
2.20.1

