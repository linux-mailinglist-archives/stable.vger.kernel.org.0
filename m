Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DE3300630
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728713AbhAVOy3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:54:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728634AbhAVOXt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:23:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DC1D23A5C;
        Fri, 22 Jan 2021 14:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325112;
        bh=rcKDZAZky7dcXQQk+3aImrm6EK+xujHNo0sLL7NNYso=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EyXRb7rQ/MAR1kGPx7mgz/E7S/gPbG1LwacLxzXkRmTzoOCwL2i54jtHIaa4q7YG9
         uBNIayTV38P+phFZudjKWUT46WG+54fdPrOXf0BFutWpE9viLqM5UOoLdKMsuCCbbe
         utMBgHIXfCmYfj1H6wsKxo4+lclSNQu4Kcu6Yc1g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, De4dCr0w <sa516203@mail.ustc.edu.cn>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 05/43] bpf: Fix signed_{sub,add32}_overflows type handling
Date:   Fri, 22 Jan 2021 15:12:21 +0100
Message-Id: <20210122135735.870059247@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit bc895e8b2a64e502fbba72748d59618272052a8b upstream.

Fix incorrect signed_{sub,add32}_overflows() input types (and a related buggy
comment). It looks like this might have slipped in via copy/paste issue, also
given prior to 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
the signature of signed_sub_overflows() had s64 a and s64 b as its input args
whereas now they are truncated to s32. Thus restore proper types. Also, the case
of signed_add32_overflows() is not consistent to signed_sub32_overflows(). Both
have s32 as inputs, therefore align the former.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Reported-by: De4dCr0w <sa516203@mail.ustc.edu.cn>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5255,7 +5255,7 @@ static bool signed_add_overflows(s64 a,
 	return res < a;
 }
 
-static bool signed_add32_overflows(s64 a, s64 b)
+static bool signed_add32_overflows(s32 a, s32 b)
 {
 	/* Do the add in u32, where overflow is well-defined */
 	s32 res = (s32)((u32)a + (u32)b);
@@ -5265,7 +5265,7 @@ static bool signed_add32_overflows(s64 a
 	return res < a;
 }
 
-static bool signed_sub_overflows(s32 a, s32 b)
+static bool signed_sub_overflows(s64 a, s64 b)
 {
 	/* Do the sub in u64, where overflow is well-defined */
 	s64 res = (s64)((u64)a - (u64)b);
@@ -5277,7 +5277,7 @@ static bool signed_sub_overflows(s32 a,
 
 static bool signed_sub32_overflows(s32 a, s32 b)
 {
-	/* Do the sub in u64, where overflow is well-defined */
+	/* Do the sub in u32, where overflow is well-defined */
 	s32 res = (s32)((u32)a - (u32)b);
 
 	if (b < 0)


