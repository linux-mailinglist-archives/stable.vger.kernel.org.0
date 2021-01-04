Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B55612E9A89
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:13:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728994AbhADQLJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:11:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:36558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728275AbhADQAQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:00:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E5DCB22AB0;
        Mon,  4 Jan 2021 15:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609775995;
        bh=3U9d0/nS1d9EMpclSP8nCQLyvH2BWG7hJmgCvL9H/LQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCSYzgZX/NC31eluMSm0t3+PggUEZbbDk0owL/bi15kgh0j+85YFIZ11N7VO6xe57
         URYwaEU0SykIoxgm6WZtgs2BB1Dghpx1Ioh//DCREs2Yrm1CTxgdqQrTDo6Vkeo568
         t58OSbdZYOpe8OsxI8e8NoOCkZqqwQQhJVU9KBQQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.4 23/47] cgroup: Fix memory leak when parsing multiple source parameters
Date:   Mon,  4 Jan 2021 16:57:22 +0100
Message-Id: <20210104155706.860082652@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155705.740576914@linuxfoundation.org>
References: <20210104155705.740576914@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

commit 2d18e54dd8662442ef5898c6bdadeaf90b3cebbc upstream.

A memory leak is found in cgroup1_parse_param() when multiple source
parameters overwrite fc->source in the fs_context struct without free.

unreferenced object 0xffff888100d930e0 (size 16):
  comm "mount", pid 520, jiffies 4303326831 (age 152.783s)
  hex dump (first 16 bytes):
    74 65 73 74 6c 65 61 6b 00 00 00 00 00 00 00 00  testleak........
  backtrace:
    [<000000003e5023ec>] kmemdup_nul+0x2d/0xa0
    [<00000000377dbdaa>] vfs_parse_fs_string+0xc0/0x150
    [<00000000cb2b4882>] generic_parse_monolithic+0x15a/0x1d0
    [<000000000f750198>] path_mount+0xee1/0x1820
    [<0000000004756de2>] do_mount+0xea/0x100
    [<0000000094cafb0a>] __x64_sys_mount+0x14b/0x1f0

Fix this bug by permitting a single source parameter and rejecting with
an error all subsequent ones.

Fixes: 8d2451f4994f ("cgroup1: switch to option-by-option parsing")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Reviewed-by: Zefan Li <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/cgroup/cgroup-v1.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -914,6 +914,8 @@ int cgroup1_parse_param(struct fs_contex
 	opt = fs_parse(fc, &cgroup1_fs_parameters, param, &result);
 	if (opt == -ENOPARAM) {
 		if (strcmp(param->key, "source") == 0) {
+			if (fc->source)
+				return invalf(fc, "Multiple sources not supported");
 			fc->source = param->string;
 			param->string = NULL;
 			return 0;


