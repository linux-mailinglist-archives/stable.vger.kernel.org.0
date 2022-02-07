Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2DB4ABC73
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:48:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiBGLhj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:37:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378403AbiBGL3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:29:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1CEC02B64F;
        Mon,  7 Feb 2022 03:27:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A8560A67;
        Mon,  7 Feb 2022 11:26:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2FDEC004E1;
        Mon,  7 Feb 2022 11:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233218;
        bh=9i6uG1aZ++DUqweaR8L6Nn40KDQFuqLBEi6rjjyAHXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PFNzWLwEuu4ABMVxwgKsjAsMIE2iS9AqQyGcTKKJwFyXfC6PPBzWDABrEyli2E9Do
         JtYGO8JYv6hnha1okjJSHK9vJ/bVt0HHdcZQfgZjxwFwisuESbVHwgbF69Re6SJ1O3
         U+eG4lbVi4LDb02aulFJ67Sryd43w7HsHhyTm6Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 023/110] drm/amd/pm: correct the MGpuFanBoost support for Beige Goby
Date:   Mon,  7 Feb 2022 12:05:56 +0100
Message-Id: <20220207103803.038547260@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit 3ec5586b4699cfb75cdfa09425e11d121db40773 upstream.

The existing way cannot handle Beige Goby well as a different
PPTable data structure(PPTable_beige_goby_t instead of PPTable_t)
is used there.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -3728,14 +3728,14 @@ static ssize_t sienna_cichlid_get_gpu_me
 
 static int sienna_cichlid_enable_mgpu_fan_boost(struct smu_context *smu)
 {
-	struct smu_table_context *table_context = &smu->smu_table;
-	PPTable_t *smc_pptable = table_context->driver_pptable;
+	uint16_t *mgpu_fan_boost_limit_rpm;
 
+	GET_PPTABLE_MEMBER(MGpuFanBoostLimitRpm, &mgpu_fan_boost_limit_rpm);
 	/*
 	 * Skip the MGpuFanBoost setting for those ASICs
 	 * which do not support it
 	 */
-	if (!smc_pptable->MGpuFanBoostLimitRpm)
+	if (*mgpu_fan_boost_limit_rpm == 0)
 		return 0;
 
 	return smu_cmn_send_smc_msg_with_param(smu,


