Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4076ECE58
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbjDXNbg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:31:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232499AbjDXNbN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:31:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D9F7AB5
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:30:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BCB9861F13
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:30:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDFDBC433EF;
        Mon, 24 Apr 2023 13:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343046;
        bh=Zwts10tNv+EforyZyRfjdqT/oWFrrG94yVF4zELsC2w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrliaDht9GIsLxKUnmPvq23v6yPDEnuGausc7oyLp+sWP9UMv7yDx3lDfhrRBdM9G
         sjVZIG2D8jTtY16FLXG6kTgpBimy4ZwVyyQaB11rr37wmMYhLAQyvllji2kLjzZGhB
         C8gV9cjtWgq7Y4c1qLbDuAEsISOs8IYzW9u1HPWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, "Rafael J. Wysocki" <rafael@kernel.org>,
        Jianmin Lv <lvjianmin@loongson.cn>,
        Huacai Chen <chenhuacai@loongson.cn>,
        Bob Moore <robert.moore@intel.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable@kernel.org
Subject: [PATCH 6.2 056/110] Revert "ACPICA: Events: Support fixed PCIe wake event"
Date:   Mon, 24 Apr 2023 15:17:18 +0200
Message-Id: <20230424131138.388793981@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 8e41e0a575664d26bb87e012c39435c4c3914ed9 upstream.

This reverts commit 5c62d5aab8752e5ee7bfbe75ed6060db1c787f98.

This broke wake-on-lan for multiple people, and for much too long.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=217069
Link: https://lore.kernel.org/all/754225a2-95a9-2c36-1886-7da1a78308c2@loongson.cn/
Link: https://github.com/acpica/acpica/pull/866
Cc: Rafael J. Wysocki <rafael@kernel.org>
Cc: Jianmin Lv <lvjianmin@loongson.cn>
Cc: Huacai Chen <chenhuacai@loongson.cn>
Cc: Bob Moore <robert.moore@intel.com>
Cc: stable@kernel.org # 6.2
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/acpica/evevent.c  |   11 -----------
 drivers/acpi/acpica/hwsleep.c  |   14 --------------
 drivers/acpi/acpica/utglobal.c |    4 ----
 include/acpi/actypes.h         |    3 +--
 4 files changed, 1 insertion(+), 31 deletions(-)

--- a/drivers/acpi/acpica/evevent.c
+++ b/drivers/acpi/acpica/evevent.c
@@ -142,9 +142,6 @@ static acpi_status acpi_ev_fixed_event_i
 			status =
 			    acpi_write_bit_register(acpi_gbl_fixed_event_info
 						    [i].enable_register_id,
-						    (i ==
-						     ACPI_EVENT_PCIE_WAKE) ?
-						    ACPI_ENABLE_EVENT :
 						    ACPI_DISABLE_EVENT);
 			if (ACPI_FAILURE(status)) {
 				return (status);
@@ -188,11 +185,6 @@ u32 acpi_ev_fixed_event_detect(void)
 		return (int_status);
 	}
 
-	if (fixed_enable & ACPI_BITMASK_PCIEXP_WAKE_DISABLE)
-		fixed_enable &= ~ACPI_BITMASK_PCIEXP_WAKE_DISABLE;
-	else
-		fixed_enable |= ACPI_BITMASK_PCIEXP_WAKE_DISABLE;
-
 	ACPI_DEBUG_PRINT((ACPI_DB_INTERRUPTS,
 			  "Fixed Event Block: Enable %08X Status %08X\n",
 			  fixed_enable, fixed_status));
@@ -258,9 +250,6 @@ static u32 acpi_ev_fixed_event_dispatch(
 	if (!acpi_gbl_fixed_event_handlers[event].handler) {
 		(void)acpi_write_bit_register(acpi_gbl_fixed_event_info[event].
 					      enable_register_id,
-					      (event ==
-					       ACPI_EVENT_PCIE_WAKE) ?
-					      ACPI_ENABLE_EVENT :
 					      ACPI_DISABLE_EVENT);
 
 		ACPI_ERROR((AE_INFO,
--- a/drivers/acpi/acpica/hwsleep.c
+++ b/drivers/acpi/acpica/hwsleep.c
@@ -311,20 +311,6 @@ acpi_status acpi_hw_legacy_wake(u8 sleep
 				    [ACPI_EVENT_SLEEP_BUTTON].
 				    status_register_id, ACPI_CLEAR_STATUS);
 
-	/* Enable pcie wake event if support */
-	if ((acpi_gbl_FADT.flags & ACPI_FADT_PCI_EXPRESS_WAKE)) {
-		(void)
-		    acpi_write_bit_register(acpi_gbl_fixed_event_info
-					    [ACPI_EVENT_PCIE_WAKE].
-					    enable_register_id,
-					    ACPI_DISABLE_EVENT);
-		(void)
-		    acpi_write_bit_register(acpi_gbl_fixed_event_info
-					    [ACPI_EVENT_PCIE_WAKE].
-					    status_register_id,
-					    ACPI_CLEAR_STATUS);
-	}
-
 	acpi_hw_execute_sleep_method(METHOD_PATHNAME__SST, ACPI_SST_WORKING);
 	return_ACPI_STATUS(status);
 }
--- a/drivers/acpi/acpica/utglobal.c
+++ b/drivers/acpi/acpica/utglobal.c
@@ -186,10 +186,6 @@ struct acpi_fixed_event_info acpi_gbl_fi
 					ACPI_BITREG_RT_CLOCK_ENABLE,
 					ACPI_BITMASK_RT_CLOCK_STATUS,
 					ACPI_BITMASK_RT_CLOCK_ENABLE},
-	/* ACPI_EVENT_PCIE_WAKE     */ {ACPI_BITREG_PCIEXP_WAKE_STATUS,
-					ACPI_BITREG_PCIEXP_WAKE_DISABLE,
-					ACPI_BITMASK_PCIEXP_WAKE_STATUS,
-					ACPI_BITMASK_PCIEXP_WAKE_DISABLE},
 };
 #endif				/* !ACPI_REDUCED_HARDWARE */
 
--- a/include/acpi/actypes.h
+++ b/include/acpi/actypes.h
@@ -723,8 +723,7 @@ typedef u32 acpi_event_type;
 #define ACPI_EVENT_POWER_BUTTON         2
 #define ACPI_EVENT_SLEEP_BUTTON         3
 #define ACPI_EVENT_RTC                  4
-#define ACPI_EVENT_PCIE_WAKE            5
-#define ACPI_EVENT_MAX                  5
+#define ACPI_EVENT_MAX                  4
 #define ACPI_NUM_FIXED_EVENTS           ACPI_EVENT_MAX + 1
 
 /*


