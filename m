Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74DEF69D284
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 19:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232494AbjBTSFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 13:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbjBTSFW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 13:05:22 -0500
Received: from out162-62-57-210.mail.qq.com (out162-62-57-210.mail.qq.com [162.62.57.210])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D162193FB
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 10:05:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1676916314;
        bh=8quL8igquQ9Kpm/AZBs6y+F0BDjn+y3tcWnrGNq8Pf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=bhZXjzOLA/5e9g984DJWFBzpojjjg66MVk7OHGYHP5datNjq7d3oxAvgcO/dGOnP7
         qteGpuGuZRwrC7NZsvEtMD4iE94L1Xa8kTzZ5J67JFm/hDmCOQ0bCbGITi7FOCTUDn
         kvXGJP9F3gCnELmRnz7QzGMbu0Zp2+Lkx2cr6aoQ=
Received: from localhost.localdomain ([106.92.97.84])
        by newxmesmtplogicsvrszc1-0.qq.com (NewEsmtp) with SMTP
        id 141274B8; Tue, 21 Feb 2023 02:05:01 +0800
X-QQ-mid: xmsmtpt1676916307tnbzi422g
Message-ID: <tencent_F9ABCA98DA2FC867F23FBD8579C1CFE63905@qq.com>
X-QQ-XMAILINFO: NMGzQWUSIfvTebJKomk4jB6tzMjfPQI9YLLcyfsu9LEtDcO4e/P7wR6fsgCXw2
         1c6XsKWy4EMnyMAV866daHHJxbxyZ15PoyKZTxjw4t/iwQqK8ndO2orKys5aoRWUj4p9PnZHLIQX
         kCrnWSyT0Giqlcohfm5+ggAND/7/OubyDTQ/7NIm5eKd0KqdOYT1OYsvqBQ39HNNSl0+z+e4y+p9
         Joy8NhnX9yyg4hCJsVOAqQ8zmheWLkGBxTkZ2i0ivM40yiW4nJ1a8bGmncrz2Xlzm8nXNDyqO/I9
         Bbjex1F2Il32UPFFAKWz0K4kqPzX/osm7ZOo2R+rzF4feA3QrfRgY9bFxEQOEdq/bVHu6IL+1rQH
         ubxAK3gUwa2I9BMpzOPSUTLZ7TqvB6HIIoDYA53Z0X84tIGOpCvJygjxAGoyCXqORMyDv5gzFOiz
         X3iYM/7Wae84pins1tz+9dAtH9ZHv4TQkLr8yE0m5YKcjlJ+q5Uvk74nxwXmM6UaaEJ37/hhAEHQ
         KXH/EN6DKXhtfL096IQ0hp9sHYVJLywmGS8MMSUu7biBBIaEhWATLH/iOcujfMj/mVGmfXRW9cQ+
         7kkfBbPN7V07ybhZsWzvsKRPAZLb2eK085lapN2RawibxHfF0YlhtCB11UW05AekoA6iDBKymzVZ
         ILDPD/V9j8tx+SfJIyJZtB/eNaWwzxhfvdAZTY0MPQmtETlLnTzi7ImFWpezVmdAGJRMbSTEBzTS
         UciyPq/rfqD8d5hDEC4bE5bvs++2+aTMy6AvNvT5dSDsQ4KauYCBCWkTZYwkr+7UOXJnXJCDkUHo
         yHLZXs/abyWIec2yVgjmZ/F/wVsSETq3fci9I8RHzCcs94ssviCN3/9T+iAmoe9LfzyrnoNhTwGD
         v8HKFz154dMAD0tzHWqHtoZ+TJeTiRiq0TxtOTHpG7m8lMPZtlX5LAZ48ndG0P6Q/w3SRqm4kGG7
         szFu1nyuePYiImT9nDFiutFaExcFtZS3hZH9nzjUwlBEiN8hvcHg40pTrsFd2T2aJjmxzNrCMRM7
         W6u+a/bL/QLFgknBXRes7a+5/fFCgtrrLwZiVD69dYwUBE8NAfTstn+5yGsjY=
From:   wenyang.linux@foxmail.com
To:     Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Yu Kuai <yukuai3@huawei.com>, Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org,
        Wen Yang <wenyang.linux@foxmail.com>
Subject: [PATCH 5.10 3/4] nbd: fix possible overflow for 'first_minor' in nbd_dev_add()
Date:   Tue, 21 Feb 2023 02:04:48 +0800
X-OQ-MSGID: <20230220180449.36425-3-wenyang.linux@foxmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20230220180449.36425-1-wenyang.linux@foxmail.com>
References: <20230220180449.36425-1-wenyang.linux@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yu Kuai <yukuai3@huawei.com>

commit 940c264984fd1457918393c49674f6b39ee16506 upstream.

If 'part_shift' is not zero, then 'index << part_shift' might
overflow to a value that is not greater than '0xfffff', then sysfs
might complains about duplicate creation.

Fixes: b0d9111a2d53 ("nbd: use an idr to keep track of nbd devices")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Link: https://lore.kernel.org/r/20211102015237.2309763-3-yebin10@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: stable@vger.kernel.org # v5.10+
Signed-off-by: Wen Yang <wenyang.linux@foxmail.com>
---
 drivers/block/nbd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
index bd05eaf04143..1ddae8f768d5 100644
--- a/drivers/block/nbd.c
+++ b/drivers/block/nbd.c
@@ -1773,11 +1773,11 @@ static int nbd_dev_add(int index)
 	disk->major = NBD_MAJOR;
 
 	/* Too big first_minor can cause duplicate creation of
-	 * sysfs files/links, since MKDEV() expect that the max bits of
-	 * first_minor is 20.
+	 * sysfs files/links, since index << part_shift might overflow, or
+	 * MKDEV() expect that the max bits of first_minor is 20.
 	 */
 	disk->first_minor = index << part_shift;
-	if (disk->first_minor > MINORMASK) {
+	if (disk->first_minor < index || disk->first_minor > MINORMASK) {
 		err = -EINVAL;
 		goto out_free_idr;
 	}
-- 
2.37.2

