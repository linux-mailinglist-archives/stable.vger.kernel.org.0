Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA3CB2EEDD
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729812AbfE3DTy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:19:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:56998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731229AbfE3DTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:53 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDDA248DE;
        Thu, 30 May 2019 03:19:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186391;
        bh=G07YqjmcwnMdmuyaPQLQY6OURpY6A5BM4VT9U3TF1iI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hEuR2zP6pBUjue1dXSCzPEITCDEeud6qbPzLl036ZMkD7kGJSbbHhy/wueqoSXhpi
         tHiOUIo+MHX8ocUVBK0K97BKmJ91KQoO0Fks/+sbhEx9v1vMPk2yyn5AaYaaEDRqLB
         /pqsDbABUBDHgvdiHPTZk2kuLOqnDRj/Lwz9k2LE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+f648cfb7e0b52bf7ae32@syzkaller.appspotmail.com>,
        Kay Sievers <kay@vrfy.org>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.14 163/193] kobject: Dont trigger kobject_uevent(KOBJ_REMOVE) twice.
Date:   Wed, 29 May 2019 20:06:57 -0700
Message-Id: <20190530030510.715672847@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c03a0fd0b609e2f5c669c2b7f27c8e1928e9196e ]

syzbot is hitting use-after-free bug in uinput module [1]. This is because
kobject_uevent(KOBJ_REMOVE) is called again due to commit 0f4dafc0563c6c49
("Kobject: auto-cleanup on final unref") after memory allocation fault
injection made kobject_uevent(KOBJ_REMOVE) from device_del() from
input_unregister_device() fail, while uinput_destroy_device() is expecting
that kobject_uevent(KOBJ_REMOVE) is not called after device_del() from
input_unregister_device() completed.

That commit intended to catch cases where nobody even attempted to send
"remove" uevents. But there is no guarantee that an event will ultimately
be sent. We are at the point of no return as far as the rest of the kernel
is concerned; there are no repeats or do-overs.

Also, it is not clear whether some subsystem depends on that commit.
If no subsystem depends on that commit, it will be better to remove
the state_{add,remove}_uevent_sent logic. But we don't want to risk
a regression (in a patch which will be backported) by trying to remove
that logic. Therefore, as a first step, let's avoid the use-after-free bug
by making sure that kobject_uevent(KOBJ_REMOVE) won't be triggered twice.

[1] https://syzkaller.appspot.com/bug?id=8b17c134fe938bbddd75a45afaa9e68af43a362d

Reported-by: syzbot <syzbot+f648cfb7e0b52bf7ae32@syzkaller.appspotmail.com>
Analyzed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Fixes: 0f4dafc0563c6c49 ("Kobject: auto-cleanup on final unref")
Cc: Kay Sievers <kay@vrfy.org>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/kobject_uevent.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/lib/kobject_uevent.c b/lib/kobject_uevent.c
index f237a09a58627..3916cf0e2f0ae 100644
--- a/lib/kobject_uevent.c
+++ b/lib/kobject_uevent.c
@@ -340,6 +340,13 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 	struct uevent_sock *ue_sk;
 #endif
 
+	/*
+	 * Mark "remove" event done regardless of result, for some subsystems
+	 * do not want to re-trigger "remove" event via automatic cleanup.
+	 */
+	if (action == KOBJ_REMOVE)
+		kobj->state_remove_uevent_sent = 1;
+
 	pr_debug("kobject: '%s' (%p): %s\n",
 		 kobject_name(kobj), kobj, __func__);
 
@@ -441,10 +448,6 @@ int kobject_uevent_env(struct kobject *kobj, enum kobject_action action,
 		kobj->state_add_uevent_sent = 1;
 		break;
 
-	case KOBJ_REMOVE:
-		kobj->state_remove_uevent_sent = 1;
-		break;
-
 	case KOBJ_UNBIND:
 		zap_modalias_env(env);
 		break;
-- 
2.20.1



