Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D2A3ED50E
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237000AbhHPNHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:07:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237400AbhHPNG1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:06:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1921763299;
        Mon, 16 Aug 2021 13:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119154;
        bh=s/xkU721XOfspTYCcsgDSAK1VUb/vKLDxdxP14qM2WE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BzrqDjZPvjUEva+9nUgl71HmB9jukKU65kVw7L/u/Bs1VXe/JoqgMs+e66CGP9+rH
         TG4r30+xpGlzMMYVHqJIJJiZUjpORzDhOcqMagqXHyW6OqfPaZ3d2G+X8eSSQpf5v/
         /9av9ZjnDHwfFacFq9o4L/ts811TM4ln6bMY+mTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hsuan-Chi Kuo <hsuanchikuo@gmail.com>,
        Wiktor Garbacz <wiktorg@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.10 13/96] seccomp: Fix setting loaded filter count during TSYNC
Date:   Mon, 16 Aug 2021 15:01:23 +0200
Message-Id: <20210816125435.363992495@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125434.948010115@linuxfoundation.org>
References: <20210816125434.948010115@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hsuan-Chi Kuo <hsuanchikuo@gmail.com>

commit b4d8a58f8dcfcc890f296696cadb76e77be44b5f upstream.

The desired behavior is to set the caller's filter count to thread's.
This value is reported via /proc, so this fixes the inaccurate count
exposed to userspace; it is not used for reference counting, etc.

Signed-off-by: Hsuan-Chi Kuo <hsuanchikuo@gmail.com>
Link: https://lore.kernel.org/r/20210304233708.420597-1-hsuanchikuo@gmail.com
Co-developed-by: Wiktor Garbacz <wiktorg@google.com>
Signed-off-by: Wiktor Garbacz <wiktorg@google.com>
Link: https://lore.kernel.org/lkml/20210810125158.329849-1-wiktorg@google.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Cc: stable@vger.kernel.org
Fixes: c818c03b661c ("seccomp: Report number of loaded filters in /proc/$pid/status")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/seccomp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -511,7 +511,7 @@ static inline void seccomp_sync_threads(
 		smp_store_release(&thread->seccomp.filter,
 				  caller->seccomp.filter);
 		atomic_set(&thread->seccomp.filter_count,
-			   atomic_read(&thread->seccomp.filter_count));
+			   atomic_read(&caller->seccomp.filter_count));
 
 		/*
 		 * Don't let an unprivileged task work around


