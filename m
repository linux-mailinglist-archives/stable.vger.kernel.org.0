Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B69319A894
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 11:24:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgDAJYt convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 1 Apr 2020 05:24:49 -0400
Received: from esa2.mentor.iphmx.com ([68.232.141.98]:18387 "EHLO
        esa2.mentor.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726205AbgDAJYt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 05:24:49 -0400
IronPort-SDR: aCPaLfvGF6SeV6KvDIpMYHevZ4GZbJU+OtIjVLRIrROAVHM4XBO+9ynnhzS5Py1HDKeuFPB5p2
 rU9V0vUIvAC+Ev44zArSmQoz5VpKXX2INuslGf4Xcm3Re5Te7uoHbHL46sPOlcQFKhl2/THVDU
 askkJX/NYpFtnQG4953fdPqYe+inqVGLfupiIWegyDOFYGAxfnEWuZWopHePW75khoxI/qmmBL
 6k/NcudcYGQWgoEyN1HIZnovZzPn7mHLvIAb3afnQqT34z6uB4Uv4cRL0gMwREfaocQio744xl
 w2s=
X-IronPort-AV: E=Sophos;i="5.72,331,1580803200"; 
   d="scan'208,223";a="47245895"
Received: from orw-gwy-01-in.mentorg.com ([192.94.38.165])
  by esa2.mentor.iphmx.com with ESMTP; 01 Apr 2020 01:24:47 -0800
IronPort-SDR: S8ikznCiKmFZprasLyTUnZKYYF6YBl5N2N71MVIPSknTCaSD0GeauMIaPwsxgeICww81qfGf92
 WhcN+vSCc8VTO5XDNiXNcd5lS9pdmYB+c+uiLYarMImgd2GSBq5nN1FMf8dJTp8a9QBULM4YxU
 R3jgM6Ozh1UZTQEesj05SorKMpMO4oCNRjtdrPoZgwBldiUqP8yB0LI1FqFmpeN6qSLw7FgbB0
 dLQpA3ORQSY7aNUzPdTBjGfYjUl32nbM1MHPGut0de+C5HE6nB9pyjFph9X9Cb/iEvf7YvG3Un
 pvo=
From:   "Schmid, Carsten" <Carsten_Schmid@mentor.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        "sashal@kernel.org" <sashal@kernel.org>
CC:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: [PATCH Backport to stable/linux-4.14.y] make 'user_access_begin()' do
 'access_ok()'
Thread-Topic: [PATCH Backport to stable/linux-4.14.y] make
 'user_access_begin()' do 'access_ok()'
Thread-Index: AQHWCAJkVCaPiBB3fEi305LG7KYcnahj/f2V
Date:   Wed, 1 Apr 2020 09:24:43 +0000
Message-ID: <1585733082992.99012@mentor.com>
References: <8a297704c58b4b4e867efecb08214040@SVR-IES-MBX-03.mgc.mentorg.com>
In-Reply-To: <8a297704c58b4b4e867efecb08214040@SVR-IES-MBX-03.mgc.mentorg.com>
Accept-Language: de-DE, en-IE, en-US
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [137.202.0.90]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From eb5a13ddc30824c20f1e2b662d2c821ad3808526 Mon Sep 17 00:00:00 2001
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 4 Jan 2019 12:56:09 -0800
Subject: [PATCH] make 'user_access_begin()' do 'access_ok()'

[ Upstream commit 594cc251fdd0d231d342d88b2fdff4bc42fb0690 ]

Fixes CVE-2018-20669
Backported from v5.0-rc1
Patch 1/1

Originally, the rule used to be that you'd have to do access_ok()
separately, and then user_access_begin() before actually doing the
direct (optimized) user access.

But experience has shown that people then decide not to do access_ok()
at all, and instead rely on it being implied by other operations or
similar.  Which makes it very hard to verify that the access has
actually been range-checked.

If you use the unsafe direct user accesses, hardware features (either
SMAP - Supervisor Mode Access Protection - on x86, or PAN - Privileged
Access Never - on ARM) do force you to use user_access_begin().  But
nothing really forces the range check.

By putting the range check into user_access_begin(), we actually force
people to do the right thing (tm), and the range check vill be visible
near the actual accesses.  We have way too long a history of people
trying to avoid them.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
Rationale:
When working on stability and security for a project with 4.14 kernel,
i backported patches from upstream.
Want to give this work back to the community, as 4.14 is a SLTS.
---
 arch/x86/include/asm/uaccess.h             |  9 ++++++++-
 drivers/gpu/drm/i915/i915_gem_execbuffer.c | 15 +++++++++++++--
 include/linux/uaccess.h                    |  2 +-
 kernel/compat.c                            |  6 ++----
 kernel/exit.c                              |  6 ++----
 lib/strncpy_from_user.c                    |  9 +++++----
 lib/strnlen_user.c                         |  9 +++++----
 7 files changed, 36 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 971830341061..fd00c5fba059 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -711,7 +711,14 @@ extern struct movsl_mask {
  * checking before using them, but you have to surround them with the
  * user_access_begin/end() pair.
  */
-#define user_access_begin()    __uaccess_begin()
+static __must_check inline bool user_access_begin(const void __user *ptr, size_t len)
+{
+       if (unlikely(!access_ok(VERIFY_READ,ptr,len)))
+               return 0;
+       __uaccess_begin();
+       return 1;
+}
+#define user_access_begin(a,b) user_access_begin(a,b)
 #define user_access_end()       __uaccess_end()

 #define unsafe_put_user(x, ptr, err_label)                                      \
diff --git a/drivers/gpu/drm/i915/i915_gem_execbuffer.c b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
index d99d05a91032..3a65a45184ad 100644
--- a/drivers/gpu/drm/i915/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/i915_gem_execbuffer.c
@@ -1566,7 +1566,9 @@ static int eb_copy_relocations(const struct i915_execbuffer *eb)
                  * happened we would make the mistake of assuming that the
                  * relocations were valid.
                  */
-               user_access_begin();
+               if (!user_access_begin(urelocs, size))
+                       goto end_user;
+
                 for (copied = 0; copied < nreloc; copied++)
                         unsafe_put_user(-1,
                                         &urelocs[copied].presumed_offset,
@@ -2649,7 +2651,16 @@ i915_gem_execbuffer2(struct drm_device *dev, void *data,
                 unsigned int i;

                 /* Copy the new buffer offsets back to the user's exec list. */
-               user_access_begin();
+               /*
+                * Note: args->buffer_count * sizeof(*user_exec_list) does not overflow,
+                * because we checked this on entry.
+                *
+                * And this range already got effectively checked earlier
+                * when we did the "copy_from_user()" above.
+                */
+               if (!user_access_begin(user_exec_list, args->buffer_count * sizeof(*user_exec_list)))
+                       goto end_user;
+
                 for (i = 0; i < args->buffer_count; i++) {
                         if (!(exec2_list[i].offset & UPDATE))
                                 continue;
diff --git a/include/linux/uaccess.h b/include/linux/uaccess.h
index 251e655d407f..76407748701b 100644
--- a/include/linux/uaccess.h
+++ b/include/linux/uaccess.h
@@ -267,7 +267,7 @@ extern long strncpy_from_unsafe(char *dst, const void *unsafe_addr, long count);
         probe_kernel_read(&retval, addr, sizeof(retval))

 #ifndef user_access_begin
-#define user_access_begin() do { } while (0)
+#define user_access_begin(ptr,len) access_ok(ptr, len)
 #define user_access_end() do { } while (0)
 #define unsafe_get_user(x, ptr, err) do { if (unlikely(__get_user(x, ptr))) goto err; } while (0)
 #define unsafe_put_user(x, ptr, err) do { if (unlikely(__put_user(x, ptr))) goto err; } while (0)
diff --git a/kernel/compat.c b/kernel/compat.c
index 7e83733d4c95..a9f5de63dc90 100644
--- a/kernel/compat.c
+++ b/kernel/compat.c
@@ -437,10 +437,9 @@ long compat_get_bitmap(unsigned long *mask, const compat_ulong_t __user *umask,
         bitmap_size = ALIGN(bitmap_size, BITS_PER_COMPAT_LONG);
         nr_compat_longs = BITS_TO_COMPAT_LONGS(bitmap_size);

-       if (!access_ok(VERIFY_READ, umask, bitmap_size / 8))
+       if (!user_access_begin(umask, bitmap_size / 8))
                 return -EFAULT;

-       user_access_begin();
         while (nr_compat_longs > 1) {
                 compat_ulong_t l1, l2;
                 unsafe_get_user(l1, umask++, Efault);
@@ -467,10 +466,9 @@ long compat_put_bitmap(compat_ulong_t __user *umask, unsigned long *mask,
         bitmap_size = ALIGN(bitmap_size, BITS_PER_COMPAT_LONG);
         nr_compat_longs = BITS_TO_COMPAT_LONGS(bitmap_size);

-       if (!access_ok(VERIFY_WRITE, umask, bitmap_size / 8))
+       if (!user_access_begin(umask, bitmap_size / 8))
                 return -EFAULT;

-       user_access_begin();
         while (nr_compat_longs > 1) {
                 unsigned long m = *mask++;
                 unsafe_put_user((compat_ulong_t)m, umask++, Efault);
diff --git a/kernel/exit.c b/kernel/exit.c
index d1baf9c96c3e..c3ad546ba7c2 100644
--- a/kernel/exit.c
+++ b/kernel/exit.c
@@ -1597,10 +1597,9 @@ SYSCALL_DEFINE5(waitid, int, which, pid_t, upid, struct siginfo __user *,
         if (!infop)
                 return err;

-       if (!access_ok(VERIFY_WRITE, infop, sizeof(*infop)))
+       if (!user_access_begin(infop, sizeof(*infop)))
                 return -EFAULT;

-       user_access_begin();
         unsafe_put_user(signo, &infop->si_signo, Efault);
         unsafe_put_user(0, &infop->si_errno, Efault);
         unsafe_put_user(info.cause, &infop->si_code, Efault);
@@ -1725,10 +1724,9 @@ COMPAT_SYSCALL_DEFINE5(waitid,
         if (!infop)
                 return err;

-       if (!access_ok(VERIFY_WRITE, infop, sizeof(*infop)))
+       if (!user_access_begin(infop, sizeof(*infop)))
                 return -EFAULT;

-       user_access_begin();
         unsafe_put_user(signo, &infop->si_signo, Efault);
         unsafe_put_user(0, &infop->si_errno, Efault);
         unsafe_put_user(info.cause, &infop->si_code, Efault);
diff --git a/lib/strncpy_from_user.c b/lib/strncpy_from_user.c
index e304b54c9c7d..023ba9f3b99f 100644
--- a/lib/strncpy_from_user.c
+++ b/lib/strncpy_from_user.c
@@ -115,10 +115,11 @@ long strncpy_from_user(char *dst, const char __user *src, long count)

                 kasan_check_write(dst, count);
                 check_object_size(dst, count, false);
-               user_access_begin();
-               retval = do_strncpy_from_user(dst, src, count, max);
-               user_access_end();
-               return retval;
+               if (user_access_begin(src, max)) {
+                       retval = do_strncpy_from_user(dst, src, count, max);
+                       user_access_end();
+                       return retval;
+               }
         }
         return -EFAULT;
 }
diff --git a/lib/strnlen_user.c b/lib/strnlen_user.c
index 184f80f7bacf..7f2db3fe311f 100644
--- a/lib/strnlen_user.c
+++ b/lib/strnlen_user.c
@@ -114,10 +114,11 @@ long strnlen_user(const char __user *str, long count)
                 unsigned long max = max_addr - src_addr;
                 long retval;

-               user_access_begin();
-               retval = do_strnlen_user(str, count, max);
-               user_access_end();
-               return retval;
+               if (user_access_begin(str, max)) {
+                       retval = do_strnlen_user(str, count, max);
+                       user_access_end();
+                       return retval;
+               }
         }
         return 0;
 }
--
2.17.1
-----------------
Mentor Graphics (Deutschland) GmbH, Arnulfstraße 201, 80634 München / Germany
Registergericht München HRB 106955, Geschäftsführer: Thomas Heurung, Alexander Walter
