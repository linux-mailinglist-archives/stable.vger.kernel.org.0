Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA9751654B
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 18:31:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349189AbiEAQfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 12:35:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235795AbiEAQfT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 12:35:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70DB51F622
        for <stable@vger.kernel.org>; Sun,  1 May 2022 09:31:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D8BEB80E79
        for <stable@vger.kernel.org>; Sun,  1 May 2022 16:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA93C385A9;
        Sun,  1 May 2022 16:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651422711;
        bh=0RV389WHVgXU9DInFfFQYuna2+Y9+rvjef+RAZ0AG4A=;
        h=Subject:To:Cc:From:Date:From;
        b=Elr2L4j5ykr/VIaYhnHrWXIPTlVsjOApDppnZMfcOkNIQLxsXp4U50VQoI99z6UIh
         ouNlG2aZfWrzTDF7oyzO5lVUFP2wRgbFUIGTHuJlX5KDnaZSi5RcrYBgQpb2HM81j4
         l4C4Men3tfbCJW427orFtW43HryhdcAjnqwxIYZY=
Subject: FAILED: patch "[PATCH] arch_topology: Do not set llc_sibling if llc_id is invalid" failed to apply to 4.19-stable tree
To:     wangqing@vivo.com, gregkh@linuxfoundation.org,
        stable@vger.kernel.org, sudeep.holla@arm.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 01 May 2022 18:31:43 +0200
Message-ID: <1651422703135153@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1dc9f1a66e1718479e1c4f95514e1750602a3cb9 Mon Sep 17 00:00:00 2001
From: Wang Qing <wangqing@vivo.com>
Date: Sun, 10 Apr 2022 19:36:19 -0700
Subject: [PATCH] arch_topology: Do not set llc_sibling if llc_id is invalid

When ACPI is not enabled, cpuid_topo->llc_id = cpu_topo->llc_id = -1, which
will set llc_sibling 0xff(...), this is misleading.

Don't set llc_sibling(default 0) if we don't know the cache topology.

Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Wang Qing <wangqing@vivo.com>
Fixes: 37c3ec2d810f ("arm64: topology: divorce MC scheduling domain from core_siblings")
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1649644580-54626-1-git-send-email-wangqing@vivo.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

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

