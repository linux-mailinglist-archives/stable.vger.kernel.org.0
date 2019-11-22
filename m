Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB5FD10712D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727923AbfKVKdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:33:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:55938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727050AbfKVKdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:33:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6983C20714;
        Fri, 22 Nov 2019 10:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418798;
        bh=46tdXdSQHPeM2Uf2IhlUgJGdfheCHnVWs3MdbyS8Qd0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGD66E1e/SrhG1HmwxmSXRxpK6t0p+wrpRc/2O9VuCEfxBMW57L+ABKIXH3CmOcdy
         88UW1g2bzO+CnN3PO+38nOOY/uED3ltbHEWk3P05SFoaLliFUm2wxaCOaeIEW2yZCv
         cLOfOYOBhUJM9/U+BESvR8W0VzOcokgPis/QBD0Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 055/159] kernfs: Fix range checks in kernfs_get_target_path
Date:   Fri, 22 Nov 2019 11:27:26 +0100
Message-Id: <20191122100747.383847982@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit a75e78f21f9ad4b810868c89dbbabcc3931591ca ]

The terminating NUL byte is only there because the buffer is
allocated with kzalloc(PAGE_SIZE, GFP_KERNEL), but since the
range-check is off-by-one, and PAGE_SIZE==PATH_MAX, the
returned string may not be zero-terminated if it is exactly
PATH_MAX characters long.  Furthermore also the initial loop
may theoretically exceed PATH_MAX and cause a fault.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/symlink.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index b3b293e2c0990..0a379a86ff768 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -63,6 +63,9 @@ static int kernfs_get_target_path(struct kernfs_node *parent,
 		if (base == kn)
 			break;
 
+		if ((s - path) + 3 >= PATH_MAX)
+			return -ENAMETOOLONG;
+
 		strcpy(s, "../");
 		s += 3;
 		base = base->parent;
@@ -79,7 +82,7 @@ static int kernfs_get_target_path(struct kernfs_node *parent,
 	if (len < 2)
 		return -EINVAL;
 	len--;
-	if ((s - path) + len > PATH_MAX)
+	if ((s - path) + len >= PATH_MAX)
 		return -ENAMETOOLONG;
 
 	/* reverse fillup of target string from target to base */
-- 
2.20.1



