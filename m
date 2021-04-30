Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF6736FC11
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 16:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhD3OVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 10:21:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232733AbhD3OVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 10:21:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 332CE61474;
        Fri, 30 Apr 2021 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619792435;
        bh=chSn0igrfso4Dcmj3/WZkR8AP/DG4nT04Qmc3P60n/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuQCRvzCJ4qwWNL78CplGmrKBs6xcxT0YB/callabMa0ldbqMv2KpR6JRJdSDX0pK
         l2Hlw+ifwEEIIzbbVK+TNtca+iJ9PYQC26CAh6vLqubDp9nARgEvxg0GIyEbVmzF1+
         RS1Y9xkr6J7nCJQg2Vt7bxw8Mj+XFR+Xa6/8i17s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.4 3/8] bpf: Rework ptr_limit into alu_limit and add common error path
Date:   Fri, 30 Apr 2021 16:20:17 +0200
Message-Id: <20210430141911.256507736@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
References: <20210430141911.137473863@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit b658bbb844e28f1862867f37e8ca11a8e2aa94a3 upstream.

Small refactor with no semantic changes in order to consolidate the max
ptr_limit boundary check.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |   21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4265,12 +4265,12 @@ static struct bpf_insn_aux_data *cur_aux
 
 static int retrieve_ptr_limit(const struct bpf_reg_state *ptr_reg,
 			      const struct bpf_reg_state *off_reg,
-			      u32 *ptr_limit, u8 opcode)
+			      u32 *alu_limit, u8 opcode)
 {
 	bool off_is_neg = off_reg->smin_value < 0;
 	bool mask_to_left = (opcode == BPF_ADD &&  off_is_neg) ||
 			    (opcode == BPF_SUB && !off_is_neg);
-	u32 off, max;
+	u32 off, max = 0, ptr_limit = 0;
 
 	if (!tnum_is_const(off_reg->var_off) &&
 	    (off_reg->smin_value < 0) != (off_reg->smax_value < 0))
@@ -4287,22 +4287,27 @@ static int retrieve_ptr_limit(const stru
 		 */
 		off = ptr_reg->off + ptr_reg->var_off.value;
 		if (mask_to_left)
-			*ptr_limit = MAX_BPF_STACK + off;
+			ptr_limit = MAX_BPF_STACK + off;
 		else
-			*ptr_limit = -off - 1;
-		return *ptr_limit >= max ? -ERANGE : 0;
+			ptr_limit = -off - 1;
+		break;
 	case PTR_TO_MAP_VALUE:
 		max = ptr_reg->map_ptr->value_size;
 		if (mask_to_left) {
-			*ptr_limit = ptr_reg->umax_value + ptr_reg->off;
+			ptr_limit = ptr_reg->umax_value + ptr_reg->off;
 		} else {
 			off = ptr_reg->smin_value + ptr_reg->off;
-			*ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
+			ptr_limit = ptr_reg->map_ptr->value_size - off - 1;
 		}
-		return *ptr_limit >= max ? -ERANGE : 0;
+		break;
 	default:
 		return -EINVAL;
 	}
+
+	if (ptr_limit >= max)
+		return -ERANGE;
+	*alu_limit = ptr_limit;
+	return 0;
 }
 
 static bool can_skip_alu_sanitation(const struct bpf_verifier_env *env,


