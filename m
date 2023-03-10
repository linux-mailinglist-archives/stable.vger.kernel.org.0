Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDAD6B4509
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232481AbjCJOag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:30:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbjCJOaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:30:15 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86691F4B44
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:29:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16A3A618A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C0AFC433EF;
        Fri, 10 Mar 2023 14:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458542;
        bh=W8UwYRrOuuAN07NjUgwA+ybcYCYJlMM2vAuC6bjrJrM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eFpr7b2dA07jsJY4XAye6GKT9N9qSFUhAEx2lMAm0bXtcB2lbZiJXQTXdZLpr0at4
         qmjtfdeqtb+3UUbz5cS6DV0kFHGRsv1AotziMYk2FdrnlsDpwn+pEHeYqyYJNDKe8T
         RqKXykCBI5193R6ISL2emYBdBmKPVC+Z4z6Hc108=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Armin Wolf <W_Armin@gmx.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 062/357] ACPI: battery: Fix missing NUL-termination with large strings
Date:   Fri, 10 Mar 2023 14:35:51 +0100
Message-Id: <20230310133736.715941431@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index 974c2df13da1d..a49a09e3de1b3 100644
--- a/drivers/acpi/battery.c
+++ b/drivers/acpi/battery.c
@@ -465,7 +465,7 @@ static int extract_package(struct acpi_battery *battery,
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



