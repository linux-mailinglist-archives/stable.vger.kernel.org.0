Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1811B337E36
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 20:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhCKTbQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 14:31:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbhCKTa4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 14:30:56 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0E8EC061574;
        Thu, 11 Mar 2021 11:30:55 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id kk2-20020a17090b4a02b02900c777aa746fso9850339pjb.3;
        Thu, 11 Mar 2021 11:30:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=WTyvjgP+/OReF3DM4qtKAuAfj8VF6/RyxnNhlngUYSM=;
        b=QMpxd3SKCfYJwKIgSO6m+mG+nU1QbTtt0KEORM3QxOqsCViqxn7iwGE+bCtb/V9Pgt
         HyNuxOZmGx20RtgqT0KVxWLxbnh31SHyr3gOcXbCSWUmyLva69FB5naNkjJmyP1w/U0o
         vvzw00FJdFc6nmTFqil8G+XrF82WXM5da/z5MGUxKSH7aIQirrkGYLp3q3b1pPDtdIq/
         DkAMsq/FvR/OY+z2ux6N0SgiWP+lpMN9rbj+PbtYq483HZPdHwdg6mK3ItOkYvkXWzBj
         q10/ZW4Hj8DnqKO6v9/CNYVpxbcYO2mxvca+CQYPobgDG7hRitCRvE5D9rjj+PoFoi6+
         9rrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=WTyvjgP+/OReF3DM4qtKAuAfj8VF6/RyxnNhlngUYSM=;
        b=PkDmr155UYkLbbQg2wLYw1u5kIZvWzzn9N8kjKrz6PCvpLaBg3EAmJB5jLGPsoTr+w
         /+7bo+38DOgK03vjjxIT7mU3kiEB5R1VPii7uKO43bBXAdvT89CUXUB6VGVTsNRQ8Uxz
         ezpii+Yaa2+nkMtGoxrAx+m3MZAtUc3uLJXRIlik7rC5ywkoUyJ3K2nHQUkdgzM+DBh2
         +60prsg1I4gj4lJssIxKRz+gUco0lHWR7d5bse9AiRG2e3vqIOtF32tqJABccoobJ27V
         slhQyZMMC2gm2N8sUqgL+KaZH8EuVwEgaDH5lAqA+a3kToVrFZIjOahFbJ1lhmR+6CDk
         gbQQ==
X-Gm-Message-State: AOAM531o1Sv3HyynHrd6i7oNDhIsFoR5O1PsaanP8QA+mhe9IltIkJRS
        j+BFpsXyDXh+eCAMb8YCFSvrPqBIBOXrGA==
X-Google-Smtp-Source: ABdhPJwpu05j6sHb/+79qGOjYvAGMZl6wcuxcfZdvKVaGhih2FeRwymyr2puJ4VH3m0ac5Rg3b4I0w==
X-Received: by 2002:a17:90a:7104:: with SMTP id h4mr10070061pjk.189.1615491054726;
        Thu, 11 Mar 2021 11:30:54 -0800 (PST)
Received: from localhost.localdomain ([2601:1c2:4f03:fea0:c4aa:9f76:499c:65e7])
        by smtp.gmail.com with ESMTPSA id w5sm3161587pfn.51.2021.03.11.11.30.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 11:30:54 -0800 (PST)
From:   Ping Cheng <pinglinux@gmail.com>
X-Google-Original-From: Ping Cheng <ping.cheng@wacom.com>
To:     linux-input@vger.kernel.org
Cc:     jkosina@suse.cz, Juan.Garrido@wacom.com, Jason.Gerecke@wacom.com,
        Ping Cheng <ping.cheng@wacom.com>, stable@vger.kernel.org
Subject: [PATCH] HID: wacom: set EV_KEY and EV_ABS only for non-HID_GENERIC type of devices
Date:   Thu, 11 Mar 2021 11:30:09 -0800
Message-Id: <20210311193009.12692-1-ping.cheng@wacom.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Valid HID_GENERIC type of devices set EV_KEY and EV_ABS by wacom_map_usage.
When *_input_capabilities are reached, those devices should already have
their proper EV_* set. EV_KEY and EV_ABS only need to be set for
non-HID_GENERIC type of devices in *_input_capabilities.

Devices that don't support HID descitoprs will pass back to hid-input for
registration without being accidentally rejected by the introduction of
patch: "Input: refuse to register absolute devices without absinfo"

Fixes: 6ecfe51b4082 ("Input: refuse to register absolute devices without absinfo")
Signed-off-by: Ping Cheng <ping.cheng@wacom.com>
Reviewed-by: Jason Gerecke <Jason.Gerecke@wacom.com>
Tested-by: Juan Garrido <Juan.Garrido@wacom.com>
CC: stable@vger.kernel.org
---
 drivers/hid/wacom_wac.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 5e6e4db..8906b79 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3578,8 +3578,6 @@ int wacom_setup_pen_input_capabilities(struct input_dev *input_dev,
 {
 	struct wacom_features *features = &wacom_wac->features;
 
-	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-
 	if (!(features->device_type & WACOM_DEVICETYPE_PEN))
 		return -ENODEV;
 
@@ -3594,6 +3592,7 @@ int wacom_setup_pen_input_capabilities(struct input_dev *input_dev,
 		return 0;
 	}
 
+	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 	__set_bit(ABS_MISC, input_dev->absbit);
 
@@ -3746,8 +3745,6 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 {
 	struct wacom_features *features = &wacom_wac->features;
 
-	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
-
 	if (!(features->device_type & WACOM_DEVICETYPE_TOUCH))
 		return -ENODEV;
 
@@ -3760,6 +3757,7 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 		/* setup has already been done */
 		return 0;
 
+	input_dev->evbit[0] |= BIT_MASK(EV_KEY) | BIT_MASK(EV_ABS);
 	__set_bit(BTN_TOUCH, input_dev->keybit);
 
 	if (features->touch_max == 1) {
-- 
2.17.1

