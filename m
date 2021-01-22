Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00865300635
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728737AbhAVOyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:39602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728638AbhAVOXw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54A0123B01;
        Fri, 22 Jan 2021 14:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325123;
        bh=19OZUo+5WqaAeqWUCa5yZCv1TB9qkBNMllD/YndVSYg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMnKqCWPj0xydl7CpHcueCpPn3+k+bFe+w8bx5dku7PcwmBkkAy7MKGOOkNRqXXv0
         mJlArmqsABmJtvvJroR9tdWZDyVlquOXUuFljiNx00deWhq8BNF1QySuFlu4JXTYpu
         Y4dLMODPB27u0yLcMAG5yyh0prwta+WxiZUaCF9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Gilad Reti <gilad.reti@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        KP Singh <kpsingh@kernel.org>
Subject: [PATCH 5.10 09/43] bpf: Support PTR_TO_MEM{,_OR_NULL} register spilling
Date:   Fri, 22 Jan 2021 15:12:25 +0100
Message-Id: <20210122135736.032085194@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gilad Reti <gilad.reti@gmail.com>

commit 744ea4e3885eccb6d332a06fae9eb7420a622c0f upstream.

Add support for pointer to mem register spilling, to allow the verifier
to track pointers to valid memory addresses. Such pointers are returned
for example by a successful call of the bpf_ringbuf_reserve helper.

The patch was partially contributed by CyberArk Software, Inc.

Fixes: 457f44363a88 ("bpf: Implement BPF ring buffer and verifier support for it")
Suggested-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Gilad Reti <gilad.reti@gmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: KP Singh <kpsingh@kernel.org>
Link: https://lore.kernel.org/bpf/20210113053810.13518-1-gilad.reti@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2214,6 +2214,8 @@ static bool is_spillable_regtype(enum bp
 	case PTR_TO_RDWR_BUF:
 	case PTR_TO_RDWR_BUF_OR_NULL:
 	case PTR_TO_PERCPU_BTF_ID:
+	case PTR_TO_MEM:
+	case PTR_TO_MEM_OR_NULL:
 		return true;
 	default:
 		return false;


