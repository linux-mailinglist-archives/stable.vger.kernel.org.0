Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9CFA2E4285
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436502AbgL1N7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:59:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:33250 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407619AbgL1N7Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:59:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B7FD2064B;
        Mon, 28 Dec 2020 13:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163924;
        bh=z8lqmZyRB6iygxKL0yrJ5fz8aqgGhXJ2TaFbTZYYv0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bg5Ta/EAxVwlEeUDdP9DMaNxDT5Lf5w18+G1GrEwRlRZr+dzrUh4dNIfSCF6PJj1T
         dHT5FQ6ypQlvqrH3ktECzFKLsBvudP0YVtVMMYqW8GWT5c64dY7csUV6m4z96IhqfG
         poF5EtrSUylyNgYm6PzODGwNqPsDTFTxxZcCEh90=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.4 440/453] device-dax/core: Fix memory leak when rmmod dax.ko
Date:   Mon, 28 Dec 2020 13:51:16 +0100
Message-Id: <20201228124958.392829106@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Hai <wanghai38@huawei.com>

commit 1aa574312518ef1d60d2dc62d58f7021db3b163a upstream.

When I repeatedly modprobe and rmmod dax.ko, kmemleak report a
memory leak as follows:

unreferenced object 0xffff9a5588c05088 (size 8):
  comm "modprobe", pid 261, jiffies 4294693644 (age 42.063s)
...
  backtrace:
    [<00000000e007ced0>] kstrdup+0x35/0x70
    [<000000002ae73897>] kstrdup_const+0x3d/0x50
    [<000000002b00c9c3>] kvasprintf_const+0xbc/0xf0
    [<000000008023282f>] kobject_set_name_vargs+0x3b/0xd0
    [<00000000d2cbaa4e>] kobject_set_name+0x62/0x90
    [<00000000202e7a22>] bus_register+0x7f/0x2b0
    [<000000000b77792c>] 0xffffffffc02840f7
    [<000000002d5be5ac>] 0xffffffffc02840b4
    [<00000000dcafb7cd>] do_one_initcall+0x58/0x240
    [<00000000049fe480>] do_init_module+0x56/0x1e2
    [<0000000022671491>] load_module+0x2517/0x2840
    [<000000001a2201cb>] __do_sys_finit_module+0x9c/0xe0
    [<000000003eb304e7>] do_syscall_64+0x33/0x40
    [<0000000051c5fd06>] entry_SYSCALL_64_after_hwframe+0x44/0xa9

When rmmod dax is executed, dax_bus_exit() is missing. This patch
can fix this bug.

Fixes: 9567da0b408a ("device-dax: Introduce bus + driver model")
Cc: <stable@vger.kernel.org>
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Hai <wanghai38@huawei.com>
Link: https://lore.kernel.org/r/20201201135929.66530-1-wanghai38@huawei.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/dax/super.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/dax/super.c
+++ b/drivers/dax/super.c
@@ -720,6 +720,7 @@ err_chrdev:
 
 static void __exit dax_core_exit(void)
 {
+	dax_bus_exit();
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 	ida_destroy(&dax_minor_ida);
 	dax_fs_exit();


