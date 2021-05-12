Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91BC637C99C
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:48:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhELQUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:20:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233109AbhELQNr (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:13:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DADC161C78;
        Wed, 12 May 2021 15:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834106;
        bh=qnFGewLe+G7YI3yq09BI+wvw0NVkl4hwlP0G17JXMjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1TLapGarbYDijAfeOLA6vWwbUu9SSFXyv8MrotSKe9Af3P8KRfQTtuqjai2tikoX4
         Sbtw4Zngi3/ZAQuTSWY+l6MqfueHDQ0t4A+2tzo805Pjpb1nhONgQOUGBtCZYwKnsu
         8Q6uVIlTWeY1pI/0loEMeRJy4u9C4gk/syC4x0EA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 366/601] scsi: pm80xx: Fix potential infinite loop
Date:   Wed, 12 May 2021 16:47:23 +0200
Message-Id: <20210512144839.854252865@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 40fa7394a1ad5706e795823276f2e394cca145d0 ]

The for-loop iterates with a u8 loop counter i and compares this with the
loop upper limit of pm8001_ha->max_q_num which is a u32 type.  There is a
potential infinite loop if pm8001_ha->max_q_num is larger than the u8 loop
counter. Fix this by making the loop counter the same type as
pm8001_ha->max_q_num.

[mkp: this is purely theoretical, max_q_num is currently limited to 64]

Link: https://lore.kernel.org/r/20210407135840.494747-1-colin.king@canonical.com
Fixes: 65df7d1986a1 ("scsi: pm80xx: Fix chip initialization failure")
Addresses-Coverity: ("Infinite loop")
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm8001_hwi.c
index 6fa739c92beb..a28813d2683a 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -643,7 +643,7 @@ static void init_pci_device_addresses(struct pm8001_hba_info *pm8001_ha)
  */
 static int pm8001_chip_init(struct pm8001_hba_info *pm8001_ha)
 {
-	u8 i = 0;
+	u32 i = 0;
 	u16 deviceid;
 	pci_read_config_word(pm8001_ha->pdev, PCI_DEVICE_ID, &deviceid);
 	/* 8081 controllers need BAR shift to access MPI space
-- 
2.30.2



