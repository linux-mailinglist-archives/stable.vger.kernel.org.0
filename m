Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41EB0378937
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239223AbhEJL0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238351AbhEJLR1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:17:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3BE06610C9;
        Mon, 10 May 2021 11:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620645193;
        bh=pTjM3Nl2nmy8c77cRJ2FbBpx2W0g03c7lC80yDjpenU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=onEvjJHVEcmN3bpdcKoe6UGZiajLXZCModhZ3Mn+sj/N/JFcF2VmiIE8sloV6QdXD
         ZdNvjcCwg+dR3RJlwAaGHu6mWGd6YA2K2DHa2+MtYy9Hn2NsVy5EDDM1VQWIAZ+Z2K
         d9QUBhbKbj6sSYdFnCZNX1hcr6Xx/Br/Ts3735t0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 5.12 384/384] thermal/core/fair share: Lock the thermal zone while looping over instances
Date:   Mon, 10 May 2021 12:22:53 +0200
Message-Id: <20210510102027.447277734@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukasz Luba <lukasz.luba@arm.com>

commit fef05776eb02238dcad8d5514e666a42572c3f32 upstream.

The tz->lock must be hold during the looping over the instances in that
thermal zone. This lock was missing in the governor code since the
beginning, so it's hard to point into a particular commit.

CC: stable@vger.kernel.org # 4.4+
Signed-off-by: Lukasz Luba <lukasz.luba@arm.com>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20210422153624.6074-2-lukasz.luba@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/gov_fair_share.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thermal/gov_fair_share.c
+++ b/drivers/thermal/gov_fair_share.c
@@ -82,6 +82,8 @@ static int fair_share_throttle(struct th
 	int total_instance = 0;
 	int cur_trip_level = get_trip_level(tz);
 
+	mutex_lock(&tz->lock);
+
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
@@ -110,6 +112,8 @@ static int fair_share_throttle(struct th
 		mutex_unlock(&instance->cdev->lock);
 		thermal_cdev_update(cdev);
 	}
+
+	mutex_unlock(&tz->lock);
 	return 0;
 }
 


