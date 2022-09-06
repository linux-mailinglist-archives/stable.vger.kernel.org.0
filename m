Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 759AD5AED8F
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiIFOmv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:42:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbiIFOmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:42:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C9E958E;
        Tue,  6 Sep 2022 07:03:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1511F6154A;
        Tue,  6 Sep 2022 13:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E20AC433C1;
        Tue,  6 Sep 2022 13:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472127;
        bh=HrbJ7LB0xXHamS47DeV+VRmMG3iAGv+eo2XVcyQXrw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yXJGHH+H6ViMKuVjEwx2MHmMBQM50bRiR0SZCPcyUAP7cQzcBOB5G3yZdeKwhiDqC
         uPyA4AJ/FHc9h076acBKubsAZqj3R3yPr2S31LhgAzxYl/Bb3Woo5Ig0BlelytIkxy
         KEHPq3gv3EHfX+CeTFti07OyiOVHhzo2Dkt5hOaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Jason Ekstrand <jason.ekstrand@collabora.com>
Subject: [PATCH 5.19 136/155] dma-buf/dma-resv: check if the new fence is really later
Date:   Tue,  6 Sep 2022 15:31:24 +0200
Message-Id: <20220906132835.222727852@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Christian König <ckoenig.leichtzumerken@gmail.com>

commit a3f7c10a269d5b77dd5822ade822643ced3057f0 upstream.

Previously when we added a fence to a dma_resv object we always
assumed the the newer than all the existing fences.

With Jason's work to add an UAPI to explicit export/import that's not
necessary the case any more. So without this check we would allow
userspace to force the kernel into an use after free error.

Since the change is very small and defensive it's probably a good
idea to backport this to stable kernels as well just in case others
are using the dma_resv object in the same way.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Jason Ekstrand <jason.ekstrand@collabora.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220810172617.140047-1-christian.koenig@amd.com
Cc: stable@vger.kernel.org # v5.19+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma-buf/dma-resv.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/dma-buf/dma-resv.c
+++ b/drivers/dma-buf/dma-resv.c
@@ -295,7 +295,8 @@ void dma_resv_add_fence(struct dma_resv
 		enum dma_resv_usage old_usage;
 
 		dma_resv_list_entry(fobj, i, obj, &old, &old_usage);
-		if ((old->context == fence->context && old_usage >= usage) ||
+		if ((old->context == fence->context && old_usage >= usage &&
+		     dma_fence_is_later(fence, old)) ||
 		    dma_fence_is_signaled(old)) {
 			dma_resv_list_set(fobj, i, fence, usage);
 			dma_fence_put(old);


