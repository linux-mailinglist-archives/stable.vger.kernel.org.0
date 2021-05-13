Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A89F037FAD0
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:34:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234902AbhEMPfs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:35:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234909AbhEMPfs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:35:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8233613BF;
        Thu, 13 May 2021 15:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620920078;
        bh=0bbyMk8KgnF1UpJB+kPBGsLAQFRMn81W+BopRFtw3io=;
        h=Subject:To:From:Date:From;
        b=qUqw3RnId2JMLBhcsIcordQnUXisQS8uQIdn4ovcCT/orb7lvLNCxEg+TXSx4bLv1
         P+FlQ1C6hnRq2qKCQFNOiiZpLVp91K5f96ida7FjAAgKOXxuCJaFWTTtzj4JJiQxc2
         hbGDxpcqA3grn9OYaz5xI5rJHsnF8DCOg/S0lIZc=
Subject: patch "scsi: ufs: handle cleanup correctly on devm_reset_control_get error" added to char-misc-linus
To:     phil@philpotter.co.uk, avri.altman@wdc.com,
        gregkh@linuxfoundation.org, martin.petersen@oracle.com,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:34:17 +0200
Message-ID: <16209200579030@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    scsi: ufs: handle cleanup correctly on devm_reset_control_get error

to my char-misc git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git
in the char-misc-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 2f4a784f40f8d337d6590e2e93f46429052e15ac Mon Sep 17 00:00:00 2001
From: Phillip Potter <phil@philpotter.co.uk>
Date: Mon, 3 May 2021 13:56:58 +0200
Subject: scsi: ufs: handle cleanup correctly on devm_reset_control_get error

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
 drivers/scsi/ufs/ufs-hisi.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
index 7d1e07a9d9dd..d0626773eb38 100644
--- a/drivers/scsi/ufs/ufs-hisi.c
+++ b/drivers/scsi/ufs/ufs-hisi.c
@@ -467,17 +467,24 @@ static int ufs_hisi_init_common(struct ufs_hba *hba)
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
-- 
2.31.1


