Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DE43E81E7
	for <lists+stable@lfdr.de>; Tue, 10 Aug 2021 20:05:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhHJSDt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Aug 2021 14:03:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:32930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237916AbhHJSBr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Aug 2021 14:01:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70008613D2;
        Tue, 10 Aug 2021 17:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628617634;
        bh=GOVfuNuIDMoXMoNl+ZsQIiIQH1nS0yC/yDA1rPy+Xfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q2IG2QNbt44URfT4WXJbWbdr3l2Jff77Ghr8Mntn+z5uwUUNfy8+z7iPP9quTq9Mw
         l7Fy9+MhvSS4VhWnT/yRZXTwrHw6X+rhoWlvBBCyy2XsTrlIM+0yJwBwF5AxZf67WB
         uQte2O1GlVpn6yMcSlJwBkEUSjooO68GQwNGm0R0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.13 146/175] s390/dasd: fix use after free in dasd path handling
Date:   Tue, 10 Aug 2021 19:30:54 +0200
Message-Id: <20210810173005.775837563@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810173000.928681411@linuxfoundation.org>
References: <20210810173000.928681411@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stefan Haberland <sth@linux.ibm.com>

commit 952835edb4fdad49361d5330da918be8b765b787 upstream.

When new configuration data is obtained after a path event it is stored
in the per path array. The old data needs to be freed.
The first valid configuration data is also referenced in the device
private structure to identify the device.
When the old per path configuration data was freed the device still
pointed to the already freed data leading to a use after free.

Fix by replacing also the device configuration data with the newly
obtained one before the old data gets freed.

Fixes: 460181217a24 ("s390/dasd: Store path configuration data during path handling")
Cc: stable@vger.kernel.org # 5.11+
Signed-off-by: Stefan Haberland <sth@linux.ibm.com>
Reviewed-by: Jan Hoeppner <hoeppner@linux.ibm.com>
Link: https://lore.kernel.org/r/20210804151800.4031761-2-sth@linux.ibm.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/s390/block/dasd_eckd.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1004,15 +1004,23 @@ static unsigned char dasd_eckd_path_acce
 static void dasd_eckd_store_conf_data(struct dasd_device *device,
 				      struct dasd_conf_data *conf_data, int chp)
 {
+	struct dasd_eckd_private *private = device->private;
 	struct channel_path_desc_fmt0 *chp_desc;
 	struct subchannel_id sch_id;
+	void *cdp;
 
-	ccw_device_get_schid(device->cdev, &sch_id);
 	/*
 	 * path handling and read_conf allocate data
 	 * free it before replacing the pointer
+	 * also replace the old private->conf_data pointer
+	 * with the new one if this points to the same data
 	 */
-	kfree(device->path[chp].conf_data);
+	cdp = device->path[chp].conf_data;
+	if (private->conf_data == cdp) {
+		private->conf_data = (void *)conf_data;
+		dasd_eckd_identify_conf_parts(private);
+	}
+	ccw_device_get_schid(device->cdev, &sch_id);
 	device->path[chp].conf_data = conf_data;
 	device->path[chp].cssid = sch_id.cssid;
 	device->path[chp].ssid = sch_id.ssid;
@@ -1020,6 +1028,7 @@ static void dasd_eckd_store_conf_data(st
 	if (chp_desc)
 		device->path[chp].chpid = chp_desc->chpid;
 	kfree(chp_desc);
+	kfree(cdp);
 }
 
 static void dasd_eckd_clear_conf_data(struct dasd_device *device)


