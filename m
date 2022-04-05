Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5FCE4F3B3C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:15:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345935AbiDELwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356675AbiDEKYq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:24:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72604BF024;
        Tue,  5 Apr 2022 03:08:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25A25B81C88;
        Tue,  5 Apr 2022 10:08:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85AF0C385A1;
        Tue,  5 Apr 2022 10:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153326;
        bh=n3jyOXKYxe6u5mjO/HkPB5eTqSSy5dyknXVWnH6VdXU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eq2aZJor10n/KTYECP5bi8N52CL0uCz7kf11Qz3g5h6POmdhyzn80WeVpmcEoQ5ZD
         H4ksBUWwbrD14w6TFMppKWM9QxmeDTDZSX2ITX06Lu0/ngP3KR0200nab3RLIe82YA
         /asQ46WZIuNknsN0l94KUmd5ep2BsP3yk/cGaKN0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fengnan Chang <changfengnan@vivo.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 183/599] f2fs: compress: remove unneeded read when rewrite whole cluster
Date:   Tue,  5 Apr 2022 09:27:57 +0200
Message-Id: <20220405070304.287127761@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fengnan Chang <changfengnan@vivo.com>

[ Upstream commit 7eab7a6968278c735b1ca6387056a408f7960265 ]

when we overwrite the whole page in cluster, we don't need read original
data before write, because after write_end(), writepages() can help to
load left data in that cluster.

Signed-off-by: Fengnan Chang <changfengnan@vivo.com>
Signed-off-by: Chao Yu <yuchao0@huawei.com>
Acked-by: Chao Yu <yuchao0@huawei.com>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/f2fs/data.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index d27a92a54447..04e980c58319 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -3461,6 +3461,9 @@ static int f2fs_write_begin(struct file *file, struct address_space *mapping,
 
 		*fsdata = NULL;
 
+		if (len == PAGE_SIZE)
+			goto repeat;
+
 		ret = f2fs_prepare_compress_overwrite(inode, pagep,
 							index, fsdata);
 		if (ret < 0) {
-- 
2.34.1



