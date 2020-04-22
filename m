Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3D41B3BE9
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgDVKAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:00:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:47352 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726487AbgDVKAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:00:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7BD62077D;
        Wed, 22 Apr 2020 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549614;
        bh=wRvSAt//1Dl7jXusj8IViGumHNtyt3coDpWgMy+UbOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gxwCDm2Va/bC/GJ2GTXgvBX3vcdC2gCakg1uS+rPk8qy/8LD4QFQamVZ0RPReDJ5N
         FfJA2VTB/SlurIFbrZ35hDw+Jl0Yd+TWAMj8XaSPdz1tSLqyhl1hWQ1RbIbPMAI22/
         +Wl/33VQVUeX1urYB59SVqvg/eR8XSr20ZLL28UE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Slaby <jslaby@suse.cz>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Darren Hart <dvhart@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.4 035/100] futex: futex_wake_op, do not fail on invalid op
Date:   Wed, 22 Apr 2020 11:56:05 +0200
Message-Id: <20200422095028.981138893@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby <jslaby@suse.cz>

commit e78c38f6bdd900b2ad9ac9df8eff58b745dc5b3c upstream.

In commit 30d6e0a4190d ("futex: Remove duplicated code and fix undefined
behaviour"), I let FUTEX_WAKE_OP to fail on invalid op.  Namely when op
should be considered as shift and the shift is out of range (< 0 or > 31).

But strace's test suite does this madness:

  futex(0x7fabd78bcffc, 0x5, 0xfacefeed, 0xb, 0x7fabd78bcffc, 0xa0caffee);
  futex(0x7fabd78bcffc, 0x5, 0xfacefeed, 0xb, 0x7fabd78bcffc, 0xbadfaced);
  futex(0x7fabd78bcffc, 0x5, 0xfacefeed, 0xb, 0x7fabd78bcffc, 0xffffffff);

When I pick the first 0xa0caffee, it decodes as:

  0x80000000 & 0xa0caffee: oparg is shift
  0x70000000 & 0xa0caffee: op is FUTEX_OP_OR
  0x0f000000 & 0xa0caffee: cmp is FUTEX_OP_CMP_EQ
  0x00fff000 & 0xa0caffee: oparg is sign-extended 0xcaf = -849
  0x00000fff & 0xa0caffee: cmparg is sign-extended 0xfee = -18

That means the op tries to do this:

  (futex |= (1 << (-849))) == -18

which is completely bogus. The new check of op in the code is:

        if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28)) {
                if (oparg < 0 || oparg > 31)
                        return -EINVAL;
                oparg = 1 << oparg;
        }

which results obviously in the "Invalid argument" errno:

  FAIL: futex
  ===========

  futex(0x7fabd78bcffc, 0x5, 0xfacefeed, 0xb, 0x7fabd78bcffc, 0xa0caffee) = -1: Invalid argument
  futex.test: failed test: ../futex failed with code 1

So let us soften the failure to print only a (ratelimited) message, crop
the value and continue as if it were right.  When userspace keeps up, we
can switch this to return -EINVAL again.

[v2] Do not return 0 immediatelly, proceed with the cropped value.

Fixes: 30d6e0a4190d ("futex: Remove duplicated code and fix undefined behaviour")
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Darren Hart <dvhart@infradead.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/futex.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -1479,8 +1479,16 @@ static int futex_atomic_op_inuser(unsign
 	int oldval, ret;
 
 	if (encoded_op & (FUTEX_OP_OPARG_SHIFT << 28)) {
-		if (oparg < 0 || oparg > 31)
-			return -EINVAL;
+		if (oparg < 0 || oparg > 31) {
+			char comm[sizeof(current->comm)];
+			/*
+			 * kill this print and return -EINVAL when userspace
+			 * is sane again
+			 */
+			pr_info_ratelimited("futex_wake_op: %s tries to shift op by %d; fix this program\n",
+					get_task_comm(comm, current), oparg);
+			oparg &= 31;
+		}
 		oparg = 1 << oparg;
 	}
 


