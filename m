Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0F269670
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 17:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388265AbfGOOHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:07:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388409AbfGOOHu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:07:50 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1A942081C;
        Mon, 15 Jul 2019 14:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563199670;
        bh=OYEwGVmIPNLLr8M63NDjwv0pbARc87LufXdORz3byx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sI8b6/goaoucA/9dg6FbigtrLBOqMDO3D3XHyzbARuUu/1QeHs6GUYhR83jdjKPpl
         WusfKl2Yqk6vbhkFAscHzlFrQ9DXzqlkMRVZkBXgkVYYGkx6qfQftY/eODrmaiJr0S
         KDFPUU1k0k8XPitxbuxZqnCZmn31m/nHyvFff12M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Sasha Levin <sashal@kernel.org>, linux-s390@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 067/219] s390/qdio: handle PENDING state for QEBSM devices
Date:   Mon, 15 Jul 2019 10:01:08 -0400
Message-Id: <20190715140341.6443-67-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715140341.6443-1-sashal@kernel.org>
References: <20190715140341.6443-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 04310324c6f482921c071444833e70fe861b73d9 ]

When a CQ-enabled device uses QEBSM for SBAL state inspection,
get_buf_states() can return the PENDING state for an Output Queue.
get_outbound_buffer_frontier() isn't prepared for this, and any PENDING
buffer will permanently stall all further completion processing on this
Queue.

This isn't a concern for non-QEBSM devices, as get_buf_states() for such
devices will manually turn PENDING buffers into EMPTY ones.

Fixes: 104ea556ee7f ("qdio: support asynchronous delivery of storage blocks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/cio/qdio_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/s390/cio/qdio_main.c b/drivers/s390/cio/qdio_main.c
index 9537e656e927..06b94b2ee199 100644
--- a/drivers/s390/cio/qdio_main.c
+++ b/drivers/s390/cio/qdio_main.c
@@ -738,6 +738,7 @@ static int get_outbound_buffer_frontier(struct qdio_q *q)
 
 	switch (state) {
 	case SLSB_P_OUTPUT_EMPTY:
+	case SLSB_P_OUTPUT_PENDING:
 		/* the adapter got it */
 		DBF_DEV_EVENT(DBF_INFO, q->irq_ptr,
 			"out empty:%1d %02x", q->nr, count);
-- 
2.20.1

