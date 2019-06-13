Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31D3C440CE
	for <lists+stable@lfdr.de>; Thu, 13 Jun 2019 18:11:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387792AbfFMQJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Jun 2019 12:09:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:33458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731265AbfFMIoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Jun 2019 04:44:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D024F20851;
        Thu, 13 Jun 2019 08:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560415472;
        bh=QIHr5DZea2YBgkl2djW9ZCWCAK7jRohgG63d0kYrtl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aGKG4G7ZdPvzHFLPxWf2fIBfH0j+zwwc5U+YG+ptXlbFHwiS4eFvjc5xGQwUodhP+
         iRLJhsSoSwMA1GnYbv6K3ZOggVOoMuZy2i2s2Zs3O7dJL4rw6Pn4cL3hzqSuQRXxVE
         U+doxolX5AukWcz+pg5ci2M+XXPe4XrQcixJDwdQ=
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
Subject: [PATCH 5.1 006/155] sysctl: return -EINVAL if val violates minmax
Date:   Thu, 13 Jun 2019 10:31:58 +0200
Message-Id: <20190613075653.075900261@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190613075652.691765927@linuxfoundation.org>
References: <20190613075652.691765927@linuxfoundation.org>
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
index c9ec050bcf46..387efbaf464a 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2874,8 +2874,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
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



