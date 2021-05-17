Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C88D638302D
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 16:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239841AbhEQOZJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 10:25:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:35732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239193AbhEQOWS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 10:22:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F1390610A0;
        Mon, 17 May 2021 14:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621260708;
        bh=wRIMUKf8f9czpJ2k7bhptKZpLNn6+LmfvKRAV48OawA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vpm1sQ/DnANcPtXlmawCRMxaiP4XUX56NSoYOD7RzNfBzffBBw0/7df7C4HytRpfx
         0DM/r9EG1Bq1q12BblBEREFUl+hnGeSutlECAvqjSw8EFcbJBqRHQVy1VQRy2sw2q9
         GcAxKQK5VEO0UVBbMWSR65JQjH0kzeRuIsfvCtpU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Md Haris Iqbal <haris.iqbal@ionos.com>,
        Guoqing Jiang <guoqing.jiang@ionos.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Gioh Kim <gi-oh.kim@ionos.com>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 204/363] block/rnbd-clt: Check the return value of the function rtrs_clt_query
Date:   Mon, 17 May 2021 16:01:10 +0200
Message-Id: <20210517140309.479153706@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.508966430@linuxfoundation.org>
References: <20210517140302.508966430@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Md Haris Iqbal <haris.iqbal@cloud.ionos.com>

[ Upstream commit 1056ad829ec43f9b705b507c2093b05e2088b0b7 ]

In case none of the paths are in connected state, the function
rtrs_clt_query returns an error. In such a case, error out since the
values in the rtrs_attrs structure would be garbage.

Fixes: f7a7a5c228d45 ("block/rnbd: client: main functionality")
Signed-off-by: Md Haris Iqbal <haris.iqbal@ionos.com>
Reviewed-by: Guoqing Jiang <guoqing.jiang@ionos.com>
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Gioh Kim <gi-oh.kim@ionos.com>
Link: https://lore.kernel.org/r/20210428061359.206794-4-gi-oh.kim@ionos.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rnbd/rnbd-clt.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.c
index 45a470076652..5ab7319ff2ea 100644
--- a/drivers/block/rnbd/rnbd-clt.c
+++ b/drivers/block/rnbd/rnbd-clt.c
@@ -693,7 +693,11 @@ static void remap_devs(struct rnbd_clt_session *sess)
 		return;
 	}
 
-	rtrs_clt_query(sess->rtrs, &attrs);
+	err = rtrs_clt_query(sess->rtrs, &attrs);
+	if (err) {
+		pr_err("rtrs_clt_query(\"%s\"): %d\n", sess->sessname, err);
+		return;
+	}
 	mutex_lock(&sess->lock);
 	sess->max_io_size = attrs.max_io_size;
 
@@ -1234,7 +1238,11 @@ find_and_get_or_create_sess(const char *sessname,
 		err = PTR_ERR(sess->rtrs);
 		goto wake_up_and_put;
 	}
-	rtrs_clt_query(sess->rtrs, &attrs);
+
+	err = rtrs_clt_query(sess->rtrs, &attrs);
+	if (err)
+		goto close_rtrs;
+
 	sess->max_io_size = attrs.max_io_size;
 	sess->queue_depth = attrs.queue_depth;
 
-- 
2.30.2



