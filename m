Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 815A033B64B
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 14:59:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbhCON5i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 09:57:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:34536 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhCON5J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:57:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 194E964EF3;
        Mon, 15 Mar 2021 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816628;
        bh=MRxnbr6GCvzlsTlzldQEnZM3HHwrm9aBD+N7NzrjEOA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKKRi1xOX9X/S0TqTF+yaHlWbZMRkMwqqJkoGY315Z3eBI/WArq6sG1kFkfEzvUlX
         VpvcWfQ62/w4jSZKaXPA4iZQllZ5Ah+j2+7RsGn6gfTfv8ORXW0wdJmFY7CDCH2sJR
         vmLIF039t8MMyreDipziQtTRiEAFnSH6/T+xdnjI=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilya Leoshkevich <iii@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Heiko Carstens <hca@linux.ibm.com>, Yonghong Song <yhs@fb.com>
Subject: [PATCH 5.11 029/306] selftests/bpf: Use the last page in test_snprintf_btf on s390
Date:   Mon, 15 Mar 2021 14:51:32 +0100
Message-Id: <20210315135508.613058716@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Ilya Leoshkevich <iii@linux.ibm.com>

commit 42a382a466a967dc053c73b969cd2ac2fec502cf upstream.

test_snprintf_btf fails on s390, because NULL points to a readable
struct lowcore there. Fix by using the last page instead.

Error message example:

    printing fffffffffffff000 should generate error, got (361)

Fixes: 076a95f5aff2 ("selftests/bpf: Add bpf_snprintf_btf helper tests")
Signed-off-by: Ilya Leoshkevich <iii@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Heiko Carstens <hca@linux.ibm.com>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210227051726.121256-1-iii@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/netif_receive_skb.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/bpf/progs/netif_receive_skb.c
+++ b/tools/testing/selftests/bpf/progs/netif_receive_skb.c
@@ -16,6 +16,13 @@ bool skip = false;
 #define STRSIZE			2048
 #define EXPECTED_STRSIZE	256
 
+#if defined(bpf_target_s390)
+/* NULL points to a readable struct lowcore on s390, so take the last page */
+#define BADPTR			((void *)0xFFFFFFFFFFFFF000ULL)
+#else
+#define BADPTR			0
+#endif
+
 #ifndef ARRAY_SIZE
 #define ARRAY_SIZE(x)	(sizeof(x) / sizeof((x)[0]))
 #endif
@@ -113,11 +120,11 @@ int BPF_PROG(trace_netif_receive_skb, st
 	}
 
 	/* Check invalid ptr value */
-	p.ptr = 0;
+	p.ptr = BADPTR;
 	__ret = bpf_snprintf_btf(str, STRSIZE, &p, sizeof(p), 0);
 	if (__ret >= 0) {
-		bpf_printk("printing NULL should generate error, got (%d)",
-			   __ret);
+		bpf_printk("printing %llx should generate error, got (%d)",
+			   (unsigned long long)BADPTR, __ret);
 		ret = -ERANGE;
 	}
 


