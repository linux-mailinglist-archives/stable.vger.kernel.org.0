Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 869914575D3
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 18:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237085AbhKSRm0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 12:42:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232869AbhKSRmU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Nov 2021 12:42:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 22EEB61AFB;
        Fri, 19 Nov 2021 17:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637343558;
        bh=8lWOeGgSRQuL66eeX7Bt6IlRULRv2A98uCEnDHJJ7j0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kkgoAuQUUR6De1mjnJXIWKqjzlepH65NaP5Wehyx0KWBm9Nv95EFd7gwAzXJ/sZ16
         YpzDN5BUKAl2i/UlLvJtDfKviypOKMOkZoJOf6CRTELfrigalzcpenjCCWrwqVAS1r
         74O6Zxfsa+AII9pobBs+NiBtQRUzcrTMNmuJ2NCk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xie Yongji <xieyongji@bytedance.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 05/15] block: Add a helper to validate the block size
Date:   Fri, 19 Nov 2021 18:38:38 +0100
Message-Id: <20211119171443.894943025@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211119171443.724340448@linuxfoundation.org>
References: <20211119171443.724340448@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

commit 570b1cac477643cbf01a45fa5d018430a1fddbce upstream.

There are some duplicated codes to validate the block
size in block drivers. This limitation actually comes
from block layer, so this patch tries to add a new block
layer helper for that.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20211026144015.188-2-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/blkdev.h |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -240,6 +240,14 @@ struct request {
 	void *end_io_data;
 };
 
+static inline int blk_validate_block_size(unsigned int bsize)
+{
+	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+		return -EINVAL;
+
+	return 0;
+}
+
 static inline bool blk_op_is_passthrough(unsigned int op)
 {
 	op &= REQ_OP_MASK;


