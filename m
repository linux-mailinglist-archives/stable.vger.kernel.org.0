Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB3DF569C
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732020AbfKHTJx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:09:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:41740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732947AbfKHTJt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:09:49 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 847BE206A3;
        Fri,  8 Nov 2019 19:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240189;
        bh=9r8zL6sSvPcpJIggKFfnzpnK5oCqK/XRjrW9dKyEW+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=elMmlWr65SKOQ9Rnwk2KXikOK237PMKpDhC6uOpkL+P+cV+fU2zC5aDeINtWsEyQA
         EKl1Xn0tcKT857HHO3GuAEE+GNgiRHhfdCoUq5MNKF2Vq2i+1mUSMMa7ZFjTAMDZFO
         RmQb0oby7J+j2gyibxcx5hkw7+Mp8TJrJkFAPRxk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mike Christie <mchristi@redhat.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 077/140] nbd: protect cmd->status with cmd->lock
Date:   Fri,  8 Nov 2019 19:50:05 +0100
Message-Id: <20191108174909.960322693@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit de6346ecbc8f5591ebd6c44ac164e8b8671d71d7 ]

We already do this for the most part, except in timeout and clear_req.
For the timeout case we take the lock after we grab a ref on the config,
but that isn't really necessary because we're safe to touch the cmd at
this point, so just move the order around.

For the clear_req cause this is initiated by the user, so again is safe.

Reviewed-by: Mike Christie <mchristi@redhat.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/nbd.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index 9650777d0aaf1..7301fe55084bf 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -351,17 +351,16 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req,
 	struct nbd_device *nbd = cmd->nbd;
 	struct nbd_config *config;
 
+	if (!mutex_trylock(&cmd->lock))
+		return BLK_EH_RESET_TIMER;
+
 	if (!refcount_inc_not_zero(&nbd->config_refs)) {
 		cmd->status = BLK_STS_TIMEOUT;
+		mutex_unlock(&cmd->lock);
 		goto done;
 	}
 	config = nbd->config;
 
-	if (!mutex_trylock(&cmd->lock)) {
-		nbd_config_put(nbd);
-		return BLK_EH_RESET_TIMER;
-	}
-
 	if (config->num_connections > 1) {
 		dev_err_ratelimited(nbd_to_dev(nbd),
 				    "Connection timed out, retrying (%d/%d alive)\n",
@@ -755,7 +754,10 @@ static bool nbd_clear_req(struct request *req, void *data, bool reserved)
 {
 	struct nbd_cmd *cmd = blk_mq_rq_to_pdu(req);
 
+	mutex_lock(&cmd->lock);
 	cmd->status = BLK_STS_IOERR;
+	mutex_unlock(&cmd->lock);
+
 	blk_mq_complete_request(req);
 	return true;
 }
-- 
2.20.1



