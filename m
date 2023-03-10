Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C85856B4A40
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:20:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233267AbjCJPUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:20:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbjCJPUL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:20:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4C312DDCD
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:10:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4821ACE2942
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:09:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FD7FC433D2;
        Fri, 10 Mar 2023 15:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460955;
        bh=tw+6G/rxqMb1GJYc5EqdCAGNkOYKA6VdtFu9kSDFbyQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jQTWBkuvUPwwtLVht9z+Iq0kM/8RmbxjNrefkg7Eg5XRIGC6rrDixO1kAcw9K/6aK
         yGrLqRpuUb8DCPnOkijKpqqozd5VBFm5BWUr5eFHJtCQnjhrs4bII5N5iqWhxPTX0C
         KvJH5eMwSjK5s4O+NY4nliUMmsGWQRoq+x+dUCcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zhong Jinghua <zhongjinghua@huawei.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 477/529] loop: loop_set_status_from_info() check before assignment
Date:   Fri, 10 Mar 2023 14:40:20 +0100
Message-Id: <20230310133826.952431571@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

From: Zhong Jinghua <zhongjinghua@huawei.com>

[ Upstream commit 9f6ad5d533d1c71e51bdd06a5712c4fbc8768dfa ]

In loop_set_status_from_info(), lo->lo_offset and lo->lo_sizelimit should
be checked before reassignment, because if an overflow error occurs, the
original correct value will be changed to the wrong value, and it will not
be changed back.

More, the original patch did not solve the problem, the value was set and
ioctl returned an error, but the subsequent io used the value in the loop
driver, which still caused an alarm:

loop_handle_cmd
 do_req_filebacked
  loff_t pos = ((loff_t) blk_rq_pos(rq) << 9) + lo->lo_offset;
  lo_rw_aio
   cmd->iocb.ki_pos = pos

Fixes: c490a0b5a4f3 ("loop: Check for overflow while configuring loop")
Signed-off-by: Zhong Jinghua <zhongjinghua@huawei.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20230221095027.3656193-1-zhongjinghua@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index b10410585a746..d86fbea54652a 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1029,13 +1029,13 @@ loop_set_status_from_info(struct loop_device *lo,
 	if (err)
 		return err;
 
+	/* Avoid assigning overflow values */
+	if (info->lo_offset > LLONG_MAX || info->lo_sizelimit > LLONG_MAX)
+		return -EOVERFLOW;
+
 	lo->lo_offset = info->lo_offset;
 	lo->lo_sizelimit = info->lo_sizelimit;
 
-	/* loff_t vars have been assigned __u64 */
-	if (lo->lo_offset < 0 || lo->lo_sizelimit < 0)
-		return -EOVERFLOW;
-
 	memcpy(lo->lo_file_name, info->lo_file_name, LO_NAME_SIZE);
 	memcpy(lo->lo_crypt_name, info->lo_crypt_name, LO_NAME_SIZE);
 	lo->lo_file_name[LO_NAME_SIZE-1] = 0;
-- 
2.39.2



