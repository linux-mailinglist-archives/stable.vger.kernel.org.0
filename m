Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 525C86042AF
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:09:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiJSLIp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:08:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232549AbiJSLI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:08:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA35F17C55E;
        Wed, 19 Oct 2022 03:37:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFD5FB822DD;
        Wed, 19 Oct 2022 08:42:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36825C433B5;
        Wed, 19 Oct 2022 08:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666168932;
        bh=60PZ+RY33//MRdOs+d0W6qXIbeFiZGLYctjbhfQDJfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DQZmfMwV6jhX7nNMhuAgAav1UfGjEyrIAqe5nzvMxUIvmL/o6jCAwGqMSJtrPZ1eW
         pw2e+ZD49aEDP4aDq3uL8WVIQWeFS5+vlBW6tOGDFvV5z37GetiGtOyivwDm3vIgCd
         AYssaVSuwU7vU3LJwvdF0dZxcbYG+EE05wiru81g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        Wang Wendy <wendy.wang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 6.0 101/862] powercap: intel_rapl: Use standard Energy Unit for SPR Dram RAPL domain
Date:   Wed, 19 Oct 2022 10:23:08 +0200
Message-Id: <20221019083254.368732759@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

commit 4c081324df5608b73428662ca54d5221ea03a6bd upstream.

Intel Xeon servers used to use a fixed energy resolution (15.3uj) for
Dram RAPL domain. But on SPR, Dram RAPL domain follows the standard
energy resolution as described in MSR_RAPL_POWER_UNIT.

Remove the SPR dram_domain_energy_unit quirk.

Fixes: 2d798d9f5967 ("powercap: intel_rapl: add support for Sapphire Rapids")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Wang Wendy <wendy.wang@intel.com>
Cc: 5.9+ <stable@vger.kernel.org> # 5.9+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/powercap/intel_rapl_common.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/powercap/intel_rapl_common.c
+++ b/drivers/powercap/intel_rapl_common.c
@@ -1035,7 +1035,6 @@ static const struct rapl_defaults rapl_d
 	.check_unit = rapl_check_unit_core,
 	.set_floor_freq = set_floor_freq_default,
 	.compute_time_window = rapl_compute_time_window_core,
-	.dram_domain_energy_unit = 15300,
 	.psys_domain_energy_unit = 1000000000,
 	.spr_psys_bits = true,
 };


