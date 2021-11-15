Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78558451375
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:52:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348268AbhKOTva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343598AbhKOTVZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 28415635AC;
        Mon, 15 Nov 2021 18:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001773;
        bh=OiufC8pL7TWcuNUxGFH+t+ZqQE871C5D3yXEOIwBva0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=03CsttK/j1WGoZNJkYaAAV42OBIhpl+9s5+nkrWodTM3McsWvn9p8a+qheFGPXZGQ
         Q9f0rIG1EYoIXv/0R3CskygYuLO5MUaYxcOfcO8cnnNygddM0LYvhClN8wrNXWBElu
         PmA3N784H0Hjpn4JNdNJc/cUxnskZ7HM65BMAaA0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Chao Yu <chao@kernel.org>,
        syzbot+d8aaffc3719597e8cfb4@syzkaller.appspotmail.com,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 316/917] erofs: dont trigger WARN() when decompression fails
Date:   Mon, 15 Nov 2021 17:56:51 +0100
Message-Id: <20211115165439.458113860@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gao Xiang <hsiangkao@linux.alibaba.com>

[ Upstream commit a0961f351d82d43ab0b845304caa235dfe249ae9 ]

syzbot reported a WARNING [1] due to corrupted compressed data.

As Dmitry said, "If this is not a kernel bug, then the code should
not use WARN. WARN if for kernel bugs and is recognized as such by
all testing systems and humans."

[1] https://lore.kernel.org/r/000000000000b3586105cf0ff45e@google.com

Link: https://lore.kernel.org/r/20211025074311.130395-1-hsiangkao@linux.alibaba.com
Cc: Dmitry Vyukov <dvyukov@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Reported-by: syzbot+d8aaffc3719597e8cfb4@syzkaller.appspotmail.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/decompressor.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/erofs/decompressor.c b/fs/erofs/decompressor.c
index a5bc4b1b7813e..ad3f31380e6b2 100644
--- a/fs/erofs/decompressor.c
+++ b/fs/erofs/decompressor.c
@@ -233,7 +233,6 @@ static int z_erofs_lz4_decompress(struct z_erofs_decompress_req *rq, u8 *out)
 		erofs_err(rq->sb, "failed to decompress %d in[%u, %u] out[%u]",
 			  ret, rq->inputsize, inputmargin, rq->outputsize);
 
-		WARN_ON(1);
 		print_hex_dump(KERN_DEBUG, "[ in]: ", DUMP_PREFIX_OFFSET,
 			       16, 1, src + inputmargin, rq->inputsize, true);
 		print_hex_dump(KERN_DEBUG, "[out]: ", DUMP_PREFIX_OFFSET,
-- 
2.33.0



