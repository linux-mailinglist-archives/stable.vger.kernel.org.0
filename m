Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9985939FFCB
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:35:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233302AbhFHSgh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:36:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:57090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234546AbhFHSen (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:34:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 263F161376;
        Tue,  8 Jun 2021 18:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177116;
        bh=GzbMRsUzb729PgDmzp73frCqNVg0mWy6WDCmh0rqdYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jukmADJ4o2/n4D+YoFrK11jc2Q9E77dmn8Aravoc5qX0UP6CN9wYPeVb4Hzvs73Dt
         I1XsJa1+f3eXaTdkqu/k3MoPMrkv5xWthyMpJBKTNge7py+sr4DRu51YTlPpw3lWfc
         qSXAYgxr4MemyLVYV6knmv+HuEFpr9ANN2eQY62w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel test robot <xiaolong.ye@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 4.14 38/47] selftests/bpf: fix test_align
Date:   Tue,  8 Jun 2021 20:27:21 +0200
Message-Id: <20210608175931.727183559@linuxfoundation.org>
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

From: Alexei Starovoitov <ast@fb.com>

commit 2b36047e7889b7efee22c11e17f035f721855731 upstream.

since commit 82abbf8d2fc4 the verifier rejects the bit-wise
arithmetic on pointers earlier.
The test 'dubious pointer arithmetic' now has less output to match on.
Adjust it.

Fixes: 82abbf8d2fc4 ("bpf: do not allow root to mangle valid pointers")
Reported-by: kernel test robot <xiaolong.ye@intel.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/test_align.c |   22 +---------------------
 1 file changed, 1 insertion(+), 21 deletions(-)

--- a/tools/testing/selftests/bpf/test_align.c
+++ b/tools/testing/selftests/bpf/test_align.c
@@ -474,27 +474,7 @@ static struct bpf_align_test tests[] = {
 		.result = REJECT,
 		.matches = {
 			{4, "R5=pkt(id=0,off=0,r=0,imm=0)"},
-			/* ptr & 0x40 == either 0 or 0x40 */
-			{5, "R5=inv(id=0,umax_value=64,var_off=(0x0; 0x40))"},
-			/* ptr << 2 == unknown, (4n) */
-			{7, "R5=inv(id=0,smax_value=9223372036854775804,umax_value=18446744073709551612,var_off=(0x0; 0xfffffffffffffffc))"},
-			/* (4n) + 14 == (4n+2).  We blow our bounds, because
-			 * the add could overflow.
-			 */
-			{8, "R5=inv(id=0,var_off=(0x2; 0xfffffffffffffffc))"},
-			/* Checked s>=0 */
-			{10, "R5=inv(id=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			/* packet pointer + nonnegative (4n+2) */
-			{12, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			{14, "R4=pkt(id=1,off=4,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
-			/* NET_IP_ALIGN + (4n+2) == (4n), alignment is fine.
-			 * We checked the bounds, but it might have been able
-			 * to overflow if the packet pointer started in the
-			 * upper half of the address space.
-			 * So we did not get a 'range' on R6, and the access
-			 * attempt will fail.
-			 */
-			{16, "R6=pkt(id=1,off=0,r=0,umin_value=2,umax_value=9223372036854775806,var_off=(0x2; 0x7ffffffffffffffc))"},
+			/* R5 bitwise operator &= on pointer prohibited */
 		}
 	},
 	{


