Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 309A7499414
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:40:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388273AbiAXUip (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:38:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385491AbiAXUd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:33:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EF0C061366;
        Mon, 24 Jan 2022 11:13:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5700B811F9;
        Mon, 24 Jan 2022 19:13:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088EDC340E5;
        Mon, 24 Jan 2022 19:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643051595;
        bh=2Vc5uuT2sZZYyfYgafyeNPF3odAtR3w3IPP05lx1XxE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GZa4/994ccEa2soU0uAa7Ga+JachJxQlACjTn721WM3PrZkPId3+FnRpiWBYplR0Y
         /j6XU44HBBvolVk1423uJ5XH+yythLQQDtPLo1y0jiZwB7tsClPbQp+1KU8c4qfczU
         RqEIfEXW1jsW5z4JqTFv6NleQswx5NqCNA/F+/aQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.19 025/239] HID: wacom: Avoid using stale array indicies to read contact count
Date:   Mon, 24 Jan 2022 19:41:03 +0100
Message-Id: <20220124183943.920097912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183943.102762895@linuxfoundation.org>
References: <20220124183943.102762895@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gerecke <killertofu@gmail.com>

commit 20f3cf5f860f9f267a6a6e5642d3d0525edb1814 upstream.

If we ever see a touch report with contact count data we initialize
several variables used to read the contact count in the pre-report
phase. These variables are never reset if we process a report which
doesn't contain a contact count, however. This can cause the pre-
report function to trigger a read of arbitrary memory (e.g. NULL
if we're lucky) and potentially crash the driver.

This commit restores resetting of the variables back to default
"none" values that were used prior to the commit mentioned
below.

Link: https://github.com/linuxwacom/input-wacom/issues/276
Fixes: 003f50ab673c (HID: wacom: Update last_slot_field during pre_report phase)
CC: stable@vger.kernel.org
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_wac.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -2610,6 +2610,10 @@ static void wacom_wac_finger_pre_report(
 
 	hid_data->confidence = true;
 
+	hid_data->cc_report = 0;
+	hid_data->cc_index = -1;
+	hid_data->cc_value_index = -1;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;


