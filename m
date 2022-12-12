Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58BE264A180
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 14:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232582AbiLLNlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 08:41:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232900AbiLLNkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 08:40:42 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A03213F7F
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 05:40:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9FAA5CE0F7E
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 13:40:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC22C433D2;
        Mon, 12 Dec 2022 13:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670852405;
        bh=b5thqV3BytwIzBS8oLucKu9ZgsjqsUrFZrV2CO3YNmU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZuHdfi/U6vxTZ2B13qjU7C5ys9ABSFywPyogVfNixyZ5g5wpUcmjJo5RvzZf8zTSi
         y6w98nTiKsJ7tiy6rR+f0boITMADK/rKJ46znqkbYnU9Ll8nuPRKSk5iK0P9zeIXks
         Zu7X7q7VVHlvZ4RkS5B4AqZFEkfSvwCp7t1iUPDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 074/157] drm/amd/display: fix array index out of bound error in DCN32 DML
Date:   Mon, 12 Dec 2022 14:17:02 +0100
Message-Id: <20221212130937.659494556@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
References: <20221212130934.337225088@linuxfoundation.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

commit aeffc8fb2174f017a10df114bc312f899904dc68 upstream.

[Why&How]
LinkCapacitySupport array is indexed with the number of voltage states and
not the number of max DPPs. Fix the error by changing the array
declaration to use the correct (larger) array size of total number of
voltage states.

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
+++ b/drivers/gpu/drm/amd/display/dc/dml/display_mode_vba.h
@@ -1152,7 +1152,7 @@ struct vba_vars_st {
 	double UrgBurstFactorLumaPre[DC__NUM_DPP__MAX];
 	double UrgBurstFactorChromaPre[DC__NUM_DPP__MAX];
 	bool NotUrgentLatencyHidingPre[DC__NUM_DPP__MAX];
-	bool LinkCapacitySupport[DC__NUM_DPP__MAX];
+	bool LinkCapacitySupport[DC__VOLTAGE_STATES];
 	bool VREADY_AT_OR_AFTER_VSYNC[DC__NUM_DPP__MAX];
 	unsigned int MIN_DST_Y_NEXT_START[DC__NUM_DPP__MAX];
 	unsigned int VFrontPorch[DC__NUM_DPP__MAX];


