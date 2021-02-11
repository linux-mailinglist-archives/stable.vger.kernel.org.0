Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A92DD318DF8
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:19:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbhBKPS5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:18:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229916AbhBKPNT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:13:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2D30364EF3;
        Thu, 11 Feb 2021 15:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055884;
        bh=pZUWVGmpSgyq0X0nBEATrlOBq1AczwSKMjBI4an9OuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kI2Ff6tbpAzyiodDz1zfnpRM2xSNMfcNcu6qOmoyLo2GDh61k1yzttvY3IzUdAJxZ
         iJ6iAC5ZQDpmPUVwoa1t0/H2sEmq0s2xQpS2vooPEnR8UoCgvrVPMovY2QipTJn3Wp
         utjZPXXt1GLpC6441Fb/FHOGvVKznowufZXJIsd8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 46/54] bpf: Fix verifier jsgt branch analysis on max bound
Date:   Thu, 11 Feb 2021 16:02:30 +0100
Message-Id: <20210211150154.878999096@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit ee114dd64c0071500345439fc79dd5e0f9d106ed upstream.

Fix incorrect is_branch{32,64}_taken() analysis for the jsgt case. The return
code for both will tell the caller whether a given conditional jump is taken
or not, e.g. 1 means branch will be taken [for the involved registers] and the
goto target will be executed, 0 means branch will not be taken and instead we
fall-through to the next insn, and last but not least a -1 denotes that it is
not known at verification time whether a branch will be taken or not. Now while
the jsgt has the branch-taken case correct with reg->s32_min_value > sval, the
branch-not-taken case is off-by-one when testing for reg->s32_max_value < sval
since the branch will also be taken for reg->s32_max_value == sval. The jgt
branch analysis, for example, gets this right.

Fixes: 3f50f132d840 ("bpf: Verifier, do explicit ALU32 bounds tracking")
Fixes: 4f7b3e82589e ("bpf: improve verifier branch analysis")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -6822,7 +6822,7 @@ static int is_branch32_taken(struct bpf_
 	case BPF_JSGT:
 		if (reg->s32_min_value > sval)
 			return 1;
-		else if (reg->s32_max_value < sval)
+		else if (reg->s32_max_value <= sval)
 			return 0;
 		break;
 	case BPF_JLT:
@@ -6895,7 +6895,7 @@ static int is_branch64_taken(struct bpf_
 	case BPF_JSGT:
 		if (reg->smin_value > sval)
 			return 1;
-		else if (reg->smax_value < sval)
+		else if (reg->smax_value <= sval)
 			return 0;
 		break;
 	case BPF_JLT:


