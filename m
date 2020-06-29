Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 542A220E85C
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgF2SfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726122AbgF2SfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:15 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BE36246E6;
        Mon, 29 Jun 2020 15:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444030;
        bh=WtMcDFcoVkqmSmFB9fi4UUXLZ3w+ig53ufzkYtp4ooo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zz6A2LX6BpeLhHL6rhURsJfmdtr1o8fF3KVD2uEwfYawQx0K7zBIZU7pYrA3V57nW
         3MDltxNhoI6/IRRnQ5O8pCWSssVS5KR47nFJ7fGixO3PKkehqlcZokDIqq0ynlO828
         hHWLdT7jNQ3H1VLewMDcC/dH/6ozdf5cR3hMjPgM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 137/265] s390/qeth: fix error handling for isolation mode cmds
Date:   Mon, 29 Jun 2020 11:16:10 -0400
Message-Id: <20200629151818.2493727-138-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julian Wiedmann <jwi@linux.ibm.com>

[ Upstream commit e2dfcfba00ba4a414617ef4c5a8501fe21567eb3 ]

Current(?) OSA devices also store their cmd-specific return codes for
SET_ACCESS_CONTROL cmds into the top-level cmd->hdr.return_code.
So once we added stricter checking for the top-level field a while ago,
none of the error logic that rolls back the user's configuration to its
old state is applied any longer.

For this specific cmd, go back to the old model where we peek into the
cmd structure even though the top-level field indicated an error.

Fixes: 686c97ee29c8 ("s390/qeth: fix error handling in adapter command callbacks")
Signed-off-by: Julian Wiedmann <jwi@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/net/qeth_core_main.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
index 569966bdc5138..60d675fefac7d 100644
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -4265,9 +4265,6 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 	int fallback = *(int *)reply->param;
 
 	QETH_CARD_TEXT(card, 4, "setaccb");
-	if (cmd->hdr.return_code)
-		return -EIO;
-	qeth_setadpparms_inspect_rc(cmd);
 
 	access_ctrl_req = &cmd->data.setadapterparms.data.set_access_ctrl;
 	QETH_CARD_TEXT_(card, 2, "rc=%d",
@@ -4277,7 +4274,7 @@ static int qeth_setadpparms_set_access_ctrl_cb(struct qeth_card *card,
 		QETH_DBF_MESSAGE(3, "ERR:SET_ACCESS_CTRL(%#x) on device %x: %#x\n",
 				 access_ctrl_req->subcmd_code, CARD_DEVID(card),
 				 cmd->data.setadapterparms.hdr.return_code);
-	switch (cmd->data.setadapterparms.hdr.return_code) {
+	switch (qeth_setadpparms_inspect_rc(cmd)) {
 	case SET_ACCESS_CTRL_RC_SUCCESS:
 		if (card->options.isolation == ISOLATION_MODE_NONE) {
 			dev_info(&card->gdev->dev,
-- 
2.25.1

