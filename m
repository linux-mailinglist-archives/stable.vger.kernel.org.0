Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A4C6E68BD
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730649AbfJ0Vbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:36346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730878AbfJ0VQl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:16:41 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 51B4421848;
        Sun, 27 Oct 2019 21:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211000;
        bh=sv62GLlzZY0YW5GNEa6kawtjMTNjMoGLeHqaa5Chwck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YOBlcMn8oloH0h/r6EOo7ZfDzNcaNmgZ+VAb7rhBK/PWUjM/Df6GjgiJhUNlrdEmp
         lpaWmngRBgVPr6IalfALrRUFSGsDvBoLR4Q6y2W1Y5gpKQ6Mx42jQkEz3khbsGfVYm
         ZDlpqKf5TRdi3NMRrmOKg8XXlE6xfdPnPwzeuHFY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.19 92/93] blk-rq-qos: fix first node deletion of rq_qos_del()
Date:   Sun, 27 Oct 2019 22:01:44 +0100
Message-Id: <20191027203318.353148127@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203251.029297948@linuxfoundation.org>
References: <20191027203251.029297948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

commit 307f4065b9d7c1e887e8bdfb2487e4638559fea1 upstream.

rq_qos_del() incorrectly assigns the node being deleted to the head if
it was the first on the list in the !prev path.  Fix it by iterating
with ** instead.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Fixes: a79050434b45 ("blk-rq-qos: refactor out common elements of blk-wbt")
Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-rq-qos.h |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/block/blk-rq-qos.h
+++ b/block/blk-rq-qos.h
@@ -80,16 +80,13 @@ static inline void rq_qos_add(struct req
 
 static inline void rq_qos_del(struct request_queue *q, struct rq_qos *rqos)
 {
-	struct rq_qos *cur, *prev = NULL;
-	for (cur = q->rq_qos; cur; cur = cur->next) {
-		if (cur == rqos) {
-			if (prev)
-				prev->next = rqos->next;
-			else
-				q->rq_qos = cur;
+	struct rq_qos **cur;
+
+	for (cur = &q->rq_qos; *cur; cur = &(*cur)->next) {
+		if (*cur == rqos) {
+			*cur = rqos->next;
 			break;
 		}
-		prev = cur;
 	}
 }
 


