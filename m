Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2541924BACC
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:18:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729191AbgHTMRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726925AbgHTJ4d (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:56:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C38832067C;
        Thu, 20 Aug 2020 09:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917393;
        bh=WBgfNVb4k44s9KC7OFjmYwafkNkP4GWt5fO3r7F+LYI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dohGRD9tu4qYSUdsX/lHBQr3vkGpgRn/aSTQs+9BNJM2XZK7oPzGyiD1/593zN1d4
         CpQTUfx56KapxdX/sK5C8mlXPKZqpVo8jgz/CBkdz5DjQM2JeAsPbFXR/l8kMIpQSK
         VIW8UtJCqFqgczE1zo5uV7DJMl6BGIYtPrhmuqPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+77a25acfa0382e06ab23@syzkaller.appspotmail.com,
        Wang Hai <wanghai38@huawei.com>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 016/212] 9p/trans_fd: Fix concurrency del of req_list in p9_fd_cancelled/p9_read_work
Date:   Thu, 20 Aug 2020 11:19:49 +0200
Message-Id: <20200820091603.156368680@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

[ Upstream commit 74d6a5d5662975aed7f25952f62efbb6f6dadd29 ]

p9_read_work and p9_fd_cancelled may be called concurrently.
In some cases, req->req_list may be deleted by both p9_read_work
and p9_fd_cancelled.

We can fix it by ignoring replies associated with a cancelled
request and ignoring cancelled request if message has been received
before lock.

Link: http://lkml.kernel.org/r/20200612090833.36149-1-wanghai38@huawei.com
Fixes: 60ff779c4abb ("9p: client: remove unused code and any reference to "cancelled" function")
Cc: <stable@vger.kernel.org> # v3.12+
Reported-by: syzbot+77a25acfa0382e06ab23@syzkaller.appspotmail.com
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Signed-off-by: Dominique Martinet <asmadeus@codewreck.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index 91f71958c2e16..b0f47563f0bf3 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -377,6 +377,10 @@ static void p9_read_work(struct work_struct *work)
 		if (m->req->status == REQ_STATUS_SENT) {
 			list_del(&m->req->req_list);
 			p9_client_cb(m->client, m->req, REQ_STATUS_RCVD);
+		} else if (m->req->status == REQ_STATUS_FLSHD) {
+			/* Ignore replies associated with a cancelled request. */
+			p9_debug(P9_DEBUG_TRANS,
+				 "Ignore replies associated with a cancelled request\n");
 		} else {
 			spin_unlock(&m->client->lock);
 			p9_debug(P9_DEBUG_ERROR,
@@ -717,11 +721,20 @@ static int p9_fd_cancelled(struct p9_client *client, struct p9_req_t *req)
 {
 	p9_debug(P9_DEBUG_TRANS, "client %p req %p\n", client, req);
 
+	spin_lock(&client->lock);
+	/* Ignore cancelled request if message has been received
+	 * before lock.
+	 */
+	if (req->status == REQ_STATUS_RCVD) {
+		spin_unlock(&client->lock);
+		return 0;
+	}
+
 	/* we haven't received a response for oldreq,
 	 * remove it from the list.
 	 */
-	spin_lock(&client->lock);
 	list_del(&req->req_list);
+	req->status = REQ_STATUS_FLSHD;
 	spin_unlock(&client->lock);
 
 	return 0;
-- 
2.25.1



