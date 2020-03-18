Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4F218A6C4
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 22:10:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726704AbgCRUxY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 16:53:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:52240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRUxY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 16:53:24 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F407A20777;
        Wed, 18 Mar 2020 20:53:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584564803;
        bh=rY05YLwtbtXzyT165RkLIipQqmrwA6WUFyYk2qA7868=;
        h=From:To:Cc:Subject:Date:From;
        b=MFWj37g4/xef/y5znjvVQhQm+jTIn74eqyqUdQodP0LqvOodTKabK4H7meezvgFsL
         piZnLOYXWkJiX253JXXlDXlLSNHsB5gDLjihnS1qQ4/kiC2wlh8fJ+C1JhYoMZIkXT
         gXjHw/fQSEMz3/j3lG2h4imhV4SASba1Kb2LMRCE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vasily Averin <vvs@virtuozzo.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org
Subject: [PATCH AUTOSEL 5.5 01/84] cgroup-v1: cgroup_pidlist_next should update position index
Date:   Wed, 18 Mar 2020 16:51:58 -0400
Message-Id: <20200318205321.16066-1-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>

[ Upstream commit db8dd9697238be70a6b4f9d0284cd89f59c0e070 ]

if seq_file .next fuction does not change position index,
read after some lseek can generate unexpected output.

 # mount | grep cgroup
 # dd if=/mnt/cgroup.procs bs=1  # normal output
...
1294
1295
1296
1304
1382
584+0 records in
584+0 records out
584 bytes copied

dd: /mnt/cgroup.procs: cannot skip to specified offset
83  <<< generates end of last line
1383  <<< ... and whole last line once again
0+1 records in
0+1 records out
8 bytes copied

dd: /mnt/cgroup.procs: cannot skip to specified offset
1386  <<< generates last line anyway
0+1 records in
0+1 records out
5 bytes copied

https://bugzilla.kernel.org/show_bug.cgi?id=206283
Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup-v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 09f3a413f6f89..84bedb87ae137 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -473,6 +473,7 @@ static void *cgroup_pidlist_next(struct seq_file *s, void *v, loff_t *pos)
 	 */
 	p++;
 	if (p >= end) {
+		(*pos)++;
 		return NULL;
 	} else {
 		*pos = *p;
-- 
2.20.1

