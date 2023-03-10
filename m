Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73A0B6B4AB0
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbjCJPZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:25:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbjCJPZd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:25:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C05105F13
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:14:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8320CCE28EA
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 508D7C4339C;
        Fri, 10 Mar 2023 15:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461202;
        bh=kNUCn9oc1p6Pq7Pgnj4XxhTNpziCLAYlIkgINOwQqQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O1ShwAyduHi9Cya60/I+1pYQte4T8u3jsXkYIW4wYLr/45xiKVJB2RMLF5omGUula
         1W/2CHsjHBToRVQRJmgXJtwsovT2z4rfoB/VAsye5UUVhaR1vgPflhuvQlrr0w/ilo
         9uM9HfTLmrGYnyb/HSxr9sJHl2X8pk787/k5KO1I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Yangtao Li <frank.li@vivo.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 029/136] f2fs: fix to avoid potential memory corruption in __update_iostat_latency()
Date:   Fri, 10 Mar 2023 14:42:31 +0100
Message-Id: <20230310133707.877934083@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yangtao Li <frank.li@vivo.com>

[ Upstream commit 0dbbf0fb38d5ec5d4138d1aeaeb43d9217b9a592 ]

Add iotype sanity check to avoid potential memory corruption.
This is to fix the compile error below:

fs/f2fs/iostat.c:231 __update_iostat_latency() error: buffer overflow
'io_lat->peak_lat[type]' 3 <= 3

vim +228 fs/f2fs/iostat.c

  211  static inline void __update_iostat_latency(struct bio_iostat_ctx
	*iostat_ctx,
  212					enum iostat_lat_type type)
  213  {
  214		unsigned long ts_diff;
  215		unsigned int page_type = iostat_ctx->type;
  216		struct f2fs_sb_info *sbi = iostat_ctx->sbi;
  217		struct iostat_lat_info *io_lat = sbi->iostat_io_lat;
  218		unsigned long flags;
  219
  220		if (!sbi->iostat_enable)
  221			return;
  222
  223		ts_diff = jiffies - iostat_ctx->submit_ts;
  224		if (page_type >= META_FLUSH)
                                 ^^^^^^^^^^

  225			page_type = META;
  226
  227		spin_lock_irqsave(&sbi->iostat_lat_lock, flags);
 @228		io_lat->sum_lat[type][page_type] += ts_diff;
                                      ^^^^^^^^^
Mixup between META_FLUSH and NR_PAGE_TYPE leads to memory corruption.

Fixes: a4b6817625e7 ("f2fs: introduce periodic iostat io latency traces")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Suggested-by: Chao Yu <chao@kernel.org>
Suggested-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Yangtao Li <frank.li@vivo.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/iostat.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/iostat.c b/fs/f2fs/iostat.c
index cdcf54ae0db8f..9e0160a02bf4a 100644
--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -194,8 +194,12 @@ static inline void __update_iostat_latency(struct bio_iostat_ctx *iostat_ctx,
 		return;
 
 	ts_diff = jiffies - iostat_ctx->submit_ts;
-	if (iotype >= META_FLUSH)
+	if (iotype == META_FLUSH) {
 		iotype = META;
+	} else if (iotype >= NR_PAGE_TYPE) {
+		f2fs_warn(sbi, "%s: %d over NR_PAGE_TYPE", __func__, iotype);
+		return;
+	}
 
 	if (rw == 0) {
 		idx = READ_IO;
-- 
2.39.2



