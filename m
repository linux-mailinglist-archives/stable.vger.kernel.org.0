Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A1039FFBC
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234512AbhFHSfq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:35:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:58040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234700AbhFHSd7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:33:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46F6C613D5;
        Tue,  8 Jun 2021 18:31:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177093;
        bh=xSZSnl7m2UGgysvLCU5ppFhx0YrUxXVXZlphh5Nb7fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Upx8F3+eoSBGMYzCyru4w4rl+lE8Jf9JSNrWF+Qzi6i+XjEb2V7XKtVZh6fA/tS1V
         pw8fcLBWv65WS3icz7f7usAdKnhrKEDv1pCkBO6XwI/HVh/2awfAikt74sFWmtJmxS
         iKFHVH+PN546TXdNEuWCWcZ51oYVGzmTcl1u3gpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 30/47] bpf: Rework ptr_limit into alu_limit and add common error path
Date:   Tue,  8 Jun 2021 20:27:13 +0200
Message-Id: <20210608175931.466685613@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175930.477274100@linuxfoundation.org>
References: <20210608175930.477274100@linuxfoundation.org>
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
@@ -2026,12 +2026,12 @@ static struct bpf_insn_aux_data *cur_aux
 
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
@@ -2045,22 +2045,27 @@ static int retrieve_ptr_limit(const stru
 		max = MAX_BPF_STACK + mask_to_left;
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


