Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8113617FABD
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729660AbgCJNHz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 09:07:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:53900 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731017AbgCJNHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 09:07:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 056EE24692;
        Tue, 10 Mar 2020 13:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583845671;
        bh=yjk5d3iI4kGMUGd1qiJvQf6NchPy6z4WP19mELEkXzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=koqurEHpppkc4/EBCFs1mR9RnuTR+liioVzK/v+700utaq65sLzvp2P+9ckdEDC/l
         2DKXfAs0iRN8xjWWe//asKokH7lPh66SAFBNZDPhB6EnCn77ciFk/8d124AnHSlOQy
         QjQkLPI4BHjSqr3LQG37tzFIs3HmTboH+WWIGueg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andy Gospodarek <gospo@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 051/126] include/linux/bitops.h: introduce BITS_PER_TYPE
Date:   Tue, 10 Mar 2020 13:41:12 +0100
Message-Id: <20200310124207.497136358@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310124203.704193207@linuxfoundation.org>
References: <20200310124203.704193207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 9144d75e22cad3c89e6b2ccab551db9ee28d250a upstream.

net_dim.h has a rather useful extension to BITS_PER_BYTE to compute the
number of bits in a type (BITS_PER_BYTE * sizeof(T)), so promote the macro
to bitops.h, alongside BITS_PER_BYTE, for wider usage.

Link: http://lkml.kernel.org/r/20180706094458.14116-1-chris@chris-wilson.co.uk
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Andy Gospodarek <gospo@broadcom.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[only take the bitops.h portion for stable kernels - gregkh]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/linux/bitops.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/bitops.h
+++ b/include/linux/bitops.h
@@ -4,7 +4,8 @@
 #include <asm/types.h>
 #include <linux/bits.h>
 
-#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_BYTE * sizeof(long))
+#define BITS_PER_TYPE(type) (sizeof(type) * BITS_PER_BYTE)
+#define BITS_TO_LONGS(nr)	DIV_ROUND_UP(nr, BITS_PER_TYPE(long))
 
 extern unsigned int __sw_hweight8(unsigned int w);
 extern unsigned int __sw_hweight16(unsigned int w);


