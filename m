Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C78676EC5
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbjAVPOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:14:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbjAVPOJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:14:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 223F52201C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:14:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B325960C5C
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:14:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DE0C433EF;
        Sun, 22 Jan 2023 15:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400448;
        bh=gMl4Y3T65w18VlVhPj7/Z/5YdYj4ezZrbxOGRT3pfa4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pv6CCmrHKUaanbE6GD9aAgvvXS6bqCJiZUj5kJYDrSmikuaU6W5n4DO2/MuHptY2r
         ZkjjBX+bgvo1vQzt5sBhBjN7P0QVNzE7+vh1EQnope+mK4x1o51yeQYL9cCnsWOt/6
         MqztRyP5XVW745L1i5TK700/+aZ0VeFaZEa3udGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Harry Wentland <harry.wentland@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        hongao <hongao@uniontech.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 77/98] drm/amd/display: Fix set scaling doesns work
Date:   Sun, 22 Jan 2023 16:04:33 +0100
Message-Id: <20230122150232.696961282@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150229.351631432@linuxfoundation.org>
References: <20230122150229.351631432@linuxfoundation.org>
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
@@ -8783,8 +8783,8 @@ static int amdgpu_dm_atomic_check(struct
 			goto fail;
 		}
 
-		if (dm_old_con_state->abm_level !=
-		    dm_new_con_state->abm_level)
+		if (dm_old_con_state->abm_level != dm_new_con_state->abm_level ||
+		    dm_old_con_state->scaling != dm_new_con_state->scaling)
 			new_crtc_state->connectors_changed = true;
 	}
 


