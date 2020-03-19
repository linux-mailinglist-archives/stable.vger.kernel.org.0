Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFC3A18B6C7
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:29:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727753AbgCSNZL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:25:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52612 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730592AbgCSNZL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:25:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5762620B1F;
        Thu, 19 Mar 2020 13:25:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624310;
        bh=MdM4dmvB1NrI3FG6lrkvPkf35G6mA0uFNk6ScnH/2ew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pqzBPi81/1+3wCS07o1wz2SsLX79VvASdikiZh+GQPBrboW1zVVVbX6hOyIs72c7c
         W0KhQRoicgml7FelRWWg/BCS+E96zShPM+e8/H/7BMZhybbNv7JGqB34BIZfptr7VN
         /Eob8+x6VbeHGlR+2piiLbrpBhYwddNn3n6tZgUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanno Zulla <kontakt@hanno.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 18/65] HID: hid-bigbenff: fix race condition for scheduled work during removal
Date:   Thu, 19 Mar 2020 14:04:00 +0100
Message-Id: <20200319123932.165773859@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



