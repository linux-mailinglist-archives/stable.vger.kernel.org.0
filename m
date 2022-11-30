Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188FE63DDFF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:32:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230158AbiK3Sck (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:32:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230218AbiK3Sch (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:32:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 424C42BC3
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:32:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F532B81CA4
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:32:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA861C433D6;
        Wed, 30 Nov 2022 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833152;
        bh=02f8O6FWNWlv3zF9r1pu4H01Ab8pPZeNwIsqBE4Zc9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I0/9UgdEbQrIo6qfSgNtpFUxvXOaUZbu+GbRcCnKXsbyEYp53yVPaD/YdMoMCPIdh
         O4uSkbVv4Ypj4zniFGTbweFzTWHsc6JCt0s0ZmWf+hIRRi7120ITFCJ1nJ3zZjQRzO
         mTvU/mq6zDLyu864GFiyErAXnud3NVOXnO6/6/0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>
Subject: [PATCH 5.10 161/162] drm/amdgpu: always register an MMU notifier for userptr
Date:   Wed, 30 Nov 2022 19:24:02 +0100
Message-Id: <20221130180532.837493976@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit b39df63b16b64a3af42695acb9bc567aad144776 upstream.

Since switching to HMM we always need that because we no longer grab
references to the pages.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Acked-by: Felix Kuehling <Felix.Kuehling@amd.com>
CC: stable@vger.kernel.org
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_gem.c
@@ -341,11 +341,9 @@ int amdgpu_gem_userptr_ioctl(struct drm_
 	if (r)
 		goto release_object;
 
-	if (args->flags & AMDGPU_GEM_USERPTR_REGISTER) {
-		r = amdgpu_mn_register(bo, args->addr);
-		if (r)
-			goto release_object;
-	}
+	r = amdgpu_mn_register(bo, args->addr);
+	if (r)
+		goto release_object;
 
 	if (args->flags & AMDGPU_GEM_USERPTR_VALIDATE) {
 		r = amdgpu_ttm_tt_get_user_pages(bo, bo->tbo.ttm->pages);


