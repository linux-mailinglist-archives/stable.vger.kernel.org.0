Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7752738375F
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244146AbhEQPmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:42:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344050AbhEQPkN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:40:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 619DC61D02;
        Mon, 17 May 2021 14:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262509;
        bh=LnGGExNcUTjQB6r41cBkpiSRuxFT6a9BFdRTamgqnu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lyiMSfsdoWD3j3dIHyTK7HqdhzsV6wzJ3/c9As/TBU5NsC3R7XfBrrGl4mkeJFf1K
         8NWLl/IH1EGlKKs0YPHrPqhUBWdimqHK5FqZ2D5ZOTvzMYPsBTRNjxcgnPFuoFOhbW
         OJZBwQQc5c1UdXdtxVtYMucTsIgxSIiFjnFmtY34=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        syzbot+92340f7b2b4789907fdb@syzkaller.appspotmail.com
Subject: [PATCH 5.11 310/329] kobject_uevent: remove warning in init_uevent_argv()
Date:   Mon, 17 May 2021 16:03:41 +0200
Message-Id: <20210517140312.578673376@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit b4104180a2efb85f55e1ba1407885c9421970338 upstream.

syzbot can trigger the WARN() in init_uevent_argv() which isn't the
nicest as the code does properly recover and handle the error.  So
change the WARN() call to pr_warn() and provide some more information on
what the buffer size that was needed.

Link: https://lore.kernel.org/r/20201107082206.GA19079@kroah.com
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: linux-kernel@vger.kernel.org
Reported-by: syzbot+92340f7b2b4789907fdb@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/r/20210405094852.1348499-1-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/kobject_uevent.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -251,12 +251,13 @@ static int kobj_usermode_filter(struct k
 
 static int init_uevent_argv(struct kobj_uevent_env *env, const char *subsystem)
 {
+	int buffer_size = sizeof(env->buf) - env->buflen;
 	int len;
 
-	len = strlcpy(&env->buf[env->buflen], subsystem,
-		      sizeof(env->buf) - env->buflen);
-	if (len >= (sizeof(env->buf) - env->buflen)) {
-		WARN(1, KERN_ERR "init_uevent_argv: buffer size too small\n");
+	len = strlcpy(&env->buf[env->buflen], subsystem, buffer_size);
+	if (len >= buffer_size) {
+		pr_warn("init_uevent_argv: buffer size of %d too small, needed %d\n",
+			buffer_size, len);
 		return -ENOMEM;
 	}
 


