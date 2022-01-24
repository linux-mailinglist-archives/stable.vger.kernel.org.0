Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08F4349939D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385986AbiAXUe4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:34:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378024AbiAXU2e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:28:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D575C082566;
        Mon, 24 Jan 2022 11:42:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8CC81B81142;
        Mon, 24 Jan 2022 19:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF77C340E5;
        Mon, 24 Jan 2022 19:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053332;
        bh=3CEz9ODacc9jEscmMETRWxB3JPYlvQ03a39mjOKa3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YnPdVRkV3Ix/me3cZjTtWOgdjihegYSPiiWkVvkqzyjSqXK0c2CGJPP5QIFnuj226
         /SnaCN0jdhknQ8u3sb0cwClXoh3nuvLG+wPrhcg3VAnBPZbt4ilz3qmoQ+rgvQ6adK
         k1/r7tVUCMiLBu4OvzmQmEiUvbpO/it8Omt2BkhY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 003/563] HID: wacom: Reset expected and received contact counts at the same time
Date:   Mon, 24 Jan 2022 19:36:08 +0100
Message-Id: <20220124184024.526771179@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit 546e41ac994cc185ef3de610ca849a294b5df3ba upstream.

These two values go hand-in-hand and must be valid for the driver to
behave correctly. We are currently lazy about updating the values and
rely on the "expected" code flow to take care of making sure they're
valid at the point they're needed. The "expected" flow changed somewhat
with commit f8b6a74719b5 ("HID: wacom: generic: Support multiple tools
per report"), however. This led to problems with the DTH-2452 due (in
part) to *all* contacts being fully processed -- even those past the
expected contact count. Specifically, the received count gets reset to
0 once all expected fingers are processed, but not the expected count.
The rest of the contacts in the report are then *also* processed since
now the driver thinks we've only processed 0 of N expected contacts.

Later commits such as 7fb0413baa7f (HID: wacom: Use "Confidence" flag to
prevent reporting invalid contacts) worked around the DTH-2452 issue by
skipping the invalid contacts at the end of the report, but this is not
a complete fix. The confidence flag cannot be relied on when a contact
is removed (see the following patch), and dealing with that condition
re-introduces the DTH-2452 issue unless we also address this contact
count laziness. By resetting expected and received counts at the same
time we ensure the driver understands that there are 0 more contacts
expected in the report. Similarly, we also make sure to reset the
received count if for some reason we're out of sync in the pre-report
phase.

Link: https://github.com/linuxwacom/input-wacom/issues/288
Fixes: f8b6a74719b5 ("HID: wacom: generic: Support multiple tools per report")
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2664,11 +2664,14 @@ static void wacom_wac_finger_pre_report(
 	    hid_data->cc_index >= 0) {
 		struct hid_field *field = report->field[hid_data->cc_index];
 		int value = field->value[hid_data->cc_value_index];
-		if (value)
+		if (value) {
 			hid_data->num_expected = value;
+			hid_data->num_received = 0;
+		}
 	}
 	else {
 		hid_data->num_expected = wacom_wac->features.touch_max;
+		hid_data->num_received = 0;
 	}
 }
 
@@ -2692,6 +2695,7 @@ static void wacom_wac_finger_report(stru
 
 	input_sync(input);
 	wacom_wac->hid_data.num_received = 0;
+	wacom_wac->hid_data.num_expected = 0;
 
 	/* keep touch state for pen event */
 	wacom_wac->shared->touch_down = wacom_wac_finger_count_touches(wacom_wac);


