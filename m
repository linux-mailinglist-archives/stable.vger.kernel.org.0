Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FFF566D06
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbiGEMUp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:20:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237092AbiGEMSn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:18:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DC6E1C930;
        Tue,  5 Jul 2022 05:13:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FC49619E2;
        Tue,  5 Jul 2022 12:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587CBC341C7;
        Tue,  5 Jul 2022 12:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023236;
        bh=UwoVQFB2xwA9RIMlc72V+TJNik4rzihZerxzliovbrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GBEW4WTVDuWQWqABheBDJUM6LY78sXLPRvknluzPkGSuAtOAHPEQmG7x/d3+MJul8
         MmnqiifiAGkRHYijLBGcZdW0qWxkvkFvGhq5mpoqPyHbAvo5MomjCGgVWHir1n3B3P
         Oe5L2+MOGeZFlU8dOM+e487dUh91nNaAyhajt42o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        katrinzhou <katrinzhou@tencent.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 87/98] drm/i915/gem: add missing else
Date:   Tue,  5 Jul 2022 13:58:45 +0200
Message-Id: <20220705115620.040019331@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: katrinzhou <katrinzhou@tencent.com>

[ Upstream commit 9efdd519d001ee3e761f6ff80d5eb123387421c1 ]

Add missing else in set_proto_ctx_param() to fix coverity issue.

Addresses-Coverity: ("Unused value")
Fixes: d4433c7600f7 ("drm/i915/gem: Use the proto-context to handle create parameters (v5)")
Suggested-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: katrinzhou <katrinzhou@tencent.com>
[tursulin: fixup alignment]
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220621124926.615884-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 7482a65664c16cc88eb84d2b545a1fed887378a1)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 166bb46408a9..ee0c0b712522 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -720,8 +720,9 @@ static int set_proto_ctx_param(struct drm_i915_file_private *fpriv,
 	case I915_CONTEXT_PARAM_PERSISTENCE:
 		if (args->size)
 			ret = -EINVAL;
-		ret = proto_context_set_persistence(fpriv->dev_priv, pc,
-						    args->value);
+		else
+			ret = proto_context_set_persistence(fpriv->dev_priv, pc,
+							    args->value);
 		break;
 
 	case I915_CONTEXT_PARAM_NO_ZEROMAP:
-- 
2.35.1



