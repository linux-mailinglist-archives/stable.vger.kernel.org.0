Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE4BA1C1651
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 16:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731704AbgEANoD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:44:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731697AbgEANoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:44:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E42F205C9;
        Fri,  1 May 2020 13:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588340639;
        bh=xR5sllBxTIDYao6jzEiJfu6TyrAgFun+Eq479l2zj0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cJ7+WDjs13zycDCWzRNh+CFdormdQj1HHn0T/L7XNr7XHWQ2tmykMidG09yey/YIc
         jbiMFQVdSCjX8UlWTj0scHK7TEwWiPLhfZcvLEuEuHMAUrD3N2ouns9ukhouprnM7l
         V3W7RPq3mEJ69vp3N2RcauxFX6Q6tc36G18NlKdc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.6 064/106] bpf: Propagate expected_attach_type when verifying freplace programs
Date:   Fri,  1 May 2020 15:23:37 +0200
Message-Id: <20200501131551.736327335@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131543.421333643@linuxfoundation.org>
References: <20200501131543.421333643@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

commit 03f87c0b45b177ba5f6b4a9bbe9f95e4aba31026 upstream.

For some program types, the verifier relies on the expected_attach_type of
the program being verified in the verification process. However, for
freplace programs, the attach type was not propagated along with the
verifier ops, so the expected_attach_type would always be zero for freplace
programs.

This in turn caused the verifier to sometimes make the wrong call for
freplace programs. For all existing uses of expected_attach_type for this
purpose, the result of this was only false negatives (i.e., freplace
functions would be rejected by the verifier even though they were valid
programs for the target they were replacing). However, should a false
positive be introduced, this can lead to out-of-bounds accesses and/or
crashes.

The fix introduced in this patch is to propagate the expected_attach_type
to the freplace program during verification, and reset it after that is
done.

Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/158773526726.293902.13257293296560360508.stgit@toke.dk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/verifier.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9892,6 +9892,7 @@ static int check_attach_btf_id(struct bp
 				return -EINVAL;
 			}
 			env->ops = bpf_verifier_ops[tgt_prog->type];
+			prog->expected_attach_type = tgt_prog->expected_attach_type;
 		}
 		if (!tgt_prog->jited) {
 			verbose(env, "Can attach to only JITed progs\n");
@@ -10225,6 +10226,13 @@ err_release_maps:
 		 * them now. Otherwise free_used_maps() will release them.
 		 */
 		release_maps(env);
+
+	/* extension progs temporarily inherit the attach_type of their targets
+	   for verification purposes, so set it back to zero before returning
+	 */
+	if (env->prog->type == BPF_PROG_TYPE_EXT)
+		env->prog->expected_attach_type = 0;
+
 	*prog = env->prog;
 err_unlock:
 	if (!is_priv)


