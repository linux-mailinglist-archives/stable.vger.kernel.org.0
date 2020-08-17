Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA2C7246FCB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:54:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731621AbgHQRxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388628AbgHQQLh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:11:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65E8422BED;
        Mon, 17 Aug 2020 16:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680695;
        bh=kVRhEtl+UAk4V947xnY62S2SgqgbROmEWjYLUe4PZH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WaL864TQJctIMb952BwhbdwDG6rQ+phUePy2T3WnGw/LbVu1RuwKBjLLDM14NdD5q
         BMDqX5lbJilyvv8Bz7zNW179OAFc5UiROh56GxggAKrAxnpISmeAtLvZt2A0Pden85
         8NB9NFpSwRXKQAC7weMNhISySSz2TEFNL6hQiNqc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Darren Hart <darren@dvhart.com>,
        Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Darren Hart <dvhart@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 002/168] HID: input: Fix devices that return multiple bytes in battery report
Date:   Mon, 17 Aug 2020 17:15:33 +0200
Message-Id: <20200817143733.824503362@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Grant Likely <grant.likely@secretlab.ca>

commit 4f57cace81438cc873a96f9f13f08298815c9b51 upstream.

Some devices, particularly the 3DConnexion Spacemouse wireless 3D
controllers, return more than just the battery capacity in the battery
report. The Spacemouse devices return an additional byte with a device
specific field. However, hidinput_query_battery_capacity() only
requests a 2 byte transfer.

When a spacemouse is connected via USB (direct wire, no wireless dongle)
and it returns a 3 byte report instead of the assumed 2 byte battery
report the larger transfer confuses and frightens the USB subsystem
which chooses to ignore the transfer. Then after 2 seconds assume the
device has stopped responding and reset it. This can be reproduced
easily by using a wired connection with a wireless spacemouse. The
Spacemouse will enter a loop of resetting every 2 seconds which can be
observed in dmesg.

This patch solves the problem by increasing the transfer request to 4
bytes instead of 2. The fix isn't particularly elegant, but it is simple
and safe to backport to stable kernels. A further patch will follow to
more elegantly handle battery reports that contain additional data.

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Darren Hart <darren@dvhart.com>
Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: stable@vger.kernel.org
Tested-by: Darren Hart <dvhart@infradead.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-input.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -362,13 +362,13 @@ static int hidinput_query_battery_capaci
 	u8 *buf;
 	int ret;
 
-	buf = kmalloc(2, GFP_KERNEL);
+	buf = kmalloc(4, GFP_KERNEL);
 	if (!buf)
 		return -ENOMEM;
 
-	ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 2,
+	ret = hid_hw_raw_request(dev, dev->battery_report_id, buf, 4,
 				 dev->battery_report_type, HID_REQ_GET_REPORT);
-	if (ret != 2) {
+	if (ret < 2) {
 		kfree(buf);
 		return -ENODATA;
 	}


