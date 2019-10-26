Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78AF2E5B91
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbfJZNYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729844AbfJZNXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:23:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCBC021D7F;
        Sat, 26 Oct 2019 13:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572096209;
        bh=RZgYwf4dW4DVYCcsg1CIb7anwqRWL1dPYJyucHUDUEc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T6SsebHH8cDRuPEAv02GZa1HdshS+UtwMoAqUglrqEhETh73cX20WkN+pQhW+hfFS
         RYRSipeiTKNVQEF6ADblghFyrvcP1SVQpTOTfr0Oh7DvZfNKS8bpx5wdMkajf5pmt2
         83PlBGjfD4fIuK2M553JfwQT6emq/FbdcLJ/Gg6E=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-xtensa@linux-xtensa.org
Subject: [PATCH AUTOSEL 4.4 12/17] xtensa: fix {get,put}_user() for 64bit values
Date:   Sat, 26 Oct 2019 09:22:56 -0400
Message-Id: <20191026132302.4622-12-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026132302.4622-1-sashal@kernel.org>
References: <20191026132302.4622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 6595d144decec396bf2e2efee27e50634a4b627f ]

First of all, on short copies __copy_{to,from}_user() return the amount
of bytes left uncopied, *not* -EFAULT.  get_user() and put_user() are
expected to return -EFAULT on failure.

Another problem is get_user(v32, (__u64 __user *)p); that should
fetch 64bit value and the assign it to v32, truncating it in process.
Current code, OTOH, reads 8 bytes of data and stores them at the
address of v32, stomping on the 4 bytes that follow v32 itself.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Max Filippov <jcmvbkbc@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/xtensa/include/asm/uaccess.h | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/arch/xtensa/include/asm/uaccess.h b/arch/xtensa/include/asm/uaccess.h
index 147b26ed9c91f..42133985a19a1 100644
--- a/arch/xtensa/include/asm/uaccess.h
+++ b/arch/xtensa/include/asm/uaccess.h
@@ -245,7 +245,7 @@ do {									\
 	case 4: __put_user_asm(x, ptr, retval, 4, "s32i", __cb); break;	\
 	case 8: {							\
 		     __typeof__(*ptr) __v64 = x;			\
-		     retval = __copy_to_user(ptr, &__v64, 8);		\
+		     retval = __copy_to_user(ptr, &__v64, 8) ? -EFAULT : 0;	\
 		     break;						\
 	        }							\
 	default: __put_user_bad();					\
@@ -344,7 +344,16 @@ do {									\
 	case 1: __get_user_asm(x, ptr, retval, 1, "l8ui", __cb);  break;\
 	case 2: __get_user_asm(x, ptr, retval, 2, "l16ui", __cb); break;\
 	case 4: __get_user_asm(x, ptr, retval, 4, "l32i", __cb);  break;\
-	case 8: retval = __copy_from_user(&x, ptr, 8);    break;	\
+	case 8: {							\
+		u64 __x;						\
+		if (unlikely(__copy_from_user(&__x, ptr, 8))) {		\
+			retval = -EFAULT;				\
+			(x) = 0;					\
+		} else {						\
+			(x) = *(__force __typeof__((ptr)))&__x;		\
+		}							\
+		break;							\
+	}								\
 	default: (x) = __get_user_bad();				\
 	}								\
 } while (0)
-- 
2.20.1

