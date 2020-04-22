Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 023D51B406D
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731568AbgDVKqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:46:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729808AbgDVKRN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:17:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 620642070B;
        Wed, 22 Apr 2020 10:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550632;
        bh=6C7xh4fdosy9PmJynSHRDL6D+i/I+xfTjWUEGVjU2ng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XM/nc4Z2ls9EhvRdKn3sbjzlvHbmSYqNsY2VpAhBVWSpIIaLMk4+Vyrg8ZEEHgSIR
         X3WV+eZv6NeWWxIcCGtPC8Rn4xXPhWTItb5kubyCJFIdCdzaNvOAYrYg/E2xOHth/S
         EJ6JDZtZN1LgyM/zneUV0pBz4C3aYCzwe8Tg6IxU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li RongQing <lirongqing@baidu.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>
Subject: [PATCH 5.4 003/118] xsk: Fix out of boundary write in __xsk_rcv_memcpy
Date:   Wed, 22 Apr 2020 11:56:04 +0200
Message-Id: <20200422095032.073200981@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Li RongQing <lirongqing@baidu.com>

commit db5c97f02373917efe2c218ebf8e3d8b19e343b6 upstream.

first_len is the remainder of the first page we're copying.
If this size is larger, then out of page boundary write will
otherwise happen.

Fixes: c05cd3645814 ("xsk: add support to allow unaligned chunk placement")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Link: https://lore.kernel.org/bpf/1585813930-19712-1-git-send-email-lirongqing@baidu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xdp/xsk.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -129,8 +129,9 @@ static void __xsk_rcv_memcpy(struct xdp_
 		u64 page_start = addr & ~(PAGE_SIZE - 1);
 		u64 first_len = PAGE_SIZE - (addr - page_start);
 
-		memcpy(to_buf, from_buf, first_len + metalen);
-		memcpy(next_pg_addr, from_buf + first_len, len - first_len);
+		memcpy(to_buf, from_buf, first_len);
+		memcpy(next_pg_addr, from_buf + first_len,
+		       len + metalen - first_len);
 
 		return;
 	}


