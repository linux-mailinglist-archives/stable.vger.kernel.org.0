Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669442F9F8C
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403889AbhARM1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:39804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390840AbhARLpv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDAD022DA7;
        Mon, 18 Jan 2021 11:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970326;
        bh=HADbE/FakHhDROn6NwYgWzHwVLKZoc+x1p5oAFGp8Xg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RoHJFuhpyNh3GsANg98h7wxd4uruwZKLdseEXoqP6b7s3VGrHC5MJkvUxy6BvnLDL
         m/wh0FUwD6GKStbeaw5L0Gt/mZlSMQdjQzf4ojquQ9tclnhqpQnN9jtsOBtEQX4+5a
         /EBZMHple+ErmL56rdTq/r5iS0m4SznmhYxuso7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chaotian Jing <chaotian.jing@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.10 131/152] scsi: ufs: Fix possible power drain during system suspend
Date:   Mon, 18 Jan 2021 12:35:06 +0100
Message-Id: <20210118113359.004000857@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stanley Chu <stanley.chu@mediatek.com>

commit 1d53864c3617f5235f891ca0fbe9347c4cd35d46 upstream.

Currently if device needs to do flush or BKOP operations, the device VCC
power is kept during runtime-suspend period.

However, if system suspend is happening while device is runtime-suspended,
such power may not be disabled successfully.

The reasons may be,

1. If current PM level is the same as SPM level, device will keep
   runtime-suspended by ufshcd_system_suspend().

2. Flush recheck work may not be scheduled successfully during system
   suspend period. If it can wake up the system, this is also not the
   intention of the recheck work.

To fix this issue, simply runtime-resume the device if the flush is allowed
during runtime suspend period. Flush capability will be disabled while
leaving runtime suspend, and also not be allowed in system suspend period.

Link: https://lore.kernel.org/r/20201222072905.32221-2-stanley.chu@mediatek.com
Fixes: 51dd905bd2f6 ("scsi: ufs: Fix WriteBooster flush during runtime suspend")
Reviewed-by: Chaotian Jing <chaotian.jing@mediatek.com>
Reviewed-by: Can Guo <cang@codeaurora.org>
Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -8818,7 +8818,8 @@ int ufshcd_system_suspend(struct ufs_hba
 	if ((ufs_get_pm_lvl_to_dev_pwr_mode(hba->spm_lvl) ==
 	     hba->curr_dev_pwr_mode) &&
 	    (ufs_get_pm_lvl_to_link_pwr_state(hba->spm_lvl) ==
-	     hba->uic_link_state))
+	     hba->uic_link_state) &&
+	     !hba->dev_info.b_rpm_dev_flush_capable)
 		goto out;
 
 	if (pm_runtime_suspended(hba->dev)) {


