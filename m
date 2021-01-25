Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52337304A82
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731138AbhAZFFG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:05:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:40870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731341AbhAYSyb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:54:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 91576224D1;
        Mon, 25 Jan 2021 18:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600830;
        bh=ukEi+vhPWq6KXCBmDHjfToPs8cn6gzqUIJytbWwpn8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PDQDkD7Ad6HkduSbWE98O1937sNFzTLbB5dG/QXCdlkdBm1Bb6V/8Mf6VmARdxU2K
         athzcqsigoKy21Q6epBVjBTypSwT/4cTnvdCXAILq2+pfFwByafU5qFoHB1gTL8SXh
         1mwNSzFUs7t46pTaaq9/wOcEzMHdIJR/WpZ1ZlJk=
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
Subject: [PATCH 5.10 168/199] kasan: fix incorrect arguments passing in kasan_add_zero_shadow
Date:   Mon, 25 Jan 2021 19:39:50 +0100
Message-Id: <20210125183223.285349254@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
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
 mm/kasan/init.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/mm/kasan/init.c
+++ b/mm/kasan/init.c
@@ -492,7 +492,6 @@ int kasan_add_zero_shadow(void *start, u
 
 	ret = kasan_populate_early_shadow(shadow_start, shadow_end);
 	if (ret)
-		kasan_remove_zero_shadow(shadow_start,
-					size >> KASAN_SHADOW_SCALE_SHIFT);
+		kasan_remove_zero_shadow(start, size);
 	return ret;
 }


