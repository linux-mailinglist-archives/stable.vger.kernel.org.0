Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33E933EB88F
	for <lists+stable@lfdr.de>; Fri, 13 Aug 2021 17:26:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241247AbhHMPOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Aug 2021 11:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241818AbhHMPNL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Aug 2021 11:13:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E134D6109E;
        Fri, 13 Aug 2021 15:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628867562;
        bh=/Y0Kv6TgSTJSKK5u49KwSb7oEb3l6Q6wJ2i/6ohi8Pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XdORy019e8wCibef6nRapWEby0xaAfiaAg+ed+MLUXp+PgonDOdjY6Wlioqa6XCJE
         a1zm8FLCMxK1tozk7TdVk3HirGy9g25+EAtZN/FfS4VXpFtt1FAxIrh/5tHaob+Gji
         uGJlc8+MTSxO91ywxiwrjgfZwGg9nzQyz1KV5EWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        bpf@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 4.19 06/11] bpf, selftests: Adjust few selftest outcomes wrt unreachable code
Date:   Fri, 13 Aug 2021 17:07:13 +0200
Message-Id: <20210813150520.278492879@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210813150520.072304554@linuxfoundation.org>
References: <20210813150520.072304554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit 973377ffe8148180b2651825b92ae91988141b05 upstream.

In almost all cases from test_verifier that have been changed in here, we've
had an unreachable path with a load from a register which has an invalid
address on purpose. This was basically to make sure that we never walk this
path and to have the verifier complain if it would otherwise. Change it to
match on the right error for unprivileged given we now test these paths
under speculative execution.

There's one case where we match on exact # of insns_processed. Due to the
extra path, this will of course mismatch on unprivileged. Thus, restrict the
test->insn_processed check to privileged-only.

In one other case, we result in a 'pointer comparison prohibited' error. This
is similarly due to verifying an 'invalid' branch where we end up with a value
pointer on one side of the comparison.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
[OP: ignore changes to tests that do not exist in 4.19]
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_verifier.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/bpf/test_verifier.c
+++ b/tools/testing/selftests/bpf/test_verifier.c
@@ -2792,6 +2792,8 @@ static struct bpf_test tests[] = {
 			BPF_LDX_MEM(BPF_DW, BPF_REG_0, BPF_REG_7, 0),
 			BPF_EXIT_INSN(),
 		},
+		.errstr_unpriv = "R7 invalid mem access 'inv'",
+		.result_unpriv = REJECT,
 		.result = ACCEPT,
 		.retval = 0,
 	},


