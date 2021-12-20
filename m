Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF3747ADC5
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:55:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235596AbhLTOzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237687AbhLTOw1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:52:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DCD7C061747;
        Mon, 20 Dec 2021 06:47:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F380B80EE2;
        Mon, 20 Dec 2021 14:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775C1C36AE8;
        Mon, 20 Dec 2021 14:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011636;
        bh=r+UUXRyF7d8DlHuW9/+xuatkvkscxPDiBOVtwg/ghK8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OjapWkJ1Mbqq6reB59cdqTITqps3aszHa4kNSXucyEZY86YU5Ep3V1ISluMKPaU37
         Ux7o83DIpvqqRI47D7H7H9gSvviO1R9l06877Z/W3VCBJNajeZkOY8iZCrGTrALWno
         Qn9zPjpwdnpKMRJwb/TTFFAtEIAtpwRe69k0N2M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 09/99] bpf: Make 32->64 bounds propagation slightly more robust
Date:   Mon, 20 Dec 2021 15:33:42 +0100
Message-Id: <20211220143029.658946229@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
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
@@ -1249,22 +1249,28 @@ static void __reg_bound_offset(struct bp
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


