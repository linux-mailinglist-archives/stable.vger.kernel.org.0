Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 781C9D15F6
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbfJIRYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:49516 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731916AbfJIRYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:24:41 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C969A21929;
        Wed,  9 Oct 2019 17:24:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641880;
        bh=AfTVmmdd1JtrLrEZVG/I2M2smUQ/qzHak5qpjOvJ+yk=;
        h=From:To:Cc:Subject:Date:From;
        b=cjD9Xpx/IJjfeY23zI7J+N7pXTzQAKet1SVdCG8BElj2UQYY+qtrDApkj/Kn0b5+f
         eM7cJnUQDOA62Pu9CtiOO4xB6gSJ9lHncg0ioQFGwMheq8EFqczsJtFADwB92shYdn
         cwGzxQaySS0nDS+9DZTTRFlnDUQDM6/Il5lXRs+E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 01/13] scsi: ufs: skip shutdown if hba is not powered
Date:   Wed,  9 Oct 2019 13:06:20 -0400
Message-Id: <20191009170635.536-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

[ Upstream commit f51913eef23f74c3bd07899dc7f1ed6df9e521d8 ]

In some cases, hba may go through shutdown flow without successful
initialization and then make system hang.

For example, if ufshcd_change_power_mode() gets error and leads to
ufshcd_hba_exit() to release resources of the host, future shutdown flow
may hang the system since the host register will be accessed in unpowered
state.

To solve this issue, simply add checking to skip shutdown for above kind of
situation.

Link: https://lore.kernel.org/r/1568780438-28753-1-git-send-email-stanley.chu@mediatek.com
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Acked-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index a9c172692f21d..26f259fb6e3ca 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6492,6 +6492,9 @@ int ufshcd_shutdown(struct ufs_hba *hba)
 {
 	int ret = 0;
 
+	if (!hba->is_powered)
+		goto out;
+
 	if (ufshcd_is_ufs_dev_poweroff(hba) && ufshcd_is_link_off(hba))
 		goto out;
 
-- 
2.20.1

