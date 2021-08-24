Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 033933F653B
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239502AbhHXRKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:52370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239859AbhHXRJk (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B80B61A52;
        Tue, 24 Aug 2021 17:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824422;
        bh=AESHKDUZqNd5dXqLnLIv1OlWBblWwGqbJADwnOLV8YE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RYit3yMTnYft5ORaBt6Br7AMNH8c1a+7aRUC/rhUWsNyC6qNFF1GrliNLi+PRSNri
         DD97egVpwyjJkZQ+CSPxnP+Jih6aLSD/U0cQ4dCBbFN88D0rC3JJh//AQsow1uEUuD
         +MEsbZ71Ik42EnEHP8Grnm19PgVr2Dtm7o1ScWshWT1nqmUcgx4TxgXjfz6nNCM+eG
         HskrJUviRE9EK2v7SqiHU1Zep1AVLIqnAjXJsbTkorhvw/t/EAMzrMo1+7LDCU5ys9
         4DUNrVbbor5ahkvLOzN1Mtsn575FN/F8Snb6v4eTHaRwicLxRLtuH6LosvM572a05H
         ItnoFdth0NCZQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>,
        gushengxian <gushengxian@yulong.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 72/98] Revert "flow_offload: action should not be NULL when it is referenced"
Date:   Tue, 24 Aug 2021 12:58:42 -0400
Message-Id: <20210824165908.709932-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit fa05bdb89b01b098aad19ec0ebc4d1cc7b11177e ]

This reverts commit 9ea3e52c5bc8bb4a084938dc1e3160643438927a.

Cited commit added a check to make sure 'action' is not NULL, but
'action' is already dereferenced before the check, when calling
flow_offload_has_one_action().

Therefore, the check does not make any sense and results in a smatch
warning:

include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn:
variable dereferenced before check 'action' (see line 319)

Fix by reverting this commit.

Cc: gushengxian <gushengxian@yulong.com>
Fixes: 9ea3e52c5bc8 ("flow_offload: action should not be NULL when it is referenced")
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://lore.kernel.org/r/20210819105842.1315705-1-idosch@idosch.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/flow_offload.h | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
index 161b90979038..123b1e9ea304 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -312,14 +312,12 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
 	if (flow_offload_has_one_action(action))
 		return true;
 
-	if (action) {
-		flow_action_for_each(i, action_entry, action) {
-			if (i && action_entry->hw_stats != last_hw_stats) {
-				NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
-				return false;
-			}
-			last_hw_stats = action_entry->hw_stats;
+	flow_action_for_each(i, action_entry, action) {
+		if (i && action_entry->hw_stats != last_hw_stats) {
+			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
+			return false;
 		}
+		last_hw_stats = action_entry->hw_stats;
 	}
 	return true;
 }
-- 
2.30.2

