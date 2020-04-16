Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A84231AC723
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394766AbgDPOuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:50:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731230AbgDPN60 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:58:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E66720786;
        Thu, 16 Apr 2020 13:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045505;
        bh=uS2XvlTl56H4jcaiC9wk+rQLx8ZcbiN32EuYD9MrFuo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eewccISnGrz2dj7Nq5o/gUCenUq3VKzXbMQH/TGNCW7VUv7aaqVdMY92pRsRZ36Bt
         ckvn/CBWNDlHSvXh9FMhg+JnpTrnKE7Qv8LLAG4VqqQQvGU7j1UiYJwFNC8/N7Xy3I
         fj9hONxiJwVBiyE8seXvYPY/tb0nQJLFlchzcjns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>,
        Dmitry Safonov <dima@arista.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrei Vagin <avagin@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        stable@kernel.org
Subject: [PATCH 5.6 162/254] time/namespace: Add max_time_namespaces ucount
Date:   Thu, 16 Apr 2020 15:24:11 +0200
Message-Id: <20200416131346.861418414@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Safonov <dima@arista.com>

commit eeec26d5da8248ea4e240b8795bb4364213d3247 upstream.

Michael noticed that userns limit for number of time namespaces is missing.

Furthermore, time namespace introduced UCOUNT_TIME_NAMESPACES, but didn't
introduce an array member in user_table[]. It would make array's
initialisation OOB write, but by luck the user_table array has an excessive
empty member (all accesses to the array are limited with UCOUNT_COUNTS - so
it silently reuses the last free member.

Fixes user-visible regression: max_inotify_instances by reason of the
missing UCOUNT_ENTRY() has limited max number of namespaces instead of the
number of inotify instances.

Fixes: 769071ac9f20 ("ns: Introduce Time Namespace")
Reported-by: Michael Kerrisk (man-pages) <mtk.manpages@gmail.com>
Signed-off-by: Dmitry Safonov <dima@arista.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Andrei Vagin <avagin@gmail.com>
Acked-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: stable@kernel.org
Link: https://lkml.kernel.org/r/20200406171342.128733-1-dima@arista.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 Documentation/admin-guide/sysctl/user.rst |    6 ++++++
 kernel/ucount.c                           |    1 +
 2 files changed, 7 insertions(+)

--- a/Documentation/admin-guide/sysctl/user.rst
+++ b/Documentation/admin-guide/sysctl/user.rst
@@ -65,6 +65,12 @@ max_pid_namespaces
   The maximum number of pid namespaces that any user in the current
   user namespace may create.
 
+max_time_namespaces
+===================
+
+  The maximum number of time namespaces that any user in the current
+  user namespace may create.
+
 max_user_namespaces
 ===================
 
--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -69,6 +69,7 @@ static struct ctl_table user_table[] = {
 	UCOUNT_ENTRY("max_net_namespaces"),
 	UCOUNT_ENTRY("max_mnt_namespaces"),
 	UCOUNT_ENTRY("max_cgroup_namespaces"),
+	UCOUNT_ENTRY("max_time_namespaces"),
 #ifdef CONFIG_INOTIFY_USER
 	UCOUNT_ENTRY("max_inotify_instances"),
 	UCOUNT_ENTRY("max_inotify_watches"),


