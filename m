Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0E74CF8E7
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 11:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238986AbiCGKCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 05:02:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240161AbiCGKAr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 05:00:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A9BB7E0A7;
        Mon,  7 Mar 2022 01:46:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976416116E;
        Mon,  7 Mar 2022 09:46:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A28D4C340E9;
        Mon,  7 Mar 2022 09:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646413;
        bh=aU0Y04APZ85P1rnfe0lrNNhe9t5kaVF9E89VwKMrJ18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tj/2IiLw4PduA2eH4cnefR9bFtO/xX5BQGpZ+aaLic+9Wl4nrzhUTUDzR0nWvIJiy
         egD5ow3aaS7FHr/5nv+ut9mT74mUGkXqL8WDDo/vjhgjCIoQQDxomJN4B21tOi97f5
         F3wjpmWmzmoalMo+cu0EKRmbGh/IGbWrLA3R9C/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Vinay Belgaumkar <vinay.belgaumkar@intel.com>,
        Ramalingam C <ramalingam.c@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 235/262] drm/i915/guc/slpc: Correct the param count for unset param
Date:   Mon,  7 Mar 2022 10:19:39 +0100
Message-Id: <20220307091709.945872528@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Belgaumkar <vinay.belgaumkar@intel.com>

[ Upstream commit 1b279f6ad467535c3b8a66b4edefaca2cdd5bdc3 ]

SLPC unset param H2G only needs one parameter - the id of the
param.

Fixes: 025cb07bebfa ("drm/i915/guc/slpc: Cache platform frequency limits")

Suggested-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Vinay Belgaumkar <vinay.belgaumkar@intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Ramalingam C <ramalingam.c@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220216181504.7155-1-vinay.belgaumkar@intel.com
(cherry picked from commit 9648f1c3739505557d94ff749a4f32192ea81fe3)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
index 65a3e7fdb2b2..95ff630157b9 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_slpc.c
@@ -133,7 +133,7 @@ static int guc_action_slpc_unset_param(struct intel_guc *guc, u8 id)
 {
 	u32 request[] = {
 		GUC_ACTION_HOST2GUC_PC_SLPC_REQUEST,
-		SLPC_EVENT(SLPC_EVENT_PARAMETER_UNSET, 2),
+		SLPC_EVENT(SLPC_EVENT_PARAMETER_UNSET, 1),
 		id,
 	};
 
-- 
2.34.1



