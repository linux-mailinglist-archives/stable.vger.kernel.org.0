Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5893A4FC9A9
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:45:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242922AbiDLAsK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243374AbiDLAru (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:47:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C6C1AF14;
        Mon, 11 Apr 2022 17:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C9C99617F1;
        Tue, 12 Apr 2022 00:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E059C385AB;
        Tue, 12 Apr 2022 00:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724334;
        bh=9tgTgIrTemDGv97o6B8jl4nwl+jRC9WPDriLZxzNA9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ktIKcLdV6BdjQo0ZwfTvk3BzciQFnAj4MDjLOjlMFMKAThlB6H/a7H0MzFd2PCJpP
         K2mW11M7ABz60UFRiJ37XcaN5u5bW5ZPLUXfKeu/N8dsDw+QzUN8ZPrKBKmuJw1yKk
         Oe9pmduBKCeQqVwR16gmya8LI+XJlWqqgyx09EdOPf1XGSXGtDWhX3BZBUG08Svrnv
         ynaL4z96V/LQ2SoK6jI0eid5mGJI7+8ibkZ7RryfGhyVeZmHTNKJXkVmdOjXq4np3J
         MqaX+i8rdQexFWlWy/Qa30e3TEKnp6dK6D2xQH0zqw0Q3aoORnGBJ91skPVTsNxsmJ
         9kvknuQ93Kxvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Akihiko Odaki <akihiko.odaki@gmail.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 26/49] Revert "ACPI: processor: idle: Only flush cache on entering C3"
Date:   Mon, 11 Apr 2022 20:43:44 -0400
Message-Id: <20220412004411.349427-26-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Akihiko Odaki <akihiko.odaki@gmail.com>

[ Upstream commit dfbba2518aac4204203b0697a894d3b2f80134d3 ]

Revert commit 87ebbb8c612b ("ACPI: processor: idle: Only flush cache
on entering C3") that broke the assumptions of the acpi_idle_play_dead()
callers.

Namely, the CPU cache must always be flushed in acpi_idle_play_dead(),
regardless of the target C-state that is going to be requested, because
this is likely to be part of a CPU offline procedure or preparation for
entering a system-wide sleep state and the lack of synchronization
between the CPU cache and RAM may lead to problems going forward, for
example when the CPU is brought back online.

In particular, it breaks resume from suspend-to-RAM on Lenovo ThinkPad
C13 which fails occasionally until the problematic commit is reverted.

Signed-off-by: Akihiko Odaki <akihiko.odaki@gmail.com>
[ rjw: Changelog ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/processor_idle.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index f8e9fa82cb9b..05b3985a1984 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -570,8 +570,7 @@ static int acpi_idle_play_dead(struct cpuidle_device *dev, int index)
 {
 	struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
 
-	if (cx->type == ACPI_STATE_C3)
-		ACPI_FLUSH_CPU_CACHE();
+	ACPI_FLUSH_CPU_CACHE();
 
 	while (1) {
 
-- 
2.35.1

