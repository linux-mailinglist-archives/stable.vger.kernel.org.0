Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E96343A6045
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 12:31:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233148AbhFNKcy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Jun 2021 06:32:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233067AbhFNKcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Jun 2021 06:32:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98562611EE;
        Mon, 14 Jun 2021 10:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623666610;
        bh=YDAiIfHevNO5ORjS0kTUf9NlrNBWQqz2BWZOZuDAUng=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TFa5bP0Gq9kQ1M/PGzO6aDHS1wJA//UX9+PXY9ocPkR49ff70k96D8CDu4yRYc+68
         TW6rKH5fGtjscVC5R9qvbsfCH9TYkm/jjsFTZJgYxGBxd+t3/WO4QiKnVL617B14cc
         nQElTpxmV354zpf76Sl9XMhBci5oJt+eScKeKa94=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Kuznetsov <wwfq@yandex-team.ru>,
        Andrey Krasichkov <buglloc@yandex-team.ru>,
        Dmitry Yakunin <zeil@yandex-team.ru>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4.4 21/34] cgroup1: dont allow \n in renaming
Date:   Mon, 14 Jun 2021 12:27:12 +0200
Message-Id: <20210614102642.265837815@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210614102641.582612289@linuxfoundation.org>
References: <20210614102641.582612289@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Kuznetsov <wwfq@yandex-team.ru>

commit b7e24eb1caa5f8da20d405d262dba67943aedc42 upstream.

cgroup_mkdir() have restriction on newline usage in names:
$ mkdir $'/sys/fs/cgroup/cpu/test\ntest2'
mkdir: cannot create directory
'/sys/fs/cgroup/cpu/test\ntest2': Invalid argument

But in cgroup1_rename() such check is missed.
This allows us to make /proc/<pid>/cgroup unparsable:
$ mkdir /sys/fs/cgroup/cpu/test
$ mv /sys/fs/cgroup/cpu/test $'/sys/fs/cgroup/cpu/test\ntest2'
$ echo $$ > $'/sys/fs/cgroup/cpu/test\ntest2'
$ cat /proc/self/cgroup
11:pids:/
10:freezer:/
9:hugetlb:/
8:cpuset:/
7:blkio:/user.slice
6:memory:/user.slice
5:net_cls,net_prio:/
4:perf_event:/
3:devices:/user.slice
2:cpu,cpuacct:/test
test2
1:name=systemd:/
0::/

Signed-off-by: Alexander Kuznetsov <wwfq@yandex-team.ru>
Reported-by: Andrey Krasichkov <buglloc@yandex-team.ru>
Acked-by: Dmitry Yakunin <zeil@yandex-team.ru>
Cc: stable@vger.kernel.org
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3310,6 +3310,10 @@ static int cgroup_rename(struct kernfs_n
 	struct cgroup *cgrp = kn->priv;
 	int ret;
 
+	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
+	if (strchr(new_name_str, '\n'))
+		return -EINVAL;
+
 	if (kernfs_type(kn) != KERNFS_DIR)
 		return -ENOTDIR;
 	if (kn->parent != new_parent)


