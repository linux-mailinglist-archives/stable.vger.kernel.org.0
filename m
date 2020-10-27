Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6A9629B6FF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 16:32:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798520AbgJ0P22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:40956 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798149AbgJ0P0E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AB63E20657;
        Tue, 27 Oct 2020 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812364;
        bh=OLsKuVf6jPXIMWi+0XJdWfm+tHNgMCRxhWDDeUvn96s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bqa9zeCaWcEg8H6PmeF+d84xd32Mfj6lbWHFE0FHNfrlblcxb53QBVTIDJbq5l2yA
         AwEJjnQ6LdmV8XK3kyZSFXRvZT2Zi3S4qsm2dyFr6SrP+qaNzOIGFuv9OI7zZUKUmK
         kayuKBjVewA1QM5vFILo889+N5q750HLHAihWTJg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Melissa Wen <melissa.srw@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 184/757] drm/vkms: fix xrgb on compute crc
Date:   Tue, 27 Oct 2020 14:47:14 +0100
Message-Id: <20201027135459.232869377@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Melissa Wen <melissa.srw@gmail.com>

[ Upstream commit 0986191186128b10b6bbfa5220fc587ed5725e49 ]

The previous memset operation was not correctly zeroing the alpha
channel to compute the crc, and as a result, the IGT subtest
kms_cursor_crc/pipe-A-cursor-alpha-transparent fails.

Fixes: db7f419c06d7c ("drm/vkms: Compute CRC with Cursor Plane")

Signed-off-by: Melissa Wen <melissa.srw@gmail.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20200730202524.5upzuh4irboru7my@smtp.gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vkms/vkms_composer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/vkms/vkms_composer.c b/drivers/gpu/drm/vkms/vkms_composer.c
index 4af2f19480f4f..b8b060354667e 100644
--- a/drivers/gpu/drm/vkms/vkms_composer.c
+++ b/drivers/gpu/drm/vkms/vkms_composer.c
@@ -33,7 +33,7 @@ static uint32_t compute_crc(void *vaddr_out, struct vkms_composer *composer)
 				     + (i * composer->pitch)
 				     + (j * composer->cpp);
 			/* XRGB format ignores Alpha channel */
-			memset(vaddr_out + src_offset + 24, 0,  8);
+			bitmap_clear(vaddr_out + src_offset, 24, 8);
 			crc = crc32_le(crc, vaddr_out + src_offset,
 				       sizeof(u32));
 		}
-- 
2.25.1



