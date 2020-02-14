Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF3E15F223
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387866AbgBNSG7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 13:06:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35106 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731170AbgBNPyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:54:43 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DD5E24684;
        Fri, 14 Feb 2020 15:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695682;
        bh=K+GbBvUYMrSGOr40poPKHl1+OJzijRKgppJ0R0XLZ9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZwMC+UC7EYD9rN+Wa9p/lSvnmW5KE8KoQ7o4TMU/Q1mJwKKFAmbLdzrJ1tFCQVL1r
         5yZzxTN5iyryegTP/d/y4tJhpB5GbXJmKCbMZC7Pj6wdJWZAUjmRAD3hu1N3RbQwl+
         83z2aqYS2XdGvpZ++nLyb7plQS5kjvK9AM5mZGts=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 268/542] PM / devfreq: exynos-ppmu: Fix excessive stack usage
Date:   Fri, 14 Feb 2020 10:44:20 -0500
Message-Id: <20200214154854.6746-268-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d4556f5e99d5f603913bac01adaff8670cb2d08b ]

Putting a 'struct devfreq_event_dev' object on the stack is generally
a bad idea and here it leads to a warnig about potential stack overflow:

drivers/devfreq/event/exynos-ppmu.c:643:12: error: stack frame size of 1040 bytes in function 'exynos_ppmu_probe' [-Werror,-Wframe-larger-than=]

There is no real need for the device structure, only the string inside
it, so add an internal helper function that simply takes the string
as its argument and remove the device structure.

Fixes: 1dd62c66d345 ("PM / devfreq: events: extend events by type of counted data")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
[cw00.choi: Fix the issue from 'desc->name' to 'desc[j].name']
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/devfreq/event/exynos-ppmu.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/devfreq/event/exynos-ppmu.c b/drivers/devfreq/event/exynos-ppmu.c
index 85c7a77bf3f0d..055deea42c373 100644
--- a/drivers/devfreq/event/exynos-ppmu.c
+++ b/drivers/devfreq/event/exynos-ppmu.c
@@ -101,17 +101,22 @@ static struct __exynos_ppmu_events {
 	PPMU_EVENT(dmc1_1),
 };
 
-static int exynos_ppmu_find_ppmu_id(struct devfreq_event_dev *edev)
+static int __exynos_ppmu_find_ppmu_id(const char *edev_name)
 {
 	int i;
 
 	for (i = 0; i < ARRAY_SIZE(ppmu_events); i++)
-		if (!strcmp(edev->desc->name, ppmu_events[i].name))
+		if (!strcmp(edev_name, ppmu_events[i].name))
 			return ppmu_events[i].id;
 
 	return -EINVAL;
 }
 
+static int exynos_ppmu_find_ppmu_id(struct devfreq_event_dev *edev)
+{
+	return __exynos_ppmu_find_ppmu_id(edev->desc->name);
+}
+
 /*
  * The devfreq-event ops structure for PPMU v1.1
  */
@@ -556,13 +561,11 @@ static int of_get_devfreq_events(struct device_node *np,
 			 * use default if not.
 			 */
 			if (info->ppmu_type == EXYNOS_TYPE_PPMU_V2) {
-				struct devfreq_event_dev edev;
 				int id;
 				/* Not all registers take the same value for
 				 * read+write data count.
 				 */
-				edev.desc = &desc[j];
-				id = exynos_ppmu_find_ppmu_id(&edev);
+				id = __exynos_ppmu_find_ppmu_id(desc[j].name);
 
 				switch (id) {
 				case PPMU_PMNCNT0:
-- 
2.20.1

