Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D74F960A5E2
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiJXMbA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233983AbiJXM3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77CF387FB0;
        Mon, 24 Oct 2022 05:03:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E680612DA;
        Mon, 24 Oct 2022 11:54:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83682C433D6;
        Mon, 24 Oct 2022 11:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612467;
        bh=jUlYH+CCO+C1GozJgPk99oAfl+QuIg9M6++iiseMq9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IuO43QW+vapaFCju19mj4ZC+60gSwnyTJz7u9Ep5bG0FGwcecTTUwt+Sbm3KurU8c
         FRdC6Kz/AYc/IBLplKIdWwiqkUH1EWG57NnWedCOywFWeR3RIdT7rBN7F6iBqpmDiB
         YD+XDzQK0wR0NJj7WYJHoaNj8Vv0+zC41wDd1C9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 4.14 210/210] thermal: intel_powerclamp: Use first online CPU as control_cpu
Date:   Mon, 24 Oct 2022 13:32:07 +0200
Message-Id: <20221024113003.827869862@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit 4bb7f6c2781e46fc5bd00475a66df2ea30ef330d upstream.

Commit 68b99e94a4a2 ("thermal: intel_powerclamp: Use get_cpu() instead
of smp_processor_id() to avoid crash") fixed an issue related to using
smp_processor_id() in preemptible context by replacing it with a pair
of get_cpu()/put_cpu(), but what is needed there really is any online
CPU and not necessarily the one currently running the code.  Arguably,
getting the one that's running the code in there is confusing.

For this reason, simply give the control CPU role to the first online
one which automatically will be CPU0 if it is online, so one check
can be dropped from the code for an added benefit.

Link: https://lore.kernel.org/linux-pm/20221011113646.GA12080@duo.ucw.cz/
Fixes: 68b99e94a4a2 ("thermal: intel_powerclamp: Use get_cpu() instead of smp_processor_id() to avoid crash")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/intel_powerclamp.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/thermal/intel_powerclamp.c
+++ b/drivers/thermal/intel_powerclamp.c
@@ -549,11 +549,7 @@ static int start_power_clamp(void)
 	get_online_cpus();
 
 	/* prefer BSP */
-	control_cpu = 0;
-	if (!cpu_online(control_cpu)) {
-		control_cpu = get_cpu();
-		put_cpu();
-	}
+	control_cpu = cpumask_first(cpu_online_mask);
 
 	clamping = true;
 	schedule_delayed_work(&poll_pkg_cstate_work, 0);


