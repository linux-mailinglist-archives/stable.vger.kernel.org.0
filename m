Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923A530CB85
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBBT1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:27:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233529AbhBBN7B (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:59:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35BA964F72;
        Tue,  2 Feb 2021 13:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273581;
        bh=CaVfVYIxP1gyPkUtrnppSfw4+6q6Ngh3L0VAOaX9+Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wwCvExL2VVagj5kuXzQ22ItNyowNxSK46nSF8e4bgWO8kptYkOFIRrgpkj9Kdh9SI
         ykDZt8OS5IdCB5QgwaeEUcPLlA5VO+3ZfWudgHTT/HuCYIXbmhp8jSov1o+JGGkWIA
         TBklAVupy16hUTLIJ6cmKNG5SwOL6icUk9wshbQY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Baoquan He <bhe@redhat.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Pingfan Liu <kernelfans@gmail.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 5.4 05/61] kernel: kexec: remove the lock operation of system_transition_mutex
Date:   Tue,  2 Feb 2021 14:37:43 +0100
Message-Id: <20210202132946.706162495@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
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
@@ -1129,7 +1129,6 @@ int kernel_kexec(void)
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-		lock_system_sleep();
 		pm_prepare_console();
 		error = freeze_processes();
 		if (error) {
@@ -1192,7 +1191,6 @@ int kernel_kexec(void)
 		thaw_processes();
  Restore_console:
 		pm_restore_console();
-		unlock_system_sleep();
 	}
 #endif
 


