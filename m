Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9701A86A0F
	for <lists+stable@lfdr.de>; Thu,  8 Aug 2019 21:14:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405198AbfHHTJ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Aug 2019 15:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:44346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405205AbfHHTJ7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 8 Aug 2019 15:09:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 012662173E;
        Thu,  8 Aug 2019 19:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565291398;
        bh=Z6vYSwF3i/SL/KjmwyRDEqkFfEj7HtgxLLeYqEI4hMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehbd1ONi0QobQSk+QR18pk7CfP07aSpmWI+Rk+SK6b1Lfo0OhXOpQmEgkW6VqINJ+
         SFTsX3/Sa0Kwkv0x5E6X6TR0GjXDe68gBYeTtjARGJ5Y0QNa+4melmh8iuGRUNhFYc
         iwhvZfGthXKxpjg1g6LEkA95WV3dY0Fxd/sdMfB0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        syzbot+d4bba5ccd4f9a2a68681@syzkaller.appspotmail.com
Subject: [PATCH 4.19 44/45] cgroup: Fix css_task_iter_advance_css_set() cset skip condition
Date:   Thu,  8 Aug 2019 21:05:30 +0200
Message-Id: <20190808190456.379808712@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190808190453.827571908@linuxfoundation.org>
References: <20190808190453.827571908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit c596687a008b579c503afb7a64fcacc7270fae9e upstream.

While adding handling for dying task group leaders c03cd7738a83
("cgroup: Include dying leaders with live threads in PROCS
iterations") added an inverted cset skip condition to
css_task_iter_advance_css_set().  It should skip cset if it's
completely empty but was incorrectly testing for the inverse condition
for the dying_tasks list.  Fix it.

Signed-off-by: Tejun Heo <tj@kernel.org>
Fixes: c03cd7738a83 ("cgroup: Include dying leaders with live threads in PROCS iterations")
Reported-by: syzbot+d4bba5ccd4f9a2a68681@syzkaller.appspotmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4154,7 +4154,7 @@ static void css_task_iter_advance_css_se
 			it->task_pos = NULL;
 			return;
 		}
-	} while (!css_set_populated(cset) && !list_empty(&cset->dying_tasks));
+	} while (!css_set_populated(cset) && list_empty(&cset->dying_tasks));
 
 	if (!list_empty(&cset->tasks))
 		it->task_pos = cset->tasks.next;


