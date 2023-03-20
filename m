Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6B036C177E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:14:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjCTPOW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:14:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232231AbjCTPOH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:14:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D7762B9D8
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:09:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4EDD5B80EAC
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:09:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9C98C433EF;
        Mon, 20 Mar 2023 15:09:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679324942;
        bh=qOx0NylQ5SqAsnJQQ9dOPNOihNCwU44HtqiZPA15SuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoHli+bLn/b7RSZSD6I9h8m/AppHEhgfmRmDoYQVGo/EeSydYFcKYlZqezXx+r1GT
         ZRg+xdeR85n9DuCz5zqnSRU/1K+MdDgE1dh+sS9L2Z8OiCJSl3ED2Kx3dvJ/xwovdV
         T56PpLz5Ha4hV8ak36TYAHaq07i5Zzg8gt6gVnZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yazen Ghannam <yazen.ghannam@amd.com>,
        "Borislav Petkov (AMD)" <bp@alien8.de>,
        Tony Luck <tony.luck@intel.com>
Subject: [PATCH 5.10 75/99] x86/mce: Make sure logged MCEs are processed after sysfs update
Date:   Mon, 20 Mar 2023 15:54:53 +0100
Message-Id: <20230320145446.547035823@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145443.333824603@linuxfoundation.org>
References: <20230320145443.333824603@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -2309,6 +2309,7 @@ static void mce_restart(void)
 {
 	mce_timer_delete_all();
 	on_each_cpu(mce_cpu_restart, NULL, 1);
+	mce_schedule_work();
 }
 
 /* Toggle features for corrected errors */


