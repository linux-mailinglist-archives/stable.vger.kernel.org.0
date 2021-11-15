Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD1E451045
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:42:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236957AbhKOSpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 13:45:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:50438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242324AbhKOSmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:42:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 984276330F;
        Mon, 15 Nov 2021 18:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999531;
        bh=OiufC8pL7TWcuNUxGFH+t+ZqQE871C5D3yXEOIwBva0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lXpgl/CJul+b4ZuBVOtKuILa/fgx2nwI7xqDlx/Mg6lXaM/1J6fMNrtRvtqT1qwGA
         97cxoq5DIHp+3P6zmZzuwCov311gg/5dI6bB/beYZrIY49I7dmiM1kX6zkOF62epL5
         2XWL5pvxttpFIRpSgvPLNWEqPHm16FVFCCFUEkTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Vyukov <dvyukov@google.com>,
        Chao Yu <chao@kernel.org>,
        syzbot+d8aaffc3719597e8cfb4@syzkaller.appspotmail.com,
        Gao Xiang <hsiangkao@linux.alibaba.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 332/849] erofs: dont trigger WARN() when decompression fails
Date:   Mon, 15 Nov 2021 17:56:55 +0100
Message-Id: <20211115165431.474272159@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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



