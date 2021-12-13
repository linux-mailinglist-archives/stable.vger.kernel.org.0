Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C79E472433
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:35:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbhLMJez (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:55 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:58434 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhLMJeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:34:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBAE9CE0E77;
        Mon, 13 Dec 2021 09:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87253C00446;
        Mon, 13 Dec 2021 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388047;
        bh=vJQ6ymBTQJdFTgo0RwDmqrh+qj8MQP8lRhHa+QDcWeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6V5wTT/6dQ3NsY3HwzEu70/fSoj00REBsSsUEcw6L4+agwmYMOi18oZFrZC8OxkC
         unHETcXF5ba5eh9Xn3OoPD2BtRRazfQ4ioe/OKn+Olb97dkYA53z+1CDkBrj8OqFk1
         Fc+AjhrAS9w6VW+4GodjPna/EQ0s+eh6Or9y+778=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org
Subject: [PATCH 4.9 02/42] HID: add hid_is_usb() function to make it simpler for USB detection
Date:   Mon, 13 Dec 2021 10:29:44 +0100
Message-Id: <20211213092926.660321136@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
References: <20211213092926.578829548@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit f83baa0cb6cfc92ebaf7f9d3a99d7e34f2e77a8a upstream.

A number of HID drivers already call hid_is_using_ll_driver() but only
for the detection of if this is a USB device or not.  Make this more
obvious by creating hid_is_usb() and calling the function that way.

Also converts the existing hid_is_using_ll_driver() functions to use the
new call.

Cc: Jiri Kosina <jikos@kernel.org>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc: linux-input@vger.kernel.org
Cc: stable@vger.kernel.org
Tested-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Link: https://lore.kernel.org/r/20211201183503.2373082-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hid.h |    5 +++++
 1 file changed, 5 insertions(+)

--- a/include/linux/hid.h
+++ b/include/linux/hid.h
@@ -773,6 +773,11 @@ static inline bool hid_is_using_ll_drive
 	return hdev->ll_driver == driver;
 }
 
+static inline bool hid_is_usb(struct hid_device *hdev)
+{
+	return hid_is_using_ll_driver(hdev, &usb_hid_driver);
+}
+
 #define	PM_HINT_FULLON	1<<5
 #define PM_HINT_NORMAL	1<<1
 


