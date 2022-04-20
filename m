Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1A2B508DDF
	for <lists+stable@lfdr.de>; Wed, 20 Apr 2022 19:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380815AbiDTRDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Apr 2022 13:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380817AbiDTRDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Apr 2022 13:03:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2307D26138
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 10:00:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D4561A81
        for <stable@vger.kernel.org>; Wed, 20 Apr 2022 17:00:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C736DC385A1;
        Wed, 20 Apr 2022 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650474050;
        bh=n/Fd0QOreFX1jouJzqoUOibqysu0dDRV0wQmcDLn7rA=;
        h=Subject:To:From:Date:From;
        b=qjDNCyQxRhSNdWeoCxWQ2jGLeIxJ5pwgDffbcSvHiMG94pIlLpYQN7dRfPEkHY8Mo
         82AEBT7PoPZdZbJmchAxFf5smO4xoWmCqFo4BJlnWOdbP5ryLU4DfCaNaN2Vy0Y+OU
         7FjG1MLP7WReKc8QSJ/YATLWOyWlQ1yD8/7Tz0Jk=
Subject: patch "arch_topology: Do not set llc_sibling if llc_id is invalid" added to driver-core-linus
To:     wangqing@vivo.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, sudeep.holla@arm.com
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 20 Apr 2022 19:00:36 +0200
Message-ID: <16504740365544@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    arch_topology: Do not set llc_sibling if llc_id is invalid

to my driver-core git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-core.git
in the driver-core-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 1dc9f1a66e1718479e1c4f95514e1750602a3cb9 Mon Sep 17 00:00:00 2001
From: Wang Qing <wangqing@vivo.com>
Date: Sun, 10 Apr 2022 19:36:19 -0700
Subject: arch_topology: Do not set llc_sibling if llc_id is invalid

When ACPI is not enabled, cpuid_topo->llc_id = cpu_topo->llc_id = -1, which
will set llc_sibling 0xff(...), this is misleading.

Don't set llc_sibling(default 0) if we don't know the cache topology.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wang Qing <wangqing@vivo.com>
Fixes: 37c3ec2d810f ("arm64: topology: divorce MC scheduling domain from core_siblings")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1649644580-54626-1-git-send-email-wangqing@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_topology.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/base/arch_topology.c b/drivers/base/arch_topology.c
index 5497c5ab7318..f73b836047cf 100644
--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -693,7 +693,7 @@ void update_siblings_masks(unsigned int cpuid)
 	for_each_online_cpu(cpu) {
 		cpu_topo = &cpu_topology[cpu];
 
-		if (cpuid_topo->llc_id == cpu_topo->llc_id) {
+		if (cpu_topo->llc_id != -1 && cpuid_topo->llc_id == cpu_topo->llc_id) {
 			cpumask_set_cpu(cpu, &cpuid_topo->llc_sibling);
 			cpumask_set_cpu(cpuid, &cpu_topo->llc_sibling);
 		}
-- 
2.35.3


