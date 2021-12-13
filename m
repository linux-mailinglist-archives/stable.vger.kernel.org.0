Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599294724D5
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbhLMJi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:38:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:49914 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbhLMJha (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:37:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7ED7B80E15;
        Mon, 13 Dec 2021 09:37:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA8F9C00446;
        Mon, 13 Dec 2021 09:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388248;
        bh=+txLVm7434gQb8qMkJfbHz/qNnk0pSIt2gK4IJbFqpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LRxFdqzH4EUVIpRfcLvClcYHhbPpOWLJKsU0rRdrspNvp+C/UWudS1OS2wdCbxEmJ
         B6tiOxUfWHBptZIE/8XyTvGT5aYYVOj+t1j4UKUWueOwiYjOJ8axCVQpFiDJ40UwBR
         mFG7lmpXTinJsoMmkNeY/9KGXvzKMh9b5wBuKKfY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 09/53] bpf: Fix the off-by-two error in range markings
Date:   Mon, 13 Dec 2021 10:29:48 +0100
Message-Id: <20211213092928.669463787@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092928.349556070@linuxfoundation.org>
References: <20211213092928.349556070@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@nvidia.com>

commit 2fa7d94afc1afbb4d702760c058dc2d7ed30f226 upstream.

The first commit cited below attempts to fix the off-by-one error that
appeared in some comparisons with an open range. Due to this error,
arithmetically equivalent pieces of code could get different verdicts
from the verifier, for example (pseudocode):

  // 1. Passes the verifier:
  if (data + 8 > data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

  // 2. Rejected by the verifier (should still pass):
  if (data + 7 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The attempted fix, however, shifts the range by one in a wrong
direction, so the bug not only remains, but also such piece of code
starts failing in the verifier:

  // 3. Rejected by the verifier, but the check is stricter than in #1.
  if (data + 8 >= data_end)
      return early
  read *(u64 *)data, i.e. [data; data+7]

The change performed by that fix converted an off-by-one bug into
off-by-two. The second commit cited below added the BPF selftests
written to ensure than code chunks like #3 are rejected, however,
they should be accepted.

This commit fixes the off-by-two error by adjusting new_range in the
right direction and fixes the tests by changing the range into the
one that should actually fail.

Fixes: fb2a311a31d3 ("bpf: fix off by one for range markings with L{T, E} patterns")
Fixes: b37242c773b2 ("bpf: add test cases to bpf selftests to cover all access tests")
Signed-off-by: Maxim Mikityanskiy <maximmi@nvidia.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211130181607.593149-1-maximmi@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2989,7 +2989,7 @@ static void find_good_pkt_pointers(struc
 
 	new_range = dst_reg->off;
 	if (range_right_open)
-		new_range--;
+		new_range++;
 
 	/* Examples for register markings:
 	 *


