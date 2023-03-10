Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1DC06B43B9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232130AbjCJORE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:17:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231802AbjCJOQp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:16:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A47E11ACB2
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:15:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ACFA861771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C08CEC433D2;
        Fri, 10 Mar 2023 14:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457752;
        bh=7J5HSHDxRcVkjVxdnbAAcNS0Ikr0EXVHLtr0MbZclHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/nbBPJmKbDqfSclsp8LRkKFIVbnCJTOftblNPA72q8nv4EZ5aSDMTyku/0PUSwhq
         bPoPV+V3FLp44P0wuGmBW3zsWdKGrCVwZsCWFCYc0pSUyej6yv9JghGMss2lu8icdO
         TyUuDxbq8X+f5s7jPo8iwKiJyIZAp2i7GYjtd8fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Armin Wolf <W_Armin@gmx.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/252] ACPI: battery: Fix missing NUL-termination with large strings
Date:   Fri, 10 Mar 2023 14:36:55 +0100
Message-Id: <20230310133720.185112503@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit f2ac14b5f197e4a2dec51e5ceaa56682ff1592bc ]

When encountering a string bigger than the destination buffer (32 bytes),
the string is not properly NUL-terminated, causing buffer overreads later.

This for example happens on the Inspiron 3505, where the battery
model name is larger than 32 bytes, which leads to sysfs showing
the model name together with the serial number string (which is
NUL-terminated and thus prevents worse).

Fix this by using strscpy() which ensures that the result is
always NUL-terminated.

Fixes: 106449e870b3 ("ACPI: Battery: Allow extract string from integer")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/battery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/battery.c b/drivers/acpi/battery.c
index c0c533206e02d..88f4040d6c1f2 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -478,7 +478,7 @@ static int extract_package(struct acpi_battery *battery,
 			u8 *ptr = (u8 *)battery + offsets[i].offset;
 			if (element->type == ACPI_TYPE_STRING ||
 			    element->type == ACPI_TYPE_BUFFER)
-				strncpy(ptr, element->string.pointer, 32);
+				strscpy(ptr, element->string.pointer, 32);
 			else if (element->type == ACPI_TYPE_INTEGER) {
 				strncpy(ptr, (u8 *)&element->integer.value,
 					sizeof(u64));
-- 
2.39.2



