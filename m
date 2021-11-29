Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40F80461E83
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:34:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379717AbhK2Sgn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:36:43 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37258 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354777AbhK2Sen (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:34:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B235EB815B1;
        Mon, 29 Nov 2021 18:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA32CC53FC7;
        Mon, 29 Nov 2021 18:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210683;
        bh=Vtq3xw5BKtUOnlV9IrZNnYmN0WomtlWx7C0pszlLM+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inMbTVek3AOxr7mdFBownmjZ+lktDIVT26dtEPkqrLhZE0XNMGvr4n9++TKp1yYqQ
         2sGWa/L+Kyg1aiYOXeJH94ABUmNZn99p2PA/dJImzS4XajIVR32v9mZwWh0HyMPfPG
         J1HAfV0DJeujDl4Q/M8TEsWfnbzRpuCumx8/3UXc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thomas Zeitlhofer <thomas.zeitlhofer+lkml@ze-it.at>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/121] PM: hibernate: use correct mode for swsusp_close()
Date:   Mon, 29 Nov 2021 19:18:32 +0100
Message-Id: <20211129181714.385344135@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181711.642046348@linuxfoundation.org>
References: <20211129181711.642046348@linuxfoundation.org>
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
index 2fc7d509a34fc..bf640fd6142a0 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -688,7 +688,7 @@ static int load_image_and_restore(void)
 		goto Unlock;
 
 	error = swsusp_read(&flags);
-	swsusp_close(FMODE_READ);
+	swsusp_close(FMODE_READ | FMODE_EXCL);
 	if (!error)
 		error = hibernation_restore(flags & SF_PLATFORM_MODE);
 
@@ -978,7 +978,7 @@ static int software_resume(void)
 	/* The snapshot device should not be opened while we're running */
 	if (!hibernate_acquire()) {
 		error = -EBUSY;
-		swsusp_close(FMODE_READ);
+		swsusp_close(FMODE_READ | FMODE_EXCL);
 		goto Unlock;
 	}
 
@@ -1013,7 +1013,7 @@ static int software_resume(void)
 	pm_pr_dbg("Hibernation image not present or could not be loaded.\n");
 	return error;
  Close_Finish:
-	swsusp_close(FMODE_READ);
+	swsusp_close(FMODE_READ | FMODE_EXCL);
 	goto Finish;
 }
 
-- 
2.33.0



