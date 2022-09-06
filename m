Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8B855AF06B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 18:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiIFQcK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 12:32:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbiIFQbk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 12:31:40 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D673617A89
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 09:04:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662480276;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=8aqTDgZ9S3xUVtZZj9N8B3wCOKXsynU6SIs7zbX6wbU=;
        b=a/3jZdoDLMAqFaEiRY6Mrdv78swKe0o5SR8RycEtS7M7ug0OkfC0vkTlZ7rMxNusvccQog
        ODfg3HC0a2+QvhYasSTUl4VU3tMfTn5Sjbp2qI4V6KRq/mATtYnhJmsbkinxn/j0g7U2LO
        9WC0ZQdHGfq8OqFm9B7EnZe578WxaUw=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-526-n_kaTBntPiiocCur2-YYRw-1; Tue, 06 Sep 2022 12:04:32 -0400
X-MC-Unique: n_kaTBntPiiocCur2-YYRw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EEC1E1C14B73;
        Tue,  6 Sep 2022 16:04:31 +0000 (UTC)
Received: from pauld.bos.com (dhcp-17-237.bos.redhat.com [10.18.17.237])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 35576409B3E6;
        Tue,  6 Sep 2022 16:04:31 +0000 (UTC)
From:   Phil Auld <pauld@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Yury Norov <yury.norov@gmail.com>,
        feng xiangjun <fengxj325@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] drivers/base: Fix unsigned comparison to -1 in CPUMAP_FILE_MAX_BYTES
Date:   Tue,  6 Sep 2022 12:04:30 -0400
Message-Id: <20220906160430.1169837-1-pauld@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,HEXHASH_WORD,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Reported-by: feng xiangjun <fengxj325@gmail.com>
Signed-off-by: Phil Auld <pauld@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: stable@vger.kernel.org
Cc: feng xiangjun <fengxj325@gmail.com>
---
 include/linux/cpumask.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/include/linux/cpumask.h b/include/linux/cpumask.h
index bd047864c7ac..7b1349612d6d 100644
--- a/include/linux/cpumask.h
+++ b/include/linux/cpumask.h
@@ -1127,9 +1127,10 @@ cpumap_print_list_to_buf(char *buf, const struct cpumask *mask,
  * cover a worst-case of every other cpu being on one of two nodes for a
  * very large NR_CPUS.
  *
- *  Use PAGE_SIZE as a minimum for smaller configurations.
+ *  Use PAGE_SIZE as a minimum for smaller configurations while avoiding
+ *  unsigned comparison to -1.
  */
-#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32 - 1) > PAGE_SIZE) \
+#define CPUMAP_FILE_MAX_BYTES  ((((NR_CPUS * 9)/32) > PAGE_SIZE + 1) \
 					? (NR_CPUS * 9)/32 - 1 : PAGE_SIZE)
 #define CPULIST_FILE_MAX_BYTES  (((NR_CPUS * 7)/2 > PAGE_SIZE) ? (NR_CPUS * 7)/2 : PAGE_SIZE)
 
-- 
2.31.1

