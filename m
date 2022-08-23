Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1112559D404
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242254AbiHWIQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242470AbiHWIPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:15:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E48AA6CF7A;
        Tue, 23 Aug 2022 01:10:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8075361298;
        Tue, 23 Aug 2022 08:10:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FBEC433D6;
        Tue, 23 Aug 2022 08:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242207;
        bh=38z5+1E7HVbT6HeQjqkDPqJFtUVE6OakjVGr/qrHk+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h3iPVD5B+6fizRvEQACLzP6L+nRPB472DH0BCC6LhpMEreHS/6V1K76vbAXNUlb9e
         WowP4jxkB03c9xrv8hNWgoXI3SDQu1OaTiihYRNkM+gOWgZgieX4+6e3r5XBgzeuR6
         0GC7AQVsAcwhTD74yxU9eg36XbMFJvqbC5y2i+4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <ttabi@nvidia.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 4.9 036/101] drm/nouveau: fix another off-by-one in nvbios_addr
Date:   Tue, 23 Aug 2022 10:03:09 +0200
Message-Id: <20220823080035.956589692@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080034.579196046@linuxfoundation.org>
References: <20220823080034.579196046@linuxfoundation.org>
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


