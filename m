Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5FB53031D2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 03:30:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbhAYSnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 13:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728277AbhAYSnU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:43:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0C03207B3;
        Mon, 25 Jan 2021 18:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600150;
        bh=2g7jRJwckN2NI1Fy2SCiUY24zKA5YSEGWbyG6YyKTXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CJJMv4oFOkLBo/NaeX8lQm1ZXMikWl8Djd1sPjfSJcrSwAL8RUC2t4Tm9l/NFTh1F
         8f6w69d/50C+3h7bTA+YWSsLkhCYI1Wk/c2w6GhCTBVN3Vru33nFtRoDnNnrgUhhoi
         5OXns7pyynlONuY0z6btr2RpbZMoYZbXKc3LOzLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lecopzer Chen <lecopzer.chen@mediatek.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Alexander Potapenko <glider@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 50/58] kasan: fix incorrect arguments passing in kasan_add_zero_shadow
Date:   Mon, 25 Jan 2021 19:39:51 +0100
Message-Id: <20210125183158.857168202@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lecopzer Chen <lecopzer@gmail.com>

commit 5dabd1712cd056814f9ab15f1d68157ceb04e741 upstream.

kasan_remove_zero_shadow() shall use original virtual address, start and
size, instead of shadow address.

Link: https://lkml.kernel.org/r/20210103063847.5963-1-lecopzer@gmail.com
Fixes: 0207df4fa1a86 ("kernel/memremap, kasan: make ZONE_DEVICE with work with KASAN")
Signed-off-by: Lecopzer Chen <lecopzer.chen@mediatek.com>
Reviewed-by: Andrey Konovalov <andreyknvl@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Alexander Potapenko <glider@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/kasan/kasan_init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kasan/kasan_init.c
+++ b/mm/kasan/kasan_init.c
@@ -487,7 +487,6 @@ int kasan_add_zero_shadow(void *start, u
 
 	ret = kasan_populate_zero_shadow(shadow_start, shadow_end);
 	if (ret)
-		kasan_remove_zero_shadow(shadow_start,
-					size >> KASAN_SHADOW_SCALE_SHIFT);
+		kasan_remove_zero_shadow(start, size);
 	return ret;
 }


