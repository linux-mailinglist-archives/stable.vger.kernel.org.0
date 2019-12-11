Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDE2511B4D4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732140AbfLKPWG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:22:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:52628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731800AbfLKPWF (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:22:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 11FFE24688;
        Wed, 11 Dec 2019 15:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077724;
        bh=LYumfA8VqoRw4l3DO1/O2rjaQk6bmu4mjUoyxerzGL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Li/9BRFvq8okAdEFbYe/4ih9w5oRlUg2J8BZgktvY4Fo8gN6joRtoGUblfSqIHGGr
         GYOwLe1JlquA13oY1p/6FD0JD9VS1lzT8biRtv/z0ARC9GIMoROJ3NhodlkK59gKWI
         NladmmZLy5onUxE5vG0z+djo0smFkIcmgf+avZVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 145/243] tools/bpf: make libbpf _GNU_SOURCE friendly
Date:   Wed, 11 Dec 2019 16:05:07 +0100
Message-Id: <20191211150348.955070559@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

[ Upstream commit b42699547fc9fb1057795bccc21a6445743a7fde ]

During porting libbpf to bcc, I got some warnings like below:
  ...
  [  2%] Building C object src/cc/CMakeFiles/bpf-shared.dir/libbpf/src/libbpf.c.o
  /home/yhs/work/bcc2/src/cc/libbpf/src/libbpf.c:12:0:
  warning: "_GNU_SOURCE" redefined [enabled by default]
   #define _GNU_SOURCE
  ...
  [  3%] Building C object src/cc/CMakeFiles/bpf-shared.dir/libbpf/src/libbpf_errno.c.o
  /home/yhs/work/bcc2/src/cc/libbpf/src/libbpf_errno.c: In function ‘libbpf_strerror’:
  /home/yhs/work/bcc2/src/cc/libbpf/src/libbpf_errno.c:45:7:
  warning: assignment makes integer from pointer without a cast [enabled by default]
     ret = strerror_r(err, buf, size);
  ...

bcc is built with _GNU_SOURCE defined and this caused the above warning.
This patch intends to make libpf _GNU_SOURCE friendly by
  . define _GNU_SOURCE in libbpf.c unless it is not defined
  . undefine _GNU_SOURCE as non-gnu version of strerror_r is expected.

Signed-off-by: Yonghong Song <yhs@fb.com>
Acked-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c       | 2 ++
 tools/lib/bpf/libbpf_errno.c | 1 +
 2 files changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index a350f97e3a1a4..a62be78fc07b1 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -22,7 +22,9 @@
  * License along with this program; if not,  see <http://www.gnu.org/licenses>
  */
 
+#ifndef _GNU_SOURCE
 #define _GNU_SOURCE
+#endif
 #include <stdlib.h>
 #include <stdio.h>
 #include <stdarg.h>
diff --git a/tools/lib/bpf/libbpf_errno.c b/tools/lib/bpf/libbpf_errno.c
index d9ba851bd7f9f..d2d17226d9d6b 100644
--- a/tools/lib/bpf/libbpf_errno.c
+++ b/tools/lib/bpf/libbpf_errno.c
@@ -20,6 +20,7 @@
  * License along with this program; if not,  see <http://www.gnu.org/licenses>
  */
 
+#undef _GNU_SOURCE
 #include <stdio.h>
 #include <string.h>
 
-- 
2.20.1



