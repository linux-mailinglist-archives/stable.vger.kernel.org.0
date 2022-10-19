Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8205260415F
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 12:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232622AbiJSKnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 06:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230493AbiJSKms (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 06:42:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C45451119D8;
        Wed, 19 Oct 2022 03:20:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3EECB823AB;
        Wed, 19 Oct 2022 08:52:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E312C433D6;
        Wed, 19 Oct 2022 08:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169527;
        bh=c6jaiSw5Oz8WJHTSZ7ux3MCbsJtx19rEilrmCIVTGds=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sDiYYdXa6j2m978GyW7JnJhNhCvVxy7+rPji8h0Crj5B54qAqP+D1m0DL/NzbIaVR
         AvT9TRMDXwEuhcZNkT+70nn7B3ILCqtCH54HCCPUQboN/G36h2tMtgF9L84oTbUbtr
         a3eUCTjfqFFITRnM3wldoqnSXaBONtCAzDE1rq4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pu Lehui <pulehui@huawei.com>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 303/862] bpftool: Fix wrong cgroup attach flags being assigned to effective progs
Date:   Wed, 19 Oct 2022 10:26:30 +0200
Message-Id: <20221019083303.389799738@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pu Lehui <pulehui@huawei.com>

[ Upstream commit bdcee1b0b0834d031c76a12209840afe949b048a ]

When root-cgroup attach multi progs and sub-cgroup attach a override prog,
bpftool will display incorrectly for the attach flags of the sub-cgroup’s
effective progs:

$ bpftool cgroup tree /sys/fs/cgroup effective
CgroupPath
ID       AttachType      AttachFlags     Name
/sys/fs/cgroup
6        cgroup_sysctl   multi           sysctl_tcp_mem
13       cgroup_sysctl   multi           sysctl_tcp_mem
/sys/fs/cgroup/cg1
20       cgroup_sysctl   override        sysctl_tcp_mem
6        cgroup_sysctl   override        sysctl_tcp_mem <- wrong
13       cgroup_sysctl   override        sysctl_tcp_mem <- wrong
/sys/fs/cgroup/cg1/cg2
20       cgroup_sysctl                   sysctl_tcp_mem
6        cgroup_sysctl                   sysctl_tcp_mem
13       cgroup_sysctl                   sysctl_tcp_mem

Attach flags is only valid for attached progs of this layer cgroup,
but not for effective progs. For querying with EFFECTIVE flags,
exporting attach flags does not make sense. So let's remove the
AttachFlags field and the associated logic. After this patch, the
above effective cgroup tree will show as bellow:

$ bpftool cgroup tree /sys/fs/cgroup effective
CgroupPath
ID       AttachType      Name
/sys/fs/cgroup
6        cgroup_sysctl   sysctl_tcp_mem
13       cgroup_sysctl   sysctl_tcp_mem
/sys/fs/cgroup/cg1
20       cgroup_sysctl   sysctl_tcp_mem
6        cgroup_sysctl   sysctl_tcp_mem
13       cgroup_sysctl   sysctl_tcp_mem
/sys/fs/cgroup/cg1/cg2
20       cgroup_sysctl   sysctl_tcp_mem
6        cgroup_sysctl   sysctl_tcp_mem
13       cgroup_sysctl   sysctl_tcp_mem

Fixes: b79c9fc9551b ("bpf: implement BPF_PROG_QUERY for BPF_LSM_CGROUP")
Fixes: a98bf57391a2 ("tools: bpftool: add support for reporting the effective cgroup progs")
Signed-off-by: Pu Lehui <pulehui@huawei.com>
Link: https://lore.kernel.org/r/20220921104604.2340580-3-pulehui@huaweicloud.com
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/cgroup.c | 54 ++++++++++++++++++++++++++++++++++----
 1 file changed, 49 insertions(+), 5 deletions(-)

diff --git a/tools/bpf/bpftool/cgroup.c b/tools/bpf/bpftool/cgroup.c
index cced668fb2a3..b46a998d8f8d 100644
--- a/tools/bpf/bpftool/cgroup.c
+++ b/tools/bpf/bpftool/cgroup.c
@@ -136,8 +136,8 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			jsonw_string_field(json_wtr, "attach_type", attach_type_str);
 		else
 			jsonw_uint_field(json_wtr, "attach_type", attach_type);
-		jsonw_string_field(json_wtr, "attach_flags",
-				   attach_flags_str);
+		if (!(query_flags & BPF_F_QUERY_EFFECTIVE))
+			jsonw_string_field(json_wtr, "attach_flags", attach_flags_str);
 		jsonw_string_field(json_wtr, "name", prog_name);
 		if (attach_btf_name)
 			jsonw_string_field(json_wtr, "attach_btf_name", attach_btf_name);
@@ -150,7 +150,10 @@ static int show_bpf_prog(int id, enum bpf_attach_type attach_type,
 			printf("%-15s", attach_type_str);
 		else
 			printf("type %-10u", attach_type);
-		printf(" %-15s %-15s", attach_flags_str, prog_name);
+		if (query_flags & BPF_F_QUERY_EFFECTIVE)
+			printf(" %-15s", prog_name);
+		else
+			printf(" %-15s %-15s", attach_flags_str, prog_name);
 		if (attach_btf_name)
 			printf(" %-15s", attach_btf_name);
 		else if (info.attach_btf_id)
@@ -195,6 +198,32 @@ static int cgroup_has_attached_progs(int cgroup_fd)
 
 	return no_prog ? 0 : 1;
 }
+
+static int show_effective_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
+				    int level)
+{
+	LIBBPF_OPTS(bpf_prog_query_opts, p);
+	__u32 prog_ids[1024] = {0};
+	__u32 iter;
+	int ret;
+
+	p.query_flags = query_flags;
+	p.prog_cnt = ARRAY_SIZE(prog_ids);
+	p.prog_ids = prog_ids;
+
+	ret = bpf_prog_query_opts(cgroup_fd, type, &p);
+	if (ret)
+		return ret;
+
+	if (p.prog_cnt == 0)
+		return 0;
+
+	for (iter = 0; iter < p.prog_cnt; iter++)
+		show_bpf_prog(prog_ids[iter], type, NULL, level);
+
+	return 0;
+}
+
 static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 				   int level)
 {
@@ -245,6 +274,14 @@ static int show_attached_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
 	return 0;
 }
 
+static int show_bpf_progs(int cgroup_fd, enum bpf_attach_type type,
+			  int level)
+{
+	return query_flags & BPF_F_QUERY_EFFECTIVE ?
+	       show_effective_bpf_progs(cgroup_fd, type, level) :
+	       show_attached_bpf_progs(cgroup_fd, type, level);
+}
+
 static int do_show(int argc, char **argv)
 {
 	enum bpf_attach_type type;
@@ -292,6 +329,8 @@ static int do_show(int argc, char **argv)
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
+	else if (query_flags & BPF_F_QUERY_EFFECTIVE)
+		printf("%-8s %-15s %-15s\n", "ID", "AttachType", "Name");
 	else
 		printf("%-8s %-15s %-15s %-15s\n", "ID", "AttachType",
 		       "AttachFlags", "Name");
@@ -304,7 +343,7 @@ static int do_show(int argc, char **argv)
 		 * If we were able to get the show for at least one
 		 * attach type, let's return 0.
 		 */
-		if (show_attached_bpf_progs(cgroup_fd, type, 0) == 0)
+		if (show_bpf_progs(cgroup_fd, type, 0) == 0)
 			ret = 0;
 	}
 
@@ -362,7 +401,7 @@ static int do_show_tree_fn(const char *fpath, const struct stat *sb,
 
 	btf_vmlinux = libbpf_find_kernel_btf();
 	for (type = 0; type < __MAX_BPF_ATTACH_TYPE; type++)
-		show_attached_bpf_progs(cgroup_fd, type, ftw->level);
+		show_bpf_progs(cgroup_fd, type, ftw->level);
 
 	if (errno == EINVAL)
 		/* Last attach type does not support query.
@@ -436,6 +475,11 @@ static int do_show_tree(int argc, char **argv)
 
 	if (json_output)
 		jsonw_start_array(json_wtr);
+	else if (query_flags & BPF_F_QUERY_EFFECTIVE)
+		printf("%s\n"
+		       "%-8s %-15s %-15s\n",
+		       "CgroupPath",
+		       "ID", "AttachType", "Name");
 	else
 		printf("%s\n"
 		       "%-8s %-15s %-15s %-15s\n",
-- 
2.35.1



