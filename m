Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31FD6360C8E
	for <lists+stable@lfdr.de>; Thu, 15 Apr 2021 16:51:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233595AbhDOOvp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Apr 2021 10:51:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233948AbhDOOvH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Apr 2021 10:51:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 844CC613C3;
        Thu, 15 Apr 2021 14:50:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618498244;
        bh=7gOT+euCVm7O7XlWbv/g4fgdzJgd7Y8iqX0HZT1O+14=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tzLijPWxuVazA6Lactn7spz/eFeHQkMoEcAJ+CrXNHvnpuO+qIcWRiEMODgZmOiqj
         80CGNA7/a5PcGiCFMikAw1Uek7ST+Q7lmH8ZUdnTdPbgqjv4fLLdptdOYCfor5X/xE
         8BtcIQ3JZTtEa3EIcTIpojU3ge9pah6UyjKOjnsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Beguin <liambeguin@gmail.com>,
        Helge Deller <deller@gmx.de>, Gao Xiang <hsiangkao@redhat.com>
Subject: [PATCH 4.9 15/47] parisc: avoid a warning on u8 cast for cmpxchg on u8 pointers
Date:   Thu, 15 Apr 2021 16:47:07 +0200
Message-Id: <20210415144413.954642795@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415144413.487943796@linuxfoundation.org>
References: <20210415144413.487943796@linuxfoundation.org>
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
@@ -71,7 +71,7 @@ __cmpxchg(volatile void *ptr, unsigned l
 #endif
 	case 4: return __cmpxchg_u32((unsigned int *)ptr,
 				     (unsigned int)old, (unsigned int)new_);
-	case 1: return __cmpxchg_u8((u8 *)ptr, (u8)old, (u8)new_);
+	case 1: return __cmpxchg_u8((u8 *)ptr, old & 0xff, new_ & 0xff);
 	}
 	__cmpxchg_called_with_bad_pointer();
 	return old;


