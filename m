Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5A994ABC64
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377494AbiBGLfm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:35:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359536AbiBGL2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:28:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61325C08E834;
        Mon,  7 Feb 2022 03:26:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7AEA4B80EBD;
        Mon,  7 Feb 2022 11:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8882EC004E1;
        Mon,  7 Feb 2022 11:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233212;
        bh=JE/jV0p/vLig4xTmzfQk4lQFfn7O51vh4mZW9DF20YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BP7sXMhYgMS2DG8/uPFdX2hu/5CxNecOti5C+3D7ws6gK7Ku/EOwTbDhw/4u6Dt49
         01RNpocPsuNhxpVZ+/hQtlz1r65OFtXeBEgji7dSqaXt3N8vsn8MymuQbSakHqIzZ4
         J/lUGsTZqTPsHYXRSC42nuX6YK7fFIG/8ZzFOZFA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nick Lopez <github@glowingmonkey.org>,
        Ilia Mirkin <imirkin@alum.mit.edu>,
        Karol Herbst <kherbst@redhat.com>
Subject: [PATCH 5.15 021/110] drm/nouveau: fix off by one in BIOS boundary checking
Date:   Mon,  7 Feb 2022 12:05:54 +0100
Message-Id: <20220207103802.973694188@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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


