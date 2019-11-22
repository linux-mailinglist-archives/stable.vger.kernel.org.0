Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B470D106C0E
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:50:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729675AbfKVKt3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:49:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:58874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729465AbfKVKt2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:49:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A64DD20715;
        Fri, 22 Nov 2019 10:49:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419768;
        bh=5sAEPQ6C3izdvVEkVcjaWep+k5AXbl+VHCVHCcYnFlU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u2ySOzWCDGdn48wLbs5gUr/LFv+kzVSS/B98rgkYpz7JOij5EM+/BbkQzZh2OGQi+
         uba64VZvwqIyZCwMzjrHK8nhL9kAmBU6mbAGd2NvLF/ADrXKmjksDZTWw1JRKAl35i
         XQQ4CnraA+exje9eDPkg+qH6gnoQov/GE/etTsUY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 215/222] orangefs: rate limit the client not running info message
Date:   Fri, 22 Nov 2019 11:29:15 +0100
Message-Id: <20191122100918.003934371@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100830.874290814@linuxfoundation.org>
References: <20191122100830.874290814@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit 2978d873471005577e7b68a528b4f256a529b030 ]

Currently accessing various /sys/fs/orangefs files will spam the
kernel log with the following info message when the client is not
running:

[  491.489284] sysfs_service_op_show: Client not running :-5:

Rate limit this info message to make it less spammy.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/orangefs/orangefs-sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/orangefs-sysfs.c b/fs/orangefs/orangefs-sysfs.c
index a799546a67f77..f6172c3f83ba0 100644
--- a/fs/orangefs/orangefs-sysfs.c
+++ b/fs/orangefs/orangefs-sysfs.c
@@ -315,7 +315,7 @@ static ssize_t sysfs_service_op_show(struct kobject *kobj,
 	/* Can't do a service_operation if the client is not running... */
 	rc = is_daemon_in_service();
 	if (rc) {
-		pr_info("%s: Client not running :%d:\n",
+		pr_info_ratelimited("%s: Client not running :%d:\n",
 			__func__,
 			is_daemon_in_service());
 		goto out;
-- 
2.20.1



