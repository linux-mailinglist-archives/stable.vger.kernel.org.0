Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C221145643
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729239AbgAVNYN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:24:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:42926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729441AbgAVNYK (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:24:10 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17B2D2468A;
        Wed, 22 Jan 2020 13:24:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699449;
        bh=VrtlMaqMSn19d9G4Yf2VkWyA29v8P9OI5I/Lj9pzz1A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C49IEm+2ZTRqZ5CeO3E8T5wBHWX+w6mn/9uQLxwXHJc6g7eZPbqorzMENjBQZTgSM
         bRJfMG4vYHcC7hBVSEh+NdIQcU0NYMfC61jameFpuiE2v3Wrv/K95hM+PtHIhFjABd
         xLKS5tOTMoQOU5dWCxsGHVCk1lun5zcUdFqLFk2A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Subject: [PATCH 5.4 113/222] bpf: Sockmap/tls, tls_sw can create a plaintext buf > encrypt buf
Date:   Wed, 22 Jan 2020 10:28:19 +0100
Message-Id: <20200122092841.824015725@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: John Fastabend <john.fastabend@gmail.com>

commit d468e4775c1c351616947ba0cccc43273963b9b5 upstream.

It is possible to build a plaintext buffer using push helper that is larger
than the allocated encrypt buffer. When this record is pushed to crypto
layers this can result in a NULL pointer dereference because the crypto
API expects the encrypt buffer is large enough to fit the plaintext
buffer. Kernel splat below.

To resolve catch the cases this can happen and split the buffer into two
records to send individually. Unfortunately, there is still one case to
handle where the split creates a zero sized buffer. In this case we merge
the buffers and unmark the split. This happens when apply is zero and user
pushed data beyond encrypt buffer. This fixes the original case as well
because the split allocated an encrypt buffer larger than the plaintext
buffer and the merge simply moves the pointers around so we now have
a reference to the new (larger) encrypt buffer.

Perhaps its not ideal but it seems the best solution for a fixes branch
and avoids handling these two cases, (a) apply that needs split and (b)
non apply case. The are edge cases anyways so optimizing them seems not
necessary unless someone wants later in next branches.

[  306.719107] BUG: kernel NULL pointer dereference, address: 0000000000000008
[...]
[  306.747260] RIP: 0010:scatterwalk_copychunks+0x12f/0x1b0
[...]
[  306.770350] Call Trace:
[  306.770956]  scatterwalk_map_and_copy+0x6c/0x80
[  306.772026]  gcm_enc_copy_hash+0x4b/0x50
[  306.772925]  gcm_hash_crypt_remain_continue+0xef/0x110
[  306.774138]  gcm_hash_crypt_continue+0xa1/0xb0
[  306.775103]  ? gcm_hash_crypt_continue+0xa1/0xb0
[  306.776103]  gcm_hash_assoc_remain_continue+0x94/0xa0
[  306.777170]  gcm_hash_assoc_continue+0x9d/0xb0
[  306.778239]  gcm_hash_init_continue+0x8f/0xa0
[  306.779121]  gcm_hash+0x73/0x80
[  306.779762]  gcm_encrypt_continue+0x6d/0x80
[  306.780582]  crypto_gcm_encrypt+0xcb/0xe0
[  306.781474]  crypto_aead_encrypt+0x1f/0x30
[  306.782353]  tls_push_record+0x3b9/0xb20 [tls]
[  306.783314]  ? sk_psock_msg_verdict+0x199/0x300
[  306.784287]  bpf_exec_tx_verdict+0x3f2/0x680 [tls]
[  306.785357]  tls_sw_sendmsg+0x4a3/0x6a0 [tls]

test_sockmap test signature to trigger bug,

[TEST]: (1, 1, 1, sendmsg, pass,redir,start 1,end 2,pop (1,2),ktls,):

Fixes: d3b18ad31f93d ("tls: add bpf support to sk_msg handling")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Jonathan Lemon <jonathan.lemon@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20200111061206.8028-7-john.fastabend@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/tls/tls_sw.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -677,12 +677,32 @@ static int tls_push_record(struct sock *
 
 	split_point = msg_pl->apply_bytes;
 	split = split_point && split_point < msg_pl->sg.size;
+	if (unlikely((!split &&
+		      msg_pl->sg.size +
+		      prot->overhead_size > msg_en->sg.size) ||
+		     (split &&
+		      split_point +
+		      prot->overhead_size > msg_en->sg.size))) {
+		split = true;
+		split_point = msg_en->sg.size;
+	}
 	if (split) {
 		rc = tls_split_open_record(sk, rec, &tmp, msg_pl, msg_en,
 					   split_point, prot->overhead_size,
 					   &orig_end);
 		if (rc < 0)
 			return rc;
+		/* This can happen if above tls_split_open_record allocates
+		 * a single large encryption buffer instead of two smaller
+		 * ones. In this case adjust pointers and continue without
+		 * split.
+		 */
+		if (!msg_pl->sg.size) {
+			tls_merge_open_record(sk, rec, tmp, orig_end);
+			msg_pl = &rec->msg_plaintext;
+			msg_en = &rec->msg_encrypted;
+			split = false;
+		}
 		sk_msg_trim(sk, msg_en, msg_pl->sg.size +
 			    prot->overhead_size);
 	}


