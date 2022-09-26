Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F01945EA407
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:39:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234418AbiIZLjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:39:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238166AbiIZLhz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:37:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 096476EF1E;
        Mon, 26 Sep 2022 03:44:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A46DB60A36;
        Mon, 26 Sep 2022 10:42:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D444C433D6;
        Mon, 26 Sep 2022 10:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188940;
        bh=mXgQHzzbXk8scCA00EwPq4JkzV+JHFrkwHS/AwZf3bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=voVb0GUgrFWRAaAZYimRjYLNyaLa4x3nJarP/VFWOG5wD1g0mnPNzL8QICKFWKclS
         c26zGfPk3xTkAgkc5gUrAUjc1so/fxW2TeK77pkd2RmrIC5ZV8W7VSPFsw3u5f18Ul
         8x25iLXGpI/8FORe1fZb4/LuhGmgp+mfNAnrtSkw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        feng xiangjun <fengxj325@gmail.com>,
        Phil Auld <pauld@redhat.com>
Subject: [PATCH 5.19 021/207] drivers/base: Fix unsigned comparison to -1 in CPUMAP_FILE_MAX_BYTES
Date:   Mon, 26 Sep 2022 12:10:10 +0200
Message-Id: <20220926100807.421848068@linuxfoundation.org>
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

From: Phil Auld <pauld@redhat.com>

commit d7f06bdd6ee87fbefa05af5f57361d85e7715b11 upstream.

As PAGE_SIZE is unsigned long, -1 > PAGE_SIZE when NR_CPUS <= 3.
This leads to very large file sizes:

topology$ ls -l
total 0
-r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 core_cpus
-r--r--r-- 1 root root                 4096 Sep  5 11:59 core_cpus_list
-r--r--r-- 1 root root                 4096 Sep  5 10:58 core_id
-r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 core_siblings
-r--r--r-- 1 root root                 4096 Sep  5 11:59 core_siblings_list
-r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 die_cpus
-r--r--r-- 1 root root                 4096 Sep  5 11:59 die_cpus_list
-r--r--r-- 1 root root                 4096 Sep  5 11:59 die_id
-r--r--r-- 1 root root 18446744073709551615 Sep  5 11:59 package_cpus
-r--r--r-- 1 root root                 4096 Sep  5 11:59 package_cpus_list
-r--r--r-- 1 root root                 4096 Sep  5 10:58 physical_package_id
-r--r--r-- 1 root root 18446744073709551615 Sep  5 10:10 thread_siblings
-r--r--r-- 1 root root                 4096 Sep  5 11:59 thread_siblings_list

Adjust the inequality to catch the case when NR_CPUS is configured
to a small value.

Fixes: 7ee951acd31a ("drivers/base: fix userspace break from using bin_attributes for cpumap and cpulist")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: stable@vger.kernel.org
Cc: feng xiangjun <fengxj325@gmail.com>
Reported-by: feng xiangjun <fengxj325@gmail.com>
Signed-off-by: Phil Auld <pauld@redhat.com>
Signed-off-by: Yury Norov <yury.norov@gmail.com>
Link: https://lore.kernel.org/r/20220906203542.1796629-1-pauld@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cpumask.h |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1083,9 +1083,10 @@ cpumap_print_list_to_buf(char *buf, cons
  * cover a worst-case of every other cpu being on one of two nodes for a
  * very large NR_CPUS.
  *
- *  Use PAGE_SIZE as a minimum for smaller configurations.
+ *  Use PAGE_SIZE as a minimum for smaller configurations while avoiding
+ *  unsigned comparison to -1.
  */
-#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
+#define CPUMAP_FILE_MAX_BYTES  (((NR_CPUS * 9)/32 > PAGE_SIZE) \
 					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
 #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
 


