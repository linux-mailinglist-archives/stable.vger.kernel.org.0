Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B2124ABB92
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:38:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382363AbiBGL3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383042AbiBGLV1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:21:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C8ABC03FEDD;
        Mon,  7 Feb 2022 03:21:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60841B81028;
        Mon,  7 Feb 2022 11:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AB2C004E1;
        Mon,  7 Feb 2022 11:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232859;
        bh=JE/jV0p/vLig4xTmzfQk4lQFfn7O51vh4mZW9DF20YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WTpfscR7/+I3pDPfd6YR1xbCMcHHKUMeMgFWqxVDuNII41gmj8Humc6MZx4+pdiHz
         UA8pQIDq+d5A6gg73665XN9ikYyPhCRLeWnGOLFg+eOHhRRcvJgM59Tv4IT3W5wQXz
         8Uma6OLGSAyOYxBcBkOVexryknBgrG7eKN1VNa68=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Lopez <github@glowingmonkey.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.10 14/74] drm/nouveau: fix off by one in BIOS boundary checking
Date:   Mon,  7 Feb 2022 12:06:12 +0100
Message-Id: <20220207103757.700664517@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nick Lopez <github@glowingmonkey.org>

commit 1b777d4d9e383d2744fc9b3a09af6ec1893c8b1a upstream.

Bounds checking when parsing init scripts embedded in the BIOS reject
access to the last byte. This causes driver initialization to fail on
Apple eMac's with GeForce 2 MX GPUs, leaving the system with no working
console.

This is probably only seen on OpenFirmware machines like PowerPC Macs
because the BIOS image provided by OF is only the used parts of the ROM,
not a power-of-two blocks read from PCI directly so PCs always have
empty bytes at the end that are never accessed.

Signed-off-by: Nick Lopez <github@glowingmonkey.org>
Fixes: 4d4e9907ff572 ("drm/nouveau/bios: guard against out-of-bounds accesses to image")
Cc: <stable@vger.kernel.org> # v4.10+
Reviewed-by: Ilia Mirkin <imirkin@alum.mit.edu>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Signed-off-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220122081906.2633061-1-github@glowingmonkey.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
+++ b/drivers/gpu/drm/nouveau/nvkm/subdev/bios/base.c
@@ -38,7 +38,7 @@ nvbios_addr(struct nvkm_bios *bios, u32
 		*addr += bios->imaged_addr;
 	}
 
-	if (unlikely(*addr + size >= bios->size)) {
+	if (unlikely(*addr + size > bios->size)) {
 		nvkm_error(&bios->subdev, "OOB %d %08x %08x\n", size, p, *addr);
 		return false;
 	}


