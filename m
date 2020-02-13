Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F78F15C6AB
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 17:12:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388282AbgBMQCl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 11:02:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:37798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728316AbgBMPYZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 10:24:25 -0500
Received: from localhost (unknown [104.132.1.104])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96022246B5;
        Thu, 13 Feb 2020 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581607464;
        bh=BEYeYSxuYmpToPR07BBAl6RW6YSE4xomtz0yxKKWWSI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JmhOBe0Mbh19aJ1Jll/tt40uvoiSW71AGM1kb5tcaUYJh1CwiMtB+ljbzfRWxCVGm
         QKPT9R1nkWy2gfr3+B2m5Hut/2ornGf3CYrdbj3V7UQ3Z2MWPBgbduIuoLJKs/Osv/
         Solit7X5Gn2mCGbcK3ZKB/Q3qw6OiBfK0Decl6s4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Asutosh Das <asutoshd@codeaurora.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4.9 099/116] scsi: ufs: Fix ufshcd_probe_hba() reture value in case ufshcd_scsi_add_wlus() fails
Date:   Thu, 13 Feb 2020 07:20:43 -0800
Message-Id: <20200213151921.087795846@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200213151842.259660170@linuxfoundation.org>
References: <20200213151842.259660170@linuxfoundation.org>
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
@@ -5347,7 +5347,8 @@ static int ufshcd_probe_hba(struct ufs_h
 			ufshcd_init_icc_levels(hba);
 
 		/* Add required well known logical units to scsi mid layer */
-		if (ufshcd_scsi_add_wlus(hba))
+		ret = ufshcd_scsi_add_wlus(hba);
+		if (ret)
 			goto out;
 
 		scsi_scan_host(hba->host);


