Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95B9F66C146
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:09:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbjAPOJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:09:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbjAPOIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:08:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91088241E0;
        Mon, 16 Jan 2023 06:04:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4C329B80E93;
        Mon, 16 Jan 2023 14:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE667C433EF;
        Mon, 16 Jan 2023 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877839;
        bh=ex2P9mjaiy1ixyTthepQ1ud7mfFrU8jTvWyvwFpzCFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NgYUoTFEWARhKkV9lP1hEh+scVZRbcJVx+YOW2tbHEsglHJFpR1PfF84uBpaghYej
         SfybkqU2mUA+RP1/He18Kfb8Y5zjFSLj8e/AVwaXa1YR0IJ3PIOFPv/7AhZi+iybRn
         0CwLh2LnlRM1yvobnj7l3VfqYFXsLOl1GFfDvpbp8P191BJ7MAUnhk1oi+3iMKk6bv
         Is/30OMg4xx6VVXkytYpC4j3AO7eCqHmPSGXVkkY29QtFxZT/TLMwS4Kl2Aq6UlEg2
         UFW4wmGaxKKjY3n7FB59Z9js69n72DU60mZd1QyIWRPp9+Qtf0sRLHMxRhj6yzEnuW
         ak89R8oWxaQAw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kees Cook <keescook@chromium.org>,
        Paul Menzel <pmenzel@molgen.mpg.de>,
        Jack Rosenthal <jrosenth@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 53/53] firmware: coreboot: Check size of table entry and use flex-array
Date:   Mon, 16 Jan 2023 09:01:53 -0500
Message-Id: <20230116140154.114951-53-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 3b293487b8752cc42c1cbf8a0447bc6076c075fa ]

The memcpy() of the data following a coreboot_table_entry couldn't
be evaluated by the compiler under CONFIG_FORTIFY_SOURCE. To make it
easier to reason about, add an explicit flexible array member to struct
coreboot_device so the entire entry can be copied at once. Additionally,
validate the sizes before copying. Avoids this run-time false positive
warning:

  memcpy: detected field-spanning write (size 168) of single field "&device->entry" at drivers/firmware/google/coreboot_table.c:103 (size 8)

Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
Link: https://lore.kernel.org/all/03ae2704-8c30-f9f0-215b-7cdf4ad35a9a@molgen.mpg.de/
Cc: Jack Rosenthal <jrosenth@chromium.org>
Cc: Guenter Roeck <groeck@chromium.org>
Cc: Julius Werner <jwerner@chromium.org>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Stephen Boyd <swboyd@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Julius Werner <jwerner@chromium.org>
Reviewed-by: Guenter Roeck <groeck@chromium.org>
Link: https://lore.kernel.org/r/20230107031406.gonna.761-kees@kernel.org
Reviewed-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Jack Rosenthal <jrosenth@chromium.org>
Link: https://lore.kernel.org/r/20230112230312.give.446-kees@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/google/coreboot_table.c | 9 +++++++--
 drivers/firmware/google/coreboot_table.h | 1 +
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/google/coreboot_table.c b/drivers/firmware/google/coreboot_table.c
index 9ca21feb9d45..f3694d347801 100644
--- a/drivers/firmware/google/coreboot_table.c
+++ b/drivers/firmware/google/coreboot_table.c
@@ -93,7 +93,12 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 	for (i = 0; i < header->table_entries; i++) {
 		entry = ptr_entry;
 
-		device = kzalloc(sizeof(struct device) + entry->size, GFP_KERNEL);
+		if (entry->size < sizeof(*entry)) {
+			dev_warn(dev, "coreboot table entry too small!\n");
+			return -EINVAL;
+		}
+
+		device = kzalloc(sizeof(device->dev) + entry->size, GFP_KERNEL);
 		if (!device)
 			return -ENOMEM;
 
@@ -101,7 +106,7 @@ static int coreboot_table_populate(struct device *dev, void *ptr)
 		device->dev.parent = dev;
 		device->dev.bus = &coreboot_bus_type;
 		device->dev.release = coreboot_device_release;
-		memcpy(&device->entry, ptr_entry, entry->size);
+		memcpy(device->raw, ptr_entry, entry->size);
 
 		ret = device_register(&device->dev);
 		if (ret) {
diff --git a/drivers/firmware/google/coreboot_table.h b/drivers/firmware/google/coreboot_table.h
index beb778674acd..4a89277b99a3 100644
--- a/drivers/firmware/google/coreboot_table.h
+++ b/drivers/firmware/google/coreboot_table.h
@@ -66,6 +66,7 @@ struct coreboot_device {
 		struct coreboot_table_entry entry;
 		struct lb_cbmem_ref cbmem_ref;
 		struct lb_framebuffer framebuffer;
+		DECLARE_FLEX_ARRAY(u8, raw);
 	};
 };
 
-- 
2.35.1

