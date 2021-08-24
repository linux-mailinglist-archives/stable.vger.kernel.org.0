Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 492DD3F640F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235197AbhHXRA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238863AbhHXQ7I (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1795261462;
        Tue, 24 Aug 2021 16:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824250;
        bh=rP2yM2hXd0LuColLC7A0n4hJV58ORcttzeuKPDKpF7s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B0OxHGoQy4TFe0OOGikx4bgvJ8ardUVzJfmUhRgr0UP/DG4TGXvGPeu88qzwyZ6A1
         TAXQKaFXG3xbwa+eITeoExIBTXgBSE8FbLinz+Kp78wtlSdKKeev3ovXllMyKyxMbp
         n8BcwJG6b7vVMaVfurX3WldKrMVudhx48a3u2oltV9NfTs2NS8hWESSQt1w8wXmmcs
         W30n/+W40ZgT5FlA+QcRlBmVRhKaIYr9oCcY/WJ31y6Y38B3TFGdiuhNDOKQRRWb/K
         gDI/pF1Id+I52l8bKPcedqiKuAoqgRVG8xATNGZgGS1ypcZQ4yd6AjEsiiaQDTsoen
         3smT7uWGGerJA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ido Schimmel <idosch@nvidia.com>,
        gushengxian <gushengxian@yulong.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 083/127] Revert "flow_offload: action should not be NULL when it is referenced"
Date:   Tue, 24 Aug 2021 12:55:23 -0400
Message-Id: <20210824165607.709387-84-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 69c9eabf8325..dc5c1e69cd9f 100644
--- a/include/net/flow_offload.h
+++ b/include/net/flow_offload.h
@@ -319,14 +319,12 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
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

