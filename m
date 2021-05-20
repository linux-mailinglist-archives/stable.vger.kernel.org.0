Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4384A38A7D0
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbhETKnA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:43:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:44060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237395AbhETKlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F5C561363;
        Thu, 20 May 2021 09:55:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504552;
        bh=8ECmGFAofV+bbpLcSvZSp8ySpsLfNcKRbrYCBBB0ZdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ypRQykzFNmMkwyu+pffNwhY9lbXggYzL+vZ7ul0yBkROH0xdTVV5Gy2ZeAiaRID9l
         5n0Z0AsFbEoq0pR9v70gl72CULEPnpfN4LB5pSmliuFyNSKDRWQPn8XpAWjECkWq3w
         DwvYBwL0sHQIrwMakh5bhBfS9D76i7AUvH/BLqKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukasz Luba <lukasz.luba@arm.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: [PATCH 4.14 297/323] thermal/core/fair share: Lock the thermal zone while looping over instances
Date:   Thu, 20 May 2021 11:23:09 +0200
Message-Id: <20210520092130.395565199@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
 drivers/thermal/fair_share.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thermal/fair_share.c
+++ b/drivers/thermal/fair_share.c
@@ -94,6 +94,8 @@ static int fair_share_throttle(struct th
 	int total_instance = 0;
 	int cur_trip_level = get_trip_level(tz);
 
+	mutex_lock(&tz->lock);
+
 	list_for_each_entry(instance, &tz->thermal_instances, tz_node) {
 		if (instance->trip != trip)
 			continue;
@@ -122,6 +124,8 @@ static int fair_share_throttle(struct th
 		mutex_unlock(&instance->cdev->lock);
 		thermal_cdev_update(cdev);
 	}
+
+	mutex_unlock(&tz->lock);
 	return 0;
 }
 


