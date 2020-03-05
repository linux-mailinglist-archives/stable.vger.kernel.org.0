Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F57F17AB8B
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:18:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727754AbgCEROl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:14:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:41012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727749AbgCEROl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:41 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCF2721556;
        Thu,  5 Mar 2020 17:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428480;
        bh=MdM4dmvB1NrI3FG6lrkvPkf35G6mA0uFNk6ScnH/2ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SdwYnAHCMb3/c+eQ43ulpZb3dX+x9vMgAgZXY6XQuJzcBwqqg+He5Hahry1GhpTSp
         kyU1GQVJj5HnPzjyCgyP8sVu0zNUaB/+LeuxR90hG5lAvG7ghBxphQ/ikXb/Dh7ihn
         5Zt2mdRZv0wDFO2l2iDbONCF861vsj7kBWpWxBbQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanno Zulla <kontakt@hanno.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 16/58] HID: hid-bigbenff: fix race condition for scheduled work during removal
Date:   Thu,  5 Mar 2020 12:13:37 -0500
Message-Id: <20200305171420.29595-16-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200305171420.29595-1-sashal@kernel.org>
References: <20200305171420.29595-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hanno Zulla <kontakt@hanno.de>

[ Upstream commit 4eb1b01de5b9d8596d6c103efcf1a15cfc1bedf7 ]

It's possible that there is scheduled work left while the device is
already being removed, which can cause a kernel crash. Adding a flag
will avoid this.

Signed-off-by: Hanno Zulla <kontakt@hanno.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index f8c552b64a899..db6da21ade063 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -174,6 +174,7 @@ static __u8 pid0902_rdesc_fixed[] = {
 struct bigben_device {
 	struct hid_device *hid;
 	struct hid_report *report;
+	bool removed;
 	u8 led_state;         /* LED1 = 1 .. LED4 = 8 */
 	u8 right_motor_on;    /* right motor off/on 0/1 */
 	u8 left_motor_force;  /* left motor force 0-255 */
@@ -190,6 +191,9 @@ static void bigben_worker(struct work_struct *work)
 		struct bigben_device, worker);
 	struct hid_field *report_field = bigben->report->field[0];
 
+	if (bigben->removed)
+		return;
+
 	if (bigben->work_led) {
 		bigben->work_led = false;
 		report_field->value[0] = 0x01; /* 1 = led message */
@@ -304,6 +308,7 @@ static void bigben_remove(struct hid_device *hid)
 {
 	struct bigben_device *bigben = hid_get_drvdata(hid);
 
+	bigben->removed = true;
 	cancel_work_sync(&bigben->worker);
 	hid_hw_stop(hid);
 }
@@ -324,6 +329,7 @@ static int bigben_probe(struct hid_device *hid,
 		return -ENOMEM;
 	hid_set_drvdata(hid, bigben);
 	bigben->hid = hid;
+	bigben->removed = false;
 
 	error = hid_parse(hid);
 	if (error) {
-- 
2.20.1

