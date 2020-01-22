Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F0441450D7
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 10:50:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732867AbgAVJjL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 04:39:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:56340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733142AbgAVJjE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 04:39:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17EF224684;
        Wed, 22 Jan 2020 09:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579685943;
        bh=KBgjthE4MXi4jjoOKexi2wKqKnsrS/GTG2qljJ1vEok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g8iCvQ/DCt0adKFw/A18hlORCxvMeure+n0C4tDRPVQNVnd/XY3mXrLq3fqAg5QUo
         e0lI50or0iRZNNRwde+LwcCErTomulmtPNXujPMVFoZanhiVQc9M7cKSaHniRAZaYC
         YbdyFGn4a7BJY5RaqmQnxfW5Sukm6CcBXWWWa4ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Wen Yang <wenyang@linux.alibaba.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qian Cai <cai@lca.pw>, Tejun Heo <tj@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 28/65] mm/page-writeback.c: avoid potential division by zero in wb_min_max_ratio()
Date:   Wed, 22 Jan 2020 10:29:13 +0100
Message-Id: <20200122092754.784874453@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092750.976732974@linuxfoundation.org>
References: <20200122092750.976732974@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>

commit 6d9e8c651dd979aa666bee15f086745f3ea9c4b3 upstream.

Patch series "use div64_ul() instead of div_u64() if the divisor is
unsigned long".

We were first inspired by commit b0ab99e7736a ("sched: Fix possible divide
by zero in avg_atom () calculation"), then refer to the recently analyzed
mm code, we found this suspicious place.

 201                 if (min) {
 202                         min *= this_bw;
 203                         do_div(min, tot_bw);
 204                 }

And we also disassembled and confirmed it:

  /usr/src/debug/kernel-4.9.168-016.ali3000/linux-4.9.168-016.ali3000.alios7.x86_64/mm/page-writeback.c: 201
  0xffffffff811c37da <__wb_calc_thresh+234>:      xor    %r10d,%r10d
  0xffffffff811c37dd <__wb_calc_thresh+237>:      test   %rax,%rax
  0xffffffff811c37e0 <__wb_calc_thresh+240>:      je 0xffffffff811c3800 <__wb_calc_thresh+272>
  /usr/src/debug/kernel-4.9.168-016.ali3000/linux-4.9.168-016.ali3000.alios7.x86_64/mm/page-writeback.c: 202
  0xffffffff811c37e2 <__wb_calc_thresh+242>:      imul   %r8,%rax
  /usr/src/debug/kernel-4.9.168-016.ali3000/linux-4.9.168-016.ali3000.alios7.x86_64/mm/page-writeback.c: 203
  0xffffffff811c37e6 <__wb_calc_thresh+246>:      mov    %r9d,%r10d    ---> truncates it to 32 bits here
  0xffffffff811c37e9 <__wb_calc_thresh+249>:      xor    %edx,%edx
  0xffffffff811c37eb <__wb_calc_thresh+251>:      div    %r10
  0xffffffff811c37ee <__wb_calc_thresh+254>:      imul   %rbx,%rax
  0xffffffff811c37f2 <__wb_calc_thresh+258>:      shr    $0x2,%rax
  0xffffffff811c37f6 <__wb_calc_thresh+262>:      mul    %rcx
  0xffffffff811c37f9 <__wb_calc_thresh+265>:      shr    $0x2,%rdx
  0xffffffff811c37fd <__wb_calc_thresh+269>:      mov    %rdx,%r10

This series uses div64_ul() instead of div_u64() if the divisor is
unsigned long, to avoid truncation to 32-bit on 64-bit platforms.

This patch (of 3):

The variables 'min' and 'max' are unsigned long and do_div truncates
them to 32 bits, which means it can test non-zero and be truncated to
zero for division.  Fix this issue by using div64_ul() instead.

Link: http://lkml.kernel.org/r/20200102081442.8273-2-wenyang@linux.alibaba.com
Fixes: 693108a8a667 ("writeback: make bdi->min/max_ratio handling cgroup writeback aware")
Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/page-writeback.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -201,11 +201,11 @@ static void wb_min_max_ratio(struct bdi_
 	if (this_bw < tot_bw) {
 		if (min) {
 			min *= this_bw;
-			do_div(min, tot_bw);
+			min = div64_ul(min, tot_bw);
 		}
 		if (max < 100) {
 			max *= this_bw;
-			do_div(max, tot_bw);
+			max = div64_ul(max, tot_bw);
 		}
 	}
 


