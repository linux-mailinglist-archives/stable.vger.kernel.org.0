Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD5396041A8
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232853AbiJSKrH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:47:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiJSKp3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:45:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6830F2252E;
        Wed, 19 Oct 2022 03:21:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 76969B822FF;
        Wed, 19 Oct 2022 08:47:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8F30C433C1;
        Wed, 19 Oct 2022 08:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169251;
        bh=WH12ROwbiwt2ezolUVlTl+7d90xLlvBmBnJiLhmIgiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=srQ8BDaRqESqM+XbKeCcGLoK7XFBNhk43GVDDJohXUOpjP5VRqRAeS6ZqRYNstpR9
         kJqY01LFUv2Cn9egX6bGWnxN1krUru7kDoIste+d9BHlHVYTZp5t3qZDC+GKmkuiEV
         JVBd2I/aSsuFIDpvFaLMMrOSx4zYjmtibMpC3//I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 192/862] drm/amd/display: zeromem mypipe heap struct before using it
Date:   Wed, 19 Oct 2022 10:24:39 +0200
Message-Id: <20221019083258.467322526@linuxfoundation.org>
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

From: Martin Leung <Martin.Leung@amd.com>

commit 5ff32b52995155f91de582124485d0f0f8881363 upstream.

[Why & How]
bug was caused when moving variable from stack to
heap because it was reusable and garbage was left
over, so we need to zero mem

Fixes: 7acc487ab57e ("drm/amd/display: reduce stack size in dcn32 dml (v2)")
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_32.c
@@ -733,6 +733,8 @@ static void DISPCLKDPPCLKDCFCLKDeepSleep
 				mode_lib->vba.FCLKChangeLatency, v->UrgentLatency,
 				mode_lib->vba.SREnterPlusExitTime);
 
+			memset(&v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe, 0, sizeof(DmlPipe));
+
 			v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe.Dppclk = mode_lib->vba.DPPCLK[k];
 			v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe.Dispclk = mode_lib->vba.DISPCLK;
 			v->dummy_vars.DISPCLKDPPCLKDCFCLKDeepSleepPrefetchParametersWatermarksAndPerformanceCalculation.myPipe.PixelClock = mode_lib->vba.PixelClock[k];


