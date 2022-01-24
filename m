Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC2EA499360
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385497AbiAXUd2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:28 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:48710 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381837AbiAXUYr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:24:47 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E177461232;
        Mon, 24 Jan 2022 20:24:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C38C340E5;
        Mon, 24 Jan 2022 20:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055886;
        bh=2/YtUJlhdhKj2+PYmbTkGubem1KTGQtxJkKwLbVF/MI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBr0dAMk4YT6ZAWcdBzuZ6Nwg+koq+bEU6ndspDlP1bdIWGfWAv4CGdd8NfbSzEHW
         00KyR14TNLOssl6g+L/wMDdvmFCkGC7La1PE5hTBiogEr8L1XXTJ8cEqMUBQ7ObNbw
         X+8X0/Agzqf6nUKR4XbF+zIKfbwZWcSsxWgrdfbM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 299/846] io_uring: remove double poll on poll update
Date:   Mon, 24 Jan 2022 19:36:56 +0100
Message-Id: <20220124184111.228757894@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit e840b4baf3cfb37e2ead4f649a45bb78178677ff ]

Before updating a poll request we should remove it from poll queues,
including the double poll entry.

Fixes: b69de288e913 ("io_uring: allow events and user_data update of running poll requests")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/ac39e7f80152613603b8a6cc29a2b6063ac2434f.1639605189.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0006fc7479ca3..ecffeddf90c68 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5925,6 +5925,7 @@ static int io_poll_update(struct io_kiocb *req, unsigned int issue_flags)
 	 * update those. For multishot, if we're racing with completion, just
 	 * let completion re-add it.
 	 */
+	io_poll_remove_double(preq);
 	completing = !__io_poll_remove_one(preq, &preq->poll, false);
 	if (completing && (preq->poll.events & EPOLLONESHOT)) {
 		ret = -EALREADY;
-- 
2.34.1



