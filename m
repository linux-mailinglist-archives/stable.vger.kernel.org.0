Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 868E813FFE6
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390889AbgAPXWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:22:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:49936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388828AbgAPXWK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:10 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A6E922075B;
        Thu, 16 Jan 2020 23:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216930;
        bh=YHCmKvqgNloUQ1CrqSeEmRJBO0gb6SZ/9jXI8HGzTVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d9wCnBwq3I8qsfM3eUwAEt18A5S+3SeTIZcUVDteF1tbf9b8FN66HGWhcr6A/6zz5
         yMTftSC2gwP2XB2NsMwYf1zKoGGTWJuKysGL4S59esz+XzJbhFXcJoWtNcLrm8MtkV
         T3tFP8an61TXvOqHkqmyLkrSw0XjJn9wZe6gbR7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.4 078/203] bpf: Make use of probe_user_write in probe write helper
Date:   Fri, 17 Jan 2020 00:16:35 +0100
Message-Id: <20200116231751.315347781@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit eb1b66887472eaa7342305b7890ae510dd9d1a79 upstream.

Convert the bpf_probe_write_user() helper to probe_user_write() such that
writes are not attempted under KERNEL_DS anymore which is buggy as kernel
and user space pointers can have overlapping addresses. Also, given we have
the access_ok() check inside probe_user_write(), the helper doesn't need
to do it twice.

Fixes: 96ae52279594 ("bpf: Add bpf_probe_write_user BPF helper to be called in tracers")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/841c461781874c07a0ee404a454c3bc0459eed30.1572649915.git.daniel@iogearbox.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/bpf_trace.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -163,7 +163,7 @@ static const struct bpf_func_proto bpf_p
 	.arg3_type	= ARG_ANYTHING,
 };
 
-BPF_CALL_3(bpf_probe_write_user, void *, unsafe_ptr, const void *, src,
+BPF_CALL_3(bpf_probe_write_user, void __user *, unsafe_ptr, const void *, src,
 	   u32, size)
 {
 	/*
@@ -186,10 +186,8 @@ BPF_CALL_3(bpf_probe_write_user, void *,
 		return -EPERM;
 	if (unlikely(!nmi_uaccess_okay()))
 		return -EPERM;
-	if (!access_ok(unsafe_ptr, size))
-		return -EPERM;
 
-	return probe_kernel_write(unsafe_ptr, src, size);
+	return probe_user_write(unsafe_ptr, src, size);
 }
 
 static const struct bpf_func_proto bpf_probe_write_user_proto = {


