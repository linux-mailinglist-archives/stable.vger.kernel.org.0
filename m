Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7B54657D2C
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233942AbiL1PkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233533AbiL1PkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:40:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E682167F2
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DC1E6155C
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F474C433F1;
        Wed, 28 Dec 2022 15:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672242011;
        bh=ymf3kUV98vrrkLChHbFC3a/CEx83PKvNYKSAs/httkY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c6NyqyQlQF6H/r/3ePNqMRI3Dn5UsuqrgI0O/gFbuUwWxZ7JS8OEDeHE1ZCIuFd5h
         CpHqvB0wokTrmTmBqG9/EpPb8BCF7FqZ5xj/aeIngUfhRskONMsCBZ9Em3iJpff/Fb
         6kGbF7htF5BUBDHL5KyB0HnL34aUULUcSqrC7gR0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0354/1073] HID: i2c: let RMI devices decide what constitutes wakeup event
Date:   Wed, 28 Dec 2022 15:32:22 +0100
Message-Id: <20221228144337.619526539@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 9984fbf55b9bd998b4ff66395cbb118020c1effa ]

HID-RMI is special in the sense that it does not carry HID events
directly, but rather uses HID protocol as a wrapper/transport for RMI
protocol.  Therefore we should not assume that all data coming from the
device via interrupt is associated with user activity and report wakeup
event indiscriminately, but rather let HID-RMI do that when appropriate.

HID-RMI devices tag responses to the commands issued by the host as
RMI_READ_DATA_REPORT_ID whereas motion and other input events from the
device are tagged as RMI_ATTN_REPORT_ID. Change hid-rmi to report wakeup
events when receiving the latter packets. This allows ChromeOS to
accurately identify wakeup source and make correct decision on the mode
of the resume the system should take ("dark" where the display stays off
vs normal one).

Fixes: d951ae1ce803 ("HID: i2c-hid: Report wakeup events")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-rmi.c              | 2 ++
 drivers/hid/i2c-hid/i2c-hid-core.c | 3 ++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-rmi.c b/drivers/hid/hid-rmi.c
index 311eee599ce9..b2bf588d18c3 100644
--- a/drivers/hid/hid-rmi.c
+++ b/drivers/hid/hid-rmi.c
@@ -327,6 +327,8 @@ static int rmi_input_event(struct hid_device *hdev, u8 *data, int size)
 	if (!(test_bit(RMI_STARTED, &hdata->flags)))
 		return 0;
 
+	pm_wakeup_event(hdev->dev.parent, 0);
+
 	local_irq_save(flags);
 
 	rmi_set_attn_data(rmi_dev, data[1], &data[2], size - 2);
diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index c078f09a2318..5a365648206e 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -554,7 +554,8 @@ static void i2c_hid_get_input(struct i2c_hid *ihid)
 	i2c_hid_dbg(ihid, "input: %*ph\n", ret_size, ihid->inbuf);
 
 	if (test_bit(I2C_HID_STARTED, &ihid->flags)) {
-		pm_wakeup_event(&ihid->client->dev, 0);
+		if (ihid->hid->group != HID_GROUP_RMI)
+			pm_wakeup_event(&ihid->client->dev, 0);
 
 		hid_input_report(ihid->hid, HID_INPUT_REPORT,
 				ihid->inbuf + sizeof(__le16),
-- 
2.35.1



