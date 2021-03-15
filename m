Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BDCA33AEDE
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 10:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbhCOJbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 05:31:47 -0400
Received: from foss.arm.com ([217.140.110.172]:55508 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229704AbhCOJbh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 05:31:37 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 68DCB1FB;
        Mon, 15 Mar 2021 02:31:37 -0700 (PDT)
Received: from e123648.arm.com (unknown [10.57.12.51])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 8F5E33F70D;
        Mon, 15 Mar 2021 02:31:35 -0700 (PDT)
From:   Lukasz Luba <lukasz.luba@arm.com>
To:     linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        cw00.choi@samsung.com
Cc:     lukasz.luba@arm.com, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com, stable@vger.kernel.org
Subject: [PATCH v2] PM / devfreq: Unlock mutex and free devfreq struct in error path
Date:   Mon, 15 Mar 2021 09:31:23 +0000
Message-Id: <20210315093123.20049-1-lukasz.luba@arm.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The devfreq->lock is held for time of setup. Release the lock in the
error path, before jumping to the end of the function.

Change the goto destination which frees the allocated memory.

Cc: v5.9+ <stable@vger.kernel.org> # v5.9+
Fixes: 4dc3bab8687f ("PM / devfreq: Add support delayed timer for polling mode")
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
---
v2:
- added fixes tag and CC stable v5.9+
- used capital letter in commit header


 drivers/devfreq/devfreq.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index b6d3e7db0b09..99b2eeedc238 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -822,7 +822,8 @@ struct devfreq *devfreq_add_device(struct device *dev,
 
 	if (devfreq->profile->timer < 0
 		|| devfreq->profile->timer >= DEVFREQ_TIMER_NUM) {
-		goto err_out;
+		mutex_unlock(&devfreq->lock);
+		goto err_dev;
 	}
 
 	if (!devfreq->profile->max_state && !devfreq->profile->freq_table) {
-- 
2.17.1

