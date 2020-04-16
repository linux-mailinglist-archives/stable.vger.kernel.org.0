Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D221AC3BF
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898706AbgDPNrr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:47:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:33790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2898701AbgDPNrm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:47:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19777208E4;
        Thu, 16 Apr 2020 13:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044862;
        bh=VPbaPb5kW02bk8XcVeA/pqUhD1EkqkrHwDEd69VA218=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGYJE5by52iHadXuOIr4laMbGGOI9+VHqqB2P9XooqcHI1fioeQfHhyTzZi6nJliX
         QQeWUWQiGdqOTmQWia25Rxmtlqys2eDGXzGSaiv9DlpkychZx/iucrckIgPYko0jd9
         /pj7Sq0pvtiuvMv1V58UwPIXnVEBLtaYr/hktxek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sven Schnelle <svens@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 091/232] seccomp: Add missing compat_ioctl for notify
Date:   Thu, 16 Apr 2020 15:23:05 +0200
Message-Id: <20200416131326.382449312@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
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
@@ -1205,6 +1205,7 @@ static const struct file_operations secc
 	.poll = seccomp_notify_poll,
 	.release = seccomp_notify_release,
 	.unlocked_ioctl = seccomp_notify_ioctl,
+	.compat_ioctl = seccomp_notify_ioctl,
 };
 
 static struct file *init_listener(struct seccomp_filter *filter)


