Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DC4F603D21
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbiJSI5v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:57:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231913AbiJSI4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:56:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45909DDAB;
        Wed, 19 Oct 2022 01:53:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16D746174B;
        Wed, 19 Oct 2022 08:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29125C433C1;
        Wed, 19 Oct 2022 08:48:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169323;
        bh=Fyg8fRwo1SLwxt6kAwmhh3Qe2G4Vzp20xGrJoqcg8JQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yUG24glOPAl3tbufrOOonqTUXt6OsRmn+pQKNNh6BIctnio821H6aTELHra8xJjzI
         jfhPncUxRGAPBxwbj9Pj7+4UlsirlHIVc1Vy0mtWQiL0CZiuFXXHVLUTT8o9GZ8Q1b
         Jo6M51euDL60MK7MOj3XjRmm7CNXufjRPaYkIdfw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>
Subject: [PATCH 6.0 197/862] drm/amd/display: Add HUBP surface flip interrupt handler
Date:   Wed, 19 Oct 2022 10:24:44 +0200
Message-Id: <20221019083258.696473963@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit 0811b9e4530d7c46542a8993ce6b725d042c6154 upstream.

Add the hubp surface flip handler. This fixes some flip timeout issues.

Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hubp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hubp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn32/dcn32_hubp.c
@@ -179,6 +179,7 @@ static struct hubp_funcs dcn32_hubp_func
 	.hubp_init = hubp3_init,
 	.set_unbounded_requesting = hubp31_set_unbounded_requesting,
 	.hubp_soft_reset = hubp31_soft_reset,
+	.hubp_set_flip_int = hubp1_set_flip_int,
 	.hubp_in_blank = hubp1_in_blank,
 	.hubp_update_force_pstate_disallow = hubp32_update_force_pstate_disallow,
 	.phantom_hubp_post_enable = hubp32_phantom_hubp_post_enable,


