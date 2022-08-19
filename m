Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61F28599F9A
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349883AbiHSPuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 11:50:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350317AbiHSPti (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 11:49:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD939104B2C;
        Fri, 19 Aug 2022 08:47:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A452B616B3;
        Fri, 19 Aug 2022 15:47:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F3BC433D6;
        Fri, 19 Aug 2022 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924068;
        bh=38z5+1E7HVbT6HeQjqkDPqJFtUVE6OakjVGr/qrHk+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsQGqy9Xm5jKxEt35hVXgQq1EA1qbIUlQuOCnG0ed5PxNPhSL9SYqWHCVjiPw4WIK
         pReB1JPbheRDnag+U0LdxMCcB+JJXfZD9uiYjjzqK5bMSmAUE7Y7gdkaKsUEvacSL3
         i/T/I9Eh4iLIy2H/kjHKbtjUsN5njUGQKztUHDFg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <ttabi@nvidia.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.10 044/545] drm/nouveau: fix another off-by-one in nvbios_addr
Date:   Fri, 19 Aug 2022 17:36:54 +0200
Message-Id: <20220819153831.183858332@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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

From: Timur Tabi <ttabi@nvidia.com>

commit c441d28945fb113220d48d6c86ebc0b090a2b677 upstream.

This check determines whether a given address is part of
image 0 or image 1.  Image 1 starts at offset image0_size,
so that address should be included.

Fixes: 4d4e9907ff572 ("drm/nouveau/bios: guard against out-of-bounds accesses to image")
Cc: <stable@vger.kernel.org> # v4.8+
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220511163716.3520591-1-ttabi@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
@@ -33,7 +33,7 @@ nvbios_addr(struct nvkm_bios *bios, u32
 {
 	u32 p = *addr;
 
-	if (*addr > bios->image0_size && bios->imaged_addr) {
+	if (*addr >= bios->image0_size && bios->imaged_addr) {
 		*addr -= bios->image0_size;
 		*addr += bios->imaged_addr;
 	}


