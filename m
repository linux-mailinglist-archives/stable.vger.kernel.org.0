Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 791564FB744
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 11:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244161AbiDKJX6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 05:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229781AbiDKJX6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 05:23:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431F83FD98
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 02:21:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D245C61013
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 09:21:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E15FEC385A3;
        Mon, 11 Apr 2022 09:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649668904;
        bh=goh5BR9INCU7chPSQWwci6F8ydJSM7FdJ5RnSBYsh3I=;
        h=Subject:To:Cc:From:Date:From;
        b=cY9sgUn8wdlWTvv0wC6TiK9HBn7no+IV8iujf+r0NKsW1oWts77XiSvImTl3jp7CO
         M2waweNxv4r+A0zMm/K1v2kq1VjglwkY0eoagK7ZkmXwHEcFTdvrkwWRL0RrPE/03T
         aDrxOJkv0816eNvaVBLqNJgZ9+JVcbFz95ZyIqec=
Subject: FAILED: patch "[PATCH] drm/amd/vcn: fix an error msg on vcn 3.0" failed to apply to 5.17-stable tree
To:     tianci.yin@amd.com, James.Zhu@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 11 Apr 2022 11:21:41 +0200
Message-ID: <1649668901119144@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.17-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dda81d9761d07541c404dd5fa93e773a8eda5ddc Mon Sep 17 00:00:00 2001
From: tiancyin <tianci.yin@amd.com>
Date: Sun, 27 Mar 2022 19:07:13 +0800
Subject: [PATCH] drm/amd/vcn: fix an error msg on vcn 3.0

Some video card has more than one vcn instance, passing 0 to
vcn_v3_0_pause_dpg_mode is incorrect.

Error msg:
Register(1) [mmUVD_POWER_STATUS] failed to reach value
0x00000001 != 0x00000002

Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: tiancyin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index e1cca0a10653..cb5f0a12333f 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1488,7 +1488,7 @@ static int vcn_v3_0_stop_dpg_mode(struct amdgpu_device *adev, int inst_idx)
 	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__UNPAUSE};
 	uint32_t tmp;
 
-	vcn_v3_0_pause_dpg_mode(adev, 0, &state);
+	vcn_v3_0_pause_dpg_mode(adev, inst_idx, &state);
 
 	/* Wait for power status to be 1 */
 	SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS, 1,

