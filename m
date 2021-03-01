Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4506F328FCE
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:01:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242513AbhCAT61 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:58:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:55186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235786AbhCATpa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:45:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ED9D650D3;
        Mon,  1 Mar 2021 17:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620763;
        bh=ELZikx7g3N74HYqa74de0f9j+RRsCSv1vYuRnXBIa+U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M+HTizxLMkX5Z6MfIYufmRXegaRruk2zTZIrIjxbxEmjZs2vIWUiSb0KtsXk8G2hI
         HWtbnoyvskmVTGtp3wFde6yJOuuw6BVuNUzoIi9epReYE/LjP5lD8XmuaHHhIf+ecF
         PoVJ3Uca/SnN8mD9LfMhvAJEJk5HcMMk6DsupWw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 240/775] perf/arm-cmn: Fix PMU instance naming
Date:   Mon,  1 Mar 2021 17:06:48 +0100
Message-Id: <20210301161213.491982586@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 79d7c3dca99fa96033695ddf5d495b775a3a137b ]

Although it's neat to avoid the suffix for the typical case of a
single PMU, it means systems with multiple CMN instances end up with
inconsistent naming. I think it also breaks perf tool's "uncore alias"
logic if the common instance prefix is also the full name of one.

Avoid any surprises by not trying to be clever and simply numbering
every instance, even when it might technically prove redundant.

Fixes: 0ba64770a2f2 ("perf: Add Arm CMN-600 PMU driver")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/649a2281233f193d59240b13ed91b57337c77b32.1611839564.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/perf/arm-cmn.rst |  2 +-
 drivers/perf/arm-cmn.c                     | 13 ++++---------
 2 files changed, 5 insertions(+), 10 deletions(-)

diff --git a/Documentation/admin-guide/perf/arm-cmn.rst b/Documentation/admin-guide/perf/arm-cmn.rst
index 0e48093460140..796e25b7027b2 100644
--- a/Documentation/admin-guide/perf/arm-cmn.rst
+++ b/Documentation/admin-guide/perf/arm-cmn.rst
@@ -17,7 +17,7 @@ PMU events
 ----------
 
 The PMU driver registers a single PMU device for the whole interconnect,
-see /sys/bus/event_source/devices/arm_cmn. Multi-chip systems may link
+see /sys/bus/event_source/devices/arm_cmn_0. Multi-chip systems may link
 more than one CMN together via external CCIX links - in this situation,
 each mesh counts its own events entirely independently, and additional
 PMU devices will be named arm_cmn_{1..n}.
diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index a76ff594f3ca4..f3071b5ddaaef 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -1502,7 +1502,7 @@ static int arm_cmn_probe(struct platform_device *pdev)
 	struct arm_cmn *cmn;
 	const char *name;
 	static atomic_t id;
-	int err, rootnode, this_id;
+	int err, rootnode;
 
 	cmn = devm_kzalloc(&pdev->dev, sizeof(*cmn), GFP_KERNEL);
 	if (!cmn)
@@ -1549,14 +1549,9 @@ static int arm_cmn_probe(struct platform_device *pdev)
 		.cancel_txn = arm_cmn_end_txn,
 	};
 
-	this_id = atomic_fetch_inc(&id);
-	if (this_id == 0) {
-		name = "arm_cmn";
-	} else {
-		name = devm_kasprintf(cmn->dev, GFP_KERNEL, "arm_cmn_%d", this_id);
-		if (!name)
-			return -ENOMEM;
-	}
+	name = devm_kasprintf(cmn->dev, GFP_KERNEL, "arm_cmn_%d", atomic_fetch_inc(&id));
+	if (!name)
+		return -ENOMEM;
 
 	err = cpuhp_state_add_instance(arm_cmn_hp_state, &cmn->cpuhp_node);
 	if (err)
-- 
2.27.0



