Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424CE411A32
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:46:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243439AbhITQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:35988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240451AbhITQri (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F62E61213;
        Mon, 20 Sep 2021 16:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156371;
        bh=lT9AcnaDFYupHCAPOGiNrpbNTJbT8jM7aaKkVAzgiuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtlXErAynyK2OYFvjcs+dYwqsi5LUA2mEBa+f26me3ixagkoSrYHXjpAPquksA/vw
         eysNh2eob0A0SN/n1rIgb5QrqEJ82DPC985VHGFVva1tP7F4dyZdtw3vwkaJa2WSZs
         kv7Rey6xynnwD7sCRWHzmg3vsbt8d79DOiRJd5r0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yisheng Xie <xieyisheng1@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Michal Hocko <mhocko@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 4.4 021/133] mm/kmemleak.c: make cond_resched() rate-limiting more efficient
Date:   Mon, 20 Sep 2021 18:41:39 +0200
Message-Id: <20210920163913.305406107@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Morton <akpm@linux-foundation.org>

commit 13ab183d138f607d885e995d625e58d47678bf97 upstream.

Commit bde5f6bc68db ("kmemleak: add scheduling point to
kmemleak_scan()") tries to rate-limit the frequency of cond_resched()
calls, but does it in a way which might incur an expensive division
operation in the inner loop.  Simplify this.

Fixes: bde5f6bc68db5 ("kmemleak: add scheduling point to kmemleak_scan()")
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Yisheng Xie <xieyisheng1@huawei.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -1394,7 +1394,7 @@ static void kmemleak_scan(void)
 			if (page_count(page) == 0)
 				continue;
 			scan_block(page, page + 1, NULL);
-			if (!(pfn % (MAX_SCAN_SIZE / sizeof(*page))))
+			if (!(pfn & 63))
 				cond_resched();
 		}
 	}


