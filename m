Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0660835BF44
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237927AbhDLJDh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:03:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239932AbhDLJBh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:01:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1955E6137A;
        Mon, 12 Apr 2021 09:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218009;
        bh=Pssl+L1Ni8KwTl834n12ZJfzUk4qjK5DT37VcSCaQfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HtbshmBukeh6ovmB6y/Sa7dkB46Z4KqNiQpepJND8DNoTJbeitGicOTREb8dgj0DS
         Wnb3qahM0kl+LUcbF4RH6y0CgZEfY5xT75P5DtV3XMETiYcZdqdtKDWhmtcIGqXGjy
         tF0LIHMM9LoY6MYFnKjKA2jWmkk0I/vLUWGaNvUs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Helge Deller <deller@gmx.de>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 5.11 037/210] parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers
Date:   Mon, 12 Apr 2021 10:39:02 +0200
Message-Id: <20210412084017.247885238@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
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


