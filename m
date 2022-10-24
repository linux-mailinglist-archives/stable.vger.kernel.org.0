Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCAB60AE67
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:00:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiJXO76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:59:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237099AbiJXO7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F95EE099B;
        Mon, 24 Oct 2022 06:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7826E61280;
        Mon, 24 Oct 2022 12:56:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86CECC433C1;
        Mon, 24 Oct 2022 12:56:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616161;
        bh=Z/v5BZaf+TCuc+KRpEXsSUVPW9PR5BVxkjpvpGiSli4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0oy9Q+FVOd8vHJFycwfVV5JWdjYJnEEau/bnduTqU5YOTOkMmDJzzrC0sP72xH9bY
         Gh+o3DZ9C2AjBx9+qkOX9yWFJ/F1zgpbS8BJ08W7itlLYkERoOylHC/1TJuCt3jrRA
         u01SjeOwYPjtM1oLXqrcFRG36RVB719XwN5w6bus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 523/530] drm/amd/display: Fix build breakage with CONFIG_DEBUG_FS=n
Date:   Mon, 24 Oct 2022 13:34:27 +0200
Message-Id: <20221024113108.668636718@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
@@ -9679,8 +9679,8 @@ static void amdgpu_dm_atomic_commit_tail
 					crtc, dm_new_crtc_state, cur_crc_src))
 					DRM_DEBUG_DRIVER("Failed to configure crc source");
 			}
-#endif
 		}
+#endif
 	}
 
 	for_each_new_crtc_in_state(state, crtc, new_crtc_state, j)


