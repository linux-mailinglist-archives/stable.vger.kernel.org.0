Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D01275EA338
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:21:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237821AbiIZLVj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:21:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237663AbiIZLTm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:19:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633E252E61;
        Mon, 26 Sep 2022 03:39:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 61FCB60C94;
        Mon, 26 Sep 2022 10:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 532EDC433C1;
        Mon, 26 Sep 2022 10:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188379;
        bh=YK4PKi78mPSYr1dez8eX75MboN5ZOy+NdJ94NHqrFdc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2C2naKMw6oyazBrrdY3brOncKxnkBVDSRZZM7pMsrrG0rsSHadtfoJ93y87zknbaj
         ngd8blsjgs7F2kyVBkGnL5YA+D3XVshE2mrhVPVYpzhC0XO9JkRJT8BbLOjNqAPz4Z
         qOtez5INhzq1I9P2ODppxgtU1hOh0fYQq6+9IZBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>,
        =?UTF-8?q?Ma=C3=ADra=20Canal?= <mairacanal@riseup.net>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/141] drm/amd/display: Mark dml30s UseMinimumDCFCLK() as noinline for stack usage
Date:   Mon, 26 Sep 2022 12:12:37 +0200
Message-Id: <20220926100759.194364478@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 41012d715d5d7b9751ae84b8fb255e404ac9c5d0 ]

This function consumes a lot of stack space and it blows up the size of
dml30_ModeSupportAndSystemConfigurationFull() with clang:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn30/display_mode_vba_30.c:3542:6: error: stack frame size (2200) exceeds limit (2048) in 'dml30_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
  void dml30_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
       ^
  1 error generated.

Commit a0f7e7f759cf ("drm/amd/display: fix i386 frame size warning")
aimed to address this for i386 but it did not help x86_64.

To reduce the amount of stack space that
dml30_ModeSupportAndSystemConfigurationFull() uses, mark
UseMinimumDCFCLK() as noinline, using the _for_stack variant for
documentation. While this will increase the total amount of stack usage
between the two functions (1632 and 1304 bytes respectively), it will
make sure both stay below the limit of 2048 bytes for these files. The
aforementioned change does help reduce UseMinimumDCFCLK()'s stack usage
so it should not be reverted in favor of this change.

Link: https://github.com/ClangBuiltLinux/linux/issues/1681
Reported-by: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
Tested-by: Maíra Canal <mairacanal@riseup.net>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
index 2663f1b31842..e427f4ffa080 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn30/display_mode_vba_30.c
@@ -6653,8 +6653,7 @@ static double CalculateUrgentLatency(
 	return ret;
 }
 
-
-static void UseMinimumDCFCLK(
+static noinline_for_stack void UseMinimumDCFCLK(
 		struct display_mode_lib *mode_lib,
 		int MaxInterDCNTileRepeaters,
 		int MaxPrefetchMode,
-- 
2.35.1



