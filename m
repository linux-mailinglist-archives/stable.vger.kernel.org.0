Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACA1F37CDF1
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:16:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343757AbhELQ7W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:59:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243919AbhELQmO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F07C61998;
        Wed, 12 May 2021 16:08:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835698;
        bh=8eLJmLZTNlA0xGW4L8I/apdPvAqzjJcA/wNW2WCKOC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4gZSQfl8osbQFiFjpQUWlcyp51fxqQTDGYRRpEfiZYTRauzAaBPhkzJnAZ+UezB9
         SEGOPugILy82zTs+djKiHPVAvnnS6jIHsQH3LEaZmCsV42uTk7N2O/LlxiRBcUIOko
         I8OVlBGXk2YSku6baVrSRme4g9cfvQ1I1oMQQDNo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 414/677] scsi: pm80xx: Fix potential infinite loop
Date:   Wed, 12 May 2021 16:47:40 +0200
Message-Id: <20210512144851.098772950@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
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
index 31e5455d280c..1b1a57f46989 100644
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



