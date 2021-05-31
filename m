Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C85D5395FF3
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbhEaORe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:17:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:43166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233754AbhEaOPd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:15:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 23B876147E;
        Mon, 31 May 2021 13:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468566;
        bh=axbAyOi48Hmr3K74CrPJHT6/KFmTBpUvIncWdwiQ5Hk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqPi9lCECghzAY6Kvk3y67xkkluC/CWtxzTpHkDEdTmLixPEkV7+6swBI+BmH8ldF
         drAO+SMKpEgwyyUG417kw+YYdIh8la+hTG1WA1KmMGFxpDkIVmgLR+wmcwkaQV6xl4
         vBHCb3EjKA194/163l8A/arGc6g9ZF4K/8bi3yE0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sargun Dhillon <sargun@sargun.me>,
        Tycho Andersen <tycho@tycho.pizza>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH 5.4 038/177] Documentation: seccomp: Fix user notification documentation
Date:   Mon, 31 May 2021 15:13:15 +0200
Message-Id: <20210531130649.242377413@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sargun Dhillon <sargun@sargun.me>

commit aac902925ea646e461c95edc98a8a57eb0def917 upstream.

The documentation had some previously incorrect information about how
userspace notifications (and responses) were handled due to a change
from a previously proposed patchset.

Signed-off-by: Sargun Dhillon <sargun@sargun.me>
Acked-by: Tycho Andersen <tycho@tycho.pizza>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
Fixes: 6a21cc50f0c7 ("seccomp: add a return code to trap to userspace")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210517193908.3113-2-sargun@sargun.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/userspace-api/seccomp_filter.rst |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

--- a/Documentation/userspace-api/seccomp_filter.rst
+++ b/Documentation/userspace-api/seccomp_filter.rst
@@ -250,14 +250,14 @@ Users can read via ``ioctl(SECCOMP_IOCTL
 seccomp notification fd to receive a ``struct seccomp_notif``, which contains
 five members: the input length of the structure, a unique-per-filter ``id``,
 the ``pid`` of the task which triggered this request (which may be 0 if the
-task is in a pid ns not visible from the listener's pid namespace), a ``flags``
-member which for now only has ``SECCOMP_NOTIF_FLAG_SIGNALED``, representing
-whether or not the notification is a result of a non-fatal signal, and the
-``data`` passed to seccomp. Userspace can then make a decision based on this
-information about what to do, and ``ioctl(SECCOMP_IOCTL_NOTIF_SEND)`` a
-response, indicating what should be returned to userspace. The ``id`` member of
-``struct seccomp_notif_resp`` should be the same ``id`` as in ``struct
-seccomp_notif``.
+task is in a pid ns not visible from the listener's pid namespace). The
+notification also contains the ``data`` passed to seccomp, and a filters flag.
+The structure should be zeroed out prior to calling the ioctl.
+
+Userspace can then make a decision based on this information about what to do,
+and ``ioctl(SECCOMP_IOCTL_NOTIF_SEND)`` a response, indicating what should be
+returned to userspace. The ``id`` member of ``struct seccomp_notif_resp`` should
+be the same ``id`` as in ``struct seccomp_notif``.
 
 It is worth noting that ``struct seccomp_data`` contains the values of register
 arguments to the syscall, but does not contain pointers to memory. The task's


