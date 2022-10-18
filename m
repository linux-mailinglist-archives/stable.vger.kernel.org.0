Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBFD601E38
	for <lists+stable@lfdr.de>; Tue, 18 Oct 2022 02:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiJRAIR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 20:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231266AbiJRAH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 20:07:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56671870B1;
        Mon, 17 Oct 2022 17:07:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4BFACB81B62;
        Tue, 18 Oct 2022 00:07:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801A8C433B5;
        Tue, 18 Oct 2022 00:07:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666051671;
        bh=Cb+3HOumpk8RmhW78xsmKl6jb7K3bfgmJZsqiHeFyGc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hAFaPi6xkJR2GobHRJIxiR06M4H5byKUYFZchFIoJwUQHwuZ2hFmFmUw3ogJfaDTo
         p/zXTI4lgXGKSNDmDGK5F85qsbUYeDqQf6OKvLxBI0vdwiXYXFvbp+oHuRfhpqVelm
         TStd3tlVbyUyEinhyhmQlH3yNRq4dkdMZiGinMEM/hlIxKvEtspj+YhxaqUlIZC2Xw
         Y/lHxhu3vtn8tkENog4eCzEWgJ0/uzGP3UbfR3/fRmgj6vusF4CoirNzr+7FadZAXm
         Wl4BQjcIDNCrGBL0MZoC9rKBki0ZjC8RLeWKDECxLbxcX2PK2Jfb/nCC3VDwmsdn5w
         /9FKNesoHj+hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Yixuan Cao <caoyixuan2019@email.szu.edu.cn>,
        Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>,
        Jiajian Ye <yejiajian2018@email.szu.edu.cn>,
        Yuhong Feng <yuhongf@szu.edu.cn>,
        Liam Mark <lmark@codeaurora.org>,
        Georgi Djakov <georgi.djakov@linaro.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, seanga2@gmail.com,
        zhangyinan2019@email.szu.edu.cn, weizhenliang@huawei.com
Subject: [PATCH AUTOSEL 6.0 09/32] tools/vm/page_owner_sort: fix -f option
Date:   Mon, 17 Oct 2022 20:07:06 -0400
Message-Id: <20221018000729.2730519-9-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221018000729.2730519-1-sashal@kernel.org>
References: <20221018000729.2730519-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>

[ Upstream commit 57eb60c04d2c7b0de91eac2bc5d0331f8fe72fd7 ]

The -f option is to filter out the information of blocks whose memory has
not been released, I noticed some blocks should not be filtered out.

Commit 9cc7e96aa846 ("mm/page_owner: record timestamp and pid") records
the allocation timestamp (ts_nsec) of all pages.

Commit 866b48526217 ("mm/page_owner: record the timestamp of all pages
during free") records the free timestamp (free_ts_nsec) of all pages.
When the page is allocated for the first time, the initial value of
free_ts_nsec is 0, and the corresponding time will be obtained when the
page is released.  But during reallocation the free_ts_nsec will not reset
to 0 again.  In particular, when page migration occurs, these two
timestamps will be the same.

Now page_owner_sort removes all text blocks whose free_ts_nsec is not 0
when using -f option.  However, this way can only select pages allocated
for the first time.  If a freed page is reallocated, free_ts_nsec will be
less than ts_nsec; if page migration occurs, the two timestamps will be
equal.  These cases should be considered as pages are not released.

So I fix the function is_need() to keep text blocks that meet the above
two conditions when using -f option.

Link: https://lkml.kernel.org/r/20220812155515.30846-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Chongxi Zhao <zhaochongxi2019@email.szu.edu.cn>
Cc: Jiajian Ye <yejiajian2018@email.szu.edu.cn>
Cc: Yuhong Feng <yuhongf@szu.edu.cn>
Cc: Liam Mark <lmark@codeaurora.org>
Cc: Georgi Djakov <georgi.djakov@linaro.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/vm/page_owner_sort.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/tools/vm/page_owner_sort.c b/tools/vm/page_owner_sort.c
index ec2e67c85b84..ce860ab94162 100644
--- a/tools/vm/page_owner_sort.c
+++ b/tools/vm/page_owner_sort.c
@@ -470,7 +470,12 @@ static bool match_str_list(const char *str, char **list, int list_size)
 
 static bool is_need(char *buf)
 {
-	if ((filter & FILTER_UNRELEASE) && get_free_ts_nsec(buf) != 0)
+	__u64 ts_nsec, free_ts_nsec;
+
+	ts_nsec = get_ts_nsec(buf);
+	free_ts_nsec = get_free_ts_nsec(buf);
+
+	if ((filter & FILTER_UNRELEASE) && free_ts_nsec != 0 && ts_nsec < free_ts_nsec)
 		return false;
 	if ((filter & FILTER_PID) && !match_num_list(get_pid(buf), fc.pids, fc.pids_size))
 		return false;
-- 
2.35.1

