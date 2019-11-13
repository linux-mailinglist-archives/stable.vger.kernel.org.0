Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 299C3FA4CD
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729121AbfKMCSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:18:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729175AbfKMBzh (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:55:37 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B542245A;
        Wed, 13 Nov 2019 01:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610137;
        bh=+E19Huy+AE+P6Kn7PRtmtBXtIXdaMq31874qfiMh7I0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cIgwI5kP/3tEpdy5Tf6jXRF4Kl7Jd6L35lAmBXgEC2ibw/tOMm6HyJ90nc/Mq9IH
         ijeCUB1EoiXsZ9ZG8DzIYHAFuX3MwSNvAC3qoHA7vFgjINUQB0goiSPRgoq+KBgXzA
         onS4EHrjzY7uRZSnXMJH5aKiqQ8iml0eD5oHu6WQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>,
        Mike Marshall <hubcap@omnibond.com>,
        Sasha Levin <sashal@kernel.org>, devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 4.19 185/209] orangefs: rate limit the client not running info message
Date:   Tue, 12 Nov 2019 20:50:01 -0500
Message-Id: <20191113015025.9685-185-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015025.9685-1-sashal@kernel.org>
References: <20191113015025.9685-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index dd28079f518c0..19739aaee6755 100644
--- a/fs/orangefs/orangefs-sysfs.c
+++ b/fs/orangefs/orangefs-sysfs.c
@@ -323,7 +323,7 @@ static ssize_t sysfs_service_op_show(struct kobject *kobj,
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

