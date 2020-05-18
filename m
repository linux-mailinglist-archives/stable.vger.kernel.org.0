Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 761111D81E9
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:52:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730902AbgERRv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:54950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730412AbgERRvz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:51:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00B8620884;
        Mon, 18 May 2020 17:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589824314;
        bh=KFbd1vMPx1N9D3//2dkbNX6qzqR1HhfZr1JgaPOh90s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=whI5lTZX7pjh6jrBV4HZzKJ3EX5TwLi70PGi+e4ozX1ONUv3GH42am/Sk1vztK6LV
         nuzMMUj/zfZXOc93wcTdB9TKmIyjwpkt88KtOFdTCKjSqkDroo2RNDJbZp3eJA8j+t
         r4H80UZoB7CUnA48ru4sWax0dmsDa3OKjOSO4Kh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 25/80] cpufreq: intel_pstate: Only mention the BIOS disabling turbo mode once
Date:   Mon, 18 May 2020 19:36:43 +0200
Message-Id: <20200518173455.410591612@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.097837707@linuxfoundation.org>
References: <20200518173450.097837707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

[ Upstream commit 8c539776ac83c0857395e1ccc9c6b516521a2d32 ]

Make a note of the first time we discover the turbo mode has been
disabled by the BIOS, as otherwise we complain every time we try to
update the mode.

Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/intel_pstate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 29f25d5d65e00..e7b3d4ed8eff4 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -957,7 +957,7 @@ static ssize_t store_no_turbo(struct kobject *a, struct kobj_attribute *b,
 
 	update_turbo_state();
 	if (global.turbo_disabled) {
-		pr_warn("Turbo disabled by BIOS or unavailable on processor\n");
+		pr_notice_once("Turbo disabled by BIOS or unavailable on processor\n");
 		mutex_unlock(&intel_pstate_limits_lock);
 		mutex_unlock(&intel_pstate_driver_lock);
 		return -EPERM;
-- 
2.20.1



