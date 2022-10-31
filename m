Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD1E6136D4
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 13:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231382AbiJaMsh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 08:48:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231184AbiJaMsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 08:48:33 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C02DFD3
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:48:31 -0700 (PDT)
X-UUID: 9922af2c0c6b4647a5f81ef4c0971313-20221031
X-CPASD-INFO: 5bab262ff2a844a6bed491fa5112fd33@frKbgl9oYJaSUqOEg3escIKWlGRpXYa
        wd2tRYpSUX1OVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBgXoZgUZB3hKSbgmJkYg==
X-CLOUD-ID: 5bab262ff2a844a6bed491fa5112fd33
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:182.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:172.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5
        .0,SPF:4.0,EDMS:-5,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-
        5,AUF:14,DUF:7054,ACD:127,DCD:127,SL:0,EISP:0,AG:0,CFC:0.576,CFSR:0.028,UAT:0
        ,RAF:0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:
        0,EAF:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 9922af2c0c6b4647a5f81ef4c0971313-20221031
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 9922af2c0c6b4647a5f81ef4c0971313-20221031
X-User: xiongxin@kylinos.cn
Received: from localhost.localdomain [(116.128.244.169)] by mailgw
        (envelope-from <xiongxin@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1065568009; Mon, 31 Oct 2022 20:48:31 +0800
From:   xiongxin <xiongxin@kylinos.cn>
To:     win239@126.com
Cc:     xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org,
        huanglei <huanglei@kylinos.cn>
Subject: [PATCH -next 2/2] PM: hibernate: add check of preallocate mem for image size pages
Date:   Mon, 31 Oct 2022 20:48:23 +0800
Message-Id: <20221031124823.719912-3-xiongxin@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221031124823.719912-1-xiongxin@kylinos.cn>
References: <20221031124823.719912-1-xiongxin@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_00,KHOP_HELO_FCRDNS,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,T_SPF_PERMERROR,
        UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Added a check on the return value of preallocate_image_highmem(). If
memory preallocate is insufficient, S4 cannot be done;

I am playing 4K video on a machine with AMD or other graphics card and
only 8GiB memory, and the kernel is not configured with CONFIG_HIGHMEM.
When doing the S4 test, the analysis found that when the pages get from
minimum_image_size() is large enough, The preallocate_image_memory() and
preallocate_image_highmem() calls failed to obtain enough memory. Add
the judgment that memory preallocate is insufficient;

"pages -= free_unnecessary_pages()" below will let pages to drop a lot,
so I wonder if it makes sense to add a judgment here.

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
Signed-off-by: huanglei <huanglei@kylinos.cn>
---
 kernel/power/snapshot.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index c20ca5fb9adc..670abf89cf31 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1738,6 +1738,7 @@ int hibernate_preallocate_memory(void)
 	struct zone *zone;
 	unsigned long saveable, size, max_size, count, highmem, pages = 0;
 	unsigned long alloc, save_highmem, pages_highmem, avail_normal;
+	unsigned long size_highmem;
 	ktime_t start, stop;
 	int error;
 
@@ -1863,7 +1864,13 @@ int hibernate_preallocate_memory(void)
 		pages_highmem += size;
 		alloc -= size;
 		size = preallocate_image_memory(alloc, avail_normal);
-		pages_highmem += preallocate_image_highmem(alloc - size);
+		size_highmem += preallocate_image_highmem(alloc - size);
+		if (size_highmem < (alloc - size)) {
+			pr_err("Image allocation is %lu pages short, exit\n",
+				alloc - size - pages_highmem);
+			goto err_out;
+		}
+		pages_highmem += size_highmem;
 		pages += pages_highmem + size;
 	}
 
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus
