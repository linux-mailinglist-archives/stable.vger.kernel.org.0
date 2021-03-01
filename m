Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B9EC6328363
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:19:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237689AbhCAQSQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:18:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:55474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237705AbhCAQRD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:17:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C16364E12;
        Mon,  1 Mar 2021 16:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615380;
        bh=I8nbikU4Sw4WIWLn374JUQfCx1J+ubH59OjzCnoMt9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myEJPW69kHeWzK5lMWNNJ+2nJA8J/QCulb3cnzgG0IkL+/o2+m9Flyn1ODqKI4JEe
         jgBZ/kuFcHZS2JB6vuKD/XrxI6dCS6ZggIzsLG4L0POTgtW3Gv2L77uHNhULc6o5Rg
         xXRlhfBtRKsYPeallUrmA1QwUokxDKDeaHpJQcVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Will McVicker <willmcvicker@google.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 4.4 01/93] HID: make arrays usage and value to be the same
Date:   Mon,  1 Mar 2021 17:12:13 +0100
Message-Id: <20210301161006.950848159@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161006.881950696@linuxfoundation.org>
References: <20210301161006.881950696@linuxfoundation.org>
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
@@ -91,7 +91,7 @@ EXPORT_SYMBOL_GPL(hid_register_report);
  * Register a new field for this report.
  */
 
-static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages, unsigned values)
+static struct hid_field *hid_register_field(struct hid_report *report, unsigned usages)
 {
 	struct hid_field *field;
 
@@ -102,7 +102,7 @@ static struct hid_field *hid_register_fi
 
 	field = kzalloc((sizeof(struct hid_field) +
 			 usages * sizeof(struct hid_usage) +
-			 values * sizeof(unsigned)), GFP_KERNEL);
+			 usages * sizeof(unsigned)), GFP_KERNEL);
 	if (!field)
 		return NULL;
 
@@ -281,7 +281,7 @@ static int hid_add_field(struct hid_pars
 	usages = max_t(unsigned, parser->local.usage_index,
 				 parser->global.report_count);
 
-	field = hid_register_field(report, usages, parser->global.report_count);
+	field = hid_register_field(report, usages);
 	if (!field)
 		return 0;
 


