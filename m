Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 776AF18B5DE
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:22:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgCSNWM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:47230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727745AbgCSNWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:22:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4852720724;
        Thu, 19 Mar 2020 13:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624129;
        bh=F1D0R/proQlgrCAIHqb84XFSvyT3s+JQd9HSM/5D7iQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cWqDZC0MsDYWKB0vNAlu0JrIaYXcsOCiQ96mchc/y4onNQOolQem5d3N0N2eg1agZ
         Qjf2bgvzsxlOYkrmdnPmY8vRadSPUAzWagJzjOLJxz6nlerxzWiZ+VDFFCvQ6ZClqG
         kd/MgOCUKmrOiPrGrlaSzo87WZjGWVdh2/P7i7es=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hanno Zulla <kontakt@hanno.de>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 17/60] HID: hid-bigbenff: fix general protection fault caused by double kfree
Date:   Thu, 19 Mar 2020 14:03:55 +0100
Message-Id: <20200319123924.615069565@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123919.441695203@linuxfoundation.org>
References: <20200319123919.441695203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



