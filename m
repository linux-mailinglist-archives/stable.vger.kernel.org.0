Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54AF0344165
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:33:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231477AbhCVMdO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:33:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:54886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230348AbhCVMcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:32:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 03AE96199E;
        Mon, 22 Mar 2021 12:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416335;
        bh=L7TxcvBoM1NEOjd7A/Vzd5wCCjpU+SvXpVi8054KYyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fhC5GdstRvv2l4sJqSv0O33pRrZmK9RbtGIGAwJgBpef8lX2tiQNMivzp9idJt7Ro
         Q0ugATQqy+iacG3CL8KGCUUj6/BQmpM7IjJB5gaaRWBVRQHbp8WPVDVh/umRc8BDYe
         5GyrrgBRa5cIdcHuMUlS2TSg1zAQDH8RZ/1GYje4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        dongjian <dongjian@yulong.com>, Yue Hu <huyue2@yulong.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.11 066/120] scsi: ufs: ufs-mediatek: Correct operator & -> &&
Date:   Mon, 22 Mar 2021 13:27:29 +0100
Message-Id: <20210322121931.880167688@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: dongjian <dongjian@yulong.com>

commit 0fdc7d5d8f3719950478cca452cf7f0f1355be10 upstream.

The "lpm" and "->enabled" are all boolean. We should be using &&
rather than the bit operator.

Link: https://lore.kernel.org/r/1615896915-148864-1-git-send-email-dj0227@163.com
Fixes: 488edafb1120 ("scsi: ufs-mediatek: Introduce low-power mode for device power supply")
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: dongjian <dongjian@yulong.com>
Signed-off-by: Yue Hu <huyue2@yulong.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-mediatek.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufs-mediatek.c
+++ b/drivers/scsi/ufs/ufs-mediatek.c
@@ -911,7 +911,7 @@ static void ufs_mtk_vreg_set_lpm(struct
 	if (!hba->vreg_info.vccq2 || !hba->vreg_info.vcc)
 		return;
 
-	if (lpm & !hba->vreg_info.vcc->enabled)
+	if (lpm && !hba->vreg_info.vcc->enabled)
 		regulator_set_mode(hba->vreg_info.vccq2->reg,
 				   REGULATOR_MODE_IDLE);
 	else if (!lpm)


