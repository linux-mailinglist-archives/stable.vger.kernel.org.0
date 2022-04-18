Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9573050515F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237347AbiDRMed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239817AbiDRMda (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:33:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C66C71BE8C;
        Mon, 18 Apr 2022 05:26:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7677BB80EC1;
        Mon, 18 Apr 2022 12:26:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BA15C385A8;
        Mon, 18 Apr 2022 12:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650284807;
        bh=F7jFz2PUQMud+q2P4/1QywOPlW8/vTq6rZs6faxrbOw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dFFYGJYVj8Eimic9Jl1OZlbN/vltusj/Nlt0MVd8Cinc223PzLAYYPCuUSPCGHhti
         5NKkOoLT0ui3pAblp59Il0FQYLpnRm1gNC7gnu8oAI1YbiXDDzzmLqRT4aB+w7Sbbq
         fRQYf5qv1rRLfXSkhhpuphKsRsgdmWM5epspNjDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mario Limonciello <mario.limonciello@amd.com>,
        Richard Gong <richard.gong@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.15 007/189] ACPI: processor idle: Allow playing dead in C3 state
Date:   Mon, 18 Apr 2022 14:10:27 +0200
Message-Id: <20220418121200.641255207@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Richard Gong <richard.gong@amd.com>

commit d6b88ce2eb9d2698eb24451eb92c0a1649b17bb1 upstream.

When some cores are disabled on AMD platforms, the system will no longer
be able to enter suspend-to-idle s0ix.

Update to allow playing dead in C3 state so that the CPUs can enter the
deepest state on AMD platforms.

BugLink: https://gitlab.freedesktop.org/drm/amd/-/issues/1708
Suggested-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Richard Gong <richard.gong@amd.com>
[ rjw: Fixed coding style ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/processor_idle.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -789,7 +789,8 @@ static int acpi_processor_setup_cstates(
 		state->enter = acpi_idle_enter;
 
 		state->flags = 0;
-		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2) {
+		if (cx->type == ACPI_STATE_C1 || cx->type == ACPI_STATE_C2 ||
+		    cx->type == ACPI_STATE_C3) {
 			state->enter_dead = acpi_idle_play_dead;
 			drv->safe_state_index = count;
 		}


