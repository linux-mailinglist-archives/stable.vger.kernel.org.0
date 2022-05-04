Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 345D751A857
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343881AbiEDRKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356181AbiEDRJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 835E452E41;
        Wed,  4 May 2022 09:54:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F13961794;
        Wed,  4 May 2022 16:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69FA2C385A4;
        Wed,  4 May 2022 16:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683295;
        bh=TSEPwtreDnFz7e52zYOcOmj3K2cUukjzTzINFygPDPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bvMiQtm6PNi/eFip9l7drEO9FKoFN9Em+kl0t/nK5QR42Zo3r1Yn9oG20iTdDbRQG
         1TyOUIMjxMUipLkXJFXHGGdUaAw8a9r9f6MP+Vkju7sy5owGZ+o1U7BRzcfHMp+9Qy
         8a/HiJj8BRRTPHaJiDRs6dEGA2giNnR8JBIlngdg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Woody Suwalski <wsuwalski@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 149/177] ACPI: processor: idle: Avoid falling back to C3 type C-states
Date:   Wed,  4 May 2022 18:45:42 +0200
Message-Id: <20220504153106.656086753@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153053.873100034@linuxfoundation.org>
References: <20220504153053.873100034@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit fc45e55ebc58dbf622cb89ddbf797589c7a5510b upstream.

The "safe state" index is used by acpi_idle_enter_bm() to avoid
entering a C-state that may require bus mastering to be disabled
on entry in the cases when this is not going to happen.  For this
reason, it should not be set to point to C3 type of C-states, because
they may require bus mastering to be disabled on entry in principle.

This was broken by commit d6b88ce2eb9d ("ACPI: processor idle: Allow
playing dead in C3 state") which inadvertently allowed the "safe
state" index to point to C3 type of C-states.

This results in a machine that won't boot past the point when it first
enters C3. Restore the correct behaviour (either demote to C1/C2, or
use C3 but also set ARB_DIS=1).

I hit this on a Fujitsu Siemens Lifebook S6010 (P3) machine.

Fixes: d6b88ce2eb9d ("ACPI: processor idle: Allow playing dead in C3 state")
Cc: 5.16+ <stable@vger.kernel.org> # 5.16+
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Tested-by: Woody Suwalski <wsuwalski@gmail.com>
[ rjw: Subject and changelog adjustments ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -792,7 +792,8 @@ static int acpi_processor_setup_cstates(
 		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
 		    cx->type == ACPI_STATE_C3) {
 			state->enter_dead = acpi_idle_play_dead;
-			drv->safe_state_index = count;
+			if (cx->type != ACPI_STATE_C3)
+				drv->safe_state_index = count;
 		}
 		/*
 		 * Halt-induced C1 is not good for ->enter_s2idle, because it


