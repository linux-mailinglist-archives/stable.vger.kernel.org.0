Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F92A6D4935
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233622AbjDCOfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:35:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233621AbjDCOft (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:35:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 370011FE1
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:35:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA82961E73
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:35:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E007EC4339B;
        Mon,  3 Apr 2023 14:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680532547;
        bh=mEBjERivfwzPAjwAhvtJsPGyYdvaT7idA8OjqIELXqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOr/+uG6/36R1EkOB3L1PbhEaoUzhb6gpWIKF01QKqLKMXPqY9NPq+86wWTmTV0wD
         6kM58Ze2m2Y++D8Fu3fLwkRkgK7jMzDmIcLXwhu1jRR4xNNUnckgRel5DG74LqwQfU
         /5w3P1KBneLwe28L8BDiwlkZFeKpdSH5xrveSl+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 009/181] zonefs: Fix error message in zonefs_file_dio_append()
Date:   Mon,  3 Apr 2023 16:07:24 +0200
Message-Id: <20230403140415.421955678@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140415.090615502@linuxfoundation.org>
References: <20230403140415.090615502@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

[ Upstream commit 88b170088ad2c3e27086fe35769aa49f8a512564 ]

Since the expected write location in a sequential file is always at the
end of the file (append write), when an invalid write append location is
detected in zonefs_file_dio_append(), print the invalid written location
instead of the expected write location.

Fixes: a608da3bd730 ("zonefs: Detect append writes at invalid locations")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/zonefs/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/zonefs/file.c b/fs/zonefs/file.c
index 738b0e28d74b5..c71cc0fcb3ec8 100644
--- a/fs/zonefs/file.c
+++ b/fs/zonefs/file.c
@@ -426,7 +426,7 @@ static ssize_t zonefs_file_dio_append(struct kiocb *iocb, struct iov_iter *from)
 		if (bio->bi_iter.bi_sector != wpsector) {
 			zonefs_warn(inode->i_sb,
 				"Corrupted write pointer %llu for zone at %llu\n",
-				wpsector, z->z_sector);
+				bio->bi_iter.bi_sector, z->z_sector);
 			ret = -EIO;
 		}
 	}
-- 
2.39.2



