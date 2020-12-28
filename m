Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF66C2E3EB5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503651AbgL1Obz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:31:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:39626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504403AbgL1ObY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:31:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6BA0D22573;
        Mon, 28 Dec 2020 14:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165844;
        bh=1xvNz+z0lFAd+OY6z96kpeCbnLJPAUZvH3SSCJdjepc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bydR/I2BAjcFVSAAoPh2wYSiZAdiuvOLIFh3hJgCz1qd4DSeDxUHDIT6ZnHcYbwUZ
         mJGa+NZPx6El3r6SHMi5YoyzN4b7CUHN2JdxQ2DTtXSBhto2ZinmKyTt9riA8yMTA+
         kN3vwM3+gSDF/Cw9JY+Cr/vSGOXXm7STvd2hyuLc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aleksa Sarai <cyphar@cyphar.com>,
        Christian Brauner <christian.brauner@ubuntu.com>
Subject: [PATCH 5.10 673/717] openat2: reject RESOLVE_BENEATH|RESOLVE_IN_ROOT
Date:   Mon, 28 Dec 2020 13:51:11 +0100
Message-Id: <20201228125053.220476023@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Aleksa Sarai <cyphar@cyphar.com>

commit 398840f8bb935d33c64df4ec4fed77a7d24c267d upstream.

This was an oversight in the original implementation, as it makes no
sense to specify both scoping flags to the same openat2(2) invocation
(before this patch, the result of such an invocation was equivalent to
RESOLVE_IN_ROOT being ignored).

This is a userspace-visible ABI change, but the only user of openat2(2)
at the moment is LXC which doesn't specify both flags and so no
userspace programs will break as a result.

Fixes: fddb5d430ad9 ("open: introduce openat2(2) syscall")
Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://lore.kernel.org/r/20201027235044.5240-2-cyphar@cyphar.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/open.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/open.c
+++ b/fs/open.c
@@ -1010,6 +1010,10 @@ inline int build_open_flags(const struct
 	if (how->resolve & ~VALID_RESOLVE_FLAGS)
 		return -EINVAL;
 
+	/* Scoping flags are mutually exclusive. */
+	if ((how->resolve & RESOLVE_BENEATH) && (how->resolve & RESOLVE_IN_ROOT))
+		return -EINVAL;
+
 	/* Deal with the mode. */
 	if (WILL_CREATE(flags)) {
 		if (how->mode & ~S_IALLUGO)


