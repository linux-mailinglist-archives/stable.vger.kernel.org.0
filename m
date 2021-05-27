Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C653393212
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 17:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237057AbhE0PPK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 11:15:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:43590 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236926AbhE0PO7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 11:14:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9EBB613BC;
        Thu, 27 May 2021 15:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622128401;
        bh=6mWA43S9oyKGBhSF17tON2U+5sjM0n75vzvT8VzqzAk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mdy4GIkSoQeTS586UnOF6UVAJztr96tifsU89BxTF2p+EIbIFG0oEdJMENRGyK4lj
         KDUtIXEDabCgA2q0JLUunq0mFwOJvTAIMzx0KFuHnSpttH4R8FDMy6cy3P+aGLl0PT
         EcualiarjcfMqh/zdKEMTCDU6GvIelnVeequ7d/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 5.10 3/9] bpf: No need to simulate speculative domain for immediates
Date:   Thu, 27 May 2021 17:12:55 +0200
Message-Id: <20210527151139.350491221@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
References: <20210527151139.242182390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

commit a7036191277f9fa68d92f2071ddc38c09b1e5ee5 upstream.

In 801c6058d14a ("bpf: Fix leakage of uninitialized bpf stack under
speculation") we replaced masking logic with direct loads of immediates
if the register is a known constant. Given in this case we do not apply
any masking, there is also no reason for the operation to be truncated
under the speculative domain.

Therefore, there is also zero reason for the verifier to branch-off and
simulate this case, it only needs to do it for unknown but bounded scalars.
As a side-effect, this also enables few test cases that were previously
rejected due to simulation under zero truncation.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Piotr Krysiuk <piotras@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -5802,8 +5802,12 @@ do_sim:
 	/* If we're in commit phase, we're done here given we already
 	 * pushed the truncated dst_reg into the speculative verification
 	 * stack.
+	 *
+	 * Also, when register is a known constant, we rewrite register-based
+	 * operation to immediate-based, and thus do not need masking (and as
+	 * a consequence, do not need to simulate the zero-truncation either).
 	 */
-	if (commit_window)
+	if (commit_window || off_is_imm)
 		return 0;
 
 	/* Simulate and find potential out-of-bounds access under


