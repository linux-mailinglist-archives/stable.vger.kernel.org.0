Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C82C59D36F
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbiHWIJ3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:09:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240303AbiHWIIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC116C756;
        Tue, 23 Aug 2022 01:05:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FC16B81C22;
        Tue, 23 Aug 2022 08:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B44AAC433C1;
        Tue, 23 Aug 2022 08:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241930;
        bh=l1eN8wcRrSyg38twlZ0Z+rSeqA/tyusE2PZXXuhhE18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ThijvhZ8xvPyKoQWA5vrACLBeTwotd9GwcKbpVjR5dWm5LjkCUvKpSWwr1EqWQOgw
         6tS7ymsqOpz8IJiq7O2gEqcS5Vc+pYpWNWohC6QWnjyoxzXd0L8KOmcDSKjgCxxYQn
         Gi+EGFVroUgGoGZkIXtN5rwwAVzJ9IGCZplLsu4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Likun Gao <Likun.Gao@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.19 022/365] drm/amdgpu: change vram width algorithm for vram_info v3_0
Date:   Tue, 23 Aug 2022 09:58:43 +0200
Message-Id: <20220823080119.139942824@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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

From: Likun Gao <Likun.Gao@amd.com>

commit 4a0a2cf4c03ba49a4c2596c49c7daa719917d509 upstream.

Update the vram width algorithm for vram_info v3_0 to align with the
changes of latest IFWI.

Signed-off-by: Likun Gao <Likun.Gao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.19.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
index fd8f3731758e..b81b77a9efa6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_atomfirmware.c
@@ -314,7 +314,7 @@ amdgpu_atomfirmware_get_vram_info(struct amdgpu_device *adev,
 					mem_channel_number = vram_info->v30.channel_num;
 					mem_channel_width = vram_info->v30.channel_width;
 					if (vram_width)
-						*vram_width = mem_channel_number * mem_channel_width;
+						*vram_width = mem_channel_number * (1 << mem_channel_width);
 					break;
 				default:
 					return -EINVAL;
-- 
2.37.2



