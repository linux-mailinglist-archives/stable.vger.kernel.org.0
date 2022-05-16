Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90B0D5290B6
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348057AbiEPUGX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:06:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348879AbiEPT7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:59:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ABAB3;
        Mon, 16 May 2022 12:51:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1DA7AB81611;
        Mon, 16 May 2022 19:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33425C385AA;
        Mon, 16 May 2022 19:51:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730712;
        bh=YzW8u20XqcllyETUghHYrsk3AT8VdfEGOpmwGCOwdKU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqAMblpB0aQZjL284RLaDNX97/mLfgJXE3oxUVosbvZDX+TSdC2L1jf4kxdkaKCOk
         XPimweoj+UWq5zDz+lqK65x1tKB597alnRcwl7yENDUZz42hwSE1xKJTiLvPQEPT8i
         7kEaa0gyjmFvuAFvd7AuGi4G4HrhZfTVsxiTKR6g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zack Rusin <zackr@vmware.com>,
        Martin Krastev <krastevm@vmware.com>
Subject: [PATCH 5.15 084/102] drm/vmwgfx: Disable command buffers on svga3 without gbobjects
Date:   Mon, 16 May 2022 21:36:58 +0200
Message-Id: <20220516193626.404883946@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193623.989270214@linuxfoundation.org>
References: <20220516193623.989270214@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zack Rusin <zackr@vmware.com>

commit 21d1d192890ced87f2f04f8f4dea92406e0b162a upstream.

With very limited vram on svga3 it's difficult to handle all the surface
migrations. Without gbobjects, i.e. the ability to store surfaces in
guest mobs, there's no reason to support intermediate svga2 features,
especially because we can fall back to fb traces and svga3 will never
support those in-between features.

On svga3 we wither want to use fb traces or screen targets
(i.e. gbobjects), nothing in between. This fixes presentation on a lot
of fusion/esxi tech previews where the exposed svga3 caps haven't been
finalized yet.

Signed-off-by: Zack Rusin <zackr@vmware.com>
Fixes: 2cd80dbd3551 ("drm/vmwgfx: Add basic support for SVGA3")
Cc: <stable@vger.kernel.org> # v5.14+
Reviewed-by: Martin Krastev <krastevm@vmware.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220318174332.440068-5-zack@kde.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
+++ b/drivers/gpu/drm/vmwgfx/vmwgfx_cmd.c
@@ -675,11 +675,14 @@ int vmw_cmd_emit_dummy_query(struct vmw_
  */
 bool vmw_cmd_supported(struct vmw_private *vmw)
 {
-	if ((vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
-				  SVGA_CAP_CMD_BUFFERS_2)) != 0)
-		return true;
+	bool has_cmdbufs =
+		(vmw->capabilities & (SVGA_CAP_COMMAND_BUFFERS |
+				      SVGA_CAP_CMD_BUFFERS_2)) != 0;
+	if (vmw_is_svga_v3(vmw))
+		return (has_cmdbufs &&
+			(vmw->capabilities & SVGA_CAP_GBOBJECTS) != 0);
 	/*
 	 * We have FIFO cmd's
 	 */
-	return vmw->fifo_mem != NULL;
+	return has_cmdbufs || vmw->fifo_mem != NULL;
 }


