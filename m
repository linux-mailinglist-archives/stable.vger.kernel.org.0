Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F00D157C7E
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 14:37:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727888AbgBJNh4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 08:37:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:50990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbgBJMe6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:34:58 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03AC92085B;
        Mon, 10 Feb 2020 12:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338097;
        bh=AQQYmQMpY/SeDz5/CsK3sUYLrw9DbtZY/6lH9zEyOU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTyGjSNrxFUsacglNo/fJ2r6k2Pz/XwusT2OX4pBTD+9hGWElitzoZ2Qj/HIB/u3i
         uwXkj+WRnu2h6pXRA9ymj8n1ZlCrQF6XQt+/ZJqERa0U+pCQMTae3oAY6qu1T7isXG
         EfUWq46XGLk59UI8R4mgZGSHwcE57t8zuDJ+oOHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        "Dmitry V . Levin" <ldv@altlinux.org>,
        Rich Felker <dalias@libc.org>, libc-alpha@sourceware.org,
        Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 010/195] sparc32: fix struct ipc64_perm type definition
Date:   Mon, 10 Feb 2020 04:31:08 -0800
Message-Id: <20200210122306.779089932@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122305.731206734@linuxfoundation.org>
References: <20200210122305.731206734@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 34ca70ef7d3a9fa7e89151597db5e37ae1d429b4 ]

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
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/sparc/include/uapi/asm/ipcbuf.h |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/arch/sparc/include/uapi/asm/ipcbuf.h
+++ b/arch/sparc/include/uapi/asm/ipcbuf.h
@@ -15,19 +15,19 @@
 
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


