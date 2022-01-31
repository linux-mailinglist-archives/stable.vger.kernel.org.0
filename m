Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA9E4A4228
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:11:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359094AbiAaLK7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:10:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55616 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240439AbiAaLHJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:07:09 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1882B82A66;
        Mon, 31 Jan 2022 11:07:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AA0C340E8;
        Mon, 31 Jan 2022 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627226;
        bh=jchTgH/WeRcP+rGsiq9q+IUIigxZl5WhidZEAqQun5Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KI50kzrCjUR1ohxGSP5iJCKbpymvkkx3Lg5VJ9+gk1WbNNFhrxquG1cKfSzn1//NS
         Npnakcdh58piPiylOHYINyHo3w2rp0maDVfm5D/6JF4WcRw/Ol4KuSxPmoe1QUB/8A
         OMNq/3IPRh6DCT+79jCrZzWGTWR682lYZDMus4a4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <quic_qiancai@quicinc.com>,
        Mathias Krause <minipli@grsecurity.net>,
        Alexey Gladkov <legion@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [PATCH 5.15 015/171] ucount:  Make get_ucount a safe get_user replacement
Date:   Mon, 31 Jan 2022 11:54:40 +0100
Message-Id: <20220131105230.530679350@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
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
@@ -184,6 +184,7 @@ struct ucounts *alloc_ucounts(struct use
 			kfree(new);
 		} else {
 			hlist_add_head(&new->node, hashent);
+			get_user_ns(new->ns);
 			spin_unlock_irq(&ucounts_lock);
 			return new;
 		}
@@ -204,6 +205,7 @@ void put_ucounts(struct ucounts *ucounts
 	if (atomic_dec_and_lock_irqsave(&ucounts->count, &ucounts_lock, flags)) {
 		hlist_del_init(&ucounts->node);
 		spin_unlock_irqrestore(&ucounts_lock, flags);
+		put_user_ns(ucounts->ns);
 		kfree(ucounts);
 	}
 }


