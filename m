Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6E61ACB04
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:43:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442486AbgDPPnD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:43:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:48114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895932AbgDPNgB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:36:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8007A21BE5;
        Thu, 16 Apr 2020 13:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044161;
        bh=f5G/PgNlQLorwMRYwCChGgzk+9oz/wHoIFMd326/k2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=js2SSNIV20iKLaH6M9eTzDrBCPIcJZwNZLHqRwTj/sYWgUFH9T0W+STZtk5e4lZ74
         Sjc1v6OTGH68ipjnaD3c1P1jvCzbkJ1TaGuUF6aZ4NnsZhg4ubo6Y0ZcllgNEvLNa7
         1l81gdj0zQ1L+el4wTkdy+OYkvfZYfUeihuSyIy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.5 104/257] seccomp: Add missing compat_ioctl for notify
Date:   Thu, 16 Apr 2020 15:22:35 +0200
Message-Id: <20200416131339.134491351@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Schnelle <svens@linux.ibm.com>

commit 3db81afd99494a33f1c3839103f0429c8f30cb9d upstream.

Executing the seccomp_bpf testsuite under a 64-bit kernel with 32-bit
userland (both s390 and x86) doesn't work because there's no compat_ioctl
handler defined. Add the handler.

Signed-off-by: Sven Schnelle <svens@linux.ibm.com>
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20200310123332.42255-1-svens@linux.ibm.com
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/seccomp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1221,6 +1221,7 @@ static const struct file_operations secc
 	.poll = seccomp_notify_poll,
 	.release = seccomp_notify_release,
 	.unlocked_ioctl = seccomp_notify_ioctl,
+	.compat_ioctl = seccomp_notify_ioctl,
 };
 
 static struct file *init_listener(struct seccomp_filter *filter)


