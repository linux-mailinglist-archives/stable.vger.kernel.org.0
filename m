Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C0B44388
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391395AbfFMQaY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:30:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730914AbfFMIez (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:34:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9A00720851;
        Thu, 13 Jun 2019 08:34:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560414895;
        bh=/kg/I5Js5v4YUUnY5DY/lGeNXoseSK3uBXbK6hBDt+w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ij2brdx1tjpjEjxr5M3O1WRpFU6Q7mjwdLsnQrTNzsuNR3pAEKfwuRNjw5GT6CXDb
         JWaJD10vDzZMiVot1livpZFQmKlNXy6oWW2kzViaCckRC+IZUMYdIV9pIWuz1UMPuA
         EIsRAIh+XGEJZBTssMcm7ygskU71xeRImJBVZ0aU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Brauner <christian@brauner.io>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Waiman Long <longman@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/81] sysctl: return -EINVAL if val violates minmax
Date:   Thu, 13 Jun 2019 10:32:46 +0200
Message-Id: <20190613075649.319169010@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075649.074682929@linuxfoundation.org>
References: <20190613075649.074682929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit e260ad01f0aa9e96b5386d5cd7184afd949dc457 ]

Currently when userspace gives us a values that overflow e.g.  file-max
and other callers of __do_proc_doulongvec_minmax() we simply ignore the
new value and leave the current value untouched.

This can be problematic as it gives the illusion that the limit has
indeed be bumped when in fact it failed.  This commit makes sure to
return EINVAL when an overflow is detected.  Please note that this is a
userspace facing change.

Link: http://lkml.kernel.org/r/20190210203943.8227-4-christian@brauner.io
Signed-off-by: Christian Brauner <christian@brauner.io>
Acked-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Joe Lawrence <joe.lawrence@redhat.com>
Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sysctl.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index f13601a616ad..cfc2c0d1369a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2732,8 +2732,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
 			if (neg)
 				continue;
 			val = convmul * val / convdiv;
-			if ((min && val < *min) || (max && val > *max))
-				continue;
+			if ((min && val < *min) || (max && val > *max)) {
+				err = -EINVAL;
+				break;
+			}
 			*i = val;
 		} else {
 			val = convdiv * (*i) / convmul;
-- 
2.20.1



