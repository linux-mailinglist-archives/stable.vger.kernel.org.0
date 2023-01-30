Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 647CB68106D
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236966AbjA3ODc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237044AbjA3ODV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 842213A867
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E7056103E
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2E4FC433D2;
        Mon, 30 Jan 2023 14:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087389;
        bh=DvqY4zbmbFW77b1cKIU/1IBDL/FxujeF5PglJoGY+5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XhUoEnRsS0fPLgjacneG9R+M3TjCO1rxLZmm9XGgiQC4v4qGaqtwq43UcIkcSjgK1
         In+L1f4Q/wWuU1GZoToAyw8oR5BT3v6V5BhRQLs0bE4ibG2Rjl5SsppW9vWL9JHQvS
         qqwjwGM4HdENzSLpwLXrb7NOERJEehlesXPjw/MU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Paul Menzel <pmenzel@molgen.mpg.de>,
        Jack Rosenthal <jrosenth@chromium.org>,
        Guenter Roeck <groeck@chromium.org>,
        Julius Werner <jwerner@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Kees Cook <keescook@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/313] firmware: coreboot: Check size of table entry and use flex-array
Date:   Mon, 30 Jan 2023 14:50:26 +0100
Message-Id: <20230130134345.592394226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
2.39.0



