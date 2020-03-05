Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A932D17AC8C
	for <lists+stable@lfdr.de>; Thu,  5 Mar 2020 18:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727624AbgCERVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Mar 2020 12:21:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:40930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgCEROi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Mar 2020 12:14:38 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EEFF217F4;
        Thu,  5 Mar 2020 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583428478;
        bh=F1D0R/proQlgrCAIHqb84XFSvyT3s+JQd9HSM/5D7iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W7SxEQF1mVAhLZYqDoXn5ssVdZaLqQNO9LM1HWM+YVe67nKu/2YGWXXOIXpMf1eqe
         VifwgCXt7JBPzkrEjfiNNNBxgLPh5RZRy1sjHI07KmnpOOpSWZlJnZ14/RO1vGUl8Z
         dDV+5CQT4z5oO8w5LWOt8lBXCGkbATereQfrNQ7k=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hanno Zulla <kontakt@hanno.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/58] HID: hid-bigbenff: fix general protection fault caused by double kfree
Date:   Thu,  5 Mar 2020 12:13:35 -0500
Message-Id: <20200305171420.29595-14-sashal@kernel.org>
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

[ Upstream commit 789a2c250340666220fa74bc6c8f58497e3863b3 ]

The struct *bigben was allocated via devm_kzalloc() and then used as a
parameter in input_ff_create_memless(). This caused a double kfree
during removal of the device, since both the managed resource API and
ml_ff_destroy() in drivers/input/ff-memless.c would call kfree() on it.

Signed-off-by: Hanno Zulla <kontakt@hanno.de>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-bigbenff.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-bigbenff.c b/drivers/hid/hid-bigbenff.c
index 3f6abd190df43..f7e85bacb6889 100644
--- a/drivers/hid/hid-bigbenff.c
+++ b/drivers/hid/hid-bigbenff.c
@@ -220,10 +220,16 @@ static void bigben_worker(struct work_struct *work)
 static int hid_bigben_play_effect(struct input_dev *dev, void *data,
 			 struct ff_effect *effect)
 {
-	struct bigben_device *bigben = data;
+	struct hid_device *hid = input_get_drvdata(dev);
+	struct bigben_device *bigben = hid_get_drvdata(hid);
 	u8 right_motor_on;
 	u8 left_motor_force;
 
+	if (!bigben) {
+		hid_err(hid, "no device data\n");
+		return 0;
+	}
+
 	if (effect->type != FF_RUMBLE)
 		return 0;
 
@@ -341,7 +347,7 @@ static int bigben_probe(struct hid_device *hid,
 
 	INIT_WORK(&bigben->worker, bigben_worker);
 
-	error = input_ff_create_memless(hidinput->input, bigben,
+	error = input_ff_create_memless(hidinput->input, NULL,
 		hid_bigben_play_effect);
 	if (error)
 		return error;
-- 
2.20.1

