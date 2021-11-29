Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CE26462430
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233006AbhK2WRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231473AbhK2WQr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:16:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F0CEC127125;
        Mon, 29 Nov 2021 10:22:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06791B815DB;
        Mon, 29 Nov 2021 18:22:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A018C53FAD;
        Mon, 29 Nov 2021 18:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210122;
        bh=VYiRlfloXRGTmj4FdDoX3+bibzj4hSrda9n62yaAsMw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uLW0+cJHMBSKIwn3qylEiMdN3fkLZIh4YonN9CR44N9PuDVpRNYs9TuSejsWLwnnk
         6VppQiQ0fpHvjsYv2kXmcCnslVhUU1SiQFFRsPEREg6xfl6LERl31K2aatN/MAHj78
         NDZAeQIqJLW8w7lSjBHGBX1RO5SzBoHO/4wX9Its=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 50/69] PM: hibernate: use correct mode for swsusp_close()
Date:   Mon, 29 Nov 2021 19:18:32 +0100
Message-Id: <20211129181705.288398033@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181703.670197996@linuxfoundation.org>
References: <20211129181703.670197996@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>

[ Upstream commit cefcf24b4d351daf70ecd945324e200d3736821e ]

Commit 39fbef4b0f77 ("PM: hibernate: Get block device exclusively in
swsusp_check()") changed the opening mode of the block device to
(FMODE_READ | FMODE_EXCL).

In the corresponding calls to swsusp_close(), the mode is still just
FMODE_READ which triggers the warning in blkdev_flush_mapping() on
resume from hibernate.

So, use the mode (FMODE_READ | FMODE_EXCL) also when closing the
device.

Fixes: 39fbef4b0f77 ("PM: hibernate: Get block device exclusively in swsusp_check()")
Signed-off-by: Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 28db51274ed0e..6670a44ec5d45 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -677,7 +677,7 @@ static int load_image_and_restore(void)
 		goto Unlock;
 
 	error = swsusp_read(&flags);
-	swsusp_close(FMODE_READ);
+	swsusp_close(FMODE_READ | FMODE_EXCL);
 	if (!error)
 		hibernation_restore(flags & SF_PLATFORM_MODE);
 
@@ -874,7 +874,7 @@ static int software_resume(void)
 	/* The snapshot device should not be opened while we're running */
 	if (!atomic_add_unless(&snapshot_device_available, -1, 0)) {
 		error = -EBUSY;
-		swsusp_close(FMODE_READ);
+		swsusp_close(FMODE_READ | FMODE_EXCL);
 		goto Unlock;
 	}
 
@@ -910,7 +910,7 @@ static int software_resume(void)
 	pm_pr_dbg("Hibernation image not present or could not be loaded.\n");
 	return error;
  Close_Finish:
-	swsusp_close(FMODE_READ);
+	swsusp_close(FMODE_READ | FMODE_EXCL);
 	goto Finish;
 }
 
-- 
2.33.0



