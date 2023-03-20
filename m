Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DE66C19DF
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:39:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233264AbjCTPjJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:39:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233273AbjCTPiq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16D372A6D1
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:30:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 38999615C7
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 425F4C43445;
        Mon, 20 Mar 2023 15:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326219;
        bh=IiFmBwheuAgW44hAoS70uXf0sjnbdYHC+B7x6i5aKXg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ExU4QQ9O66huROpHMsLBXteJF5T3BsT6ID6Eb9MbTfL9PBcdnP1997erCzDpXM8MB
         paFgXCU7bbj0i/ch9ivYFgeOvurPJZxGiMkAzjGGmmoXvjpzf2j9U5GY0+s0FdSvps
         OyRl8ZodYI4M3jy6jIZiajl8Ce3tOwM+qjWdOJlg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Benjamin Cheng <ben@bcheng.me>,
        Hamza Mahfooz <hamza.mahfooz@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 172/211] drm/amd/display: Write to correct dirty_rect
Date:   Mon, 20 Mar 2023 15:55:07 +0100
Message-Id: <20230320145520.645189960@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Cheng <ben@bcheng.me>

commit 751281c55579f0cb0e56c9797d4663f689909681 upstream.

When FB_DAMAGE_CLIPS are provided in a non-MPO scenario, the loop does
not use the counter i. This causes the fill_dc_dity_rect() to always
fill dirty_rects[0], causing graphical artifacts when a damage clip
aware DRM client sends more than 1 damage clip.

Instead, use the flip_addrs->dirty_rect_count which is incremented by
fill_dc_dirty_rect() on a successful fill.

Fixes: 30ebe41582d1 ("drm/amd/display: add FB_DAMAGE_CLIPS support")
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2453
Signed-off-by: Benjamin Cheng <ben@bcheng.me>
Signed-off-by: Hamza Mahfooz <hamza.mahfooz@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -4985,9 +4985,9 @@ static void fill_dc_dirty_rects(struct d
 
 		for (; flip_addrs->dirty_rect_count < num_clips; clips++)
 			fill_dc_dirty_rect(new_plane_state->plane,
-					   &dirty_rects[i], clips->x1,
-					   clips->y1, clips->x2 - clips->x1,
-					   clips->y2 - clips->y1,
+					   &dirty_rects[flip_addrs->dirty_rect_count],
+					   clips->x1, clips->y1,
+					   clips->x2 - clips->x1, clips->y2 - clips->y1,
 					   &flip_addrs->dirty_rect_count,
 					   false);
 		return;


