Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C378521891
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242177AbiEJNjI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:39:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243513AbiEJNfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:35:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 013A62C0D02;
        Tue, 10 May 2022 06:24:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56259617DF;
        Tue, 10 May 2022 13:24:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483BBC385A6;
        Tue, 10 May 2022 13:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189092;
        bh=tWydUitcdou5KgHaeOgMFE3O5AHjYU42pGOO4FY5kts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ipe5EWjswNBnQqba2UVYwdVvIf6prdfm/gN2nvlwjQ9uJGdweqvXWAjF93n0Plh3K
         GWvBJTKy4r0puN7O8zAXX6/WudFaociPBjKda/J7uy1Vo/9M59NJA4nY7pUPgtqfNY
         4lST90ZGmXYanx678pl9Z5iFuHgCM5+w3hMhFSN8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 10/70] drm/amd/display: Avoid reading audio pattern past AUDIO_CHANNELS_COUNT
Date:   Tue, 10 May 2022 15:07:29 +0200
Message-Id: <20220510130733.168973865@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

commit 3dfe85fa87b2a26bdbd292b66653bba065cf9941 upstream.

A faulty receiver might report an erroneous channel count. We
should guard against reading beyond AUDIO_CHANNELS_COUNT as
that would overflow the dpcd_pattern_period array.

Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -2822,7 +2822,7 @@ static void dp_test_get_audio_test_data(
 		&dpcd_pattern_type.value,
 		sizeof(dpcd_pattern_type));
 
-	channel_count = dpcd_test_mode.bits.channel_count + 1;
+	channel_count = min(dpcd_test_mode.bits.channel_count + 1, AUDIO_CHANNELS_COUNT);
 
 	// read pattern periods for requested channels when sawTooth pattern is requested
 	if (dpcd_pattern_type.value == AUDIO_TEST_PATTERN_SAWTOOTH ||


