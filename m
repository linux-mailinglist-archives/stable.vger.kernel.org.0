Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6D15FD238
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 03:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbiJMBJB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Oct 2022 21:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232438AbiJMBIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Oct 2022 21:08:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A834811540F;
        Wed, 12 Oct 2022 18:06:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 518D5B81629;
        Thu, 13 Oct 2022 00:26:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20351C43150;
        Thu, 13 Oct 2022 00:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665620800;
        bh=c9KwSiNVgBXBuKA/mG8YVGWL/opA9IdLJkp3LRCodbs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8HIrE+Uj+339HWT29Zym3oTQrfkT/ysyZcX3KzT9w//O1FOBv5fh7ghBqoAnc3mz
         bz8hbsj5Xfgkf18m1R2zL3gUDCAFw8eGK5H5Yt3TV2xmA65eD9q7+D+oB7+91/O9Ji
         7nBuprvyV1yXEPWV4lQnwLBi+bxFfWSBCHYs2Yz176jDNanT0fvJNpCkkLfkKV5fnk
         eQQwI91hmSvM0HZAsCIVviiCRcWCeM2B1R6COy2H4ucu8JngN38iVg/QpcyVRXmvvh
         iIqk6DUEK0PHeBT6n27T3Rw3wfbru4ZYMgA4Fv+tX8fbEv9omHrHAmruefuDbiucBY
         N3I3+42T5IrXQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <imv4bel@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>,
        erazor_de@users.sourceforge.net, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/19] HID: roccat: Fix use-after-free in roccat_read()
Date:   Wed, 12 Oct 2022 20:26:07 -0400
Message-Id: <20221013002623.1895576-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221013002623.1895576-1-sashal@kernel.org>
References: <20221013002623.1895576-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit cacdb14b1c8d3804a3a7d31773bc7569837b71a4 ]

roccat_report_event() is responsible for registering
roccat-related reports in struct roccat_device.

int roccat_report_event(int minor, u8 const *data)
{
	struct roccat_device *device;
	struct roccat_reader *reader;
	struct roccat_report *report;
	uint8_t *new_value;

	device = devices[minor];

	new_value = kmemdup(data, device->report_size, GFP_ATOMIC);
	if (!new_value)
		return -ENOMEM;

	report = &device->cbuf[device->cbuf_end];

	/* passing NULL is safe */
	kfree(report->value);
	...

The registered report is stored in the struct roccat_device member
"struct roccat_report cbuf[ROCCAT_CBUF_SIZE];".
If more reports are received than the "ROCCAT_CBUF_SIZE" value,
kfree() the saved report from cbuf[0] and allocates a new reprot.
Since there is no lock when this kfree() is performed,
kfree() can be performed even while reading the saved report.

static ssize_t roccat_read(struct file *file, char __user *buffer,
		size_t count, loff_t *ppos)
{
	struct roccat_reader *reader = file->private_data;
	struct roccat_device *device = reader->device;
	struct roccat_report *report;
	ssize_t retval = 0, len;
	DECLARE_WAITQUEUE(wait, current);

	mutex_lock(&device->cbuf_lock);

	...

	report = &device->cbuf[reader->cbuf_start];
	/*
	 * If report is larger than requested amount of data, rest of report
	 * is lost!
	 */
	len = device->report_size > count ? count : device->report_size;

	if (copy_to_user(buffer, report->value, len)) {
		retval = -EFAULT;
		goto exit_unlock;
	}
	...

The roccat_read() function receives the device->cbuf report and
delivers it to the user through copy_to_user().
If the N+ROCCAT_CBUF_SIZE th report is received while copying of
the Nth report->value is in progress, the pointer that copy_to_user()
is working on is kfree()ed and UAF read may occur. (race condition)

Since the device node of this driver does not set separate permissions,
this is not a security vulnerability, but because it is used for
requesting screen display of profile or dpi settings,
a user using the roccat device can apply udev to this device node or
There is a possibility to use it by giving.

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-roccat.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-roccat.c b/drivers/hid/hid-roccat.c
index 5be8de70c651..c9cec00b4e6e 100644
--- a/drivers/hid/hid-roccat.c
+++ b/drivers/hid/hid-roccat.c
@@ -260,6 +260,8 @@ int roccat_report_event(int minor, u8 const *data)
 	if (!new_value)
 		return -ENOMEM;
 
+	mutex_lock(&device->cbuf_lock);
+
 	report = &device->cbuf[device->cbuf_end];
 
 	/* passing NULL is safe */
@@ -279,6 +281,8 @@ int roccat_report_event(int minor, u8 const *data)
 			reader->cbuf_start = (reader->cbuf_start + 1) % ROCCAT_CBUF_SIZE;
 	}
 
+	mutex_unlock(&device->cbuf_lock);
+
 	wake_up_interruptible(&device->wait);
 	return 0;
 }
-- 
2.35.1

