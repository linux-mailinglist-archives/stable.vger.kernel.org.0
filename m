Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C68E2E3F3D
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:38:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392282AbgL1OiE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:38:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504620AbgL1OcL (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:32:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7001422573;
        Mon, 28 Dec 2020 14:31:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165891;
        bh=AxoiFViYVZh/CH7Pv/I6I/Qv+57/z6Bfmh3oI2XqIOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDwnOz6O21VQG1wd22xK9RdOIR/8Yp6Un9uFg2Wh1mMZ4tUdcVEtZuSTmDFe0e5H5
         Cmuw4w1KRMZtsP/ojrHGvBarqTb4PnCMlrowbyU1R13iHA9EFQ2qmnL4+NrGEud0p9
         eui64JtvQ1YzpdeHLae6JwMk6BTzX8stcTwlbW60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Hai <wanghai38@huawei.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [PATCH 5.10 692/717] device-dax/core: Fix memory leak when rmmod dax.ko
Date:   Mon, 28 Dec 2020 13:51:30 +0100
Message-Id: <20201228125054.130588190@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
@@ -752,6 +752,7 @@ err_chrdev:
 
 static void __exit dax_core_exit(void)
 {
+	dax_bus_exit();
 	unregister_chrdev_region(dax_devt, MINORMASK+1);
 	ida_destroy(&dax_minor_ida);
 	dax_fs_exit();


