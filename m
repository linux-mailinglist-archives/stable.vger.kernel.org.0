Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B2CC35BF69
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238736AbhDLJGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:54808 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239056AbhDLJCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:02:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C8FA6120F;
        Mon, 12 Apr 2021 09:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218065;
        bh=LoIVIG201NgWMbtMbOxt0eFw+i4Kk2Mnc1xL11C2MQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cXYFIBOZQYSWFQiKfygyfDxwWNuhCJOa8Tr4oIwNVOQcymeOajZ+eQ08xRvJB7ToD
         tuJIfxZegsiZ6iXeRcAfNawtBemhXu9ICKRx/acrXIHYSgnS4t5/0YQH3dQuW0FJ6j
         VFmnALxkqD5mFEAc3d4TvoXQ3d3sOTe7S37MdlkQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pedro Tammela <pctammela@mojatatu.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: [PATCH 5.11 051/210] libbpf: Fix bail out from ringbuf_process_ring() on error
Date:   Mon, 12 Apr 2021 10:39:16 +0200
Message-Id: <20210412084017.705893143@linuxfoundation.org>
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

From: Pedro Tammela <pctammela@gmail.com>

commit 6032ebb54c60cae24329f6aba3ce0c1ca8ad6abe upstream.

The current code bails out with negative and positive returns.
If the callback returns a positive return code, 'ring_buffer__consume()'
and 'ring_buffer__poll()' will return a spurious number of records
consumed, but mostly important will continue the processing loop.

This patch makes positive returns from the callback a no-op.

Fixes: bf99c936f947 ("libbpf: Add BPF ring buffer support")
Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210325150115.138750-1-pctammela@mojatatu.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/lib/bpf/ringbuf.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/lib/bpf/ringbuf.c
+++ b/tools/lib/bpf/ringbuf.c
@@ -227,7 +227,7 @@ static int ringbuf_process_ring(struct r
 			if ((len & BPF_RINGBUF_DISCARD_BIT) == 0) {
 				sample = (void *)len_ptr + BPF_RINGBUF_HDR_SZ;
 				err = r->sample_cb(r->ctx, sample, len);
-				if (err) {
+				if (err < 0) {
 					/* update consumer pos and bail out */
 					smp_store_release(r->consumer_pos,
 							  cons_pos);


