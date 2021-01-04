Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4C9D2E999F
	for <lists+stable@lfdr.de>; Mon,  4 Jan 2021 17:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbhADQCF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Jan 2021 11:02:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728731AbhADQCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Jan 2021 11:02:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C320722507;
        Mon,  4 Jan 2021 16:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609776107;
        bh=6mnFiwIiKvqBurv8MOmnq9HzW+/bMiarWiH2R3iQ5zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqiz9GFhwz3tFPL0Pdvj70u+hb85EeiSLqOpbGMWzwjEvODweTRvhgOJgambfvKsr
         3rVuFUWfxXAXD+oq+xm3LHCVZAiobj5NozyD6l1lcv4+bS25uSDnIOIJ1ii8zsLlj/
         Mw2zAPjxi4mO0ZISWEvpITy4l8dOL7iuDZlcGzKM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Qinglang Miao <miaoqinglang@huawei.com>,
        Zefan Li <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 5.10 24/63] cgroup: Fix memory leak when parsing multiple source parameters
Date:   Mon,  4 Jan 2021 16:57:17 +0100
Message-Id: <20210104155709.994677471@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210104155708.800470590@linuxfoundation.org>
References: <20210104155708.800470590@linuxfoundation.org>
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
@@ -908,6 +908,8 @@ int cgroup1_parse_param(struct fs_contex
 	opt = fs_parse(fc, cgroup1_fs_parameters, param, &result);
 	if (opt == -ENOPARAM) {
 		if (strcmp(param->key, "source") == 0) {
+			if (fc->source)
+				return invalf(fc, "Multiple sources not supported");
 			fc->source = param->string;
 			param->string = NULL;
 			return 0;


