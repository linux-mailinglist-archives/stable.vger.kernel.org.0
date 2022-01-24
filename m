Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CE249A25F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365705AbiAXXvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837015AbiAXWli (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:41:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBBA2C06B581;
        Mon, 24 Jan 2022 13:04:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58E9860B03;
        Mon, 24 Jan 2022 21:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18741C340E5;
        Mon, 24 Jan 2022 21:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058281;
        bh=1thdJ/X7BNliuNC54o65kVEUZOHrhkbxjwWO8sllG/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LOZD3jPKeEQ6XD0LMMz8HA/SBeXTANxuEv7dzRTJtp77LJrI5DRBaKMikbnB0/fHS
         kJmAGEmgw/8C1mBDjLFdWgYeAWCkDSG1H3Oir94mnKhWYqvFQFjfwa3nTZGkXbvoEw
         ceUQOckxcN0BZYUYUv0sNwqCGiJE9QUhW+r4yB4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0239/1039] platform/x86: wmi: Replace read_takes_no_args with a flags field
Date:   Mon, 24 Jan 2022 19:33:48 +0100
Message-Id: <20220124184133.355836698@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit a90b38c58667142ecff2521481ed44286d46b140 ]

Replace the wmi_block.read_takes_no_args bool field with
an unsigned long flags field, used together with test_bit()
and friends.

This is a preparation patch for fixing a driver->notify() vs ->probe()
race, which requires atomic flag handling.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20211128190031.405620-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/wmi.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/wmi.c b/drivers/platform/x86/wmi.c
index c34341f4da763..46178e03aecad 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -57,6 +57,10 @@ static_assert(sizeof(typeof_member(struct guid_block, guid)) == 16);
 static_assert(sizeof(struct guid_block) == 20);
 static_assert(__alignof__(struct guid_block) == 1);
 
+enum {	/* wmi_block flags */
+	WMI_READ_TAKES_NO_ARGS,
+};
+
 struct wmi_block {
 	struct wmi_device dev;
 	struct list_head list;
@@ -67,8 +71,7 @@ struct wmi_block {
 	wmi_notify_handler handler;
 	void *handler_data;
 	u64 req_buf_size;
-
-	bool read_takes_no_args;
+	unsigned long flags;
 };
 
 
@@ -367,7 +370,7 @@ static acpi_status __query_block(struct wmi_block *wblock, u8 instance,
 	wq_params[0].type = ACPI_TYPE_INTEGER;
 	wq_params[0].integer.value = instance;
 
-	if (instance == 0 && wblock->read_takes_no_args)
+	if (instance == 0 && test_bit(WMI_READ_TAKES_NO_ARGS, &wblock->flags))
 		input.count = 0;
 
 	/*
@@ -1113,7 +1116,7 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	 * laptops, WQxx may not be a method at all.)
 	 */
 	if (info->type != ACPI_TYPE_METHOD || info->param_count == 0)
-		wblock->read_takes_no_args = true;
+		set_bit(WMI_READ_TAKES_NO_ARGS, &wblock->flags);
 
 	kfree(info);
 
-- 
2.34.1



