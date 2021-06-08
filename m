Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BDA3A02E2
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236437AbhFHTLG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237262AbhFHTH1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 15:07:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B9261930;
        Tue,  8 Jun 2021 18:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623178032;
        bh=FUO7UuQf3hDrBcpa+PrsQh8xp4SbyJVK6JOokVqjmyw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wxPysLAnC2heVuUDtUVnIInrJ+3nVeMr6UnqKBENILK0Gp9KupNdeM7ZQjwPSjxDd
         ojCLHU/RNq3vfduxhrpE2ksqK1o78rFoW4IDOM970T17mV/tf4WIhX3cP8IWcMXtU+
         8ZTN5WmWiFftWwfGUXDfHTt5XO7khkWJp2wNKXR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
        Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 018/161] HID: amd_sfh: Fix memory leak in amd_sfh_work
Date:   Tue,  8 Jun 2021 20:25:48 +0200
Message-Id: <20210608175946.078965598@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175945.476074951@linuxfoundation.org>
References: <20210608175945.476074951@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit 5ad755fd2b326aa2bc8910b0eb351ee6aece21b1 ]

Kmemleak tool detected a memory leak in the amd_sfh driver.

====================
unreferenced object 0xffff88810228ada0 (size 32):
  comm "insmod", pid 3968, jiffies 4295056001 (age 775.792s)
  hex dump (first 32 bytes):
    00 20 73 1f 81 88 ff ff 00 01 00 00 00 00 ad de  . s.............
    22 01 00 00 00 00 ad de 01 00 02 00 00 00 00 00  "...............
  backtrace:
    [<000000007b4c8799>] kmem_cache_alloc_trace+0x163/0x4f0
    [<0000000005326893>] amd_sfh_get_report+0xa4/0x1d0 [amd_sfh]
    [<000000002a9e5ec4>] amdtp_hid_request+0x62/0x80 [amd_sfh]
    [<00000000b8a95807>] sensor_hub_get_feature+0x145/0x270 [hid_sensor_hub]
    [<00000000fda054ee>] hid_sensor_parse_common_attributes+0x215/0x460 [hid_sensor_iio_common]
    [<0000000021279ecf>] hid_accel_3d_probe+0xff/0x4a0 [hid_sensor_accel_3d]
    [<00000000915760ce>] platform_probe+0x6a/0xd0
    [<0000000060258a1f>] really_probe+0x192/0x620
    [<00000000fa812f2d>] driver_probe_device+0x14a/0x1d0
    [<000000005e79f7fd>] __device_attach_driver+0xbd/0x110
    [<0000000070d15018>] bus_for_each_drv+0xfd/0x160
    [<0000000013a3c312>] __device_attach+0x18b/0x220
    [<000000008c7b4afc>] device_initial_probe+0x13/0x20
    [<00000000e6e99665>] bus_probe_device+0xfe/0x120
    [<00000000833fa90b>] device_add+0x6a6/0xe00
    [<00000000fa901078>] platform_device_add+0x180/0x380
====================

The fix is to freeing request_list entry once the processed entry is
removed from the request_list.

Fixes: 4b2c53d93a4b ("SFH:Transport Driver to add support of AMD Sensor Fusion Hub (SFH)")
Reviewed-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/amd-sfh-hid/amd_sfh_client.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hid/amd-sfh-hid/amd_sfh_client.c b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
index 2ab38b715347..ea9a4913932d 100644
--- a/drivers/hid/amd-sfh-hid/amd_sfh_client.c
+++ b/drivers/hid/amd-sfh-hid/amd_sfh_client.c
@@ -88,6 +88,7 @@ static void amd_sfh_work(struct work_struct *work)
 	sensor_index = req_node->sensor_idx;
 	report_id = req_node->report_id;
 	node_type = req_node->report_type;
+	kfree(req_node);
 
 	if (node_type == HID_FEATURE_REPORT) {
 		report_size = get_feature_report(sensor_index, report_id,
-- 
2.30.2



