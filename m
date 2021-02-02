Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF28730BFDB
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:43:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231962AbhBBNn5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:43:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232661AbhBBNk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:40:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EFEF64F5F;
        Tue,  2 Feb 2021 13:39:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273189;
        bh=yPb8DO6ChUmx2eSgUraMKtt1Bbk4tuqYUv5KZIIUEws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XRn6HkOifLVaErlnHI3Jfzw+vXv7EB5xh6WjkJYiOwK5nQGhFVotg49qHmY5QbYEu
         9p3M6P63IS4sWx6h0k229X+UZcinyWsGk8h4wby14uGKN0C9tfIGzWgQZuowcomY0I
         O6gXX0x8m8WR/VGA04/fdYF8g/dosOUGLiFcyLS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pingfan Liu <kernelfans@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.10 006/142] kernel: kexec: remove the lock operation of system_transition_mutex
Date:   Tue,  2 Feb 2021 14:36:09 +0100
Message-Id: <20210202132957.958567172@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Baoquan He <bhe@redhat.com>

commit 56c91a18432b631ca18438841fd1831ef756cabf upstream.

Function kernel_kexec() is called with lock system_transition_mutex
held in reboot system call. While inside kernel_kexec(), it will
acquire system_transition_mutex agin. This will lead to dead lock.

The dead lock should be easily triggered, it hasn't caused any
failure report just because the feature 'kexec jump' is almost not
used by anyone as far as I know. An inquiry can be made about who
is using 'kexec jump' and where it's used. Before that, let's simply
remove the lock operation inside CONFIG_KEXEC_JUMP ifdeffery scope.

Fixes: 55f2503c3b69 ("PM / reboot: Eliminate race between reboot and suspend")
Signed-off-by: Baoquan He <bhe@redhat.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Pingfan Liu <kernelfans@gmail.com>
Cc: 4.19+ <stable@vger.kernel.org> # 4.19+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/kexec_core.c |    2 --
 1 file changed, 2 deletions(-)

--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1135,7 +1135,6 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-		lock_system_sleep();
 		pm_prepare_console();
 		error = freeze_processes();
 		if (error) {
@@ -1198,7 +1197,6 @@ int kernel_kexec(void)
 		thaw_processes();
  Restore_console:
 		pm_restore_console();
-		unlock_system_sleep();
 	}
 #endif
 


