Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18BA812C766
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728645AbfL2R2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:28:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:52496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728659AbfL2R2q (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:28:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01724207FF;
        Sun, 29 Dec 2019 17:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640525;
        bh=XEw1MLkKkBAfT6/DF5ZElitYttQJBPi1wQ5u08eLZhE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vfNDBqnxMouWrrM6S8FqSf285F6zy4XF2UZ9vaayVZ3ichYsWfWcey+4HZREOsuap
         OGotBmQpArHiHaEdVXRAkzPtfANJsmRgKl1bEjYoX8ui/qJKRE0xhc/Q2MFqL4K47h
         KirKsT1I4Oza78K7svViGRmDl5ED2Ujix3HRaUcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 004/219] net: dst: Force 4-byte alignment of dst_metrics
Date:   Sun, 29 Dec 2019 18:16:46 +0100
Message-Id: <20191229162509.732442011@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>

[ Upstream commit 258a980d1ec23e2c786e9536a7dd260bea74bae6 ]

When storing a pointer to a dst_metrics structure in dst_entry._metrics,
two flags are added in the least significant bits of the pointer value.
Hence this assumes all pointers to dst_metrics structures have at least
4-byte alignment.

However, on m68k, the minimum alignment of 32-bit values is 2 bytes, not
4 bytes.  Hence in some kernel builds, dst_default_metrics may be only
2-byte aligned, leading to obscure boot warnings like:

    WARNING: CPU: 0 PID: 7 at lib/refcount.c:28 refcount_warn_saturate+0x44/0x9a
    refcount_t: underflow; use-after-free.
    Modules linked in:
    CPU: 0 PID: 7 Comm: ksoftirqd/0 Tainted: G        W         5.5.0-rc2-atari-01448-g114a1a1038af891d-dirty #261
    Stack from 10835e6c:
	    10835e6c 0038134f 00023fa6 00394b0f 0000001c 00000009 00321560 00023fea
	    00394b0f 0000001c 001a70f8 00000009 00000000 10835eb4 00000001 00000000
	    04208040 0000000a 00394b4a 10835ed4 00043aa8 001a70f8 00394b0f 0000001c
	    00000009 00394b4a 0026aba8 003215a4 00000003 00000000 0026d5a8 00000001
	    003215a4 003a4361 003238d6 000001f0 00000000 003215a4 10aa3b00 00025e84
	    003ddb00 10834000 002416a8 10aa3b00 00000000 00000080 000aa038 0004854a
    Call Trace: [<00023fa6>] __warn+0xb2/0xb4
     [<00023fea>] warn_slowpath_fmt+0x42/0x64
     [<001a70f8>] refcount_warn_saturate+0x44/0x9a
     [<00043aa8>] printk+0x0/0x18
     [<001a70f8>] refcount_warn_saturate+0x44/0x9a
     [<0026aba8>] refcount_sub_and_test.constprop.73+0x38/0x3e
     [<0026d5a8>] ipv4_dst_destroy+0x5e/0x7e
     [<00025e84>] __local_bh_enable_ip+0x0/0x8e
     [<002416a8>] dst_destroy+0x40/0xae

Fix this by forcing 4-byte alignment of all dst_metrics structures.

Fixes: e5fd387ad5b30ca3 ("ipv6: do not overwrite inetpeer metrics prematurely")
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/dst.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -93,7 +93,7 @@ struct dst_entry {
 struct dst_metrics {
 	u32		metrics[RTAX_MAX];
 	refcount_t	refcnt;
-};
+} __aligned(4);		/* Low pointer bits contain DST_METRICS_FLAGS */
 extern const struct dst_metrics dst_default_metrics;
 
 u32 *dst_cow_metrics_generic(struct dst_entry *dst, unsigned long old);


