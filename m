Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731A0419C12
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237194AbhI0RZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:25:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237216AbhI0RWb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A4DA861356;
        Mon, 27 Sep 2021 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762860;
        bh=wrxX2eap+yMjhNiAV493M40hjD0C94S0mhDnQ1OmbMo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b3ozN5fA+S4FH+lBWfuLsUGfQGJ28hI3dtPqtDtAHINOy/EytIVe0nrq3gq7AACBj
         BI7b6tSxvoJjXiUxL7d4e979rt1vWEuO0EQSPEkUZmNVXJyCZ/39GiXNHpYGT6fTaK
         EgTZipeh1BNNlnpsp3+GPQ6x7CVmAuwa6ZLZ4CMk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Raspl <raspl@linux.ibm.com>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        Alexandra Winter <wintera@linux.ibm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>
Subject: [PATCH 5.14 078/162] s390/qeth: fix NULL deref in qeth_clear_working_pool_list()
Date:   Mon, 27 Sep 2021 19:02:04 +0200
Message-Id: <20210927170236.156926418@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit 248f064af222a1f97ee02c84a98013dfbccad386 ]

When qeth_set_online() calls qeth_clear_working_pool_list() to roll
back after an error exit from qeth_hardsetup_card(), we are at risk of
accessing card->qdio.in_q before it was allocated by
qeth_alloc_qdio_queues() via qeth_mpc_initialize().

qeth_clear_working_pool_list() then dereferences NULL, and by writing to
queue->bufs[i].pool_entry scribbles all over the CPU's lowcore.
Resulting in a crash when those lowcore areas are used next (eg. on
the next machine-check interrupt).

Such a scenario would typically happen when the device is first set
online and its queues aren't allocated yet. An early IO error or certain
misconfigs (eg. mismatched transport mode, bad portno) then cause us to
error out from qeth_hardsetup_card() with card->qdio.in_q still being
NULL.

Fix it by checking the pointer for NULL before accessing it.

Note that we also have (rare) paths inside qeth_mpc_initialize() where
a configuration change can cause us to free the existing queues,
expecting that subsequent code will allocate them again. If we then
error out before that re-allocation happens, the same bug occurs.

Fixes: eff73e16ee11 ("s390/qeth: tolerate pre-filled RX buffer")
Reported-by: Stefan Raspl <raspl@linux.ibm.com>
Root-caused-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Reviewed-by: Alexandra Winter <wintera@linux.ibm.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 62f88ccbd03f..51f7f4e680c3 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -207,6 +207,9 @@ static void qeth_clear_working_pool_list(struct qeth_card *card)
 				 &card->qdio.in_buf_pool.entry_list, list)
 		list_del(&pool_entry->list);
 
+	if (!queue)
+		return;
+
 	for (i = 0; i < ARRAY_SIZE(queue->bufs); i++)
 		queue->bufs[i].pool_entry = NULL;
 }
-- 
2.33.0



