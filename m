Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63D940DFA1
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:11:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229461AbhIPQM0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:12:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236303AbhIPQJ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:09:58 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1880761246;
        Thu, 16 Sep 2021 16:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808498;
        bh=arSCfkk7/RnR3KdEptcjyTcAXhYHCVwqIsj5tU0TikQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uAjbE4KpS4ilB1my4OgwPbFtnQ3SEhpPXXxpOwcOvjIOGpsu75Uj3GVgF6GmOpO2x
         Hn0qgZRjYn2PAwn57zQtRAyjX7YjkOEjxSIJypTFa0OZmkOZU1WgmGLlGWdI0ENWQi
         bDqJwW+jiriBhg3ZLTqNiwytFG76ScorevQT1esM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martynas Pumputis <m@lambda.lt>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 114/306] libbpf: Fix reuse of pinned map on older kernel
Date:   Thu, 16 Sep 2021 17:57:39 +0200
Message-Id: <20210916155757.959028609@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martynas Pumputis <m@lambda.lt>

[ Upstream commit 97eb31384af943d6b97eb5947262cee4ef25cb87 ]

When loading a BPF program with a pinned map, the loader checks whether
the pinned map can be reused, i.e. their properties match. To derive
such of the pinned map, the loader invokes BPF_OBJ_GET_INFO_BY_FD and
then does the comparison.

Unfortunately, on < 4.12 kernels the BPF_OBJ_GET_INFO_BY_FD is not
available, so loading the program fails with the following error:

	libbpf: failed to get map info for map FD 5: Invalid argument
	libbpf: couldn't reuse pinned map at
		'/sys/fs/bpf/tc/globals/cilium_call_policy': parameter
		mismatch"
	libbpf: map 'cilium_call_policy': error reusing pinned map
	libbpf: map 'cilium_call_policy': failed to create:
		Invalid argument(-22)
	libbpf: failed to load object 'bpf_overlay.o'

To fix this, fallback to derivation of the map properties via
/proc/$PID/fdinfo/$MAP_FD if BPF_OBJ_GET_INFO_BY_FD fails with EINVAL,
which can be used as an indicator that the kernel doesn't support
the latter.

Signed-off-by: Martynas Pumputis <m@lambda.lt>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/bpf/20210712125552.58705-1-m@lambda.lt
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 48 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 45 insertions(+), 3 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 28923b776cdc..0dad862b3b9d 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3613,6 +3613,42 @@ static int bpf_map_find_btf_info(struct bpf_object *obj, struct bpf_map *map)
 	return 0;
 }
 
+static int bpf_get_map_info_from_fdinfo(int fd, struct bpf_map_info *info)
+{
+	char file[PATH_MAX], buff[4096];
+	FILE *fp;
+	__u32 val;
+	int err;
+
+	snprintf(file, sizeof(file), "/proc/%d/fdinfo/%d", getpid(), fd);
+	memset(info, 0, sizeof(*info));
+
+	fp = fopen(file, "r");
+	if (!fp) {
+		err = -errno;
+		pr_warn("failed to open %s: %d. No procfs support?\n", file,
+			err);
+		return err;
+	}
+
+	while (fgets(buff, sizeof(buff), fp)) {
+		if (sscanf(buff, "map_type:\t%u", &val) == 1)
+			info->type = val;
+		else if (sscanf(buff, "key_size:\t%u", &val) == 1)
+			info->key_size = val;
+		else if (sscanf(buff, "value_size:\t%u", &val) == 1)
+			info->value_size = val;
+		else if (sscanf(buff, "max_entries:\t%u", &val) == 1)
+			info->max_entries = val;
+		else if (sscanf(buff, "map_flags:\t%i", &val) == 1)
+			info->map_flags = val;
+	}
+
+	fclose(fp);
+
+	return 0;
+}
+
 int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 {
 	struct bpf_map_info info = {};
@@ -3621,6 +3657,8 @@ int bpf_map__reuse_fd(struct bpf_map *map, int fd)
 	char *new_name;
 
 	err = bpf_obj_get_info_by_fd(fd, &info, &len);
+	if (err && errno == EINVAL)
+		err = bpf_get_map_info_from_fdinfo(fd, &info);
 	if (err)
 		return err;
 
@@ -4032,12 +4070,16 @@ static bool map_is_reuse_compat(const struct bpf_map *map, int map_fd)
 	struct bpf_map_info map_info = {};
 	char msg[STRERR_BUFSIZE];
 	__u32 map_info_len;
+	int err;
 
 	map_info_len = sizeof(map_info);
 
-	if (bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len)) {
-		pr_warn("failed to get map info for map FD %d: %s\n",
-			map_fd, libbpf_strerror_r(errno, msg, sizeof(msg)));
+	err = bpf_obj_get_info_by_fd(map_fd, &map_info, &map_info_len);
+	if (err && errno == EINVAL)
+		err = bpf_get_map_info_from_fdinfo(map_fd, &map_info);
+	if (err) {
+		pr_warn("failed to get map info for map FD %d: %s\n", map_fd,
+			libbpf_strerror_r(errno, msg, sizeof(msg)));
 		return false;
 	}
 
-- 
2.30.2



