Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23DA60A8AD
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235246AbiJXNKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:10:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235436AbiJXNIm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 09:08:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 921839E680;
        Mon, 24 Oct 2022 05:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CB90EB81637;
        Mon, 24 Oct 2022 12:16:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C958C433C1;
        Mon, 24 Oct 2022 12:16:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613760;
        bh=uHn0RqWAGuY2UsCqYwefavnRuYHwaMKMXxufWpPwynk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LsFiuBzX44km6J6UEJj/6G6ZRTrwmDKC7QLmMd0C7VEMVqKqkwIdHQVEMBUgGWnfl
         qMLzjqEfKS92BPX9IfMDouq1mRTM6BKdNYVGaxZguiLIEvQQDyAgymKROvXhmYlNo8
         UuvDItQDEVyHn5sHb4chVU7MF83p0lWi3aIo5fM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Kelley <mikelley@microsoft.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Saurabh Sengar <ssengar@linux.microsoft.com>,
        Song Liu <song@kernel.org>
Subject: [PATCH 5.4 252/255] md: Replace snprintf with scnprintf
Date:   Mon, 24 Oct 2022 13:32:42 +0200
Message-Id: <20221024113011.699767171@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saurabh Sengar <ssengar@linux.microsoft.com>

commit 1727fd5015d8f93474148f94e34cda5aa6ad4a43 upstream.

Current code produces a warning as shown below when total characters
in the constituent block device names plus the slashes exceeds 200.
snprintf() returns the number of characters generated from the given
input, which could cause the expression “200 – len” to wrap around
to a large positive number. Fix this by using scnprintf() instead,
which returns the actual number of characters written into the buffer.

[ 1513.267938] ------------[ cut here ]------------
[ 1513.267943] WARNING: CPU: 15 PID: 37247 at <snip>/lib/vsprintf.c:2509 vsnprintf+0x2c8/0x510
[ 1513.267944] Modules linked in:  <snip>
[ 1513.267969] CPU: 15 PID: 37247 Comm: mdadm Not tainted 5.4.0-1085-azure #90~18.04.1-Ubuntu
[ 1513.267969] Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V UEFI Release v4.1 05/09/2022
[ 1513.267971] RIP: 0010:vsnprintf+0x2c8/0x510
<-snip->
[ 1513.267982] Call Trace:
[ 1513.267986]  snprintf+0x45/0x70
[ 1513.267990]  ? disk_name+0x71/0xa0
[ 1513.267993]  dump_zones+0x114/0x240 [raid0]
[ 1513.267996]  ? _cond_resched+0x19/0x40
[ 1513.267998]  raid0_run+0x19e/0x270 [raid0]
[ 1513.268000]  md_run+0x5e0/0xc50
[ 1513.268003]  ? security_capable+0x3f/0x60
[ 1513.268005]  do_md_run+0x19/0x110
[ 1513.268006]  md_ioctl+0x195e/0x1f90
[ 1513.268007]  blkdev_ioctl+0x91f/0x9f0
[ 1513.268010]  block_ioctl+0x3d/0x50
[ 1513.268012]  do_vfs_ioctl+0xa9/0x640
[ 1513.268014]  ? __fput+0x162/0x260
[ 1513.268016]  ksys_ioctl+0x75/0x80
[ 1513.268017]  __x64_sys_ioctl+0x1a/0x20
[ 1513.268019]  do_syscall_64+0x5e/0x200
[ 1513.268021]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: 766038846e875 ("md/raid0: replace printk() with pr_*()")
Reviewed-by: Michael Kelley <mikelley@microsoft.com>
Acked-by: Guoqing Jiang <guoqing.jiang@linux.dev>
Signed-off-by: Saurabh Sengar <ssengar@linux.microsoft.com>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/raid0.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -63,8 +63,8 @@ static void dump_zones(struct mddev *mdd
 		int len = 0;
 
 		for (k = 0; k < conf->strip_zone[j].nb_dev; k++)
-			len += snprintf(line+len, 200-len, "%s%s", k?"/":"",
-					bdevname(conf->devlist[j*raid_disks
+			len += scnprintf(line+len, 200-len, "%s%s", k?"/":"",
+					 bdevname(conf->devlist[j*raid_disks
 							       + k]->bdev, b));
 		pr_debug("md: zone%d=[%s]\n", j, line);
 


