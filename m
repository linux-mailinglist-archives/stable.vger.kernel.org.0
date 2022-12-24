Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF69E6557BD
	for <lists+stable@lfdr.de>; Sat, 24 Dec 2022 02:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbiLXBjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 20:39:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236876AbiLXBio (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 20:38:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 319EA8FCB;
        Fri, 23 Dec 2022 17:32:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 757ED61FB1;
        Sat, 24 Dec 2022 01:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2311C433EF;
        Sat, 24 Dec 2022 01:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671845572;
        bh=YgHZ8D+uhrJJjS+I3e0lf/ELxAOX3GioAVAFx+oo/9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2Pcb2dmtxi2jzTvWVDvazsXNTnYaTk2lAzS0i54q19snJF7I0kHOegdu/xgCHcot
         X5mS2iBIfkyEItFwy7mjnGXm1YwuAxy4mn7zH9b/tCunqO6UlbGnYxE26ykp26na5D
         3zNSbTHwKpl8ZphAVKjvvS3KxT9S7IEg2T/bJckUHRT7Ffq+JCkeZqhQOGskCxtRaM
         UpgEwM43SGlWFCDThlY3qiG3R4okOpQT7XusoMpC+uYETIGk3R/L+KBUpbKDtJPMmS
         FQF5lFIf+X50k47jaomzHJlMBJtw6NoLdsrtmFPAk+p7wwDFHllIgeZwPPqilDcdaU
         01aXvjNLRhpAA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, robert.moore@intel.com,
        linux-acpi@vger.kernel.org, devel@acpica.org
Subject: [PATCH AUTOSEL 5.4 6/7] ACPICA: Fix operand resolution
Date:   Fri, 23 Dec 2022 20:32:32 -0500
Message-Id: <20221224013233.393537-6-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221224013233.393537-1-sashal@kernel.org>
References: <20221224013233.393537-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 7dfb216eda99bbfc2a8c3b03d2eec63314f52b3c ]

In our tests we get UBSAN warning coming from ACPI parser. This is
caused by trying to resolve operands when there is none.

[    0.000000] Linux version 5.15.0-rc3chromeavsrel1.0.184+ (root@...) (gcc (Ubuntu 10.3.0-1ubuntu1~20.04) 10.3.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #1 SMP PREEMPT Sat Oct 16 00:08:27 UTC 2021
...
[ 14.719508] ================================================================================
[ 14.719551] UBSAN: array-index-out-of-bounds in /.../linux/drivers/acpi/acpica/dswexec.c:401:12
[ 14.719594] index -1 is out of range for type 'acpi_operand_object *[9]'
[ 14.719621] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 5.15.0-rc3chromeavsrel1.0.184+ #1
[ 14.719657] Hardware name: Intel Corp. Geminilake/GLK RVP2 LP4SD (07), BIOS GELKRVPA.X64.0214.B50.2009111159 09/11/2020
[ 14.719694] Call Trace:
[ 14.719712] dump_stack_lvl+0x38/0x49
[ 14.719749] dump_stack+0x10/0x12
[ 14.719775] ubsan_epilogue+0x9/0x45
[ 14.719801] __ubsan_handle_out_of_bounds.cold+0x44/0x49
[ 14.719835] acpi_ds_exec_end_op+0x1d7/0x6b5
[ 14.719870] acpi_ps_parse_loop+0x942/0xb34
...

Problem happens because WalkState->NumOperands is 0 and it is used when
trying to access into operands table. Actual code is:
WalkState->Operands [WalkState->NumOperands -1]
which causes out of bound access. Improve the check before above access
to check if ACPI opcode should have any arguments (operands) at all.

Link: https://github.com/acpica/acpica/pull/745
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/dswexec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/acpica/dswexec.c b/drivers/acpi/acpica/dswexec.c
index a68237b97c4c..309942672a96 100644
--- a/drivers/acpi/acpica/dswexec.c
+++ b/drivers/acpi/acpica/dswexec.c
@@ -389,9 +389,11 @@ acpi_status acpi_ds_exec_end_op(struct acpi_walk_state *walk_state)
 
 		/*
 		 * All opcodes require operand resolution, with the only exceptions
-		 * being the object_type and size_of operators.
+		 * being the object_type and size_of operators as well as opcodes that
+		 * take no arguments.
 		 */
-		if (!(walk_state->op_info->flags & AML_NO_OPERAND_RESOLVE)) {
+		if (!(walk_state->op_info->flags & AML_NO_OPERAND_RESOLVE) &&
+		    (walk_state->op_info->flags & AML_HAS_ARGS)) {
 
 			/* Resolve all operands */
 
-- 
2.35.1

