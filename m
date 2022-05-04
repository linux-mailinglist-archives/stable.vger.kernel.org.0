Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3F6451A80C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:06:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355017AbiEDRHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355412AbiEDRET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:04:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F1F4EDC0;
        Wed,  4 May 2022 09:53:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 74FE361794;
        Wed,  4 May 2022 16:53:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C694BC385A5;
        Wed,  4 May 2022 16:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683181;
        bh=GqXocJ5EJAhLTU16Rx/GrEiSpEnAcl5XCgho8hZgfqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ip1JqS5UqQog1mjHa5ozY7oCaG2Nrne0N5ck8ul5+Q+Mc5plt7+sKSTyco3W1sPGx
         fdahs9sfcTDP2UBX60eZZpFHmi8OoABrsFDPPkigGcPkfy+pxoCJmhZ9WaFaGWc/y9
         fBN1gl1b0i9uCYrm1biRg3Lq+0J7SmT0o0nij6ac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Wang Qing <wangqing@vivo.com>
Subject: [PATCH 5.15 033/177] arch_topology: Do not set llc_sibling if llc_id is invalid
Date:   Wed,  4 May 2022 18:43:46 +0200
Message-Id: <20220504153055.948533399@linuxfoundation.org>
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

From: Wang Qing <wangqing@vivo.com>

commit 1dc9f1a66e1718479e1c4f95514e1750602a3cb9 upstream.

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
 drivers/base/arch_topology.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/base/arch_topology.c
+++ b/drivers/base/arch_topology.c
@@ -609,7 +609,7 @@ void update_siblings_masks(unsigned int
 	for_each_online_cpu(cpu) {
 		cpu_topo = &cpu_topology[cpu];
 
-		if (cpuid_topo->llc_id == cpu_topo->llc_id) {
+		if (cpu_topo->llc_id != -1 && cpuid_topo->llc_id == cpu_topo->llc_id) {
 			cpumask_set_cpu(cpu, &cpuid_topo->llc_sibling);
 			cpumask_set_cpu(cpuid, &cpu_topo->llc_sibling);
 		}


