Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29D9DCA2E9
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732751AbfJCQKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:59762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387626AbfJCQKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:10:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 331AC207FF;
        Thu,  3 Oct 2019 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119023;
        bh=H9nDv0dyyzuB3pj03Cz7cuoEJgES4iw7fleVU+6Tv5k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gR99TmsYSei0wzI9PNSWd8uB+ZwSJA2WIeb++RCPxQ5ee9Qy+U+a/978YC7Wgr5j
         16o4ed1ZMF2m7lGQhMWNQKVT7lHvbUQrsd/yYBvXLLco3k5u1Wu8yJac7zmaleFCQq
         1e+qoXp9BT6V1+f+HQnQ6vybpzi/G7YF6jTWTgSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
        Mike Christie <mchristi@redhat.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 098/185] nbd: add missing config put
Date:   Thu,  3 Oct 2019 17:52:56 +0200
Message-Id: <20191003154500.704904438@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154437.541662648@linuxfoundation.org>
References: <20191003154437.541662648@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mike Christie <mchristi@redhat.com>

[ Upstream commit 887e975c4172d0d5670c39ead2f18ba1e4ec8133 ]

Fix bug added with the patch:

commit 8f3ea35929a0806ad1397db99a89ffee0140822a
Author: Josef Bacik <josef@toxicpanda.com>
Date:   Mon Jul 16 12:11:35 2018 -0400

    nbd: handle unexpected replies better

where if the timeout handler runs when the completion path is and we fail
to grab the mutex in the timeout handler we will leave a config reference
and cannot free the config later.

Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index b77e9281c039d..e4b049f281f50 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -340,8 +340,10 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	}
 	config = nbd->config;
 
-	if (!mutex_trylock(&cmd->lock))
+	if (!mutex_trylock(&cmd->lock)) {
+		nbd_config_put(nbd);
 		return BLK_EH_RESET_TIMER;
+	}
 
 	if (config->num_connections > 1) {
 		dev_err_ratelimited(nbd_to_dev(nbd),
-- 
2.20.1



