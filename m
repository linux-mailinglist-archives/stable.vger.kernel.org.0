Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC8D25B6F86
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:14:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiIMONV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiIMOMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:12:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E272F5C96D;
        Tue, 13 Sep 2022 07:10:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 71C08614B9;
        Tue, 13 Sep 2022 14:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 615A8C433D7;
        Tue, 13 Sep 2022 14:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078203;
        bh=pI/efMIRfMPLZEbOkc0FWEqztzpGq+Ww3EmELNCn0n8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=APFRULcUUQhC5Bjf2hZrozIk651s9UUhovWW7RF/UgQKuWUHVLcP7a9zomh0ASfDR
         FOfu95e72+aCsHrbMLQ9DMjuVdtAl4MglEUtrQ1HDaQ2W7u/TCVYGUVf3VnaftrPGU
         17kJf6VuzQTZS+ZBgwSPLbFwArlnTny9zZUIp9hc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, Wayne Lin <Wayne.Lin@amd.com>,
        hersen wu <hersenxs.wu@amd.com>,
        Wenjing Liu <wenjing.liu@amd.com>,
        Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
        Thelford Williams <tdwilliamsiv@gmail.com>,
        Fangzhi Zuo <Jerry.Zuo@amd.com>,
        Yongzhi Liu <lyz_cs@pku.edu.cn>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Bhanuprakash Modem <bhanuprakash.modem@intel.com>,
        Sean Paul <seanpaul@chromium.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH 5.19 052/192] drm/amd/display: fix memory leak when using debugfs_lookup()
Date:   Tue, 13 Sep 2022 16:02:38 +0200
Message-Id: <20220913140412.529529553@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit cbfac7fa491651c57926c99edeb7495c6c1aeac2 upstream.

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  Fix this up by properly
calling dput().

Cc: Harry Wentland <harry.wentland@amd.com>
Cc: Leo Li <sunpeng.li@amd.com>
Cc: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: "Pan, Xinhui" <Xinhui.Pan@amd.com>
Cc: David Airlie <airlied@linux.ie>
Cc: Daniel Vetter <daniel@ffwll.ch>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: hersen wu <hersenxs.wu@amd.com>
Cc: Wenjing Liu <wenjing.liu@amd.com>
Cc: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
Cc: Thelford Williams <tdwilliamsiv@gmail.com>
Cc: Fangzhi Zuo <Jerry.Zuo@amd.com>
Cc: Yongzhi Liu <lyz_cs@pku.edu.cn>
Cc: Mikita Lipski <mikita.lipski@amd.com>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Bhanuprakash Modem <bhanuprakash.modem@intel.com>
Cc: Sean Paul <seanpaul@chromium.org>
Cc: amd-gfx@lists.freedesktop.org
Cc: dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_debugfs.c
@@ -3188,7 +3188,7 @@ void crtc_debugfs_init(struct drm_crtc *
 				   &crc_win_y_end_fops);
 	debugfs_create_file_unsafe("crc_win_update", 0644, dir, crtc,
 				   &crc_win_update_fops);
-
+	dput(dir);
 }
 #endif
 /*


