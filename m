Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A48324D55
	for <lists+stable@lfdr.de>; Thu, 25 Feb 2021 10:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhBYJ5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 04:57:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235515AbhBYJzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Feb 2021 04:55:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91EAA64EDB;
        Thu, 25 Feb 2021 09:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614246846;
        bh=0cvQT/OwTLVEuuXM4LgLBjDxKi1tlOI9rg/xaVRGIzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZOnmNAxpBBBV8qEwEoB7U6G/tQLFWXBW4Xls2FQbzEdvGxjC+zEUdi4mFdl/YBs6L
         YJHemI9IDP2WHK57eI+CcdVuW2Ha/tS4N4uMIPgek00CM1h+umO+IiiDuXXx1sLA+p
         AUPIBFyeJqBju959kGhHq1ncc3mlrvnmVFHT2I9w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will McVicker <willmcvicker@google.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.11 02/12] HID: make arrays usage and value to be the same
Date:   Thu, 25 Feb 2021 10:53:36 +0100
Message-Id: <20210225092515.134226281@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210225092515.015261674@linuxfoundation.org>
References: <20210225092515.015261674@linuxfoundation.org>
User-Agent: quilt/0.66
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
 
@@ -300,7 +300,7 @@ static int hid_add_field(struct hid_pars
 	usages = max_t(unsigned, parser->local.usage_index,
 				 parser->global.report_count);
 
-	field = hid_register_field(report, usages, parser->global.report_count);
+	field = hid_register_field(report, usages);
 	if (!field)
 		return 0;
 


