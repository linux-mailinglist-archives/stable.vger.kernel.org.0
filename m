Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFFC743A2AE
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235950AbhJYTvC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:38044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238489AbhJYTs7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:48:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8FC661183;
        Mon, 25 Oct 2021 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190881;
        bh=NsErpMrIa5aApyZY3Z8KgyJEY4UcAlxkWvMWv3/FFZM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ltuIsNvaVuV1t9kcERO/art1AdBai/WoHprK/2ltnkNWLMc6Em0wlQKSJSeo2GbQQ
         qge8gyT7jjuuaij6uJe9Ku16TJX+hbprbnzOC4VlNaNIm3USEdXC9lBFtT3fzfPhDV
         mOioIC/N7y/ZXu7uNGqV2ybRy5numASsqRnUjG1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.14 094/169] ucounts: Pair inc_rlimit_ucounts with dec_rlimit_ucoutns in commit_creds
Date:   Mon, 25 Oct 2021 21:14:35 +0200
Message-Id: <20211025191029.413298222@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit 629715adc62b0ad27ab04d0aa73a71927f886910 upstream.

The purpose of inc_rlimit_ucounts and dec_rlimit_ucounts in commit_creds
is to change which rlimit counter is used to track a process when the
credentials changes.

Use the same test for both to guarantee the tracking is correct.

Cc: stable@vger.kernel.org
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Link: https://lkml.kernel.org/r/87v91us0w4.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -499,7 +499,7 @@ int commit_creds(struct cred *new)
 		inc_rlimit_ucounts(new->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 	rcu_assign_pointer(task->real_cred, new);
 	rcu_assign_pointer(task->cred, new);
-	if (new->user != old->user)
+	if (new->user != old->user || new->user_ns != old->user_ns)
 		dec_rlimit_ucounts(old->ucounts, UCOUNT_RLIMIT_NPROC, 1);
 	alter_cred_subscribers(old, -2);
 


