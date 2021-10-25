Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4536A43A2B2
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:49:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237235AbhJYTvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:51:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:38052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238501AbhJYTtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4568061245;
        Mon, 25 Oct 2021 19:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190886;
        bh=OcycQUxWM4mADYeRy/E9Sl+VMLnGHaiZMGb7Um3+hl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LjXpk1tbg9Ow7/crsNJxlWS9eUoLR43VhGshjh1lK5/jf4NzuujWK0xSImy6ZyycG
         8Fv/KiuOobQSTjGQvBF2uWLXNM0DAbcXbbGY0EuXQ/q9ElG0eS0b7RgUIBCTE5wnmf
         pLVV1nZBcDWAGIVJOpnbrfUcQn8RA7MT25zgenvI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yu Zhao <yuzhao@google.com>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.14 095/169] ucounts: Proper error handling in set_cred_ucounts
Date:   Mon, 25 Oct 2021 21:14:36 +0200
Message-Id: <20211025191029.624785286@linuxfoundation.org>
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

commit 34dc2fd6e6908499b669c7b45320cddf38b332e1 upstream.

Instead of leaking the ucounts in new if alloc_ucounts fails, store
the result of alloc_ucounts into a temporary variable, which is later
assigned to new->ucounts.

Cc: stable@vger.kernel.org
Fixes: 905ae01c4ae2 ("Add a reference to ucounts for each cred")
Link: https://lkml.kernel.org/r/87pms2s0v8.fsf_-_@disp2133
Tested-by: Yu Zhao <yuzhao@google.com>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cred.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -667,7 +667,7 @@ int set_cred_ucounts(struct cred *new)
 {
 	struct task_struct *task = current;
 	const struct cred *old = task->real_cred;
-	struct ucounts *old_ucounts = new->ucounts;
+	struct ucounts *new_ucounts, *old_ucounts = new->ucounts;
 
 	if (new->user == old->user && new->user_ns == old->user_ns)
 		return 0;
@@ -679,9 +679,10 @@ int set_cred_ucounts(struct cred *new)
 	if (old_ucounts && old_ucounts->ns == new->user_ns && uid_eq(old_ucounts->uid, new->euid))
 		return 0;
 
-	if (!(new->ucounts = alloc_ucounts(new->user_ns, new->euid)))
+	if (!(new_ucounts = alloc_ucounts(new->user_ns, new->euid)))
 		return -EAGAIN;
 
+	new->ucounts = new_ucounts;
 	if (old_ucounts)
 		put_ucounts(old_ucounts);
 


