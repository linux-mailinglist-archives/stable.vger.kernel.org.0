Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 870F46C198D
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233050AbjCTPeq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233101AbjCTPeM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:34:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CEC39CE2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:27:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 031F561573
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E68FC433EF;
        Mon, 20 Mar 2023 15:27:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326025;
        bh=t10baPFMjYxnBT9DtwzxrADo+aZVsP3beoyuFEEIX1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zaStDLUXp8y7X8IPQhiX1BElbJrwQ+diE8oG72WpmtArWiubnjuoA2vtR6pW2evaM
         eeNiDQoB+68gKqejErgR04I4xPrmyFNZTUe4/xmTirTo2UxKdSWRjjlfmWEwMgoxbf
         CVcAQgAk/GXuyPRM6zA+43+h9g4smHIfTybx5NUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yazen Ghannam <yazen.ghannam@amd.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 6.1 187/198] x86/mce: Make sure logged MCEs are processed after sysfs update
Date:   Mon, 20 Mar 2023 15:55:25 +0100
Message-Id: <20230320145515.319079456@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 4783b9cb374af02d49740e00e2da19fd4ed6dec4 upstream.

A recent change introduced a flag to queue up errors found during
boot-time polling. These errors will be processed during late init once
the MCE subsystem is fully set up.

A number of sysfs updates call mce_restart() which goes through a subset
of the CPU init flow. This includes polling MCA banks and logging any
errors found. Since the same function is used as boot-time polling,
errors will be queued. However, the system is now past late init, so the
errors will remain queued until another error is found and the workqueue
is triggered.

Call mce_schedule_work() at the end of mce_restart() so that queued
errors are processed.

Fixes: 3bff147b187d ("x86/mce: Defer processing of early errors")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230301221420.2203184-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2365,6 +2365,7 @@ static void mce_restart(void)
 {
 	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
+	mce_schedule_work();
 }
 
 /* Toggle features for corrected errors */


