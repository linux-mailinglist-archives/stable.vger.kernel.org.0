Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBE8881CD4
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 15:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731099AbfHENYx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 09:24:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:33366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731094AbfHENYw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 09:24:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E44420644;
        Mon,  5 Aug 2019 13:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565011491;
        bh=S0Xsl0T8+NAaR8iaxwLCK5CArJFaJjeMvLO7jaYnVA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JlL9ZlXkybsQkAudLV1gOn/zz02Y6+h6QE/Ing4v6DTcIXktCb3sm2fWsjqkADeH/
         h7ddvNKXjNx45eG9ZkDd2bPPN2bFXp4RDLs3edopfQe8koPWIUdGAKeWzkOAyNqVsv
         KPewA0llLGV8ge6aovc9g0Y1q5fzWgxUl6a/PSfI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.2 081/131] dax: Fix missed wakeup in put_unlocked_entry()
Date:   Mon,  5 Aug 2019 15:02:48 +0200
Message-Id: <20190805124957.361969657@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190805124951.453337465@linuxfoundation.org>
References: <20190805124951.453337465@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Kara <jack@suse.cz>

commit 61c30c98ef17e5a330d7bb8494b78b3d6dffe9b8 upstream.

The condition checking whether put_unlocked_entry() needs to wake up
following waiter got broken by commit 23c84eb78375 ("dax: Fix missed
wakeup with PMD faults"). We need to wake the waiter whenever the passed
entry is valid (i.e., non-NULL and not special conflict entry). This
could lead to processes never being woken up when waiting for entry
lock. Fix the condition.

Cc: <stable@vger.kernel.org>
Link: http://lore.kernel.org/r/20190729120228.GC17833@quack2.suse.cz
Fixes: 23c84eb78375 ("dax: Fix missed wakeup with PMD faults")
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/dax.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/dax.c
+++ b/fs/dax.c
@@ -267,7 +267,7 @@ static void wait_entry_unlocked(struct x
 static void put_unlocked_entry(struct xa_state *xas, void *entry)
 {
 	/* If we were the only waiter woken, wake the next one */
-	if (entry && dax_is_conflict(entry))
+	if (entry && !dax_is_conflict(entry))
 		dax_wake_entry(xas, entry, false);
 }
 


