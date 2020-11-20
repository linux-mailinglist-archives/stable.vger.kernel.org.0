Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51EFB2BA88E
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728493AbgKTLJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:09:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:55132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728498AbgKTLHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B6882245B;
        Fri, 20 Nov 2020 11:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870432;
        bh=t9uLRtx0vP9bKuog9h7FCpvLi1AhNsKDwZrA1tIGNYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oQ874c1C7N/hDumxS12XdaufUF65YqvVuBgbiV3katK31zdK5uGSnC5igl2bzss4o
         +Urmwb5AzkgnOUpYO+R/OFRugqVq63NCJ+jAz9pnnA02AFFwaggluWmnBBzB8XsQpT
         nqZuGg/2AkDXbJZVVc/5OqfEbsJK9VyeHK2z7nHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eran Ben Elisha <eranbe@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Timo Rothenpieler <timo@rothenpieler.org>
Subject: [PATCH 5.4 10/17] net/mlx5: Add retry mechanism to the command entry index allocation
Date:   Fri, 20 Nov 2020 12:03:37 +0100
Message-Id: <20201120104541.571471236@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.058449969@linuxfoundation.org>
References: <20201120104541.058449969@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eran Ben Elisha <eranbe@nvidia.com>

commit 410bd754cd73c4a2ac3856d9a03d7b08f9c906bf upstream.

It is possible that new command entry index allocation will temporarily
fail. The new command holds the semaphore, so it means that a free entry
should be ready soon. Add one second retry mechanism before returning an
error.

Patch "net/mlx5: Avoid possible free of command entry while timeout comp
handler" increase the possibility to bump into this temporarily failure
as it delays the entry index release for non-callback commands.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: Eran Ben Elisha <eranbe@nvidia.com>
Reviewed-by: Moshe Shemesh <moshe@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Cc: Timo Rothenpieler <timo@rothenpieler.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c |   21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -883,6 +883,25 @@ static bool opcode_allowed(struct mlx5_c
 	return cmd->allowed_opcode == opcode;
 }
 
+static int cmd_alloc_index_retry(struct mlx5_cmd *cmd)
+{
+	unsigned long alloc_end = jiffies + msecs_to_jiffies(1000);
+	int idx;
+
+retry:
+	idx = cmd_alloc_index(cmd);
+	if (idx < 0 && time_before(jiffies, alloc_end)) {
+		/* Index allocation can fail on heavy load of commands. This is a temporary
+		 * situation as the current command already holds the semaphore, meaning that
+		 * another command completion is being handled and it is expected to release
+		 * the entry index soon.
+		 */
+		cpu_relax();
+		goto retry;
+	}
+	return idx;
+}
+
 static void cmd_work_handler(struct work_struct *work)
 {
 	struct mlx5_cmd_work_ent *ent = container_of(work, struct mlx5_cmd_work_ent, work);
@@ -900,7 +919,7 @@ static void cmd_work_handler(struct work
 	sem = ent->page_queue ? &cmd->pages_sem : &cmd->sem;
 	down(sem);
 	if (!ent->page_queue) {
-		alloc_ret = cmd_alloc_index(cmd);
+		alloc_ret = cmd_alloc_index_retry(cmd);
 		if (alloc_ret < 0) {
 			mlx5_core_err(dev, "failed to allocate command entry\n");
 			if (ent->callback) {


