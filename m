Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0CCD4401D
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:03:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388584AbfFMQDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:03:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:35848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731398AbfFMIrl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:47:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 735D021473;
        Thu, 13 Jun 2019 08:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415661;
        bh=ZD4912XdO3f56exXjAn2SQ7/RMqLQmAN1qSZIUfwW0Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E1B4kG05zQDrSxdmL5ARCC9gJPTVu9XE71GDhJXUpzHdv7jsFSPDFavhtRS0uzxdt
         ZYEYDfx+KGtDpKUD3+oTXm7gbk0c2V8jzSTlVHvoCofLZdgxSpVXfcXJbqTeXccpCt
         Clsxef1w1QJFlPf9/kg9OtQPM1p4jyDNxp5MGotY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Valentin Schneider <valentin.schneider@arm.com>,
        Leo Yan <leo.yan@linaro.org>, Olof Johansson <olof@lixom.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 081/155] arm64: defconfig: Update UFSHCD for Hi3660 soc
Date:   Thu, 13 Jun 2019 10:33:13 +0200
Message-Id: <20190613075657.579741315@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 7b3320e6b1795d68b7e30eb3fad0860f2664aedd ]

Commit 7ee7ef24d02d ("scsi: arm64: defconfig: enable configs for Hisilicon ufs")
set 'CONFIG_SCSI_UFS_HISI=y', but the configs it depends
on

  (CONFIG_SCSI_HFSHCD_PLATFORM && CONFIG_SCSI_UFSHCD)

were left to being built as modules.

Commit 1f4fa50dd48f ("arm64: defconfig: Regenerate for v4.20") "fixed"
that by reverting to 'CONFIG_SCSI_UFS_HISI=m'.

Thing is, if the rootfs is stored in the on-board flash (which
is the "canonical" way of doing things), we either need these drivers
to be built-in, or we need to fiddle with an initramfs to access that
flash and eventually load the modules installed over there.

The former is the easiest, do that.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Leo Yan <leo.yan@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/configs/defconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/configs/defconfig b/arch/arm64/configs/defconfig
index 2d9c39033c1a..32fb03503b0b 100644
--- a/arch/arm64/configs/defconfig
+++ b/arch/arm64/configs/defconfig
@@ -222,10 +222,10 @@ CONFIG_BLK_DEV_SD=y
 CONFIG_SCSI_SAS_ATA=y
 CONFIG_SCSI_HISI_SAS=y
 CONFIG_SCSI_HISI_SAS_PCI=y
-CONFIG_SCSI_UFSHCD=m
-CONFIG_SCSI_UFSHCD_PLATFORM=m
+CONFIG_SCSI_UFSHCD=y
+CONFIG_SCSI_UFSHCD_PLATFORM=y
 CONFIG_SCSI_UFS_QCOM=m
-CONFIG_SCSI_UFS_HISI=m
+CONFIG_SCSI_UFS_HISI=y
 CONFIG_ATA=y
 CONFIG_SATA_AHCI=y
 CONFIG_SATA_AHCI_PLATFORM=y
-- 
2.20.1



