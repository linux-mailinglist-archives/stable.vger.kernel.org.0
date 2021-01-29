Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AABA3088DE
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 13:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232695AbhA2MH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 07:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:55012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232455AbhA2MFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 29 Jan 2021 07:05:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88C4164F2E;
        Fri, 29 Jan 2021 11:11:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611918692;
        bh=cIhsYkjH1sbP4EzOIl/tVAIS80g1q+E0gKgoggxt1mU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IpwpTrrd34QArbmzvrpoCeuHFw/5rZyPX5YXL2e9c8m0pcUrpqXLkH1kg9JH7YtmJ
         tdeb0w0CXayaDiZV/jMtJmjXIJI45STEsprz3dmv3o5HEehVxVoRiTi+6l+wnnBiUg
         5mAlWWSP87/h7odyC89QzY1OduhlxlvVa1pKbQ7U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Josef Bacik <jbacik@fb.com>
Subject: [PATCH 4.9 19/30] bpf: Fix buggy rsh min/max bounds tracking
Date:   Fri, 29 Jan 2021 12:06:55 +0100
Message-Id: <20210129105911.339338950@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210129105910.583037839@linuxfoundation.org>
References: <20210129105910.583037839@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Borkmann <daniel@iogearbox.net>

[ no upstream commit ]

Fix incorrect bounds tracking for RSH opcode. Commit f23cc643f9ba ("bpf: fix
range arithmetic for bpf map access") had a wrong assumption about min/max
bounds. The new dst_reg->min_value needs to be derived by right shifting the
max_val bounds, not min_val, and likewise new dst_reg->max_value needs to be
derived by right shifting the min_val bounds, not max_val. Later stable kernels
than 4.9 are not affected since bounds tracking was overall reworked and they
already track this similarly as in the fix.

Fixes: f23cc643f9ba ("bpf: fix range arithmetic for bpf map access")
Reported-by: Ryota Shiga (Flatt Security)
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Cc: Josef Bacik <jbacik@fb.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/bpf/verifier.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -1732,12 +1732,11 @@ static void adjust_reg_min_max_vals(stru
 		 * unsigned shift, so make the appropriate casts.
 		 */
 		if (min_val < 0 || dst_reg->min_value < 0)
-			dst_reg->min_value = BPF_REGISTER_MIN_RANGE;
+			reset_reg_range_values(regs, insn->dst_reg);
 		else
-			dst_reg->min_value =
-				(u64)(dst_reg->min_value) >> min_val;
+			dst_reg->min_value = (u64)(dst_reg->min_value) >> max_val;
 		if (dst_reg->max_value != BPF_REGISTER_MAX_RANGE)
-			dst_reg->max_value >>= max_val;
+			dst_reg->max_value >>= min_val;
 		break;
 	default:
 		reset_reg_range_values(regs, insn->dst_reg);


