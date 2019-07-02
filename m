Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F7095CBA2
	for <lists+stable@lfdr.de>; Tue,  2 Jul 2019 10:15:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727943AbfGBIF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Jul 2019 04:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727443AbfGBIF0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Jul 2019 04:05:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFDA420659;
        Tue,  2 Jul 2019 08:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562054725;
        bh=7VoB28kTHwj0Tl6LL1H7TgWAL359xaX2QKUoNu45dKM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=grvwCBIHSGOP4EGZ1lsjytlAwSfTfYPteqYsNamuQHZpo90Quhk6uF04OVqiXmiTT
         XVQet9hEXgIWs98UkhFmuS121kR3vCpcRdqlw0eUgFDcMW3F3y9+xOdeiAIrutPOij
         XpgrYPWa/yb2gQiUU0P/ebvWiKZQraKWbTootl4Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tomas Bortoli <tomasbortoli@gmail.com>,
        Jun Piao <piaojun@huawei.com>,
        Dominique Martinet <dominique.martinet@cea.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/72] 9p: Rename req to rreq in trans_fd
Date:   Tue,  2 Jul 2019 10:01:15 +0200
Message-Id: <20190702080125.346857741@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190702080124.564652899@linuxfoundation.org>
References: <20190702080124.564652899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6d35190f395316916c8bb4aabd35a182890bf856 ]

In struct p9_conn, rename req to rreq as it is used by the read routine.

Link: http://lkml.kernel.org/r/20180903160321.2181-1-tomasbortoli@gmail.com
Signed-off-by: Tomas Bortoli <tomasbortoli@gmail.com>
Suggested-by: Jun Piao <piaojun@huawei.com>
Signed-off-by: Dominique Martinet <dominique.martinet@cea.fr>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/9p/trans_fd.c | 30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index aca528722183..12559c474dde 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -131,7 +131,7 @@ struct p9_conn {
 	int err;
 	struct list_head req_list;
 	struct list_head unsent_req_list;
-	struct p9_req_t *req;
+	struct p9_req_t *rreq;
 	struct p9_req_t *wreq;
 	char tmp_buf[7];
 	struct p9_fcall rc;
@@ -323,7 +323,7 @@ static void p9_read_work(struct work_struct *work)
 	m->rc.offset += err;
 
 	/* header read in */
-	if ((!m->req) && (m->rc.offset == m->rc.capacity)) {
+	if ((!m->rreq) && (m->rc.offset == m->rc.capacity)) {
 		p9_debug(P9_DEBUG_TRANS, "got new header\n");
 
 		/* Header size */
@@ -347,23 +347,23 @@ static void p9_read_work(struct work_struct *work)
 			 "mux %p pkt: size: %d bytes tag: %d\n",
 			 m, m->rc.size, m->rc.tag);
 
-		m->req = p9_tag_lookup(m->client, m->rc.tag);
-		if (!m->req || (m->req->status != REQ_STATUS_SENT)) {
+		m->rreq = p9_tag_lookup(m->client, m->rc.tag);
+		if (!m->rreq || (m->rreq->status != REQ_STATUS_SENT)) {
 			p9_debug(P9_DEBUG_ERROR, "Unexpected packet tag %d\n",
 				 m->rc.tag);
 			err = -EIO;
 			goto error;
 		}
 
-		if (!m->req->rc.sdata) {
+		if (!m->rreq->rc.sdata) {
 			p9_debug(P9_DEBUG_ERROR,
 				 "No recv fcall for tag %d (req %p), disconnecting!\n",
-				 m->rc.tag, m->req);
-			m->req = NULL;
+				 m->rc.tag, m->rreq);
+			m->rreq = NULL;
 			err = -EIO;
 			goto error;
 		}
-		m->rc.sdata = m->req->rc.sdata;
+		m->rc.sdata = m->rreq->rc.sdata;
 		memcpy(m->rc.sdata, m->tmp_buf, m->rc.capacity);
 		m->rc.capacity = m->rc.size;
 	}
@@ -371,21 +371,21 @@ static void p9_read_work(struct work_struct *work)
 	/* packet is read in
 	 * not an else because some packets (like clunk) have no payload
 	 */
-	if ((m->req) && (m->rc.offset == m->rc.capacity)) {
+	if ((m->rreq) && (m->rc.offset == m->rc.capacity)) {
 		p9_debug(P9_DEBUG_TRANS, "got new packet\n");
-		m->req->rc.size = m->rc.offset;
+		m->rreq->rc.size = m->rc.offset;
 		spin_lock(&m->client->lock);
-		if (m->req->status != REQ_STATUS_ERROR)
+		if (m->rreq->status != REQ_STATUS_ERROR)
 			status = REQ_STATUS_RCVD;
-		list_del(&m->req->req_list);
+		list_del(&m->rreq->req_list);
 		/* update req->status while holding client->lock  */
-		p9_client_cb(m->client, m->req, status);
+		p9_client_cb(m->client, m->rreq, status);
 		spin_unlock(&m->client->lock);
 		m->rc.sdata = NULL;
 		m->rc.offset = 0;
 		m->rc.capacity = 0;
-		p9_req_put(m->req);
-		m->req = NULL;
+		p9_req_put(m->rreq);
+		m->rreq = NULL;
 	}
 
 end_clear:
-- 
2.20.1



