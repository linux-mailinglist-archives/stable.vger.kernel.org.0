Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9214D420DEC
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236486AbhJDNTp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236546AbhJDNSg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00EA161B43;
        Mon,  4 Oct 2021 13:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352863;
        bh=/OPIkO0iQKyLqA5RPHPn66O/nq6y776p2R2o0amDLlQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MYpof6vwejZm8qfj1hBl35G3zyw/6js6cu4pAlZZ4qt07CbYxsH459ShVj5ZoICjb
         cz7XmDynZZGMuJmSezsfI7gYd/Xk1Okz2BHNmWPI/sjR4wUBYtW0V/8a0Le69AyoNt
         WD0iCTxe7A/kzm+aTUZXs+OyogWa+2KxXvchYdcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+07efed3bc5a1407bd742@syzkaller.appspotmail.com,
        "F.A. SULAIMAN" <asha.16@itfac.mrt.ac.lk>,
        Pavel Skripkin <paskripkin@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 53/56] HID: betop: fix slab-out-of-bounds Write in betop_probe
Date:   Mon,  4 Oct 2021 14:53:13 +0200
Message-Id: <20211004125031.677388981@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: F.A.Sulaiman <asha.16@itfac.mrt.ac.lk>

commit 1e4ce418b1cb1a810256b5fb3fd33d22d1325993 upstream.

Syzbot reported slab-out-of-bounds Write bug in hid-betopff driver.
The problem is the driver assumes the device must have an input report but
some malicious devices violate this assumption.

So this patch checks hid_device's input is non empty before it's been used.

Reported-by: syzbot+07efed3bc5a1407bd742@syzkaller.appspotmail.com
Signed-off-by: F.A. SULAIMAN <asha.16@itfac.mrt.ac.lk>
Reviewed-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-betopff.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-betopff.c
+++ b/drivers/hid/hid-betopff.c
@@ -56,15 +56,22 @@ static int betopff_init(struct hid_devic
 {
 	struct betopff_device *betopff;
 	struct hid_report *report;
-	struct hid_input *hidinput =
-			list_first_entry(&hid->inputs, struct hid_input, list);
+	struct hid_input *hidinput;
 	struct list_head *report_list =
 			&hid->report_enum[HID_OUTPUT_REPORT].report_list;
-	struct input_dev *dev = hidinput->input;
+	struct input_dev *dev;
 	int field_count = 0;
 	int error;
 	int i, j;
 
+	if (list_empty(&hid->inputs)) {
+		hid_err(hid, "no inputs found\n");
+		return -ENODEV;
+	}
+
+	hidinput = list_first_entry(&hid->inputs, struct hid_input, list);
+	dev = hidinput->input;
+
 	if (list_empty(report_list)) {
 		hid_err(hid, "no output reports found\n");
 		return -ENODEV;


