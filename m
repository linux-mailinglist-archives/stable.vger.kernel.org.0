Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3408608A12
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234518AbiJVIqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:46:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235292AbiJVIpK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:45:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3F042ECF6D;
        Sat, 22 Oct 2022 01:09:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B69CC60ADE;
        Sat, 22 Oct 2022 08:07:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFB19C433C1;
        Sat, 22 Oct 2022 08:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666426069;
        bh=b+tvcI6wpnxrBbfyWcd2dsGMGew2N6mThlyt7CAAejc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkUjp8EIBE5L3MjT0MqwfPFPJpgH9FcwhZ0+jfDF+ZY7otIDtVw0frsnNAHbJSoNX
         yDIkx6Fieg3RDHx3TWvXNjADiEbI1/sLmAZLm0XoeCuWoSG2gdz3ARDExR7uc+9iO4
         FVBtpI39paFcNm6rdOpGVPCqgSJfdoIqloFn2y4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.19 708/717] drm/amd/display: Fix build breakage with CONFIG_DEBUG_FS=n
Date:   Sat, 22 Oct 2022 09:29:47 +0200
Message-Id: <20221022072529.772954386@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 2130b87b2273389cafe6765bf09ef564cda01407 upstream.

After commit 8799c0be89eb ("drm/amd/display: Fix vblank refcount in vrr
transition"), a build with CONFIG_DEBUG_FS=n is broken due to a
misplaced brace, along the lines of:

  In file included from drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm_trace.h:39,
                   from drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:41:
  drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c: At top level:
  ./include/drm/drm_atomic.h:864:9: error: expected identifier or ‘(’ before ‘for’
    864 |         for ((__i) = 0;                                                 \
        |         ^~~
  drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:8317:9: note: in expansion of macro ‘for_each_new_crtc_in_state’
   8317 |         for_each_new_crtc_in_state(state, crtc, new_crtc_state, j)
        |         ^~~~~~~~~~~~~~~~~~~~~~~~~~

Move the brace within the #ifdef so that the file can be built with or
without CONFIG_DEBUG_FS.

Fixes: 8799c0be89eb ("drm/amd/display: Fix vblank refcount in vrr transition")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -9991,8 +9991,8 @@ static void amdgpu_dm_atomic_commit_tail
 					crtc, dm_new_crtc_state, cur_crc_src))
 					DRM_DEBUG_DRIVER("Failed to configure crc source");
 			}
-#endif
 		}
+#endif
 	}
 
 	for_each_new_crtc_in_state(state, crtc, new_crtc_state, j)


