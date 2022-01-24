Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D30CC498A9E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237328AbiAXTGD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:06:03 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:59474 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345224AbiAXTDG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:03:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BF95060E8D;
        Mon, 24 Jan 2022 19:03:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A17B3C340E8;
        Mon, 24 Jan 2022 19:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643050985;
        bh=qU5RB5Asf5DVcGKJra1TjZt+GZkHrDh7hncS3MOWvb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zwZ1n7vWbbZoACik/u6EwLsMLpisRNzPz/Es6CLwwyllqtI6DwGN/0admXzEPuXXh
         Jcz1Ei25uVGTtKfW2LZ4pVn0EXrgHkkILdbAow9pd0jzgx/8YFOkRP/vwe/Swz8JOq
         yx2EwF6DvG/h3qiYTMSaNTHcGQVzAy+zl+5V4JKU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gerecke <jason.gerecke@wacom.com>,
        Ping Cheng <ping.cheng@wacom.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 018/186] HID: wacom: Avoid using stale array indicies to read contact count
Date:   Mon, 24 Jan 2022 19:41:33 +0100
Message-Id: <20220124183937.701663261@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183937.101330125@linuxfoundation.org>
References: <20220124183937.101330125@linuxfoundation.org>
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
@@ -2505,6 +2505,10 @@ static void wacom_wac_finger_pre_report(
 
 	hid_data->confidence = true;
 
+	hid_data->cc_report = 0;
+	hid_data->cc_index = -1;
+	hid_data->cc_value_index = -1;
+
 	for (i = 0; i < report->maxfield; i++) {
 		struct hid_field *field = report->field[i];
 		int j;


