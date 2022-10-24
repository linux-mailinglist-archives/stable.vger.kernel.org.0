Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18D0360B9C9
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234192AbiJXUVT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234193AbiJXUUx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:20:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 890C5127BC9;
        Mon, 24 Oct 2022 11:37:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51ABDB81714;
        Mon, 24 Oct 2022 12:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8BCFC433D6;
        Mon, 24 Oct 2022 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614791;
        bh=AW2HmN9TqaQ00WLNTP/efmBXWbdmYViKnrGlcIbwwjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=esIBHyrfZld3/bmDjWGOPPjJel04SBoJ1mA5ByF31/LTD1AyYe/6AMrC2MQkCpBUT
         MPErjeOjNr8qxF2wBLFTBGirFcHqqD3dXsNcbc9J9BnASou68aB9arPrsQfxQHD0vm
         7ZFW7HhL/6wN3gDne55bSGecWp+AzAEzTp35W2Ec=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Chen Yu <yu.c.chen@intel.com>
Subject: [PATCH 5.10 388/390] thermal: intel_powerclamp: Use first online CPU as control_cpu
Date:   Mon, 24 Oct 2022 13:33:05 +0200
Message-Id: <20221024113039.490974083@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
 drivers/thermal/intel/intel_powerclamp.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/thermal/intel/intel_powerclamp.c
+++ b/drivers/thermal/intel/intel_powerclamp.c
@@ -531,11 +531,7 @@ static int start_power_clamp(void)
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


