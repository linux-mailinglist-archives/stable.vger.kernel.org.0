Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 508D0472740
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240045AbhLMJ7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239211AbhLMJ5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:57:01 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4C50C0698C4;
        Mon, 13 Dec 2021 01:47:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0B3E2CE0E89;
        Mon, 13 Dec 2021 09:47:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC8F9C341C5;
        Mon, 13 Dec 2021 09:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388851;
        bh=hhuexgiPUY5TTBoIS8kxGRsSQhEdFlQXpHHg4Zr9imw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ke64HSzL62LtJLfT3ZobK/2PYqxrB0Wb7od64irznjftKT868y5PrYRWXc4KT+WYj
         JSdJeJ/vBxWRsNBFvCfRckXaxduHPlsyLa3xli5G3BdU3QnZDSldHbTN7h8YXnIaJu
         cWAMnyANW+0YJ/hx0qRnIOu9G0cNjgTWQn9vGPuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.10 030/132] bpf, x86: Fix "no previous prototype" warning
Date:   Mon, 13 Dec 2021 10:29:31 +0100
Message-Id: <20211213092940.149571464@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Björn Töpel <bjorn@kernel.org>

commit f45b2974cc0ae959a4c503a071e38a56bd64372f upstream.

The arch_prepare_bpf_dispatcher function does not have a prototype, and
yields the following warning when W=1 is enabled for the kernel build.

  >> arch/x86/net/bpf_jit_comp.c:2188:5: warning: no previous \
  prototype for 'arch_prepare_bpf_dispatcher' [-Wmissing-prototypes]
        2188 | int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, \
	int num_funcs)
             |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Remove the warning by adding a function declaration to include/linux/bpf.h.

Fixes: 75ccbef6369e ("bpf: Introduce BPF dispatcher")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Björn Töpel <bjorn@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211117125708.769168-1-bjorn@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h |    1 +
 1 file changed, 1 insertion(+)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -666,6 +666,7 @@ int bpf_trampoline_unlink_prog(struct bp
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\


