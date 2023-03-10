Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEC706B41DF
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 14:57:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbjCJN5j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 08:57:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231349AbjCJN5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 08:57:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 680C91151D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 05:57:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 66B50617D5
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 13:57:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77515C433D2;
        Fri, 10 Mar 2023 13:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678456640;
        bh=gLsH/uL6Z+svyRgcK+yjXGRB5bC9JgA2SJY6tUyB6Cc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CVdYXgbZC3+qOmuK+PXWT1YOSgJbleDtGjzwSiDQcbsBPtJix6e2N0AQ6dKQE86Wy
         VZo19zdcOkOdm0QUd4FX9g0lROxik6K1DipR3Z3RvUpXuoraC9I2RmvWvEEiGzdFTr
         ABAWcNwU+Xt8KufKONdFXdiMHwiTRU7jiRYnZLV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>, Chao Yu <chao@kernel.org>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Yangtao Li <frank.li@vivo.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 045/211] f2fs: fix to avoid potential memory corruption in __update_iostat_latency()
Date:   Fri, 10 Mar 2023 14:37:05 +0100
Message-Id: <20230310133720.106601692@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index 3166a8939ed4f..02393c95c9f86 100644
--- a/fs/f2fs/iostat.c
+++ b/fs/f2fs/iostat.c
@@ -227,8 +227,12 @@ static inline void __update_iostat_latency(struct bio_iostat_ctx *iostat_ctx,
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



