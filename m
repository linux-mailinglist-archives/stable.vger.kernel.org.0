Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80A76582F53
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237845AbiG0RZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242208AbiG0RYk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:24:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFDA67C1A3;
        Wed, 27 Jul 2022 09:46:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C686BB821BE;
        Wed, 27 Jul 2022 16:46:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24760C433C1;
        Wed, 27 Jul 2022 16:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940369;
        bh=shgkTiZDpmlnjyo4+9wTAq+VzpGLrb6OW/DecDopaRE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2UVM6bzIW9HP7wtnqrw/XFfmTF91m2ZTlUKlQOJ6GQfHXaNRuUrYc7e3YbTqBDa0h
         WaJGjcis00Fgsj/BFh4VEuZ+XYaPVJB9vctkxPUhJ9OtioZ2Ilm6T3uQdfdQELAm1V
         CVOy1ap82MrwlHoeJMWi05r0D05F1FUOTCt3YPEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 200/201] drm/amdgpu: Off by one in dm_dmub_outbox1_low_irq()
Date:   Wed, 27 Jul 2022 18:11:44 +0200
Message-Id: <20220727161036.086600544@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit a35faec3db0e13aac8ea720bc1a3503081dd5a3d upstream.

The > ARRAY_SIZE() should be >= ARRAY_SIZE() to prevent an out of bounds
access.

Fixes: e27c41d5b068 ("drm/amd/display: Support for DMUB HPD interrupt handling")
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -757,7 +757,7 @@ static void dm_dmub_outbox1_low_irq(void
 		if (irq_params->irq_src == DC_IRQ_SOURCE_DMCUB_OUTBOX) {
 			do {
 				dc_stat_get_dmub_notification(adev->dm.dc, &notify);
-				if (notify.type > ARRAY_SIZE(dm->dmub_thread_offload)) {
+				if (notify.type >= ARRAY_SIZE(dm->dmub_thread_offload)) {
 					DRM_ERROR("DM: notify type %d larger than the array size %ld !", notify.type,
 					ARRAY_SIZE(dm->dmub_thread_offload));
 					continue;


