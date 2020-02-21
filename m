Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 72D9A167676
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730858AbgBUIfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:35:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730543AbgBUIIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:08:07 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B5B620578;
        Fri, 21 Feb 2020 08:08:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582272486;
        bh=MMvYnTh/h4R2QL5OTCI5uAa2vYTgJROedZx4TjC11Sw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z0qFLQvkU5OUyra2SBtAWOAg89V1XyvGTtDicHfyGaSX4lg1b83PKaQdz0lilkggv
         Sx30QVU60EVZhA5Iqlx2C6k6/H036J/cGg/u9OIvGQ2RRs9VTgPWy1K4b2gS/+sx7P
         FH2fsafwyHmAMb3QMxnv+j7xOCCces1SW+g2S7Dg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hechao Li <hechaol@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 161/344] bpf: Print error message for bpftool cgroup show
Date:   Fri, 21 Feb 2020 08:39:20 +0100
Message-Id: <20200221072403.456352807@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072349.335551332@linuxfoundation.org>
References: <20200221072349.335551332@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hechao Li <hechaol@fb.com>

[ Upstream commit 1162f844030ac1ac7321b5e8f6c9badc7a11428f ]

Currently, when bpftool cgroup show <path> has an error, no error
message is printed. This is confusing because the user may think the
result is empty.

Before the change:

$ bpftool cgroup show /sys/fs/cgroup
ID       AttachType      AttachFlags     Name
$ echo $?
255

After the change:
$ ./bpftool cgroup show /sys/fs/cgroup
Error: can't query bpf programs attached to /sys/fs/cgroup: Operation
not permitted

v2: Rename check_query_cgroup_progs to cgroup_has_attached_progs

Signed-off-by: Hechao Li <hechaol@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191224011742.3714301-1-hechaol@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 56 ++++++++++++++++++++++++++------------
 1 file changed, 39 insertions(+), 17 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index 1ef45e55039e1..2f017caa678dc 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -117,6 +117,25 @@ static int count_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type)
 	return prog_cnt;
 }
 
+static int cgroup_has_attached_progs(int cgroup_fd)
+{
+	enum bpf_attach_type type;
+	bool no_prog = true;
+
+	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
+		int count = count_attached_bpf_progs(cgroup_fd, type);
+
+		if (count < 0 && errno != EINVAL)
+			return -1;
+
+		if (count > 0) {
+			no_prog = false;
+			break;
+		}
+	}
+
+	return no_prog ? 0 : 1;
+}
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
@@ -161,6 +180,7 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 static int do_show(int argc, char **argv)
 {
 	enum bpf_attach_type type;
+	int has_attached_progs;
 	const char *path;
 	int cgroup_fd;
 	int ret = -1;
@@ -192,6 +212,16 @@ static int do_show(int argc, char **argv)
 		goto exit;
 	}
 
+	has_attached_progs = cgroup_has_attached_progs(cgroup_fd);
+	if (has_attached_progs < 0) {
+		p_err("can't query bpf programs attached to %s: %s",
+		      path, strerror(errno));
+		goto exit_cgroup;
+	} else if (!has_attached_progs) {
+		ret = 0;
+		goto exit_cgroup;
+	}
+
 	if (json_output)
 		jsonw_start_array(json_wtr);
 	else
@@ -212,6 +242,7 @@ static int do_show(int argc, char **argv)
 	if (json_output)
 		jsonw_end_array(json_wtr);
 
+exit_cgroup:
 	close(cgroup_fd);
 exit:
 	return ret;
@@ -228,7 +259,7 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 			   int typeflag, struct FTW *ftw)
 {
 	enum bpf_attach_type type;
-	bool skip = true;
+	int has_attached_progs;
 	int cgroup_fd;
 
 	if (typeflag != FTW_D)
@@ -240,22 +271,13 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 		return SHOW_TREE_FN_ERR;
 	}
 
-	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++) {
-		int count = count_attached_bpf_progs(cgroup_fd, type);
-
-		if (count < 0 && errno != EINVAL) {
-			p_err("can't query bpf programs attached to %s: %s",
-			      fpath, strerror(errno));
-			close(cgroup_fd);
-			return SHOW_TREE_FN_ERR;
-		}
-		if (count > 0) {
-			skip = false;
-			break;
-		}
-	}
-
-	if (skip) {
+	has_attached_progs = cgroup_has_attached_progs(cgroup_fd);
+	if (has_attached_progs < 0) {
+		p_err("can't query bpf programs attached to %s: %s",
+		      fpath, strerror(errno));
+		close(cgroup_fd);
+		return SHOW_TREE_FN_ERR;
+	} else if (!has_attached_progs) {
 		close(cgroup_fd);
 		return 0;
 	}
-- 
2.20.1



