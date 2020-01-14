Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC17A13AAF9
	for <lists+stable@lfdr.de>; Tue, 14 Jan 2020 14:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726453AbgANN1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jan 2020 08:27:14 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:53329 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbgANN1O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jan 2020 08:27:14 -0500
Received: from threadripper.lan ([149.172.19.189]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.145]) with ESMTPA (Nemesis) id
 1N2mS2-1jnUi72fDo-0139pi; Tue, 14 Jan 2020 14:26:59 +0100
From:   Arnd Bergmann <arnd@arndb.de>
To:     "David S. Miller" <davem@davemloft.net>,
        Sam Ravnborg <sam@ravnborg.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Rich Felker <dalias@libc.org>, libc-alpha@sourceware.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] sparc32: fix struct ipc64_perm type definition
Date:   Tue, 14 Jan 2020 14:26:14 +0100
Message-Id: <20200114132633.3694261-1-arnd@arndb.de>
X-Mailer: git-send-email 2.20.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:DM0uz4nPPp4jUgO+yEl0v/MrWqjzx2Rp+eofrZT3+3zAthy+ydz
 QSO2+u4V7klg2IcLv4t4yjuSyVrBjGQBVGoD1cXq8nWNIx6n2u5WnYxRUDZLY6GsKk5Ab6A
 7UyFygze4/I1fVwPPO6PFNC+qKCz9nh6MuG9DRmSf5kSoSz3EK1+hfiTB1t7c3PvXI9UaIY
 CEW6heDh8oejelRASyLfA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DkWAj92lmQg=:OftWo0gr1NF8IyXuls1x2e
 qmZPERCuY3Ytd6XWAXtx26zynKyU9RaTIfTJS4m6ZliS1RIXpNMANGyR65iJGYPF5QqQojX/U
 vW4SEI9g0Kk07aay1VlIRG4wv3vbqkOAYaK+M+oA6L7jbS4gmfd+k9n3PG9E7t3+Gf/8sapza
 Qm+XJa3mTWMKFG2xCQNdreBHokDkmCaeYoO4DOfuSctJ+ataSH8creZBmRObCr6w/MyVE32me
 bloS1HSooVfYur5UwwpX4/u2D9d6pxCPKwcEN+iELycpP3HpLpbdohx+biaTubrWi2m3HAicA
 UaiDyXMM+dhWx80FUhuSXqeTNxjOzNNRm1mKBYyAMxmC7HIAcpG5qGaXNpWf2dq5Sk+3MKYKg
 L/EX373pa2mYOUquAQ4WiQjvBy3MOghuClB3gjzni+zl4eoxogiLrGp7+QYza7SAHHwe0HcvW
 6GdP2mgKJhj1FRwuA2pj01L7HCBpjhwVxVgRXqBg5rXWhzR6FwS2MZANzMcQCRd2LbUzZvPdR
 xe7RQkuOOumhVuRiPHQgMsuLA7y/9L1kr+TPtGF1JKl88s4LIP2sqzqnpEV8n0FrFRYnVbqA8
 CJ21aW8CD094vF47iRI+WPb2QxVPoCJgs/rNs9wKijvoxPKYRuGqz3sMaUHyD4tJ+O6dGU4Dk
 Mv4IsqiI5rLPxCKLAQPKKS6peJsx1NAkM8fiWGdgFBf8OqcXY3EP5RoZhOLCyC6zHbZGSK8Hp
 gNS4QbQ1dsRpAiDXhbp5rthkXc+5GYVZki7CexeR0apdrwMWlKO3oWAjAMcVdnRhe/5LQF/Bf
 O31CtvwqLuwVmSgC27q617uJ35kPx4nB1JsOCUniOK5K0ieIv3VC5oJ/VfWbTl7BLBg5TFmGC
 y17/ah14Qj3FGJy0AGyA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As discussed in the strace issue tracker, it appears that the sparc32
sysvipc support has been broken for the past 11 years. It was however
working in compat mode, which is how it must have escaped most of the
regular testing.

The problem is that a cleanup patch inadvertently changed the uid/gid
fields in struct ipc64_perm from 32-bit types to 16-bit types in uapi
headers.

Both glibc and uclibc-ng still use the original types, so they should
work fine with compat mode, but not natively.  Change the definitions
to use __kernel_uid32_t and __kernel_gid32_t again.

Fixes: 83c86984bff2 ("sparc: unify ipcbuf.h")
Link: https://github.com/strace/strace/issues/116
Cc: <stable@vger.kernel.org> # v2.6.29
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: "Dmitry V . Levin" <ldv@altlinux.org>
Cc: Rich Felker <dalias@libc.org>
Cc: libc-alpha@sourceware.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/sparc/include/uapi/asm/ipcbuf.h | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/arch/sparc/include/uapi/asm/ipcbuf.h b/arch/sparc/include/uapi/asm/ipcbuf.h
index 5b933a598a33..0ea1240d2ea1 100644
--- a/arch/sparc/include/uapi/asm/ipcbuf.h
+++ b/arch/sparc/include/uapi/asm/ipcbuf.h
@@ -17,19 +17,19 @@
 
 struct ipc64_perm
 {
-	__kernel_key_t	key;
-	__kernel_uid_t	uid;
-	__kernel_gid_t	gid;
-	__kernel_uid_t	cuid;
-	__kernel_gid_t	cgid;
+	__kernel_key_t		key;
+	__kernel_uid32_t	uid;
+	__kernel_gid32_t	gid;
+	__kernel_uid32_t	cuid;
+	__kernel_gid32_t	cgid;
 #ifndef __arch64__
-	unsigned short	__pad0;
+	unsigned short		__pad0;
 #endif
-	__kernel_mode_t	mode;
-	unsigned short	__pad1;
-	unsigned short	seq;
-	unsigned long long __unused1;
-	unsigned long long __unused2;
+	__kernel_mode_t		mode;
+	unsigned short		__pad1;
+	unsigned short		seq;
+	unsigned long long	__unused1;
+	unsigned long long	__unused2;
 };
 
 #endif /* __SPARC_IPCBUF_H */
-- 
2.20.0

