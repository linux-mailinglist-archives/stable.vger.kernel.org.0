Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51BB337C6B9
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhELPxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:53:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:51030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235405AbhELPtb (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:49:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54FBE619C8;
        Wed, 12 May 2021 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833127;
        bh=szq5GQ7Ee/QQCsfxAcC3LIQckkDmbGnsAIIe5Uonr3w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gzb1Uefp8a1dive0e+s5m+ZuFhbp5aSf9mQ/eLqsT24xUHsuJ7SsZdsWVBOBVumHU
         E+rpCf/NlmoLkKQjRwSLRYTFJ49sdp08OA6rxNW0AF7tdUthyEhNuNmnZ2hTnYTXiz
         os73a3B6OMR0lnCY9KCCR0pHdPr2KNnRut74YT78=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.11 004/601] io_uring: truncate lengths larger than MAX_RW_COUNT on provide buffers
Date:   Wed, 12 May 2021 16:41:21 +0200
Message-Id: <20210512144827.969061914@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

commit d1f82808877bb10d3deee7cf3374a4eb3fb582db upstream.

Read and write operations are capped to MAX_RW_COUNT. Some read ops rely on
that limit, and that is not guaranteed by the IORING_OP_PROVIDE_BUFFERS.

Truncate those lengths when doing io_add_buffers, so buffer addresses still
use the uncapped length.

Also, take the chance and change struct io_buffer len member to __u32, so
it matches struct io_provide_buffer len member.

This fixes CVE-2021-3491, also reported as ZDI-CAN-13546.

Fixes: ddf0322db79c ("io_uring: add IORING_OP_PROVIDE_BUFFERS")
Reported-by: Billy Jheng Bing-Jhong (@st424204)
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -222,7 +222,7 @@ struct fixed_file_data {
 struct io_buffer {
 	struct list_head list;
 	__u64 addr;
-	__s32 len;
+	__u32 len;
 	__u16 bid;
 };
 
@@ -4252,7 +4252,7 @@ static int io_add_buffers(struct io_prov
 			break;
 
 		buf->addr = addr;
-		buf->len = pbuf->len;
+		buf->len = min_t(__u32, pbuf->len, MAX_RW_COUNT);
 		buf->bid = bid;
 		addr += pbuf->len;
 		bid++;


