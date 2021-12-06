Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E739469E37
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:36:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385613AbhLFPhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:37:04 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:37190 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388055AbhLFPcR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:32:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 737BCB81120;
        Mon,  6 Dec 2021 15:28:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9D6C34900;
        Mon,  6 Dec 2021 15:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804526;
        bh=yCesmtKBzSKX9UoFdOziBkhlSz8UJxrwP87VSnmv2pw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FJi4+MyY3t0NuGqqdgvhyCLEYcF2RGxmMrdagdV58csoGUsn6ao9ifEIc80K1UBQF
         WfdkJyhk/mqXifX3Reamh2N0w+6wQwepYSCYKZShHgkm7aN4bwf+CiRKyPbcd/akKx
         QSwVeBiY1rB+W8aPL/K/BBVSBYSbM79q6fRfcICc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Florian Fischer <florian.fl.fischer@fau.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 171/207] io-wq: dont retry task_work creation failure on fatal conditions
Date:   Mon,  6 Dec 2021 15:57:05 +0100
Message-Id: <20211206145616.188238474@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit a226abcd5d427fe9d42efc442818a4a1821e2664 ]

We don't want to be retrying task_work creation failure if there's
an actual signal pending for the parent task. If we do, then we can
enter an infinite loop of perpetually retrying and each retry failing
with -ERESTARTNOINTR because a signal is pending.

Fixes: 3146cba99aa2 ("io-wq: make worker creation resilient against signals")
Reported-by: Florian Fischer <florian.fl.fischer@fau.de>
Link: https://lore.kernel.org/io-uring/20211202165606.mqryio4yzubl7ms5@pasture/
Tested-by: Florian Fischer <florian.fl.fischer@fau.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io-wq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 8c61315657546..e8f77903d7757 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -711,6 +711,13 @@ static bool io_wq_work_match_all(struct io_wq_work *work, void *data)
 
 static inline bool io_should_retry_thread(long err)
 {
+	/*
+	 * Prevent perpetual task_work retry, if the task (or its group) is
+	 * exiting.
+	 */
+	if (fatal_signal_pending(current))
+		return false;
+
 	switch (err) {
 	case -EAGAIN:
 	case -ERESTARTSYS:
-- 
2.33.0



