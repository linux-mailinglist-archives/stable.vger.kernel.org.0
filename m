Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0E52C0988
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:18:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732850AbgKWNI6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 08:08:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:33624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732847AbgKWMso (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:48:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCBA721D81;
        Mon, 23 Nov 2020 12:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135716;
        bh=/lnL4kKUQjvt0DPZxtlw/Bxo0DaHITp042FE3rTo8Js=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQI+mG7kYdbAgn95XNe11V1HpWwUZ8r3gru8A8CIJPL+RRl2xnZK85L0gtHmizrH8
         iY56k8PWUFb0zKju8lZrzQuCyaZ/PPtNRy/fU/gKTx31IuR9aNvXjSCuIokKqoudMF
         oXu2F5+JnaSPfLAnqFqyiS65mnTOao2f1xC94/SU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Luo Meng <luomeng12@huawei.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 169/252] fail_function: Remove a redundant mutex unlock
Date:   Mon, 23 Nov 2020 13:21:59 +0100
Message-Id: <20201123121843.747853732@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luo Meng <luomeng12@huawei.com>

[ Upstream commit 2801a5da5b25b7af9dd2addd19b2315c02d17b64 ]

Fix a mutex_unlock() issue where before copy_from_user() is
not called mutex_locked.

Fixes: 4b1a29a7f542 ("error-injection: Support fault injection framework")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Luo Meng <luomeng12@huawei.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Link: https://lore.kernel.org/bpf/160570737118.263807.8358435412898356284.stgit@devnote2
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fail_function.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/fail_function.c b/kernel/fail_function.c
index 63b349168da72..b0b1ad93fa957 100644
--- a/kernel/fail_function.c
+++ b/kernel/fail_function.c
@@ -253,7 +253,7 @@ static ssize_t fei_write(struct file *file, const char __user *buffer,
 
 	if (copy_from_user(buf, buffer, count)) {
 		ret = -EFAULT;
-		goto out;
+		goto out_free;
 	}
 	buf[count] = '\0';
 	sym = strstrip(buf);
@@ -307,8 +307,9 @@ static ssize_t fei_write(struct file *file, const char __user *buffer,
 		ret = count;
 	}
 out:
-	kfree(buf);
 	mutex_unlock(&fei_lock);
+out_free:
+	kfree(buf);
 	return ret;
 }
 
-- 
2.27.0



