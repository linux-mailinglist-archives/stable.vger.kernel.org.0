Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 902CD3284D9
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbhCAQnv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:43:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:41980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233148AbhCAQhp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:37:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3F25464F40;
        Mon,  1 Mar 2021 16:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616025;
        bh=4/6JvvWtrbxjOkOfWWIozCD7cNfrTNbYmgwWbKA56hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OvonTM/3giLrnl5dzGtk/z5gk9tmnyH/viYJURVJaC/hAi9oAuVJlOdo8WhNJdRbE
         //5XNHy0yH9CSLsJie78HVr8aTAS3FK/ywsOj2Gllc5FaSBf/JG3oSk1ouhzkSjtOt
         x56ohciz6+/d3BhvQIEii6s+h3lelrpkFX4WkizA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will McVicker <willmcvicker@google.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.14 001/176] HID: make arrays usage and value to be the same
Date:   Mon,  1 Mar 2021 17:11:14 +0100
Message-Id: <20210301161021.013630488@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will McVicker <willmcvicker@google.com>

commit ed9be64eefe26d7d8b0b5b9fa3ffdf425d87a01f upstream.

The HID subsystem allows an "HID report field" to have a different
number of "values" and "usages" when it is allocated. When a field
struct is created, the size of the usage array is guaranteed to be at
least as large as the values array, but it may be larger. This leads to
a potential out-of-bounds write in
__hidinput_change_resolution_multipliers() and an out-of-bounds read in
hidinput_count_leds().

To fix this, let's make sure that both the usage and value arrays are
the same size.

Cc: stable@vger.kernel.org
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/hid/hid-core.c
+++ b/drivers/hid/hid-core.c
@@ -90,7 +90,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
  * Register a new field for this report.
  */
 
-static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
+static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages)
 {
 	struct hid_field *field;
 
@@ -101,7 +101,7 @@ static struct hid_field *hid_register_fi
 
 	field = kzalloc((sizeof(struct hid_field) +
 			 usages * sizeof(struct hid_usage) +
-			 values * sizeof(unsigned)), GFP_KERNEL);
+			 usages * sizeof(unsigned)), GFP_KERNEL);
 	if (!field)
 		return NULL;
 
@@ -280,7 +280,7 @@ static int hid_add_field(struct hid_pars
 	usages = max_t(unsigned, parser->local.usage_index,
 				 parser->global.report_count);
 
-	field = hid_register_field(report, usages, parser->global.report_count);
+	field = hid_register_field(report, usages);
 	if (!field)
 		return 0;
 


