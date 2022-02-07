Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C59344ABCC7
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387112AbiBGLjR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385893AbiBGLdB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C75A3C043181;
        Mon,  7 Feb 2022 03:33:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66EE060A67;
        Mon,  7 Feb 2022 11:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4F0C004E1;
        Mon,  7 Feb 2022 11:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233579;
        bh=0b2/NmoR00QawfH4Fcskg1rd4c91k5VvvsO+xnT9CSQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dAQ5K3juq+Gtali1zcUGtpIp1A9ljDwIRWtxuaMJFn1+kgyNXxb7RhVkp3bAg5Mcv
         y+cHKZaelkMKKVO6Ne15IKfJkMT16F2Z0kQhFcQNUvoRie17975ASa9IaqhXvSngJS
         Ut5SlUNX8twlSRCLsMkghQrdI04zwF8HWD4+Ai5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lang Yu <Lang.Yu@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 024/126] drm/amdgpu: fix a potential GPU hang on cyan skillfish
Date:   Mon,  7 Feb 2022 12:05:55 +0100
Message-Id: <20220207103804.991012702@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Lang Yu <Lang.Yu@amd.com>

commit bca52455a3c07922ee976714b00563a13a29ab15 upstream.

We observed a GPU hang when querying GMC CG state(i.e.,
cat amdgpu_pm_info) on cyan skillfish. Acctually, cyan
skillfish doesn't support any CG features.

Just prevent it from accessing GMC CG registers.

Signed-off-by: Lang Yu <Lang.Yu@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c
@@ -1147,6 +1147,9 @@ static void gmc_v10_0_get_clockgating_st
 {
 	struct amdgpu_device *adev = (struct amdgpu_device *)handle;
 
+	if (adev->ip_versions[GC_HWIP][0] == IP_VERSION(10, 1, 3))
+		return;
+
 	adev->mmhub.funcs->get_clockgating(adev, flags);
 
 	if (adev->ip_versions[ATHUB_HWIP][0] >= IP_VERSION(2, 1, 0))


