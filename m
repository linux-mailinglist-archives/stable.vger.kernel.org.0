Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA79B461F35
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379780AbhK2So4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:44:56 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:56622 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379939AbhK2Smz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:42:55 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id ACF9FCE1626;
        Mon, 29 Nov 2021 18:39:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59730C53FAD;
        Mon, 29 Nov 2021 18:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211173;
        bh=QnwtEr6uTMgVFWBAHMfxc/x+vt3b93MVx8sU0x8jb/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aSLl5I1WPeP0ZK6dsE9cFya4latM0KSDALt2PRW/RW1j7O33W/g4zTs7gsxKN2T2f
         gvF2wV5foBRoI7CDThJrU/xYfPLIE9e50AatyVTolwPhoo9bCjBtwocdlev4/z0y6u
         osv9e+Lza8T6fiTFkk7WgSYOVR4MorOtGm3VCEIU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 130/179] PM: hibernate: use correct mode for swsusp_close()
Date:   Mon, 29 Nov 2021 19:18:44 +0100
Message-Id: <20211129181723.235519788@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
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
index 559acef3fddb8..b0888e9224da3 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -691,7 +691,7 @@ static int load_image_and_restore(void)
 		goto Unlock;
 
 	error = swsusp_read(&flags);
-	swsusp_close(FMODE_READ);
+	swsusp_close(FMODE_READ | FMODE_EXCL);
 	if (!error)
 		error = hibernation_restore(flags & SF_PLATFORM_MODE);
 
@@ -981,7 +981,7 @@ static int software_resume(void)
 	/* The snapshot device should not be opened while we're running */
 	if (!hibernate_acquire()) {
 		error = -EBUSY;
-		swsusp_close(FMODE_READ);
+		swsusp_close(FMODE_READ | FMODE_EXCL);
 		goto Unlock;
 	}
 
@@ -1016,7 +1016,7 @@ static int software_resume(void)
 	pm_pr_dbg("Hibernation image not present or could not be loaded.\n");
 	return error;
  Close_Finish:
-	swsusp_close(FMODE_READ);
+	swsusp_close(FMODE_READ | FMODE_EXCL);
 	goto Finish;
 }
 
-- 
2.33.0



