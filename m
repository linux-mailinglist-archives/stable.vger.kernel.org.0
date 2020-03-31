Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 817901990A6
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731448AbgCaJNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:13:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:60998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730385AbgCaJNb (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:13:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C2B12072E;
        Tue, 31 Mar 2020 09:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585646010;
        bh=nTxRlZrbXFqAbJBx9TxjT33/QaswKJOnZ4Fdd6jn2Cw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R65iZIY3ipqzG4HwcpiJL1cZeIFEyvdd0H/dzZLOCt4lSHcXdqLo/u9fuI2zIhHel
         Y46le8abIaeTrA2JiX6BuVLu/8P0SeuRABKLurRP1QBgTpscydgzwKGNIGvr6fCkeG
         9cw35JgDIGP/onDQQ+K/LoamXr29GBoW4+GcMMyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vasily Averin <vvs@virtuozzo.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 054/155] cgroup-v1: cgroup_pidlist_next should update position index
Date:   Tue, 31 Mar 2020 10:58:14 +0200
Message-Id: <20200331085424.594555371@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085418.274292403@linuxfoundation.org>
References: <20200331085418.274292403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 7f83f4121d8d0..2db582706ec5c 100644
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



