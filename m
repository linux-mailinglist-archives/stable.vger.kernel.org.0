Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D813E47AE68
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239306AbhLTPBE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:04 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47588 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239780AbhLTO7G (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:59:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9FA61611C1;
        Mon, 20 Dec 2021 14:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 854ABC36AE7;
        Mon, 20 Dec 2021 14:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012343;
        bh=M2N0HpPe5Tw5HdGiMPI0oVITQ2n0de5hjsSXektYXDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P87pNJDJrFk80IaF2uZdzOVQGNdc45EmIcFuyzOfxuGnIrLHCKiN6GFqeJtHhevJD
         TxSzMNTNFYCvCbSa7Muf5NqKnQ4++nv6ve94PkA3uA9KjDvFDOGL6CkFAXFttFbItm
         30lIylGkD+0IMFUyX+J8PAMwYg9aixGEnpIaE5+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 166/177] io-wq: remove spurious bit clear on task_work addition
Date:   Mon, 20 Dec 2021 15:35:16 +0100
Message-Id: <20211220143045.663691870@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit e47498afeca9a0c6d07eeeacc46d563555a3f677 upstream.

There's a small race here where the task_work could finish and drop
the worker itself, so that by the time that task_work_add() returns
with a successful addition we've already put the worker.

The worker callbacks clear this bit themselves, so we don't actually
need to manually clear it in the caller. Get rid of it.

Reported-by: syzbot+b60c982cb0efc5e05a47@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io-wq.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -359,10 +359,8 @@ static bool io_queue_worker_create(struc
 
 	init_task_work(&worker->create_work, func);
 	worker->create_index = acct->index;
-	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL)) {
-		clear_bit_unlock(0, &worker->create_state);
+	if (!task_work_add(wq->task, &worker->create_work, TWA_SIGNAL))
 		return true;
-	}
 	clear_bit_unlock(0, &worker->create_state);
 fail_release:
 	io_worker_release(worker);


