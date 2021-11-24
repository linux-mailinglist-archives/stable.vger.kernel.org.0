Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2F6B45BA8E
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:12:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242795AbhKXMMC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:12:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242564AbhKXMJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:09:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7DA10610E8;
        Wed, 24 Nov 2021 12:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637755550;
        bh=1r/ap8LlLALJcfM2GKLU7eJZt1M6IpEwYjvoYhV3JdY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vRul0qaB+mv7yoY6N+vmgt1sf/goZuyNW31CxmUtHwLvrLjP6siAleFrlqsYmGY4x
         Bqtx9UdzZEEfLRDwRH1gRqtU1FhwlNXSSHFMwQH7+AKb1vigzQ98t/r7B9D74ZAJhx
         3r/ArxzK49Z8cEcfqtsbfQahbNffq3bk6YPS+1D4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 137/162] platform/x86: hp_accel: Fix an error handling path in lis3lv02d_probe()
Date:   Wed, 24 Nov 2021 12:57:20 +0100
Message-Id: <20211124115702.718720207@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115658.328640564@linuxfoundation.org>
References: <20211124115658.328640564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit c961a7d2aa23ae19e0099fbcdf1040fb760eea83 ]

If 'led_classdev_register()' fails, some additional resources should be
released.

Add the missing 'i8042_remove_filter()' and 'lis3lv02d_remove_fs()' calls
that are already in the remove function but are missing here.

Fixes: a4c724d0723b ("platform: hp_accel: add a i8042 filter to remove HPQ6000 data from kb bus stream")
Fixes: 9e0c79782143 ("lis3lv02d: merge with leds hp disk")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://lore.kernel.org/r/5a4f218f8f16d2e3a7906b7ca3654ffa946895f8.1636314074.git.christophe.jaillet@wanadoo.fr
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/hp_accel.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/platform/x86/hp_accel.c b/drivers/platform/x86/hp_accel.c
index a06262e91a933..411616e6cb744 100644
--- a/drivers/platform/x86/hp_accel.c
+++ b/drivers/platform/x86/hp_accel.c
@@ -377,9 +377,11 @@ static int lis3lv02d_add(struct acpi_device *device)
 	INIT_WORK(&hpled_led.work, delayed_set_status_worker);
 	ret = led_classdev_register(NULL, &hpled_led.led_classdev);
 	if (ret) {
+		i8042_remove_filter(hp_accel_i8042_filter);
 		lis3lv02d_joystick_disable(&lis3_dev);
 		lis3lv02d_poweroff(&lis3_dev);
 		flush_work(&hpled_led.work);
+		lis3lv02d_remove_fs(&lis3_dev);
 		return ret;
 	}
 
-- 
2.33.0



