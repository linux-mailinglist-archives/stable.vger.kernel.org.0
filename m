Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02E56469D7F
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386769AbhLFP37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358426AbhLFP1I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:27:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4DBC08EAFA;
        Mon,  6 Dec 2021 07:17:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BBE361370;
        Mon,  6 Dec 2021 15:17:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00A5DC341C1;
        Mon,  6 Dec 2021 15:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803860;
        bh=npZnKvU/5nR7hogz3rwlhMBpti5q4HTa3KMsKQ8fejI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKcly99fQSLVX8gMODmMRUb/i+6tyhEmOj1nNFY4D8p2MIdyhGAtVjG2SMnVtSH1S
         yp2w5HOnJfb7K0jCj3Jf2VjDUe80JckMWi4157CzQadEussDe2djvlWB4V3FkJkiIJ
         wEpv56nmilb2EVy1Xj90a7hXdo7PCOIUU2ZO5HlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 030/130] ACPI: Add stubs for wakeup handler functions
Date:   Mon,  6 Dec 2021 15:55:47 +0100
Message-Id: <20211206145600.678216964@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit e9380df851878cee71df5a1c7611584421527f7e ]

The commit ddfd9dcf270c ("ACPI: PM: Add acpi_[un]register_wakeup_handler()")
added new functions for drivers to use during the s2idle wakeup path, but
didn't add stubs for when CONFIG_ACPI wasn't set.

Add those stubs in for other drivers to be able to use.

Fixes: ddfd9dcf270c ("ACPI: PM: Add acpi_[un]register_wakeup_handler()")
Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Link: https://lore.kernel.org/r/20211101014853.6177-1-mario.limonciello@amd.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/acpi.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index fdb1d5262ce84..96d69404a54ff 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -953,6 +953,15 @@ static inline struct acpi_device *acpi_resource_consumer(struct resource *res)
 	return NULL;
 }
 
+static inline int acpi_register_wakeup_handler(int wake_irq,
+	bool (*wakeup)(void *context), void *context)
+{
+	return -ENXIO;
+}
+
+static inline void acpi_unregister_wakeup_handler(
+	bool (*wakeup)(void *context), void *context) { }
+
 #endif	/* !CONFIG_ACPI */
 
 #ifdef CONFIG_ACPI_HOTPLUG_IOAPIC
-- 
2.33.0



