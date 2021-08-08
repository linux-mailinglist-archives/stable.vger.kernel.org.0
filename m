Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96D263E3981
	for <lists+stable@lfdr.de>; Sun,  8 Aug 2021 09:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230515AbhHHHnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Aug 2021 03:43:25 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:38661 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbhHHHnZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 8 Aug 2021 03:43:25 -0400
Received: by mail-lf1-f43.google.com with SMTP id x27so4660015lfu.5;
        Sun, 08 Aug 2021 00:43:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xaUXR1M3JrHIdKjUj68yVCDcrvnHzz2hp1oLUNxXisE=;
        b=hU3nzM/HnbR0jjsVtFxY2pNwVpSMCAAjASJQzvvJZ8VQQeQZMUGt8VuKLRPfswTFHN
         jy7HbAMbyjUuibYMJVL/cKxLkWYKV1EDy6/KRyNFT41jtSMSjpVxDqDf47MdeWGklLKL
         JssoKU4Viql7Ar7NaB09qGY6bliC4Q7Oj2Fde+yYN453A/ErU6wnLNQEQ3i4XdpPdjzM
         PCFndtvkL+CP7dsKEakLT4d88bu92RptF9XiwVQEMlTnMHaFq4l2svPIvVR0MRydCnSV
         5rxL/4wuNQ9nmw6Nkr75vuN8stofJNSG8JfzWaEBXvlk4Qz5fDdYAgNexcILNA1XMC7D
         E77A==
X-Gm-Message-State: AOAM532DIC0odMRUXdvrzcPuV1LuhSHUcTo1eCSUhpKoY/LsJdmsAoBU
        Dc1YLLHUsfRxPc9qEsW1VD8NtbFOKUY/APAM
X-Google-Smtp-Source: ABdhPJyeTvDkHfiGdvbVtaYGP13f9+eXjPw0AdUagtYcpdUXM+or0c1ZyInJHTL3QHsZ0YJkGzemAw==
X-Received: by 2002:a05:6512:22c4:: with SMTP id g4mr13342499lfu.287.1628408584560;
        Sun, 08 Aug 2021 00:43:04 -0700 (PDT)
Received: from localhost.localdomain (broadband-188-32-236-56.ip.moscow.rt.ru. [188.32.236.56])
        by smtp.googlemail.com with ESMTPSA id c19sm406282lfc.70.2021.08.08.00.43.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Aug 2021 00:43:04 -0700 (PDT)
From:   Denis Efremov <efremov@linux.com>
To:     linux-block@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
        Denis Efremov <efremov@linux.com>,
        Mark Hounschell <markh@compro.net>,
        Jiri Kosina <jkosina@suse.cz>,
        Wim Osterholt <wim@djo.tudelft.nl>,
        Kurt Garloff <kurt@garloff.de>, stable@vger.kernel.org
Subject: [PATCH] Revert "floppy: reintroduce O_NDELAY fix"
Date:   Sun,  8 Aug 2021 10:42:46 +0300
Message-Id: <20210808074246.33449-1-efremov@linux.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <de10cb47-34d1-5a88-7751-225ca380f735@compro.net>
References: <de10cb47-34d1-5a88-7751-225ca380f735@compro.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch breaks userspace implementations (e.g. fdutils) and introduces
regressions in behaviour. Previously, it was possible to O_NDELAY open a
floppy device with no media inserted or with write protected media without
an error. Some userspace tools use this particular behavior for probing.

It's not the first time when we revert this patch. Previous revert is in
commit f2791e7eadf4 (Revert "floppy: refactor open() flags handling").

This reverts commit 8a0c014cd20516ade9654fc13b51345ec58e7be8.

Link: https://lore.kernel.org/linux-block/de10cb47-34d1-5a88-7751-225ca380f735@compro.net/
Reported-by: Mark Hounschell <markh@compro.net>
Cc: Jiri Kosina <jkosina@suse.cz>
Cc: Wim Osterholt <wim@djo.tudelft.nl>
Cc: Kurt Garloff <kurt@garloff.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Denis Efremov <efremov@linux.com>
---
 drivers/block/floppy.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 87460e0e5c72..fef79ea52e3e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -4029,23 +4029,23 @@ static int floppy_open(struct block_device *bdev, fmode_t mode)
 	if (fdc_state[FDC(drive)].rawcmd == 1)
 		fdc_state[FDC(drive)].rawcmd = 2;
 
-	if (mode & (FMODE_READ|FMODE_WRITE)) {
-		drive_state[drive].last_checked = 0;
-		clear_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags);
-		if (bdev_check_media_change(bdev))
-			floppy_revalidate(bdev->bd_disk);
-		if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
-			goto out;
-		if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+	if (!(mode & FMODE_NDELAY)) {
+		if (mode & (FMODE_READ|FMODE_WRITE)) {
+			drive_state[drive].last_checked = 0;
+			clear_bit(FD_OPEN_SHOULD_FAIL_BIT,
+				  &drive_state[drive].flags);
+			if (bdev_check_media_change(bdev))
+				floppy_revalidate(bdev->bd_disk);
+			if (test_bit(FD_DISK_CHANGED_BIT, &drive_state[drive].flags))
+				goto out;
+			if (test_bit(FD_OPEN_SHOULD_FAIL_BIT, &drive_state[drive].flags))
+				goto out;
+		}
+		res = -EROFS;
+		if ((mode & FMODE_WRITE) &&
+		    !test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
 			goto out;
 	}
-
-	res = -EROFS;
-
-	if ((mode & FMODE_WRITE) &&
-			!test_bit(FD_DISK_WRITABLE_BIT, &drive_state[drive].flags))
-		goto out;
-
 	mutex_unlock(&open_lock);
 	mutex_unlock(&floppy_mutex);
 	return 0;
-- 
2.31.1

