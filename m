Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA15615A36
	for <lists+stable@lfdr.de>; Wed,  2 Nov 2022 04:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiKBD1F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 23:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbiKBD1D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 23:27:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88CE625EAF
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 20:27:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 21DEC61799
        for <stable@vger.kernel.org>; Wed,  2 Nov 2022 03:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACC48C433D6;
        Wed,  2 Nov 2022 03:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667359621;
        bh=IhrGfmwYXYqeJZswn1Ps3hxRwNcYIk1qgLLUivstMuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HBdyayWqYXFifO090b8mRZiehb0dXASYEJ3H91rH5VfeRo8cLTZf+LYzbFTVpJlIU
         G9hNv7Y/DfOvqQ3atJPp5dRDemXtFMe/qh/YK2E6vwFkwkmziWfjjCtRkWFtZ1YWQi
         3NimjDkc7DsJJYkVyKwhk0d9QbQK71lIxWq39MKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        kolAflash <kolAflash@kolahilft.de>
Subject: [PATCH 5.4 46/64] PM: hibernate: Allow hybrid sleep to work with s2idle
Date:   Wed,  2 Nov 2022 03:34:12 +0100
Message-Id: <20221102022053.300734944@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
References: <20221102022051.821538553@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 85850af4fc47132f3f2f0dd698b90f67906600b4 ]

Hybrid sleep is currently hardcoded to only operate with S3 even
on systems that might not support it.

Instead of assuming this mode is what the user wants to use, for
hybrid sleep follow the setting of `mem_sleep_current` which
will respect mem_sleep_default kernel command line and policy
decisions made by the presence of the FADT low power idle bit.

Fixes: 81d45bdf8913 ("PM / hibernate: Untangle power_down()")
Reported-and-tested-by: kolAflash <kolAflash@kolahilft.de>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=216574
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/power/hibernate.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
index 406b4cbbec5e..f8934f9746e6 100644
--- a/kernel/power/hibernate.c
+++ b/kernel/power/hibernate.c
@@ -625,7 +625,7 @@ static void power_down(void)
 	int error;
 
 	if (hibernation_mode == HIBERNATION_SUSPEND) {
-		error = suspend_devices_and_enter(PM_SUSPEND_MEM);
+		error = suspend_devices_and_enter(mem_sleep_current);
 		if (error) {
 			hibernation_mode = hibernation_ops ?
 						HIBERNATION_PLATFORM :
-- 
2.35.1



