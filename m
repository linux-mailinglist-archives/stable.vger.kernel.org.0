Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E774B38EE2C
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 17:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhEXPqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 11:46:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234620AbhEXPo0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 11:44:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4A4961477;
        Mon, 24 May 2021 15:35:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621870558;
        bh=c8SxYsRbdVuXVwyVy75nz6WNVPnfR4DJEfxVWeSLjlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WJj72b6nsCONFsQrInD8syc6cxWY6Z+z52PXFtjcRN1uA/mlCiD7KAZzVhqzw6CZQ
         z+KW1G0oPS5v5fKPioRgkBlhNMIkWxEja9oTT8tHMZOKbzjHOzOlQ8s+FOtTzBwDj/
         VZycKQkkAqNxiU0aek09MeGADT/LWYYAKtYfuHeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Phillip Potter <phil@philpotter.co.uk>
Subject: [PATCH 4.19 41/49] scsi: ufs: handle cleanup correctly on devm_reset_control_get error
Date:   Mon, 24 May 2021 17:25:52 +0200
Message-Id: <20210524152325.695743765@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152324.382084875@linuxfoundation.org>
References: <20210524152324.382084875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Phillip Potter <phil@philpotter.co.uk>

commit 2f4a784f40f8d337d6590e2e93f46429052e15ac upstream.

Move ufshcd_set_variant call in ufs_hisi_init_common to common error
section at end of the function, and then jump to this from the error
checking statements for both devm_reset_control_get and
ufs_hisi_get_resource. This fixes the original commit (63a06181d7ce)
which was reverted due to the University of Minnesota problems.

Suggested-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
Link: https://lore.kernel.org/r/20210503115736.2104747-32-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/ufs/ufs-hisi.c |   17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -543,17 +543,24 @@ static int ufs_hisi_init_common(struct u
 	host->hba = hba;
 	ufshcd_set_variant(hba, host);
 
-	host->rst  = devm_reset_control_get(dev, "rst");
+	host->rst = devm_reset_control_get(dev, "rst");
+	if (IS_ERR(host->rst)) {
+		dev_err(dev, "%s: failed to get reset control\n", __func__);
+		err = PTR_ERR(host->rst);
+		goto error;
+	}
 
 	ufs_hisi_set_pm_lvl(hba);
 
 	err = ufs_hisi_get_resource(host);
-	if (err) {
-		ufshcd_set_variant(hba, NULL);
-		return err;
-	}
+	if (err)
+		goto error;
 
 	return 0;
+
+error:
+	ufshcd_set_variant(hba, NULL);
+	return err;
 }
 
 static int ufs_hi3660_init(struct ufs_hba *hba)


