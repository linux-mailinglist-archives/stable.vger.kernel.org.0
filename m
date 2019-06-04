Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FF713537E
	for <lists+stable@lfdr.de>; Wed,  5 Jun 2019 01:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbfFDXZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 19:25:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:37420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbfFDXZe (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 19:25:34 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86C2820859;
        Tue,  4 Jun 2019 23:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559690734;
        bh=gdrg2V4WI2+RlDJcD0Du9au/jkt8tjHHyAdAR2qkf5o=;
        h=From:To:Cc:Subject:Date:From;
        b=p1gskzbsmM9eoqaNyMcW9i0OaDSwaRFWnAXbVwEDKjJKpsAl1b5GL0xqpbdTqYjEM
         m+P1xSt7YSDbwoPrZA9zRO5yyx7Re3f8YeDyEy72eKd/lVK+YcRsjmz+6uQ8/PLuHs
         KZOIhsjQ84V97HBMZpB+KhFxfE5/cph8D2nLTX7I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Takashi Iwai <tiwai@suse.de>,
        syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.4 01/10] ALSA: seq: Cover unsubscribe_port() in list_mutex
Date:   Tue,  4 Jun 2019 19:25:22 -0400
Message-Id: <20190604232532.7953-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 7c32ae35fbf9cffb7aa3736f44dec10c944ca18e ]

The call of unsubscribe_port() which manages the group count and
module refcount from delete_and_unsubscribe_port() looks racy; it's
not covered by the group list lock, and it's likely a cause of the
reported unbalance at port deletion.  Let's move the call inside the
group list_mutex to plug the hole.

Reported-by: syzbot+e4c8abb920efa77bace9@syzkaller.appspotmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/seq/seq_ports.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/seq/seq_ports.c b/sound/core/seq/seq_ports.c
index f04714d70bf7..a42e2ce4a726 100644
--- a/sound/core/seq/seq_ports.c
+++ b/sound/core/seq/seq_ports.c
@@ -550,10 +550,10 @@ static void delete_and_unsubscribe_port(struct snd_seq_client *client,
 		list_del_init(list);
 	grp->exclusive = 0;
 	write_unlock_irq(&grp->list_lock);
-	up_write(&grp->list_mutex);
 
 	if (!empty)
 		unsubscribe_port(client, port, grp, &subs->info, ack);
+	up_write(&grp->list_mutex);
 }
 
 /* connect two ports */
-- 
2.20.1

