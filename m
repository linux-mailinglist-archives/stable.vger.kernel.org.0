Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30151300BB3
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 19:46:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730106AbhAVSnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:43:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:39050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728551AbhAVOWp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:22:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 05B8523B6B;
        Fri, 22 Jan 2021 14:16:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324997;
        bh=Lk0HPTXq23BUToGyK2Nm9CHUIww566vzLVOcu/1DTI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkXYzXWxdJrSqCeSbJJxnIbqQAf4uQBkiBdYiP56/mPNqq1zsro5epAzA/W5wR2Yx
         9HmnhiMPv/LIZn+Egz5EZENuVH/18X3L2Iw9nn75mLZt97uuNgq0wsOZiT827bQmIm
         vGpEChB5qRl8oK7+bIzvWlqhjE/abcOddOjmMeWw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mircea Cirjaliu <mcirjaliu@bitdefender.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mauricio Vasquez <mauriciovasquezbernal@gmail.com>
Subject: [PATCH 5.4 11/33] bpf: Fix helper bpf_map_peek_elem_proto pointing to wrong callback
Date:   Fri, 22 Jan 2021 15:12:27 +0100
Message-Id: <20210122135734.037596619@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135733.565501039@linuxfoundation.org>
References: <20210122135733.565501039@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mircea Cirjaliu <mcirjaliu@bitdefender.com>

commit 301a33d51880619d0c5a581b5a48d3a5248fa84b upstream.

I assume this was obtained by copy/paste. Point it to bpf_map_peek_elem()
instead of bpf_map_pop_elem(). In practice it may have been less likely
hit when under JIT given shielded via 84430d4232c3 ("bpf, verifier: avoid
retpoline for map push/pop/peek operation").

Fixes: f1a2e44a3aec ("bpf: add queue and stack maps")
Signed-off-by: Mircea Cirjaliu <mcirjaliu@bitdefender.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Mauricio Vasquez <mauriciovasquezbernal@gmail.com>
Link: https://lore.kernel.org/bpf/AM7PR02MB6082663DFDCCE8DA7A6DD6B1BBA30@AM7PR02MB6082.eurprd02.prod.outlook.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/helpers.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -105,7 +105,7 @@ BPF_CALL_2(bpf_map_peek_elem, struct bpf
 }
 
 const struct bpf_func_proto bpf_map_peek_elem_proto = {
-	.func		= bpf_map_pop_elem,
+	.func		= bpf_map_peek_elem,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_CONST_MAP_PTR,


