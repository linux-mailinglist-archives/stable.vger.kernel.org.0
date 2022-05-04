Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE25651A60C
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 18:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353802AbiEDQwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 12:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353731AbiEDQwL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 12:52:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D2647053;
        Wed,  4 May 2022 09:48:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C3A1B8279F;
        Wed,  4 May 2022 16:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20EB0C385BD;
        Wed,  4 May 2022 16:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651682908;
        bh=yd24OcPBlVIUgxJ+YzdgSDislzfz6tX0jHWJ+szSPI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sXJt1j5kuQv5ALCD9/V8GFdWA17rWLN1zbH/0mlSMWwWSSmVSMz94YN3YFgIifquL
         cl8kQvA+kJilK0ZUttR9660Crc3AP9sOJLxV696PTBlk2ir3ZdnMsTLLlUea0rzkz/
         iHdlBnMmhYV3I01yiswY6z4J8OYPsfaHkosLxH8M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Wang Qing <wangqing@vivo.com>
Subject: [PATCH 5.4 26/84] arch_topology: Do not set llc_sibling if llc_id is invalid
Date:   Wed,  4 May 2022 18:44:07 +0200
Message-Id: <20220504152929.640436437@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504152927.744120418@linuxfoundation.org>
References: <20220504152927.744120418@linuxfoundation.org>
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
@@ -457,7 +457,7 @@ void update_siblings_masks(unsigned int
 	for_each_online_cpu(cpu) {
 		cpu_topo = &cpu_topology[cpu];
 
-		if (cpuid_topo->llc_id == cpu_topo->llc_id) {
+		if (cpu_topo->llc_id != -1 && cpuid_topo->llc_id == cpu_topo->llc_id) {
 			cpumask_set_cpu(cpu, &cpuid_topo->llc_sibling);
 			cpumask_set_cpu(cpuid, &cpu_topo->llc_sibling);
 		}


