Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3579034422A
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231597AbhCVMjO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:39:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232012AbhCVMhZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:37:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 591CD619A5;
        Mon, 22 Mar 2021 12:37:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416625;
        bh=i79ZghL5uzfZhM46bDTvgwmNqDCj6BC4tNNwJsEtxrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yLNPryD/Lr3cH+Wf0EZ7cDcsdRkE1lGgFmzO+SB94feHrHORSwayA3gu29dkSzn5P
         xvrIC/Is9pwQsJPjcDJKdFS8u+Tq30izLcV047u1DQkRHCzvWin6M+lLGQfbjry9LU
         W8yQEmbLTEQsNHrGKFtCeB3EDZnmyNebyQvMWm7w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        dongjian <dongjian@yulong.com>, Yue Hu <huyue2@yulong.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 058/157] scsi: ufs: ufs-mediatek: Correct operator & -> &&
Date:   Mon, 22 Mar 2021 13:26:55 +0100
Message-Id: <20210322121935.590470655@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
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
@@ -813,7 +813,7 @@ static void ufs_mtk_vreg_set_lpm(struct
 	if (!hba->vreg_info.vccq2 || !hba->vreg_info.vcc)
 		return;
 
-	if (lpm & !hba->vreg_info.vcc->enabled)
+	if (lpm && !hba->vreg_info.vcc->enabled)
 		regulator_set_mode(hba->vreg_info.vccq2->reg,
 				   REGULATOR_MODE_IDLE);
 	else if (!lpm)


