Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0BD15C1CA
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 16:26:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387575AbgBMP03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 10:26:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387564AbgBMP02 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:26:28 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 22D3420661;
        Thu, 13 Feb 2020 15:26:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607588;
        bh=+8K9qALO+PnHir5xlA2IA3S4gSUrvcUcxgqPV0CBVvc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jsWRGKSkcQQ2IU5ek20Bk6EoO6YQEn9pLLuXnni1UJCus9Qjpa7hZLrMyY+pjDYy8
         gmdVW+7FnWRTD7KC09mi3PipahLPldERUVFTp79HMJqYxrencecSU7Nl8t2DRi4Zyx
         k8aqb3TPUo58DLAKl1T0Zj1eieoezCHsjuUXVpLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.19 07/52] scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
Date:   Thu, 13 Feb 2020 07:20:48 -0800
Message-Id: <20200213151813.630401481@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151810.331796857@linuxfoundation.org>
References: <20200213151810.331796857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

commit b9fc5320212efdfb4e08b825aaa007815fd11d16 upstream.

A non-zero error value likely being returned by ufshcd_scsi_add_wlus() in
case of failure of adding the WLs, but ufshcd_probe_hba() doesn't use this
value, and doesn't report this failure to upper caller.  This patch is to
fix this issue.

Fixes: 2a8fa600445c ("ufs: manually add well known logical units")
Link: https://lore.kernel.org/r/20200120130820.1737-2-huobean@gmail.com
Reviewed-by: Asutosh Das <asutoshd@codeaurora.org>
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/ufs/ufshcd.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6685,7 +6685,8 @@ static int ufshcd_probe_hba(struct ufs_h
 			ufshcd_init_icc_levels(hba);
 
 		/* Add required well known logical units to scsi mid layer */
-		if (ufshcd_scsi_add_wlus(hba))
+		ret = ufshcd_scsi_add_wlus(hba);
+		if (ret)
 			goto out;
 
 		/* Initialize devfreq after UFS device is detected */


