Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031F34FD625
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377501AbiDLHuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359268AbiDLHmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:42:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EFD32C128;
        Tue, 12 Apr 2022 00:21:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AA226153F;
        Tue, 12 Apr 2022 07:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B7F7C385A1;
        Tue, 12 Apr 2022 07:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649748085;
        bh=Tnn2M0xaBWyd+/S1Dkmi6sGPEzK/LZOpiFyK6e9fGBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0dOT83nzU9LifjqInz6O4LPN5vT427EtgC6S5Ra1iOKf8HewRrfvtNzz4S4IAM+dc
         IQgXxgyP4LoO60xAhRCp0TW8OrsgvZpo6xcxQvIlRxgWavWtoo6ce6dZLhhEF8OLx4
         zv+oynhdnKLVjq10+2w1H8AANIo4mv6HLI5MqvSU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Akihiko Odaki <akihiko.odaki@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Ketsui <esgwpl@gmail.com>
Subject: [PATCH 5.17 313/343] Revert "ACPI: processor: idle: Only flush cache on entering C3"
Date:   Tue, 12 Apr 2022 08:32:11 +0200
Message-Id: <20220412063000.357228895@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

commit dfbba2518aac4204203b0697a894d3b2f80134d3 upstream.

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
Cc: Ketsui <esgwpl@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -570,8 +570,7 @@ static int acpi_idle_play_dead(struct cp
 {
 	struct acpi_processor_cx *cx = per_cpu(acpi_cstate[index], dev->cpu);
 
-	if (cx->type == ACPI_STATE_C3)
-		ACPI_FLUSH_CPU_CACHE();
+	ACPI_FLUSH_CPU_CACHE();
 
 	while (1) {
 


