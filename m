Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADE866C476
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231609AbjAPPzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjAPPy5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFD962201D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DBAB96102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AC4C433F0;
        Mon, 16 Jan 2023 15:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884495;
        bh=H5KZ6eXeakk5mwtl2lRBnBbMGJG+WvEruF/wpkRSMJA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVex/3kIn3WPT7GIYDaF1iEawx2kr3ONLcj57b5cKbS5uofY0AFAIAXjDkHUSWSZ2
         ng6zAjrb6di8IpwNBaRJAet+f9fsJVhpsr9PP8GA3ztQ4g16TnH8+I8NuwBG78SyTe
         xjq4FiadpXh1shBHA/ZBVSLfISyy3p2ImcWvj/fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Guchun Chen <guchun.chen@amd.com>,
        Kenneth Feng <kenneth.feng@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 027/183] drm/amd/pm/smu13: BACO is supported when its in BACO state
Date:   Mon, 16 Jan 2023 16:49:10 +0100
Message-Id: <20230116154804.521976517@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

commit 972fb53d3605eb6cdf0d6ae9a52e910626a91ff7 upstream.

This leverages the logic in smu11. No need to talk to SMU to
check BACO enablement as it's in BACO state already.

Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Reviewed-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0, 6.1
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c
@@ -2249,6 +2249,10 @@ bool smu_v13_0_baco_is_support(struct sm
 	    !smu_baco->platform_support)
 		return false;
 
+	/* return true if ASIC is in BACO state already */
+	if (smu_v13_0_baco_get_state(smu) == SMU_BACO_STATE_ENTER)
+		return true;
+
 	if (smu_cmn_feature_is_supported(smu, SMU_FEATURE_BACO_BIT) &&
 	    !smu_cmn_feature_is_enabled(smu, SMU_FEATURE_BACO_BIT))
 		return false;


