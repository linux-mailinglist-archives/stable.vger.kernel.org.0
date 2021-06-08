Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF3639FFE6
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234825AbhFHShR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:57666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234839AbhFHSfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:35:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D5ADE613D6;
        Tue,  8 Jun 2021 18:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177131;
        bh=So/1Lc16sLR+aqvXq8zoVNXzmbtnzhAD9WM0zRoZ7YQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tgGRrzZyeNCK3h91N+12LGLVQdj5LkIZ06+obUQpTVBx9tsb48+M5518IMEp2tF4D
         fsstBiryQC9Lx+gccQ3HSZ6uZzXg9434lZofglDo6dhsyLl0mF3EguNX9Wp1ZfFuQY
         LnG4x0DNHImrGBUcS7sk3ifOuzmua4hbdo3LMswE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Piotr Krysiuk <piotras@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 4.14 43/47] bpf: No need to simulate speculative domain for immediates
Date:   Tue,  8 Jun 2021 20:27:26 +0200
Message-Id: <20210608175931.905528105@linuxfoundation.org>
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
@@ -2169,8 +2169,12 @@ do_sim:
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


