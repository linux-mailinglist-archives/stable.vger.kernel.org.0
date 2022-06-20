Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAF95551A2F
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:07:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244736AbiFTNFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:05:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244021AbiFTNEa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:04:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C09118B0C;
        Mon, 20 Jun 2022 05:59:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD09D61535;
        Mon, 20 Jun 2022 12:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0D97C341C5;
        Mon, 20 Jun 2022 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655729975;
        bh=sfDb3mHACG0mx6O4ZAXXUVk6gPwkIftBcHm8i0J20x8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O/orYQj1qBtm44wt40PN62CT0fEbD4ADUlWwCDZjYzglEInrCskaOWEk6ik95LsMm
         dbQzxYoouGRcgRmSR5cqKbviE40MwHjrbZhwUklJ7J6KN9AEp850v++zErQPudoDZz
         30O+glG2iQLSw5QpYrWsGtIUd7d2/EElc7AYFnjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Harrison <John.C.Harrison@Intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.18 135/141] drm/i915/uc: remove accidental static from a local variable
Date:   Mon, 20 Jun 2022 14:51:13 +0200
Message-Id: <20220620124733.550621581@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124729.509745706@linuxfoundation.org>
References: <20220620124729.509745706@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 2636e008112465ca54559ac4898da5a2515e118a upstream.

The arrays are static const, but the pointer shouldn't be static.

Fixes: 3d832f370d16 ("drm/i915/uc: Allow platforms to have GuC but not HuC")
Cc: John Harrison <John.C.Harrison@Intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511094619.27889-1-jani.nikula@intel.com
(cherry picked from commit 5821a0bbb4c39960975d29d6b58ae290088db0ed)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c
@@ -154,7 +154,7 @@ __uc_fw_auto_select(struct drm_i915_priv
 		[INTEL_UC_FW_TYPE_GUC] = { blobs_guc, ARRAY_SIZE(blobs_guc) },
 		[INTEL_UC_FW_TYPE_HUC] = { blobs_huc, ARRAY_SIZE(blobs_huc) },
 	};
-	static const struct uc_fw_platform_requirement *fw_blobs;
+	const struct uc_fw_platform_requirement *fw_blobs;
 	enum intel_platform p = INTEL_INFO(i915)->platform;
 	u32 fw_count;
 	u8 rev = INTEL_REVID(i915);


