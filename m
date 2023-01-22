Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37C23676F45
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:19:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231214AbjAVPTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:19:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbjAVPTh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:19:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15D652007E
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:19:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B21E9B80B1B
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:19:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1705DC433D2;
        Sun, 22 Jan 2023 15:19:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400773;
        bh=NMsQOBCkFU1jk/rpO64mQcChiRoCV1V/qbDeTFy3Cr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cn5S8OnzgZ3Bj7DeckAY1E2QoJgc5s0NdCk3DBBWKjPWuusQ6gLl+ebDDjwfUhvxN
         +Web2SEdOizDhHQ2iynsUooLt/oedXauIgdh/sXWpVGo0Q7vN+zrB8d1egx0Rq2Ato
         IGCaudf63Nm6/p6X5kHW8MLfG/dQtnqvFMxhObwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harry Wentland <harry.wentland@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 096/117] drm/amd/display: Fix set scaling doesns work
Date:   Sun, 22 Jan 2023 16:04:46 +0100
Message-Id: <20230122150236.815782707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: hongao <hongao@uniontech.com>

commit 040625ab82ce6dca7772cb3867fe5c9eb279a344 upstream.

[Why]
Setting scaling does not correctly update CRTC state. As a result
dc stream state's src (composition area) && dest (addressable area)
was not calculated as expected. This causes set scaling doesn's work.

[How]
Correctly update CRTC state when setting scaling property.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Tested-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: hongao <hongao@uniontech.com>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -10789,8 +10789,8 @@ static int amdgpu_dm_atomic_check(struct
 			goto fail;
 		}
 
-		if (dm_old_con_state->abm_level !=
-		    dm_new_con_state->abm_level)
+		if (dm_old_con_state->abm_level != dm_new_con_state->abm_level ||
+		    dm_old_con_state->scaling != dm_new_con_state->scaling)
 			new_crtc_state->connectors_changed = true;
 	}
 


