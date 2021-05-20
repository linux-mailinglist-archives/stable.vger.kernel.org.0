Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2C3738A523
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233217AbhETKNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:13:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235245AbhETKLO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:11:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4853C61439;
        Thu, 20 May 2021 09:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503811;
        bh=nWN8Ek/6baufsSyJRUd3zxXlNVoaCE3yUJlGKIix6js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f8ani2p6tkjbE4Y9krG4nTzTqlWW7NE2GtRAuseo57i5TfdWdWpwA6YR6M6qTHNkc
         ye4Izx1rtr9MLswAS9d2XpJKcpcbl8wFpJQgRyuSyQewXk6NJ4Fcp/jpEExxC0nQb8
         6MNRfyXUPHyQpdqAWDMlutJwA82FIdY1YFHXIqWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        syzbot+92340f7b2b4789907fdb@syzkaller.appspotmail.com
Subject: [PATCH 4.19 390/425] kobject_uevent: remove warning in init_uevent_argv()
Date:   Thu, 20 May 2021 11:22:39 +0200
Message-Id: <20210520092144.220032626@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
@@ -250,12 +250,13 @@ static int kobj_usermode_filter(struct k
 
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
 


