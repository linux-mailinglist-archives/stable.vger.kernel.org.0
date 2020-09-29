Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16FEA27C89E
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:03:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgI2MD2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:03:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:60238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728186AbgI2Lie (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:38:34 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF9B206E5;
        Tue, 29 Sep 2020 11:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379512;
        bh=6h2dBenQ50K3IFjlwte/EwE+N6avJPpgBmGXxDM0h9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1Qpda1tnWItF0txGoYLA6HUQ1a6SkHuTT4UIb0GYWCWCiOK39pRP/n6RwQB6JbURX
         h6UT/+Y8VibHonUmx4VFCVrzW2iLeStCaE5i3ptH7Bvxohf86yvFga/ovBweLG+87X
         NKA+8uN+88aP2cy7VYJIb33KcAL6tdca9Wrt613c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bernd Edlinger <bernd.edlinger@hotmail.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 197/388] proc: io_accounting: Use new infrastructure to fix deadlocks in execve
Date:   Tue, 29 Sep 2020 12:58:48 +0200
Message-Id: <20200929110020.016764274@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bernd Edlinger <bernd.edlinger@hotmail.de>

[ Upstream commit 76518d3798855242817e8a8ed76b2d72f4415624 ]

This changes do_io_accounting to use the new exec_update_mutex
instead of cred_guard_mutex.

This fixes possible deadlocks when the trace is accessing
/proc/$pid/io for instance.

This should be safe, as the credentials are only used for reading.

Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/proc/base.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4fdfe4faa74ee..529d0c6ec6f9c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2770,7 +2770,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	unsigned long flags;
 	int result;
 
-	result = mutex_lock_killable(&task->signal->cred_guard_mutex);
+	result = mutex_lock_killable(&task->signal->exec_update_mutex);
 	if (result)
 		return result;
 
@@ -2806,7 +2806,7 @@ static int do_io_accounting(struct task_struct *task, struct seq_file *m, int wh
 	result = 0;
 
 out_unlock:
-	mutex_unlock(&task->signal->cred_guard_mutex);
+	mutex_unlock(&task->signal->exec_update_mutex);
 	return result;
 }
 
-- 
2.25.1



