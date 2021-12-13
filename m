Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2E47272F
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239969AbhLMJ7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:59:03 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:44286 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238695AbhLMJyP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:54:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 13111CE0EBE;
        Mon, 13 Dec 2021 09:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFE1EC3460D;
        Mon, 13 Dec 2021 09:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389252;
        bh=0lxbf4eIL5TiS/wDKjs66cU4M1CZ7EsdBWlig03swUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqUX4N7pKo+7V/GQzwb/0ZgEGr88YjGt9V2OeXgcCZyNrSHZtpr/nThyIbLDzPz7K
         UyhRfbvCoog6hVNxvaWpFU7bLJxm2WMvUxzHm3dAh1qsgQLQf+5k/GdDl5nd5OZv0a
         Mt2U9W5Yu0zfei2bLT/ADAOHdSKluKFX3gzlwxVg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 036/171] bpf, x86: Fix "no previous prototype" warning
Date:   Mon, 13 Dec 2021 10:29:11 +0100
Message-Id: <20211213092946.282091371@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
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
@@ -723,6 +723,7 @@ int bpf_trampoline_unlink_prog(struct bp
 struct bpf_trampoline *bpf_trampoline_get(u64 key,
 					  struct bpf_attach_target_info *tgt_info);
 void bpf_trampoline_put(struct bpf_trampoline *tr);
+int arch_prepare_bpf_dispatcher(void *image, s64 *funcs, int num_funcs);
 #define BPF_DISPATCHER_INIT(_name) {				\
 	.mutex = __MUTEX_INITIALIZER(_name.mutex),		\
 	.func = &_name##_func,					\


