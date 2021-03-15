Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 818E933B80C
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:04:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231271AbhCOOB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:01:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232808AbhCON75 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 09:59:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A3CEF64F16;
        Mon, 15 Mar 2021 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816779;
        bh=V5zeatwusUhooNPoZJu1Az09+q1MdFbTpey8zMyqGkM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uKLieP/TlKBdnYY8l9Y1/C4/S0/4DDawc14JdsMsT+A3DOQPyVzo/FzVDt3zInpAi
         8TVlcDJYDjC+dZEt5eW8vqTLJYbg8xSamnj+gViO03tnMO9QCIgpxWQtqs92kKsJba
         R5xi6k80Jlp/971cE7fv48X2B9/wVfgGdUkegxIo=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Julian Wiedmann <jwi@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/290] s390/qeth: remove QETH_QDIO_BUF_HANDLED_DELAYED state
Date:   Mon, 15 Mar 2021 14:53:23 +0100
Message-Id: <20210315135545.621916698@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 75cf3854dcdf7b5c583538cae12ffa054d237d93 ]

Reuse the QETH_QDIO_BUF_EMPTY state to indicate that a TX buffer has
been completed with a QAOB notification, and may be cleaned up by
qeth_cleanup_handled_pending().

Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core.h      | 2 --
 drivers/s390/net/qeth_core_main.c | 5 ++---
 2 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/s390/net/qeth_core.h b/drivers/s390/net/qeth_core.h
index 2f7e06ec9a30..ea969b8fe687 100644
--- a/drivers/s390/net/qeth_core.h
+++ b/drivers/s390/net/qeth_core.h
@@ -424,8 +424,6 @@ enum qeth_qdio_out_buffer_state {
 	/* Received QAOB notification on CQ: */
 	QETH_QDIO_BUF_QAOB_OK,
 	QETH_QDIO_BUF_QAOB_ERROR,
-	/* Handled via transfer pending / completion queue. */
-	QETH_QDIO_BUF_HANDLED_DELAYED,
 };
 
 struct qeth_qdio_out_buffer {
diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 78a866424022..e2cdb5c2fc66 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -477,8 +477,7 @@ static void qeth_cleanup_handled_pending(struct qeth_qdio_out_q *q, int bidx,
 
 		while (c) {
 			if (forced_cleanup ||
-			    atomic_read(&c->state) ==
-			      QETH_QDIO_BUF_HANDLED_DELAYED) {
+			    atomic_read(&c->state) == QETH_QDIO_BUF_EMPTY) {
 				struct qeth_qdio_out_buffer *f = c;
 
 				QETH_CARD_TEXT(f->q->card, 5, "fp");
@@ -549,7 +548,7 @@ static void qeth_qdio_handle_aob(struct qeth_card *card,
 				kmem_cache_free(qeth_core_header_cache, data);
 		}
 
-		atomic_set(&buffer->state, QETH_QDIO_BUF_HANDLED_DELAYED);
+		atomic_set(&buffer->state, QETH_QDIO_BUF_EMPTY);
 		break;
 	default:
 		WARN_ON_ONCE(1);
-- 
2.30.1



