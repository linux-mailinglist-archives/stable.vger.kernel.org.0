Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B34B200DA7
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:02:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390545AbgFSO7j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 10:59:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:55832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390539AbgFSO7h (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 10:59:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E151B21D92;
        Fri, 19 Jun 2020 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578777;
        bh=F6y+JKikiv0lny4EyV4nKnkV7zVKpmOK3oss+/+KtNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X2dVOpxieeclDEzFqGqay2zRFheM7TvTDfl0qCbP5qQ7/CGcbX+5rbWbCSYtLm7ai
         KNI3IqMGcw+Uxl9DT68uABv3Zd05d4RpzjENQ6VnSze5T9saXidsxw3Iw6lWUHYB5v
         1udB3Uy38o2/gc3Cbun6AFYn3CtdlehRUvuFj6gU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Ian Rogers <irogers@google.com>, Jiri Olsa <jolsa@redhat.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andrey Zhizhikin <andrey.z@gmail.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Petr Mladek <pmladek@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 122/267] tools api fs: Make xxx__mountpoint() more scalable
Date:   Fri, 19 Jun 2020 16:31:47 +0200
Message-Id: <20200619141654.696573514@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

[ Upstream commit c6fddb28bad26e5472cb7acf7b04cd5126f1a4ab ]

The xxx_mountpoint() interface provided by fs.c finds mount points for
common pseudo filesystems. The first time xxx_mountpoint() is invoked,
it scans the mount table (/proc/mounts) looking for a match. If found,
it is cached. The price to scan /proc/mounts is paid once if the mount
is found.

When the mount point is not found, subsequent calls to xxx_mountpoint()
scan /proc/mounts over and over again.  There is no caching.

This causes a scaling issue in perf record with hugeltbfs__mountpoint().
The function is called for each process found in
synthesize__mmap_events().  If the machine has thousands of processes
and if the /proc/mounts has many entries this could cause major overhead
in perf record. We have observed multi-second slowdowns on some
configurations.

As an example on a laptop:

Before:

  $ sudo umount /dev/hugepages
  $ strace -e trace=openat -o /tmp/tt perf record -a ls
  $ fgrep mounts /tmp/tt
  285

After:

  $ sudo umount /dev/hugepages
  $ strace -e trace=openat -o /tmp/tt perf record -a ls
  $ fgrep mounts /tmp/tt
  1

One could argue that the non-caching in case the moint point is not
found is intentional. That way subsequent calls may discover a moint
point if the sysadmin mounts the filesystem. But the same argument could
be made against caching the mount point. It could be unmounted causing
errors.  It all depends on the intent of the interface. This patch
assumes it is expected to scan /proc/mounts once. The patch documents
the caching behavior in the fs.h header file.

An alternative would be to just fix perf record. But it would solve the
problem with hugetlbs__mountpoint() but there could be similar issues
(possibly down the line) with other xxx_mountpoint() calls in perf or
other tools.

Signed-off-by: Stephane Eranian <eranian@google.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Acked-by: Jiri Olsa <jolsa@redhat.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andrey Zhizhikin <andrey.z@gmail.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Link: http://lore.kernel.org/lkml/20200402154357.107873-3-irogers@google.com
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/api/fs/fs.c | 17 +++++++++++++++++
 tools/lib/api/fs/fs.h | 12 ++++++++++++
 2 files changed, 29 insertions(+)

diff --git a/tools/lib/api/fs/fs.c b/tools/lib/api/fs/fs.c
index bd021a0eeef8..4cc69675c2a9 100644
--- a/tools/lib/api/fs/fs.c
+++ b/tools/lib/api/fs/fs.c
@@ -90,6 +90,7 @@ struct fs {
 	const char * const	*mounts;
 	char			 path[PATH_MAX];
 	bool			 found;
+	bool			 checked;
 	long			 magic;
 };
 
@@ -111,31 +112,37 @@ static struct fs fs__entries[] = {
 		.name	= "sysfs",
 		.mounts	= sysfs__fs_known_mountpoints,
 		.magic	= SYSFS_MAGIC,
+		.checked = false,
 	},
 	[FS__PROCFS] = {
 		.name	= "proc",
 		.mounts	= procfs__known_mountpoints,
 		.magic	= PROC_SUPER_MAGIC,
+		.checked = false,
 	},
 	[FS__DEBUGFS] = {
 		.name	= "debugfs",
 		.mounts	= debugfs__known_mountpoints,
 		.magic	= DEBUGFS_MAGIC,
+		.checked = false,
 	},
 	[FS__TRACEFS] = {
 		.name	= "tracefs",
 		.mounts	= tracefs__known_mountpoints,
 		.magic	= TRACEFS_MAGIC,
+		.checked = false,
 	},
 	[FS__HUGETLBFS] = {
 		.name	= "hugetlbfs",
 		.mounts = hugetlbfs__known_mountpoints,
 		.magic	= HUGETLBFS_MAGIC,
+		.checked = false,
 	},
 	[FS__BPF_FS] = {
 		.name	= "bpf",
 		.mounts = bpf_fs__known_mountpoints,
 		.magic	= BPF_FS_MAGIC,
+		.checked = false,
 	},
 };
 
@@ -158,6 +165,7 @@ static bool fs__read_mounts(struct fs *fs)
 	}
 
 	fclose(fp);
+	fs->checked = true;
 	return fs->found = found;
 }
 
@@ -220,6 +228,7 @@ static bool fs__env_override(struct fs *fs)
 		return false;
 
 	fs->found = true;
+	fs->checked = true;
 	strncpy(fs->path, override_path, sizeof(fs->path) - 1);
 	fs->path[sizeof(fs->path) - 1] = '\0';
 	return true;
@@ -246,6 +255,14 @@ static const char *fs__mountpoint(int idx)
 	if (fs->found)
 		return (const char *)fs->path;
 
+	/* the mount point was already checked for the mount point
+	 * but and did not exist, so return NULL to avoid scanning again.
+	 * This makes the found and not found paths cost equivalent
+	 * in case of multiple calls.
+	 */
+	if (fs->checked)
+		return NULL;
+
 	return fs__get_mountpoint(fs);
 }
 
diff --git a/tools/lib/api/fs/fs.h b/tools/lib/api/fs/fs.h
index 92d03b8396b1..3b70003e7cfb 100644
--- a/tools/lib/api/fs/fs.h
+++ b/tools/lib/api/fs/fs.h
@@ -18,6 +18,18 @@
 	const char *name##__mount(void);	\
 	bool name##__configured(void);		\
 
+/*
+ * The xxxx__mountpoint() entry points find the first match mount point for each
+ * filesystems listed below, where xxxx is the filesystem type.
+ *
+ * The interface is as follows:
+ *
+ * - If a mount point is found on first call, it is cached and used for all
+ *   subsequent calls.
+ *
+ * - If a mount point is not found, NULL is returned on first call and all
+ *   subsequent calls.
+ */
 FS(sysfs)
 FS(procfs)
 FS(debugfs)
-- 
2.25.1



