Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 999EE5EA473
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238567AbiIZLqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238947AbiIZLpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6B47437C;
        Mon, 26 Sep 2022 03:47:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88723B80925;
        Mon, 26 Sep 2022 10:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6A7C433D7;
        Mon, 26 Sep 2022 10:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664189236;
        bh=lhsCTra1pGvb3ZPd7KNTAV+pfCo3UKjrsSqyyZHmfss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQrRzImbqcUIF4kz8RqD7sxVeJDbOExsRKfsskjCunxjawBbccRu8Cs74C3cWw4ZV
         +n9joSMv8ZqKhok6MydTd12vmEm3q7slyBGnACsjDEg7A6X64ETIjdTqce4UQIymMD
         NMh4Bx9LINFj8RXezHZyidGxabZHUn0krhSGUF70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jie2x Zhou <jie2x.zhou@intel.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 118/207] netdevsim: Fix hwstats debugfs file permissions
Date:   Mon, 26 Sep 2022 12:11:47 +0200
Message-Id: <20220926100811.846001745@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 34513ada53eb3e3f711250d8dbc2de4de493d510 ]

The hwstats debugfs files are only writeable, but they are created with
read and write permissions, causing certain selftests to fail [1].

Fix by creating the files with write permission only.

[1]
 # ./test_offload.py
 Test destruction of generic XDP...
 Traceback (most recent call last):
   File "/home/idosch/code/linux/tools/testing/selftests/bpf/./test_offload.py", line 810, in <module>
     simdev = NetdevSimDev()
 [...]
 Exception: Command failed: cat /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex

 cat: /sys/kernel/debug/netdevsim/netdevsim0//ports/0/dev/hwstats/l3/disable_ifindex: Invalid argument

Fixes: 1a6d7ae7d63c ("netdevsim: Introduce support for L3 offload xstats")
Reported-by: Jie2x Zhou <jie2x.zhou@intel.com>
Tested-by: Jie2x Zhou <jie2x.zhou@intel.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/20220909153830.3732504-1-idosch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/netdevsim/hwstats.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/netdevsim/hwstats.c b/drivers/net/netdevsim/hwstats.c
index 605a38e16db0..0e58aa7f0374 100644
--- a/drivers/net/netdevsim/hwstats.c
+++ b/drivers/net/netdevsim/hwstats.c
@@ -433,11 +433,11 @@ int nsim_dev_hwstats_init(struct nsim_dev *nsim_dev)
 		goto err_remove_hwstats_recursive;
 	}
 
-	debugfs_create_file("enable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+	debugfs_create_file("enable_ifindex", 0200, hwstats->l3_ddir, hwstats,
 			    &nsim_dev_hwstats_l3_enable_fops.fops);
-	debugfs_create_file("disable_ifindex", 0600, hwstats->l3_ddir, hwstats,
+	debugfs_create_file("disable_ifindex", 0200, hwstats->l3_ddir, hwstats,
 			    &nsim_dev_hwstats_l3_disable_fops.fops);
-	debugfs_create_file("fail_next_enable", 0600, hwstats->l3_ddir, hwstats,
+	debugfs_create_file("fail_next_enable", 0200, hwstats->l3_ddir, hwstats,
 			    &nsim_dev_hwstats_l3_fail_fops.fops);
 
 	INIT_DELAYED_WORK(&hwstats->traffic_dw,
-- 
2.35.1



