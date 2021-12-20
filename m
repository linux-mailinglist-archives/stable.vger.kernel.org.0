Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A62C947AED8
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:04:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240506AbhLTPEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238519AbhLTPCM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:02:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80737C08EE24;
        Mon, 20 Dec 2021 06:51:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D6976118D;
        Mon, 20 Dec 2021 14:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8F43C36AE8;
        Mon, 20 Dec 2021 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011903;
        bh=6artq7rDrePHMe1YVNtIo7uMZ7LDAzzORU/ImfjVxL0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mmve0FlQ6e4NM5UQPH4b/9TyY1RRBRdvqTDvrqb3iS6bT6Ha3Ao3TZgWVA+M9Wosc
         oSZz/iZqh47ti4orj7KIwX8hTbI+82MCEZdTOPho98NBNKzif04fN/YMgeb4frOVDO
         J9dAISoT5Cmfv69v7DXTYaggUtmjOmCi6+fX4okE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.15 016/177] bpf: Make 32->64 bounds propagation slightly more robust
Date:   Mon, 20 Dec 2021 15:32:46 +0100
Message-Id: <20211220143040.617633579@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit e572ff80f05c33cd0cb4860f864f5c9c044280b6 upstream.

Make the bounds propagation in __reg_assign_32_into_64() slightly more
robust and readable by aligning it similarly as we did back in the
__reg_combine_64_into_32() counterpart. Meaning, only propagate or
pessimize them as a smin/smax pair.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1358,22 +1358,28 @@ static void __reg_bound_offset(struct bp
 	reg->var_off = tnum_or(tnum_clear_subreg(var64_off), var32_off);
 }
 
+static bool __reg32_bound_s64(s32 a)
+{
+	return a >= 0 && a <= S32_MAX;
+}
+
 static void __reg_assign_32_into_64(struct bpf_reg_state *reg)
 {
 	reg->umin_value = reg->u32_min_value;
 	reg->umax_value = reg->u32_max_value;
-	/* Attempt to pull 32-bit signed bounds into 64-bit bounds
-	 * but must be positive otherwise set to worse case bounds
-	 * and refine later from tnum.
+
+	/* Attempt to pull 32-bit signed bounds into 64-bit bounds but must
+	 * be positive otherwise set to worse case bounds and refine later
+	 * from tnum.
 	 */
-	if (reg->s32_min_value >= 0 && reg->s32_max_value >= 0)
-		reg->smax_value = reg->s32_max_value;
-	else
-		reg->smax_value = U32_MAX;
-	if (reg->s32_min_value >= 0)
+	if (__reg32_bound_s64(reg->s32_min_value) &&
+	    __reg32_bound_s64(reg->s32_max_value)) {
 		reg->smin_value = reg->s32_min_value;
-	else
+		reg->smax_value = reg->s32_max_value;
+	} else {
 		reg->smin_value = 0;
+		reg->smax_value = U32_MAX;
+	}
 }
 
 static void __reg_combine_32_into_64(struct bpf_reg_state *reg)


