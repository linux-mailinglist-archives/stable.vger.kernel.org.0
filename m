Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0EF74C7712
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237265AbiB1SL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241725AbiB1SKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:10:17 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D28D68C7CE;
        Mon, 28 Feb 2022 09:50:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 453C3CE1795;
        Mon, 28 Feb 2022 17:49:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EFB3C340E7;
        Mon, 28 Feb 2022 17:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070595;
        bh=YQezQJUNcFWu3d2mWXA9MSAfCs1H1MFpPFZm7wJocsc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eYKJ3UqqjvFwECnjAeN3dwQVxt477GIkO1rFM46jhTBZyKx1ERnnAWRyJNArwJ4W2
         UdcWkhyGiIpqY4/3EE0h5XwgiIz4mDibjQw3S3KbLGy/2Zsq+IWe5S/FZoA0Jtt4NX
         RYv7LUiUTPUehHBjqSwI1XAN/LGyjg0Az7TYKVdU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuansheng Liu <chuansheng.liu@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.16 146/164] thermal: int340x: fix memory leak in int3400_notify()
Date:   Mon, 28 Feb 2022 18:25:08 +0100
Message-Id: <20220228172413.106173595@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuansheng Liu <chuansheng.liu@intel.com>

commit 3abea10e6a8f0e7804ed4c124bea2d15aca977c8 upstream.

It is easy to hit the below memory leaks in my TigerLake platform:

unreferenced object 0xffff927c8b91dbc0 (size 32):
  comm "kworker/0:2", pid 112, jiffies 4294893323 (age 83.604s)
  hex dump (first 32 bytes):
    4e 41 4d 45 3d 49 4e 54 33 34 30 30 20 54 68 65  NAME=INT3400 The
    72 6d 61 6c 00 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b a5  rmal.kkkkkkkkkk.
  backtrace:
    [<ffffffff9c502c3e>] __kmalloc_track_caller+0x2fe/0x4a0
    [<ffffffff9c7b7c15>] kvasprintf+0x65/0xd0
    [<ffffffff9c7b7d6e>] kasprintf+0x4e/0x70
    [<ffffffffc04cb662>] int3400_notify+0x82/0x120 [int3400_thermal]
    [<ffffffff9c8b7358>] acpi_ev_notify_dispatch+0x54/0x71
    [<ffffffff9c88f1a7>] acpi_os_execute_deferred+0x17/0x30
    [<ffffffff9c2c2c0a>] process_one_work+0x21a/0x3f0
    [<ffffffff9c2c2e2a>] worker_thread+0x4a/0x3b0
    [<ffffffff9c2cb4dd>] kthread+0xfd/0x130
    [<ffffffff9c201c1f>] ret_from_fork+0x1f/0x30

Fix it by calling kfree() accordingly.

Fixes: 38e44da59130 ("thermal: int3400_thermal: process "thermal table changed" event")
Signed-off-by: Chuansheng Liu <chuansheng.liu@intel.com>
Cc: 4.14+ <stable@vger.kernel.org> # 4.14+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel/int340x_thermal/int3400_thermal.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
+++ b/drivers/thermal/intel/int340x_thermal/int3400_thermal.c
@@ -404,6 +404,10 @@ static void int3400_notify(acpi_handle h
 	thermal_prop[3] = kasprintf(GFP_KERNEL, "EVENT=%d", therm_event);
 	thermal_prop[4] = NULL;
 	kobject_uevent_env(&priv->thermal->device.kobj, KOBJ_CHANGE, thermal_prop);
+	kfree(thermal_prop[0]);
+	kfree(thermal_prop[1]);
+	kfree(thermal_prop[2]);
+	kfree(thermal_prop[3]);
 }
 
 static int int3400_thermal_get_temp(struct thermal_zone_device *thermal,


