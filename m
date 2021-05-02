Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39642370CBF
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:06:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233776AbhEBOHU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:51998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233266AbhEBOGg (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:06:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CCD1C613DB;
        Sun,  2 May 2021 14:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964340;
        bh=NEuUn62GfhKmcJ/2RMkMwNqyYtuxp0cE9FhV7n16B+Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KGFB0Zi3+wBb7iAaccprVIT4uI4E3iAqBnuClM+ZylfBi611+HqFBReX/yhyLNpOc
         rDb+sVNErmXV6F0aK9xkDWc95t7iBwdf+ictYRQD3GBZVmt4Xo1bW8xiHd4fQA4529
         /EJm238VcWSMNlQWJi95kutZFvDTgFuvBoq1fsmUv4xA3sU4FKBg4QIiZSGCG3fwbu
         eKFLw3uZ2r7HSal4vn/H62OZal05U282ZPgaL6TE7Ocal6jsVo+STNsrcGiDzOy9sA
         QaWVquVqEZ4t+hetIRufemhOG8LLA2QIoNKUhVp/ZHGSXBAPwPxTZMAckGmLRwqea0
         v7t+nSAeA0ZWQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@denx.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 18/21] intel_th: Consistency and off-by-one fix
Date:   Sun,  2 May 2021 10:05:14 -0400
Message-Id: <20210502140517.2719912-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140517.2719912-1-sashal@kernel.org>
References: <20210502140517.2719912-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Machek <pavel@ucw.cz>

[ Upstream commit 18ffbc47d45a1489b664dd68fb3a7610a6e1dea3 ]

Consistently use "< ... +1" in for loops.

Fix of-by-one in for_each_set_bit().

Signed-off-by: Pavel Machek <pavel@denx.de>
Signed-off-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Link: https://lore.kernel.org/lkml/20190724095841.GA6952@amd/
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20210414171251.14672-6-alexander.shishkin@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwtracing/intel_th/gth.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwtracing/intel_th/gth.c b/drivers/hwtracing/intel_th/gth.c
index edc52d75e6bd..5041fe7fee9e 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -477,7 +477,7 @@ static void intel_th_gth_disable(struct intel_th_device *thdev,
 	output->active = false;
 
 	for_each_set_bit(master, gth->output[output->port].master,
-			 TH_CONFIGURABLE_MASTERS) {
+			 TH_CONFIGURABLE_MASTERS + 1) {
 		gth_master_set(gth, master, -1);
 	}
 	spin_unlock(&gth->gth_lock);
@@ -616,7 +616,7 @@ static void intel_th_gth_unassign(struct intel_th_device *thdev,
 	othdev->output.port = -1;
 	othdev->output.active = false;
 	gth->output[port].output = NULL;
-	for (master = 0; master <= TH_CONFIGURABLE_MASTERS; master++)
+	for (master = 0; master < TH_CONFIGURABLE_MASTERS + 1; master++)
 		if (gth->master[master] == port)
 			gth->master[master] = -1;
 	spin_unlock(&gth->gth_lock);
-- 
2.30.2

