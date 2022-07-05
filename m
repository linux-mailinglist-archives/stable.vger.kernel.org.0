Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54115566D23
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236560AbiGEMVR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:21:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237324AbiGEMTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:19:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B36AE1CFDE;
        Tue,  5 Jul 2022 05:14:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 59C25B817D6;
        Tue,  5 Jul 2022 12:14:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7A3C36AED;
        Tue,  5 Jul 2022 12:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023258;
        bh=Qy1pLN/zNK/8cHKZVUMsqXEMzNApCfDLymxAnISS+x0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KiZIkUYMf85ZbGrMheecU16FJz+Anc7p1G3S5ByqCmEkg8FDb9R986O0R/VgKSEOn
         Hey6JHeqSAwc9FVkO38RG0/tXzrbdiJOCKSzgsJUOBq3mif5Mc5tK7++VR/zURKzB0
         QCR1YdEuUAG8xdLyAL4KqlKAmW/k/PKxB9iMe83I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Carlos Llamas <cmllamas@google.com>,
        Simon Ser <contact@emersion.fr>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 95/98] drm/fourcc: fix integer type usage in uapi header
Date:   Tue,  5 Jul 2022 13:58:53 +0200
Message-Id: <20220705115620.267868752@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115617.568350164@linuxfoundation.org>
References: <20220705115617.568350164@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Carlos Llamas <cmllamas@google.com>

[ Upstream commit 20b8264394b33adb1640a485a62a84bc1388b6a3 ]

Kernel uapi headers are supposed to use __[us]{8,16,32,64} types defined
by <linux/types.h> as opposed to 'uint32_t' and similar. See [1] for the
relevant discussion about this topic. In this particular case, the usage
of 'uint64_t' escaped headers_check as these macros are not being called
here. However, the following program triggers a compilation error:

  #include <drm/drm_fourcc.h>

  int main()
  {
  	unsigned long x = AMD_FMT_MOD_CLEAR(RB);
  	return 0;
  }

gcc error:
  drm.c:5:27: error: ‘uint64_t’ undeclared (first use in this function)
      5 |         unsigned long x = AMD_FMT_MOD_CLEAR(RB);
        |                           ^~~~~~~~~~~~~~~~~

This patch changes AMD_FMT_MOD_{SET,CLEAR} macros to use the correct
integer types, which fixes the above issue.

  [1] https://lkml.org/lkml/2019/6/5/18

Fixes: 8ba16d599374 ("drm/fourcc: Add AMD DRM modifiers.")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
Reviewed-by: Simon Ser <contact@emersion.fr>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/drm/drm_fourcc.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/uapi/drm/drm_fourcc.h b/include/uapi/drm/drm_fourcc.h
index 9f4bb4a6f358..808c73c52820 100644
--- a/include/uapi/drm/drm_fourcc.h
+++ b/include/uapi/drm/drm_fourcc.h
@@ -1352,11 +1352,11 @@ drm_fourcc_canonicalize_nvidia_format_mod(__u64 modifier)
 #define AMD_FMT_MOD_PIPE_MASK 0x7
 
 #define AMD_FMT_MOD_SET(field, value) \
-	((uint64_t)(value) << AMD_FMT_MOD_##field##_SHIFT)
+	((__u64)(value) << AMD_FMT_MOD_##field##_SHIFT)
 #define AMD_FMT_MOD_GET(field, value) \
 	(((value) >> AMD_FMT_MOD_##field##_SHIFT) & AMD_FMT_MOD_##field##_MASK)
 #define AMD_FMT_MOD_CLEAR(field) \
-	(~((uint64_t)AMD_FMT_MOD_##field##_MASK << AMD_FMT_MOD_##field##_SHIFT))
+	(~((__u64)AMD_FMT_MOD_##field##_MASK << AMD_FMT_MOD_##field##_SHIFT))
 
 #if defined(__cplusplus)
 }
-- 
2.35.1



