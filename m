Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 528931B7513
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 14:31:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgDXMaq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 08:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728002AbgDXMX3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Apr 2020 08:23:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 644BC21707;
        Fri, 24 Apr 2020 12:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587731009;
        bh=k9YoWguCFiqgYPIjfG5C7mn6vB2gbtAVXK+6XkUudhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=se+9FJ0/lGXfV6akV8CA82iumyzSQ9OOKx23LyLtMBD+EqCUAqwvLvZlNss4DsamO
         NwvSQ/ebjjLWXok19tEldLN8hNoCs/mmtD6j1Yip0SIIpTiG1KRdbfbttH7sjzQz3g
         +33O+pzk74zljfO7tXUKDl6y7GggFUb/609E41Pg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 04/26] signal: check sig before setting info in kill_pid_usb_asyncio
Date:   Fri, 24 Apr 2020 08:23:01 -0400
Message-Id: <20200424122323.10194-4-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200424122323.10194-1-sashal@kernel.org>
References: <20200424122323.10194-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhiqiang Liu <liuzhiqiang26@huawei.com>

[ Upstream commit eaec2b0bd30690575c581eebffae64bfb7f684ac ]

In kill_pid_usb_asyncio, if signal is not valid, we do not need to
set info struct.

Signed-off-by: Zhiqiang Liu <liuzhiqiang26@huawei.com>
Acked-by: Christian Brauner <christian.brauner@ubuntu.com>
Link: https://lore.kernel.org/r/f525fd08-1cf7-fb09-d20c-4359145eb940@huawei.com
Signed-off-by: Christian Brauner <christian.brauner@ubuntu.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/signal.c b/kernel/signal.c
index 7d3d35eb7a0ba..3498a009eeac3 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1510,15 +1510,15 @@ int kill_pid_usb_asyncio(int sig, int errno, sigval_t addr,
 	unsigned long flags;
 	int ret = -EINVAL;
 
+	if (!valid_signal(sig))
+		return ret;
+
 	clear_siginfo(&info);
 	info.si_signo = sig;
 	info.si_errno = errno;
 	info.si_code = SI_ASYNCIO;
 	*((sigval_t *)&info.si_pid) = addr;
 
-	if (!valid_signal(sig))
-		return ret;
-
 	rcu_read_lock();
 	p = pid_task(pid, PIDTYPE_PID);
 	if (!p) {
-- 
2.20.1

