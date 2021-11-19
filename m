Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84D7D457607
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:41:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237385AbhKSRoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:44:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:46420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237364AbhKSRn3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:43:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6276B611F2;
        Fri, 19 Nov 2021 17:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343626;
        bh=uWjY/w/k51+YFbDwyzN0vMn6uyKqi3AafaRODPAL8b4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l0HKkVaQk0d2ewcsgFL4qpGPBz9/iDQWUUyjkZ1mzL/NyVtArmuNqbAw/8UhFRumw
         2NHEBCP9DgDbSb2E16iI/OEOkTOYc3timYIIP4xzaAsIcW/Exax/LGxCRGTff1GNHG
         W+3DlJwa6VV28gPoIR/Zmiigo0pJ/Hef/FlipxFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Collins <quic_collinsd@quicinc.com>,
        Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 19/20] thermal: Fix NULL pointer dereferences in of_thermal_ functions
Date:   Fri, 19 Nov 2021 18:39:37 +0100
Message-Id: <20211119171445.276124981@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171444.640508836@linuxfoundation.org>
References: <20211119171444.640508836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>

commit 96cfe05051fd8543cdedd6807ec59a0e6c409195 upstream.

of_parse_thermal_zones() parses the thermal-zones node and registers a
thermal_zone device for each subnode. However, if a thermal zone is
consuming a thermal sensor and that thermal sensor device hasn't probed
yet, an attempt to set trip_point_*_temp for that thermal zone device
can cause a NULL pointer dereference. Fix it.

 console:/sys/class/thermal/thermal_zone87 # echo 120000 > trip_point_0_temp
 ...
 Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
 ...
 Call trace:
  of_thermal_set_trip_temp+0x40/0xc4
  trip_point_temp_store+0xc0/0x1dc
  dev_attr_store+0x38/0x88
  sysfs_kf_write+0x64/0xc0
  kernfs_fop_write_iter+0x108/0x1d0
  vfs_write+0x2f4/0x368
  ksys_write+0x7c/0xec
  __arm64_sys_write+0x20/0x30
  el0_svc_common.llvm.7279915941325364641+0xbc/0x1bc
  do_el0_svc+0x28/0xa0
  el0_svc+0x14/0x24
  el0_sync_handler+0x88/0xec
  el0_sync+0x1c0/0x200

While at it, fix the possible NULL pointer dereference in other
functions as well: of_thermal_get_temp(), of_thermal_set_emul_temp(),
of_thermal_get_trend().

Suggested-by: David Collins <quic_collinsd@quicinc.com>
Signed-off-by: Subbaraman Narayanamurthy <quic_subbaram@quicinc.com>
Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_of.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/drivers/thermal/thermal_of.c
+++ b/drivers/thermal/thermal_of.c
@@ -89,7 +89,7 @@ static int of_thermal_get_temp(struct th
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_temp)
+	if (!data->ops || !data->ops->get_temp)
 		return -EINVAL;
 
 	return data->ops->get_temp(data->sensor_data, temp);
@@ -186,6 +186,9 @@ static int of_thermal_set_emul_temp(stru
 {
 	struct __thermal_zone *data = tz->devdata;
 
+	if (!data->ops || !data->ops->set_emul_temp)
+		return -EINVAL;
+
 	return data->ops->set_emul_temp(data->sensor_data, temp);
 }
 
@@ -194,7 +197,7 @@ static int of_thermal_get_trend(struct t
 {
 	struct __thermal_zone *data = tz->devdata;
 
-	if (!data->ops->get_trend)
+	if (!data->ops || !data->ops->get_trend)
 		return -EINVAL;
 
 	return data->ops->get_trend(data->sensor_data, trip, trend);
@@ -301,7 +304,7 @@ static int of_thermal_set_trip_temp(stru
 	if (trip >= data->ntrips || trip < 0)
 		return -EDOM;
 
-	if (data->ops->set_trip_temp) {
+	if (data->ops && data->ops->set_trip_temp) {
 		int ret;
 
 		ret = data->ops->set_trip_temp(data->sensor_data, trip, temp);


