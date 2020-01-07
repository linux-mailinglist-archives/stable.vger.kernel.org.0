Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D26CF133471
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgAGVZn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:25:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:33042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728180AbgAGU7l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 15:59:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 36C582081E;
        Tue,  7 Jan 2020 20:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430780;
        bh=oSVw/i/5zpP39arLMUvAIPUk4ziO5aQIjG1jYWIsv74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wuauVopSBOE0aiHQCbgCgBnWjl4hudZ4eCx9fohhcyq+BlQkWum3hn7+FE/+knU6d
         /ZUMoSl8cvLSZ37bh/I32SQ6qLGWYrJl020l3ITgZIPlzfFjsx3AFps2zl7YbXoDZn
         rcDs9tuPVAhZMLAEqaRekKGxcgdShlM7yA0UWyD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Tycho Andersen <tycho@tycho.ws>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 094/191] seccomp: Check that seccomp_notif is zeroed out by the user
Date:   Tue,  7 Jan 2020 21:53:34 +0100
Message-Id: <20200107205338.024294053@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

commit 2882d53c9c6f3b8311d225062522f03772cf0179 upstream.

This patch is a small change in enforcement of the uapi for
SECCOMP_IOCTL_NOTIF_RECV ioctl. Specifically, the datastructure which
is passed (seccomp_notif) must be zeroed out. Previously any of its
members could be set to nonsense values, and we would ignore it.

This ensures all fields are set to their zero value.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Reviewed-by: Christian Brauner <christian.brauner@ubuntu.com>
Reviewed-by: Aleksa Sarai <cyphar@cyphar.com>
Acked-by: Tycho Andersen <tycho@tycho.ws>
Link: https://lore.kernel.org/r/20191229062451.9467-2-sargun@sargun.me
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/seccomp.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/kernel/seccomp.c
+++ b/kernel/seccomp.c
@@ -1015,6 +1015,13 @@ static long seccomp_notify_recv(struct s
 	struct seccomp_notif unotif;
 	ssize_t ret;
 
+	/* Verify that we're not given garbage to keep struct extensible. */
+	ret = check_zeroed_user(buf, sizeof(unotif));
+	if (ret < 0)
+		return ret;
+	if (!ret)
+		return -EINVAL;
+
 	memset(&unotif, 0, sizeof(unotif));
 
 	ret = down_interruptible(&filter->notif->request);


