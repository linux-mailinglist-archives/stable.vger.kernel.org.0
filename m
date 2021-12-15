Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB58C475F43
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:32:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233157AbhLOR3G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:29:06 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46996 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245583AbhLOR0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:26:16 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6001F619E5;
        Wed, 15 Dec 2021 17:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48482C36AE0;
        Wed, 15 Dec 2021 17:26:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639589174;
        bh=HLAnwe27aqyD2NF+CqJU491kv2QJeG07NWGo/qz7i6E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I9fE0IXLmCGi9u9HRhu93LtMsuIqTidsKJUbG7Qf52e6mWiBUHwnTp+DMMXuUvxHU
         upAiRo7jf+BKXVIaEUM3NvXKgDjD57ioD7qOhtrfeixvMdhtvuB68FmLUvfrSK843K
         e/JTYRedbI4O1PUURU5m2QGMzblJEpO8fH8+5Gqw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Armin Wolf <W_Armin@gmx.de>,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 5.4 13/18] hwmon: (dell-smm) Fix warning on /proc/i8k creation error
Date:   Wed, 15 Dec 2021 18:21:34 +0100
Message-Id: <20211215172023.264891956@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172022.795825673@linuxfoundation.org>
References: <20211215172022.795825673@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Armin Wolf <W_Armin@gmx.de>

commit dbd3e6eaf3d813939b28e8a66e29d81cdc836445 upstream.

The removal function is called regardless of whether
/proc/i8k was created successfully or not, the later
causing a WARN() on module removal.
Fix that by only registering the removal function
if /proc/i8k was created successfully.

Tested on a Inspiron 3505.

Fixes: 039ae58503f3 ("hwmon: Allow to compile dell-smm-hwmon driver without /proc/i8k")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Acked-by: Pali Rohár <pali@kernel.org>
Link: https://lore.kernel.org/r/20211112171440.59006-1-W_Armin@gmx.de
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/dell-smm-hwmon.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/hwmon/dell-smm-hwmon.c
+++ b/drivers/hwmon/dell-smm-hwmon.c
@@ -588,15 +588,18 @@ static const struct file_operations i8k_
 	.unlocked_ioctl	= i8k_ioctl,
 };
 
+static struct proc_dir_entry *entry;
+
 static void __init i8k_init_procfs(void)
 {
 	/* Register the proc entry */
-	proc_create("i8k", 0, NULL, &i8k_fops);
+	entry = proc_create("i8k", 0, NULL, &i8k_fops);
 }
 
 static void __exit i8k_exit_procfs(void)
 {
-	remove_proc_entry("i8k", NULL);
+	if (entry)
+		remove_proc_entry("i8k", NULL);
 }
 
 #else


