Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34DAA1C164D
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731672AbgEANnt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:43:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:44772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731670AbgEANns (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:43:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1B89820757;
        Fri,  1 May 2020 13:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340627;
        bh=vHcalEBLMutUMRD2FIfDoqpmbNja+3/JedzvGyfkonk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7Q8LUABIV83YW+3S6ZPJvw3cqPok3lNTkv8vCnhohBtd8VocNxNetAn6ng92nvnk
         WUUvcOfwBQDdW6opWvJVuSigwhn80QFIixBefUuO0bWN1G9K73w68m1uB+oErxGVfI
         34dE6gUppV2mQd50phb8puQ5aYh+R8sLbtahHkTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.6 059/106] bpf: Fix handling of XADD on BTF memory
Date:   Fri,  1 May 2020 15:23:32 +0200
Message-Id: <20200501131550.708315300@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

commit 8ff3571f7e1bf3f293cc5e3dc14f2943f4fa7fcf upstream.

check_xadd() can cause check_ptr_to_btf_access() to be executed with
atype==BPF_READ and value_regno==-1 (meaning "just check whether the access
is okay, don't tell me what type it will result in").
Handle that case properly and skip writing type information, instead of
indexing into the registers at index -1 and writing into out-of-bounds
memory.

Note that at least at the moment, you can't actually write through a BTF
pointer, so check_xadd() will reject the program after calling
check_ptr_to_btf_access with atype==BPF_WRITE; but that's after the
verifier has already corrupted memory.

This patch assumes that BTF pointers are not available in unprivileged
programs.

Fixes: 9e15db66136a ("bpf: Implement accurate raw_tp context access via BTF")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200417000007.10734-2-jannh@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2885,7 +2885,7 @@ static int check_ptr_to_btf_access(struc
 	if (ret < 0)
 		return ret;
 
-	if (atype == BPF_READ) {
+	if (atype == BPF_READ && value_regno >= 0) {
 		if (ret == SCALAR_VALUE) {
 			mark_reg_unknown(env, regs, value_regno);
 			return 0;


