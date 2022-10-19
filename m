Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B09B8604172
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232194AbiJSKow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232761AbiJSKoF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:44:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A3C3AB803;
        Wed, 19 Oct 2022 03:20:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A72FB823BA;
        Wed, 19 Oct 2022 08:54:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B77DC433D6;
        Wed, 19 Oct 2022 08:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169650;
        bh=esWIenx8gII1JJLWa5PV7a3Z/OUnhFQz9LcMdo2nw8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lil9xeFsifLllLfompE4Ew2KE3jViYbjMlpACsCfiXx3+6/kVOzbRaNKaUjih9g79
         P5GYAhBfGYfLkSSp2Pt9Uu/qcLe+JIxQf/7usHA4ZiBsbmE5UMbD4KIHHScZxjmTzo
         PzX6TusEqonMSZpXDCxlPVULzredzjHX4vzXwk9U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Gow <davidgow@google.com>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 357/862] drm/format-helper: Fix test on big endian architectures
Date:   Wed, 19 Oct 2022 10:27:24 +0200
Message-Id: <20221019083305.790911380@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 18c8485236a5e3f491b670c018ae391c9cb84dfa ]

The tests fail on big endian architectures, like PowerPC:

 $ ./tools/testing/kunit/kunit.py run \
   --kunitconfig=drivers/gpu/drm/tests \
   --arch=powerpc --cross_compile=powerpc64-linux-gnu-

Transform the XRGB8888 buffer from little endian to the CPU endian
before calling the conversion function to avoid this error.

Fixes: 8f456104915f ("drm/format-helper: Add KUnit tests for drm_fb_xrgb8888_to_rgb332()")
Reported-by: David Gow <davidgow@google.com>
Reviewed-by: David Gow <davidgow@google.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220726230916.390575-2-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/tests/drm_format_helper_test.c    | 23 +++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_format_helper_test.c b/drivers/gpu/drm/tests/drm_format_helper_test.c
index 98583bf56044..eefaba3aaea2 100644
--- a/drivers/gpu/drm/tests/drm_format_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_format_helper_test.c
@@ -111,6 +111,21 @@ static size_t conversion_buf_size(u32 dst_format, unsigned int dst_pitch,
 	return dst_pitch * drm_rect_height(clip);
 }
 
+static u32 *le32buf_to_cpu(struct kunit *test, const u32 *buf, size_t buf_size)
+{
+	u32 *dst = NULL;
+	int n;
+
+	dst = kunit_kzalloc(test, sizeof(*dst) * buf_size, GFP_KERNEL);
+	if (!dst)
+		return NULL;
+
+	for (n = 0; n < buf_size; n++)
+		dst[n] = le32_to_cpu((__force __le32)buf[n]);
+
+	return dst;
+}
+
 static void xrgb8888_to_rgb332_case_desc(struct xrgb8888_to_rgb332_case *t,
 					 char *desc)
 {
@@ -125,6 +140,7 @@ static void xrgb8888_to_rgb332_test(struct kunit *test)
 	const struct xrgb8888_to_rgb332_case *params = test->param_value;
 	size_t dst_size;
 	__u8 *dst = NULL;
+	__u32 *src = NULL;
 
 	struct drm_framebuffer fb = {
 		.format = drm_format_info(DRM_FORMAT_XRGB8888),
@@ -138,8 +154,11 @@ static void xrgb8888_to_rgb332_test(struct kunit *test)
 	dst = kunit_kzalloc(test, dst_size, GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, dst);
 
-	drm_fb_xrgb8888_to_rgb332(dst, params->dst_pitch, params->xrgb8888,
-				  &fb, &params->clip);
+	src = le32buf_to_cpu(test, params->xrgb8888, TEST_BUF_SIZE);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, src);
+
+	drm_fb_xrgb8888_to_rgb332(dst, params->dst_pitch, src, &fb,
+				  &params->clip);
 	KUNIT_EXPECT_EQ(test, memcmp(dst, params->expected, dst_size), 0);
 }
 
-- 
2.35.1



