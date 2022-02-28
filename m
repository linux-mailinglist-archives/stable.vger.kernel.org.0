Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3B864C7724
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 19:11:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239868AbiB1SLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 13:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240952AbiB1SJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 13:09:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DCA55E768;
        Mon, 28 Feb 2022 09:49:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1ABB860748;
        Mon, 28 Feb 2022 17:49:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37D5FC340E7;
        Mon, 28 Feb 2022 17:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646070557;
        bh=HFf6HB8g39HJQPZk8Gzm1m7F9fQJjHJtEmp1AGuZ/+4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bX5aC1yVHv+z83n/cNppfaWuCq4qsNqKFUKU4upOpguvLhmXDhmTV88At0oPpX7ji
         FHTKP6z1Mf7XgGTZUGucsCJnjSHAYPle/TRoFbdpgf+Xqp9BgS35cz1lLmaJdpjSNb
         BsH+b2k+t74F+LZfCTvJfJJAWIBG6uo/1BQuGL3w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liu Yuntao <liuyuntao10@huawei.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 153/164] hugetlbfs: fix a truncation issue in hugepages parameter
Date:   Mon, 28 Feb 2022 18:25:15 +0100
Message-Id: <20220228172413.643077553@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172359.567256961@linuxfoundation.org>
References: <20220228172359.567256961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Yuntao <liuyuntao10@huawei.com>

commit e79ce9832316e09529b212a21278d68240ccbf1f upstream.

When we specify a large number for node in hugepages parameter, it may
be parsed to another number due to truncation in this statement:

	node = tmp;

For example, add following parameter in command line:

	hugepagesz=1G hugepages=4294967297:5

and kernel will allocate 5 hugepages for node 1 instead of ignoring it.

I move the validation check earlier to fix this issue, and slightly
simplifies the condition here.

Link: https://lkml.kernel.org/r/20220209134018.8242-1-liuyuntao10@huawei.com
Fixes: b5389086ad7be0 ("hugetlbfs: extend the definition of hugepages parameter to support node allocation")
Signed-off-by: Liu Yuntao <liuyuntao10@huawei.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index e57650a9404f..f294db835f4b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4159,10 +4159,10 @@ static int __init hugepages_setup(char *s)
 				pr_warn("HugeTLB: architecture can't support node specific alloc, ignoring!\n");
 				return 0;
 			}
+			if (tmp >= nr_online_nodes)
+				goto invalid;
 			node = tmp;
 			p += count + 1;
-			if (node < 0 || node >= nr_online_nodes)
-				goto invalid;
 			/* Parse hugepages */
 			if (sscanf(p, "%lu%n", &tmp, &count) != 1)
 				goto invalid;
-- 
2.35.1



