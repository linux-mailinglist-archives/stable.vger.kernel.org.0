Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35AD56136D5
	for <lists+stable@lfdr.de>; Mon, 31 Oct 2022 13:48:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiJaMsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Oct 2022 08:48:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbiJaMsd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Oct 2022 08:48:33 -0400
Received: from mailgw.kylinos.cn (unknown [124.126.103.232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F66DE0A4
        for <stable@vger.kernel.org>; Mon, 31 Oct 2022 05:48:32 -0700 (PDT)
X-UUID: 504ac444c3ed4ebea31e855f7bbff2ff-20221031
X-CPASD-INFO: e6a611a855a84b32b0b044b1542cfd68@roabVl5jj2hhVaOEg6V-bIJhkmBkYIK
        Ad25Sk5SUYliVhH5xTV5uYFV9fWtVYV9dYVR6eGxQYmBgZFJ4i3-XblBgXoZgUZB3tHibVmFfkQ==
X-CLOUD-ID: e6a611a855a84b32b0b044b1542cfd68
X-CPASD-SUMMARY: SIP:-1,APTIP:-2.0,KEY:0.0,FROMBLOCK:1,OB:0.0,URL:-5,TVAL:182.
        0,ESV:0.0,ECOM:-5.0,ML:0.0,FD:0.0,CUTS:94.0,IP:-2.0,MAL:-5.0,PHF:-5.0,PHC:-5.
        0,SPF:4.0,EDMS:-5,IPLABEL:4480.0,FROMTO:0,AD:0,FFOB:0.0,CFOB:0.0,SPC:0,SIG:-5
        ,AUF:13,DUF:7053,ACD:127,DCD:127,SL:0,EISP:0,AG:0,CFC:0.73,CFSR:0.021,UAT:0,R
        AF:0,IMG:-5.0,DFA:0,DTA:0,IBL:-2.0,ADI:-5,SBL:0,REDM:0,REIP:0,ESB:0,ATTNUM:0,
        EAF:0,CID:-5.0,VERSION:2.3.17
X-CPASD-ID: 504ac444c3ed4ebea31e855f7bbff2ff-20221031
X-CPASD-BLOCK: 1000
X-CPASD-STAGE: 1
X-UUID: 504ac444c3ed4ebea31e855f7bbff2ff-20221031
X-User: xiongxin@kylinos.cn
Received: from localhost.localdomain [(116.128.244.169)] by mailgw
        (envelope-from <xiongxin@kylinos.cn>)
        (Generic MTA)
        with ESMTP id 1211217641; Mon, 31 Oct 2022 20:48:30 +0800
From:   xiongxin <xiongxin@kylinos.cn>
To:     win239@126.com
Cc:     xiongxin <xiongxin@kylinos.cn>, stable@vger.kernel.org
Subject: [PATCH -next 1/2] PM: hibernate: fix spelling mistake for annotation
Date:   Mon, 31 Oct 2022 20:48:22 +0800
Message-Id: <20221031124823.719912-2-xiongxin@kylinos.cn>
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

The actual calculation formula in the code below is:

max_size = (count - (size + PAGES_FOR_IO)) / 2
	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);

But function comments are written differently, the comment is wrong?

By the way, what exactly do the "/ 2" and "2 *" mean?

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
---
 kernel/power/snapshot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 2a406753af90..c20ca5fb9adc 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1723,8 +1723,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
  * /sys/power/reserved_size, respectively).  To make this happen, we compute the
  * total number of available page frames and allocate at least
  *
- * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
- *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
+ * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
+ *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
  *
  * of them, which corresponds to the maximum size of a hibernation image.
  *
-- 
2.25.1


No virus found
		Checked by Hillstone Network AntiVirus
