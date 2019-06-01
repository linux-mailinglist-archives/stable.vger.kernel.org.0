Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D703931DD1
	for <lists+stable@lfdr.de>; Sat,  1 Jun 2019 15:33:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729623AbfFAN0F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Jun 2019 09:26:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:56486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729620AbfFAN0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 1 Jun 2019 09:26:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06104273AD;
        Sat,  1 Jun 2019 13:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559395564;
        bh=6sujLPHojiodkFk/sT4dPXMVg1EbwtHZuWkazWxrAUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0lLgDPCDGz/2BC0574EhnvGZ4uqSVqxDl1+l3Tu+Jf+oFOVUUuUJETq8zBji7+0Ui
         e4rJBHrk+NLSYD2On/z4QBV2gVdAHlW33vo/isxQWsp01ZE02qB6eT9fWFarZtBylj
         6i9lGGKGE3qM5OBBII2KgHXE9ylFAfwPj73dzsQ4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christian Brauner <christian@brauner.io>,
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
        Sasha Levin <sashal@kernel.org>, linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 02/56] sysctl: return -EINVAL if val violates minmax
Date:   Sat,  1 Jun 2019 09:25:06 -0400
Message-Id: <20190601132600.27427-2-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190601132600.27427-1-sashal@kernel.org>
References: <20190601132600.27427-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Brauner <christian@brauner.io>

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
index c140659db6699..24c7fe8608d02 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -2461,8 +2461,10 @@ static int __do_proc_doulongvec_minmax(void *data, struct ctl_table *table, int
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

