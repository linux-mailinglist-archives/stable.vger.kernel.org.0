Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C08637CABF
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbhELQcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40576 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241108AbhELQ0Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5510619C5;
        Wed, 12 May 2021 15:49:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834583;
        bh=iL9F0uU2nkg5CIRC/Gc/9Qbk5I/M2tuzeiAsq5MVDQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7qbfxKBmzNDiHGdtJc2kV8axOQ1Kffwxcr+lejDaiXCkc2URhcw07jJlQzM8QQem
         iDcgOu2IKHypUEkrQPaxwL8FT9mE82buO4PwqqqsTMRLCJe/5uqmKzkQmqL1o7jYuJ
         2Gf0DoR8uhjxXs1nB/zD9vk7O4URjHp7uJZjzIbY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.11 596/601] bpf, ringbuf: Deny reserve of buffers larger than ringbuf
Date:   Wed, 12 May 2021 16:51:13 +0200
Message-Id: <20210512144847.483743346@linuxfoundation.org>
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

commit 4b81ccebaeee885ab1aa1438133f2991e3a2b6ea upstream.

A BPF program might try to reserve a buffer larger than the ringbuf size.
If the consumer pointer is way ahead of the producer, that would be
successfully reserved, allowing the BPF program to read or write out of
the ringbuf allocated area.

Reported-by: Ryota Shiga (Flatt Security)
Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/ringbuf.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/bpf/ringbuf.c
+++ b/kernel/bpf/ringbuf.c
@@ -315,6 +315,9 @@ static void *__bpf_ringbuf_reserve(struc
 		return NULL;
 
 	len = round_up(size + BPF_RINGBUF_HDR_SZ, 8);
+	if (len > rb->mask + 1)
+		return NULL;
+
 	cons_pos = smp_load_acquire(&rb->consumer_pos);
 
 	if (in_nmi()) {


