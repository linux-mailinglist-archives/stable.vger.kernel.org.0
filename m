Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF7B4997E3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:34:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378373AbiAXVRQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:17:16 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34420 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377928AbiAXVNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:13:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 356F6B8105C;
        Mon, 24 Jan 2022 21:13:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65F46C340E7;
        Mon, 24 Jan 2022 21:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058807;
        bh=ZwfV9lC0qIECwSLVyzpet18Z//UfPAeeUHilSu2CnGI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RZCwkPkvSxxuf9alnTQs4A05nTX1C5Tq/wZ/FfGMxpIMqEhS81xXE6oeX/L+TjPc/
         2EkQO3wtQYMl4y0QKPMqMq+8qY/mGfOk9/TXGraZgffmURUy7DmGUcab/z+O4oniOg
         s23GX3Yov69h32bTe+iRMYXGBHbLH5Xo85rByjqI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0375/1039] bpf: Dont promote bogus looking registers after null check.
Date:   Mon, 24 Jan 2022 19:36:04 +0100
Message-Id: <20220124184137.918229276@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit e60b0d12a95dcf16a63225cead4541567f5cb517 ]

If we ever get to a point again where we convert a bogus looking <ptr>_or_null
typed register containing a non-zero fixed or variable offset, then lets not
reset these bounds to zero since they are not and also don't promote the register
to a <ptr> type, but instead leave it as <ptr>_or_null. Converting to a unknown
register could be an avenue as well, but then if we run into this case it would
allow to leak a kernel pointer this way.

Fixes: f1174f77b50c ("bpf/verifier: rework value tracking")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8ebabae31a431..45d5e71cd64e6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8961,15 +8961,15 @@ static void mark_ptr_or_null_reg(struct bpf_func_state *state,
 {
 	if (reg_type_may_be_null(reg->type) && reg->id == id &&
 	    !WARN_ON_ONCE(!reg->id)) {
-		/* Old offset (both fixed and variable parts) should
-		 * have been known-zero, because we don't allow pointer
-		 * arithmetic on pointers that might be NULL.
-		 */
 		if (WARN_ON_ONCE(reg->smin_value || reg->smax_value ||
 				 !tnum_equals_const(reg->var_off, 0) ||
 				 reg->off)) {
-			__mark_reg_known_zero(reg);
-			reg->off = 0;
+			/* Old offset (both fixed and variable parts) should
+			 * have been known-zero, because we don't allow pointer
+			 * arithmetic on pointers that might be NULL. If we
+			 * see this happening, don't convert the register.
+			 */
+			return;
 		}
 		if (is_null) {
 			reg->type = SCALAR_VALUE;
-- 
2.34.1



