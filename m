Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EB6B59DDC2
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357205AbiHWLOT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357219AbiHWLNu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:13:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89F9BD9B;
        Tue, 23 Aug 2022 02:18:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D58AB8105C;
        Tue, 23 Aug 2022 09:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD453C433C1;
        Tue, 23 Aug 2022 09:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661246291;
        bh=38z5+1E7HVbT6HeQjqkDPqJFtUVE6OakjVGr/qrHk+k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=THrpYpeyf2DT/QABUrGVTqDF1f6EbE9GzeN70yAnM7w3nErdAwh+XD9iMP3l00SB5
         vxCzB1UgH4YqdyY4Uwcn5nD2s62Ft8E7FDqTei6+yhgNmwTnSzDn8LcdX3nfQnxcc7
         7i+8Fxnyh6C2LaZmAGYsr9//lWvhi+W0/25JvaKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timur Tabi <ttabi@nvidia.com>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.4 032/389] drm/nouveau: fix another off-by-one in nvbios_addr
Date:   Tue, 23 Aug 2022 10:21:50 +0200
Message-Id: <20220823080117.027456498@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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


