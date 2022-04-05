Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D4AA4F3716
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:17:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245363AbiDELJy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:09:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348814AbiDEJsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E5C3A9976;
        Tue,  5 Apr 2022 02:36:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D188F616AE;
        Tue,  5 Apr 2022 09:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA264C385A0;
        Tue,  5 Apr 2022 09:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151366;
        bh=mMs8cEwxxXca6Fv/Ju+e15x+v/0X/GOCyC5VUwCK5YA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYGylumEDuUPDPO4QnHCQOAtSt+tUr5qFcLBVJvzPEyJrkbNlC1QaUEX4+8rrjn1g
         x4Z8nVFFv+vGx1oDf3IOpouK0NLSBwv0XLaJsSEhhsnaeSwr3dE0ABFiBhl4z9P+oZ
         dFMvJFbSMTsDN6zNsVRsDO5NcmobCxSI7QjfbVBc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 389/913] drm/selftests/test-drm_dp_mst_helper: Fix memory leak in sideband_msg_req_encode_decode
Date:   Tue,  5 Apr 2022 09:24:11 +0200
Message-Id: <20220405070351.508314271@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit ba3a5ddcf1e5df31f2291006d5297ca62035584f ]

Avoid leaking the "out" variable if it is not possible to allocate
the "txmsg" variable.

Fixes: 09234b88ef55 ("drm/selftests/test-drm_dp_mst_helper: Move 'sideband_msg_req_encode_decode' onto the heap")
Addresses-Coverity-ID: 1475685 ("Resource leak")
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220108165812.46797-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c b/drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c
index 6b4759ed6bfd..c491429f1a02 100644
--- a/drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c
+++ b/drivers/gpu/drm/selftests/test-drm_dp_mst_helper.c
@@ -131,8 +131,10 @@ sideband_msg_req_encode_decode(struct drm_dp_sideband_msg_req_body *in)
 		return false;
 
 	txmsg = kzalloc(sizeof(*txmsg), GFP_KERNEL);
-	if (!txmsg)
+	if (!txmsg) {
+		kfree(out);
 		return false;
+	}
 
 	drm_dp_encode_sideband_req(in, txmsg);
 	ret = drm_dp_decode_sideband_req(txmsg, out);
-- 
2.34.1



