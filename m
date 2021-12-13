Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31EB2472509
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234679AbhLMJkh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:40:37 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34030 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234676AbhLMJjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 04:39:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A5C3FCE0E29;
        Mon, 13 Dec 2021 09:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F831C341DC;
        Mon, 13 Dec 2021 09:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388340;
        bh=sADD71pTzPBhbLdqJ/7BhSPOJT1D7QZhlqrCQln+H6s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lFiaG1Eib+XV2zUF/fEYkwLB/FeT7rdJU9+w8aSypJ8NSu+ygeRgLiMlRtSq6Ate2
         aqAv5+5Ity1lYSb7IFqX7EnpdvqS+nGbV5+8TYf5olLx9A4Wnp2rNkpXFbtfAaplLr
         zXP93NM11bLQl5uyTqPLuuawL7IEcl+3bwlEyJAI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maxim Mikityanskiy <maximmi@nvidia.com>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.19 16/74] bpf: Fix the off-by-two error in range markings
Date:   Mon, 13 Dec 2021 10:29:47 +0100
Message-Id: <20211213092931.340363391@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092930.763200615@linuxfoundation.org>
References: <20211213092930.763200615@linuxfoundation.org>
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
@@ -3761,7 +3761,7 @@ static void find_good_pkt_pointers(struc
 
 	new_range = dst_reg->off;
 	if (range_right_open)
-		new_range--;
+		new_range++;
 
 	/* Examples for register markings:
 	 *


