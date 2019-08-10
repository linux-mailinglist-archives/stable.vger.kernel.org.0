Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9CAE88E51
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727255AbfHJUxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:53:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53826 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726492AbfHJUnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:49 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDJ-00053A-7c; Sat, 10 Aug 2019 21:43:45 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003YX-Oe; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jakub Drnec" <jaydee@email.cz>,
        "Michael Ellerman" <mpe@ellerman.id.au>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.615870754@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 014/157] powerpc/vdso64: Fix CLOCK_MONOTONIC
 inconsistencies across Y2038
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <mpe@ellerman.id.au>

commit b5b4453e7912f056da1ca7572574cada32ecb60c upstream.

Jakub Drnec reported:
  Setting the realtime clock can sometimes make the monotonic clock go
  back by over a hundred years. Decreasing the realtime clock across
  the y2k38 threshold is one reliable way to reproduce. Allegedly this
  can also happen just by running ntpd, I have not managed to
  reproduce that other than booting with rtc at >2038 and then running
  ntp. When this happens, anything with timers (e.g. openjdk) breaks
  rather badly.

And included a test case (slightly edited for brevity):
  #define _POSIX_C_SOURCE 199309L
  #include <stdio.h>
  #include <time.h>
  #include <stdlib.h>
  #include <unistd.h>

  long get_time(void) {
    struct timespec tp;
    clock_gettime(CLOCK_MONOTONIC, &tp);
    return tp.tv_sec + tp.tv_nsec / 1000000000;
  }

  int main(void) {
    long last = get_time();
    while(1) {
      long now = get_time();
      if (now < last) {
        printf("clock went backwards by %ld seconds!\n", last - now);
      }
      last = now;
      sleep(1);
    }
    return 0;
  }

Which when run concurrently with:
 # date -s 2040-1-1
 # date -s 2037-1-1

Will detect the clock going backward.

The root cause is that wtom_clock_sec in struct vdso_data is only a
32-bit signed value, even though we set its value to be equal to
tk->wall_to_monotonic.tv_sec which is 64-bits.

Because the monotonic clock starts at zero when the system boots the
wall_to_montonic.tv_sec offset is negative for current and future
dates. Currently on a freshly booted system the offset will be in the
vicinity of negative 1.5 billion seconds.

However if the wall clock is set past the Y2038 boundary, the offset
from wall to monotonic becomes less than negative 2^31, and no longer
fits in 32-bits. When that value is assigned to wtom_clock_sec it is
truncated and becomes positive, causing the VDSO assembly code to
calculate CLOCK_MONOTONIC incorrectly.

That causes CLOCK_MONOTONIC to jump ahead by ~4 billion seconds which
it is not meant to do. Worse, if the time is then set back before the
Y2038 boundary CLOCK_MONOTONIC will jump backward.

We can fix it simply by storing the full 64-bit offset in the
vdso_data, and using that in the VDSO assembly code. We also shuffle
some of the fields in vdso_data to avoid creating a hole.

The original commit that added the CLOCK_MONOTONIC support to the VDSO
did actually use a 64-bit value for wtom_clock_sec, see commit
a7f290dad32e ("[PATCH] powerpc: Merge vdso's and add vdso support to
32 bits kernel") (Nov 2005). However just 3 days later it was
converted to 32-bits in commit 0c37ec2aa88b ("[PATCH] powerpc: vdso
fixes (take #2)"), and the bug has existed since then AFAICS.

Fixes: 0c37ec2aa88b ("[PATCH] powerpc: vdso fixes (take #2)")
Link: http://lkml.kernel.org/r/HaC.ZfES.62bwlnvAvMP.1STMMj@seznam.cz
Reported-by: Jakub Drnec <jaydee@email.cz>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
[bwh: Backported to 3.16: CLOCK_MONOTONIC_COARSE is not handled by
 this vDSO]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/powerpc/include/asm/vdso_datapage.h  | 8 ++++----
 arch/powerpc/kernel/vdso64/gettimeofday.S | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/vdso_datapage.h
+++ b/arch/powerpc/include/asm/vdso_datapage.h
@@ -82,10 +82,10 @@ struct vdso_data {
 	__u32 icache_block_size;		/* L1 i-cache block size     */
 	__u32 dcache_log_block_size;		/* L1 d-cache log block size */
 	__u32 icache_log_block_size;		/* L1 i-cache log block size */
-	__s32 wtom_clock_sec;			/* Wall to monotonic clock */
-	__s32 wtom_clock_nsec;
-	struct timespec stamp_xtime;	/* xtime as at tb_orig_stamp */
-	__u32 stamp_sec_fraction;	/* fractional seconds of stamp_xtime */
+	__u32 stamp_sec_fraction;		/* fractional seconds of stamp_xtime */
+	__s32 wtom_clock_nsec;			/* Wall to monotonic clock nsec */
+	__s64 wtom_clock_sec;			/* Wall to monotonic clock sec */
+	struct timespec stamp_xtime;		/* xtime as at tb_orig_stamp */
    	__u32 syscall_map_64[SYSCALL_MAP_SIZE]; /* map of syscalls  */
    	__u32 syscall_map_32[SYSCALL_MAP_SIZE]; /* map of syscalls */
 };
--- a/arch/powerpc/kernel/vdso64/gettimeofday.S
+++ b/arch/powerpc/kernel/vdso64/gettimeofday.S
@@ -85,7 +85,7 @@ V_FUNCTION_BEGIN(__kernel_clock_gettime)
 	 * At this point, r4,r5 contain our sec/nsec values.
 	 */
 
-	lwa	r6,WTOM_CLOCK_SEC(r3)
+	ld	r6,WTOM_CLOCK_SEC(r3)
 	lwa	r9,WTOM_CLOCK_NSEC(r3)
 
 	/* We now have our result in r6,r9. We create a fake dependency

