Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F5C769493D
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:57:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjBMO5a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:57:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229784AbjBMO52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:57:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E5C31DBB8
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:56:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FB9961159
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:56:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95864C4339B;
        Mon, 13 Feb 2023 14:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300209;
        bh=RjQ1xj08Jy6vW/6dRljkUKBEhu4sCKRHG9ljjbnbwa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pdHUSOVzyIKQIFONboXtywtL4rZeMkV8iYAvQbHcP47n6J2y5edLSnu/6WKAPY0Pz
         1YmEAL4UZBppfKgD5u/Hf7pHpSI4TGnyBTHzn8sC2ZDhYiHG30CX2YTmSEJsYKYEDz
         fKPFBadECKSj1YhWFQ+578H7ithqvNGvIPiqpkx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Kent Russell <kent.russell@amd.com>,
        Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 106/114] drm/amdgpu: Add unique_id support for GC 11.0.1/2
Date:   Mon, 13 Feb 2023 15:49:01 +0100
Message-Id: <20230213144747.686317636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kent Russell <kent.russell@amd.com>

commit c108a18462949fe709ebd6b0be68398d643bc285 upstream.

These can support unique_id, so create the sysfs file for them

Signed-off-by: Kent Russell <kent.russell@amd.com>
Reviewed-by: Harish Kasiviswanathan <Harish.Kasiviswanathan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/amdgpu_pm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/pm/amdgpu_pm.c b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
index a9170360d7e8..2f3e239e623d 100644
--- a/drivers/gpu/drm/amd/pm/amdgpu_pm.c
+++ b/drivers/gpu/drm/amd/pm/amdgpu_pm.c
@@ -1991,6 +1991,8 @@ static int default_attr_update(struct amdgpu_device *adev, struct amdgpu_device_
 		case IP_VERSION(9, 4, 2):
 		case IP_VERSION(10, 3, 0):
 		case IP_VERSION(11, 0, 0):
+		case IP_VERSION(11, 0, 1):
+		case IP_VERSION(11, 0, 2):
 			*states = ATTR_STATE_SUPPORTED;
 			break;
 		default:
-- 
2.39.1



