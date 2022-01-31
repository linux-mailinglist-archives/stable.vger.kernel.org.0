Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 553624A4383
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:22:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376454AbiAaLVo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:21:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37606 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377402AbiAaLSM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:18:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5336EB82A61;
        Mon, 31 Jan 2022 11:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976A9C340E8;
        Mon, 31 Jan 2022 11:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627890;
        bh=zQGbytej+hfBcd7CzPG1kNgAXhdOl0s9NMF5c/xeaWE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bDrZm5o+Ud6MsANM2c2iC9ECTrA7QC71lAr6Zb7Oo7mX9TPjPm/LvKsJ2OTLkpmBS
         6AFQNsT3AQtSoafXgrkUIHZMHy6MTRpPwzpMictZu1qRkFgRw5SIZN9Qi7MK5dMhzE
         H7Fa1sFfOXbghPrmheNeD5JKUfEftBPGg4ufdTTI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <quic_qiancai@quicinc.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.16 024/200] ucount:  Make get_ucount a safe get_user replacement
Date:   Mon, 31 Jan 2022 11:54:47 +0100
Message-Id: <20220131105234.384457549@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105233.561926043@linuxfoundation.org>
References: <20220131105233.561926043@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric W. Biederman <ebiederm@xmission.com>

commit f9d87929d451d3e649699d0f1d74f71f77ad38f5 upstream.

When the ucount code was refactored to create get_ucount it was missed
that some of the contexts in which a rlimit is kept elevated can be
the only reference to the user/ucount in the system.

Ordinary ucount references exist in places that also have a reference
to the user namspace, but in POSIX message queues, the SysV shm code,
and the SIGPENDING code there is no independent user namespace
reference.

Inspection of the the user_namespace show no instance of circular
references between struct ucounts and the user_namespace.  So
hold a reference from struct ucount to i's user_namespace to
resolve this problem.

Link: https://lore.kernel.org/lkml/YZV7Z+yXbsx9p3JN@fixkernel.com/
Reported-by: Qian Cai <quic_qiancai@quicinc.com>
Reported-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Reviewed-by: Mathias Krause <minipli@grsecurity.net>
Reviewed-by: Alexey Gladkov <legion@kernel.org>
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
Fixes: 6e52a9f0532f ("Reimplement RLIMIT_MSGQUEUE on top of ucounts")
Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Cc: stable@vger.kernel.org
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/ucount.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/ucount.c
+++ b/kernel/ucount.c
@@ -190,6 +190,7 @@ struct ucounts *alloc_ucounts(struct use
 			kfree(new);
 		} else {
 			hlist_add_head(&new->node, hashent);
+			get_user_ns(new->ns);
 			spin_unlock_irq(&ucounts_lock);
 			return new;
 		}
@@ -210,6 +211,7 @@ void put_ucounts(struct ucounts *ucounts
 	if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
 		hlist_del_init(&ucounts->node);
 		spin_unlock_irqrestore(&ucounts_lock, flags);
+		put_user_ns(ucounts->ns);
 		kfree(ucounts);
 	}
 }


