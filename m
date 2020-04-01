Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 043E119B2FA
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389503AbgDAQsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:48:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390024AbgDAQrG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:47:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05C2420705;
        Wed,  1 Apr 2020 16:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759625;
        bh=HDBfyDI3oU4l6pCi6L0fG4nqaOCEBqvamVW1rdWlQQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kbeDJkFl8auA/6XUm4fa6nGsOSqLNOADuezHhPZfwl5krStoQtR2kngJ1UR+QgLBy
         FXMMluXD+/md92+2st1LfUPrrMwMewBYsmgrIaz/uL2cyP3xSykL8ovK4SJaoK6QZu
         jzvsnyFcqbb3flzxC8Rb5GF/gI4rpO96IrghB8bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        John Stultz <john.stultz@linaro.org>,
        Alexander Potapenko <glider@google.com>,
        Alistair Delva <adelva@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>
Subject: [PATCH 4.14 139/148] bpf: Explicitly memset the bpf_attr structure
Date:   Wed,  1 Apr 2020 18:18:51 +0200
Message-Id: <20200401161605.547925593@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 8096f229421f7b22433775e928d506f0342e5907 upstream.

For the bpf syscall, we are relying on the compiler to properly zero out
the bpf_attr union that we copy userspace data into. Unfortunately that
doesn't always work properly, padding and other oddities might not be
correctly zeroed, and in some tests odd things have been found when the
stack is pre-initialized to other values.

Fix this by explicitly memsetting the structure to 0 before using it.

Reported-by: Maciej Żenczykowski <maze@google.com>
Reported-by: John Stultz <john.stultz@linaro.org>
Reported-by: Alexander Potapenko <glider@google.com>
Reported-by: Alistair Delva <adelva@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://android-review.googlesource.com/c/kernel/common/+/1235490
Link: https://lore.kernel.org/bpf/20200320094813.GA421650@kroah.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/bpf/syscall.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1474,7 +1474,7 @@ static int bpf_obj_get_info_by_fd(const
 
 SYSCALL_DEFINE3(bpf, int, cmd, union bpf_attr __user *, uattr, unsigned int, size)
 {
-	union bpf_attr attr = {};
+	union bpf_attr attr;
 	int err;
 
 	if (sysctl_unprivileged_bpf_disabled && !capable(CAP_SYS_ADMIN))
@@ -1486,6 +1486,7 @@ SYSCALL_DEFINE3(bpf, int, cmd, union bpf
 	size = min_t(u32, size, sizeof(attr));
 
 	/* copy attributes from user space, may be less than sizeof(bpf_attr) */
+	memset(&attr, 0, sizeof(attr));
 	if (copy_from_user(&attr, uattr, size) != 0)
 		return -EFAULT;
 


