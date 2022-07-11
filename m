Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E196856FC50
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:42:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233239AbiGKJmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbiGKJmL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:42:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A5B9A6AE;
        Mon, 11 Jul 2022 02:21:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4AE8BB80E87;
        Mon, 11 Jul 2022 09:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE360C341CB;
        Mon, 11 Jul 2022 09:21:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531267;
        bh=ZW4rVaNnZVyHbKOzlfPdxJiSJjl1u7LswruOjxCA1rc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XCGi73Wos92Ssm9a+O2h3QbxGfxa+uFRTgj+ZeQHTkmDNc8bjO6E7GG6rj3PubiDN
         1wLrI+yxF64ldCKHCbEbKLkpjmnAv8ngsziWSnyg/6CkSkVsPmKjNYVqROHlbKPbR8
         H4qrzsFLqqNDeEf8KHdx1l65/VvuQFuCNEE0Y2PA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 041/230] platform/x86: wmi: Replace read_takes_no_args with a flags field
Date:   Mon, 11 Jul 2022 11:04:57 +0200
Message-Id: <20220711090605.249153243@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
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
index 9aeb1a009097..a00b72ace6d2 100644
--- a/drivers/platform/x86/wmi.c
+++ b/drivers/platform/x86/wmi.c
@@ -51,6 +51,10 @@ struct guid_block {
 	u8 flags;
 };
 
+enum {	/* wmi_block flags */
+	WMI_READ_TAKES_NO_ARGS,
+};
+
 struct wmi_block {
 	struct wmi_device dev;
 	struct list_head list;
@@ -61,8 +65,7 @@ struct wmi_block {
 	wmi_notify_handler handler;
 	void *handler_data;
 	u64 req_buf_size;
-
-	bool read_takes_no_args;
+	unsigned long flags;
 };
 
 
@@ -325,7 +328,7 @@ static acpi_status __query_block(struct wmi_block *wblock, u8 instance,
 	wq_params[0].type = ACPI_TYPE_INTEGER;
 	wq_params[0].integer.value = instance;
 
-	if (instance == 0 && wblock->read_takes_no_args)
+	if (instance == 0 && test_bit(WMI_READ_TAKES_NO_ARGS, &wblock->flags))
 		input.count = 0;
 
 	/*
@@ -1087,7 +1090,7 @@ static int wmi_create_device(struct device *wmi_bus_dev,
 	 * laptops, WQxx may not be a method at all.)
 	 */
 	if (info->type != ACPI_TYPE_METHOD || info->param_count == 0)
-		wblock->read_takes_no_args = true;
+		set_bit(WMI_READ_TAKES_NO_ARGS, &wblock->flags);
 
 	kfree(info);
 
-- 
2.35.1



