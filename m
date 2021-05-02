Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4A9370CEE
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbhEBOIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:08:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:51874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232446AbhEBOHS (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10AB4613ED;
        Sun,  2 May 2021 14:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964362;
        bh=qbbmotqRcQsqZb8LKliq760hLm0WV5WZAvv/LQ2y9qw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SSRfJOseN0yAPr/TWkc87c6vPj3QVAWFkQg4szVTMJsbewwNdLQotqMKQ4G5uJaBb
         o4b2sW36Yot5T0QXnT0mO+99lQ6VgSALnwfmoqyLKNAlF7OQvoMy7K4PZrZaF+ZBMr
         nw7+D83lOlYDWS0Uq3DuS3RcjrmGJ8X3vXN5eAC+LZR3ypXV+MwMw4ZID5646CP/eu
         u8XSwAC+2PmCIafHocSw4Mv9akPC5fsncYBxT2JElXbg8Va2V0EFreFaNNsHDmDUCe
         Rzq90Mn7sNPn3drj9Q8WYwqfZ0+XuNFmOrYohrQ3EzPE6+ESf6TpgmMipjSx+4tdj3
         9AClAB3SyKFTQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Machek <pavel@ucw.cz>, Pavel Machek <pavel@denx.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.14 14/16] intel_th: Consistency and off-by-one fix
Date:   Sun,  2 May 2021 10:05:42 -0400
Message-Id: <20210502140544.2720138-14-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
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
index 2a3ae9006c58..79473ba48d0c 100644
--- a/drivers/hwtracing/intel_th/gth.c
+++ b/drivers/hwtracing/intel_th/gth.c
@@ -485,7 +485,7 @@ static void intel_th_gth_disable(struct intel_th_device *thdev,
 	output->active = false;
 
 	for_each_set_bit(master, gth->output[output->port].master,
-			 TH_CONFIGURABLE_MASTERS) {
+			 TH_CONFIGURABLE_MASTERS + 1) {
 		gth_master_set(gth, master, -1);
 	}
 	spin_unlock(&gth->gth_lock);
@@ -624,7 +624,7 @@ static void intel_th_gth_unassign(struct intel_th_device *thdev,
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

