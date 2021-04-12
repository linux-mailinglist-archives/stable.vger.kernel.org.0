Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB7735BD53
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbhDLIvE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:51:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237761AbhDLIrf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:47:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C397E6127A;
        Mon, 12 Apr 2021 08:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217237;
        bh=Pssl+L1Ni8KwTl834n12ZJfzUk4qjK5DT37VcSCaQfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i2O76ZX4qIYfjvoyxPIkbBX8XCjbo1npKQXJUyICsTyrlRKkUIjYr47P5BDg4rOYG
         YKwiFuScp4zZ0c377UBpxznvKJ0C7w2S/MVYp5lMPZUULtrOxPQ3qqwuQ0b6SqmOHP
         uTjaY9bM+eKyjtAn1BH0g8UFl+vtau1ZfOEZTbY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Helge Deller <deller@gmx.de>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.4 019/111] parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers
Date:   Mon, 12 Apr 2021 10:39:57 +0200
Message-Id: <20210412084004.863571159@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084004.200986670@linuxfoundation.org>
References: <20210412084004.200986670@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@redhat.com>

commit 4d752e5af63753ab5140fc282929b98eaa4bd12e upstream.

commit b344d6a83d01 ("parisc: add support for cmpxchg on u8 pointers")
can generate a sparse warning ("cast truncates bits from constant
value"), which has been reported several times [1] [2] [3].

The original code worked as expected, but anyway, let silence such
sparse warning as what others did [4].

[1] https://lore.kernel.org/r/202104061220.nRMBwCXw-lkp@intel.com
[2] https://lore.kernel.org/r/202012291914.T5Agcn99-lkp@intel.com
[3] https://lore.kernel.org/r/202008210829.KVwn7Xeh%25lkp@intel.com
[4] https://lore.kernel.org/r/20210315131512.133720-2-jacopo+renesas@jmondi.org
Cc: Liam Beguin <liambeguin@gmail.com>
Cc: Helge Deller <deller@gmx.de>
Cc: stable@vger.kernel.org # v5.8+
Signed-off-by: Gao Xiang <hsiangkao@redhat.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/include/asm/cmpxchg.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/parisc/include/asm/cmpxchg.h
+++ b/arch/parisc/include/asm/cmpxchg.h
@@ -72,7 +72,7 @@ __cmpxchg(volatile void *ptr, unsigned l
 #endif
 	case 4: return __cmpxchg_u32((unsigned int *)ptr,
 				     (unsigned int)old, (unsigned int)new_);
-	case 1: return __cmpxchg_u8((u8 *)ptr, (u8)old, (u8)new_);
+	case 1: return __cmpxchg_u8((u8 *)ptr, old & 0xff, new_ & 0xff);
 	}
 	__cmpxchg_called_with_bad_pointer();
 	return old;


