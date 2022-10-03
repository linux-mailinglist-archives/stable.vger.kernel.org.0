Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD8415F2AD1
	for <lists+stable@lfdr.de>; Mon,  3 Oct 2022 09:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232038AbiJCHl6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Oct 2022 03:41:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231977AbiJCHlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Oct 2022 03:41:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7937854C8E;
        Mon,  3 Oct 2022 00:24:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A048E60FCC;
        Mon,  3 Oct 2022 07:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B22A5C433D6;
        Mon,  3 Oct 2022 07:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664781850;
        bh=fcmI2Frv9IH5HfPwH1WNnfB61A+ckLKxEGelZeBVq34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nGVafk3cZastMJ3TbS8dQwFNMmB00CGLAyWvxAoBKCdV4wp9UdK2LpG9felQMvgoH
         o/29BbLntr1u9pnxGz9Ks2M1ORDwJRXicHURzQnfLJoPrg7EGzk0pURznSYc/7cNhl
         26Mlh7Vw9XbbVbQhngiDE0HIVfAAw3VY0unnV7G8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 26/30] nvme: add new line after variable declatation
Date:   Mon,  3 Oct 2022 09:12:08 +0200
Message-Id: <20221003070717.091275468@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221003070716.269502440@linuxfoundation.org>
References: <20221003070716.269502440@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>

[ Upstream commit f1c772d581843e3a14bbd62ef7e40b56fc307f27 ]

Add a new line in functions nvme_pr_preempt(), nvme_pr_clear(), and
nvme_pr_release() after variable declaration which follows the rest of
the code in the nvme/host/core.c.

No functional change(s) in this patch.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: c292a337d0e4 ("nvme: Fix IOC_PR_CLEAR and IOC_PR_RELEASE ioctls for nvme devices")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index d2ea6ca37c41..c80ce7c1b6a8 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -2018,18 +2018,21 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
 		enum pr_type type, bool abort)
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (abort ? 2 : 1);
+
 	return nvme_pr_command(bdev, cdw10, old, new, nvme_cmd_resv_acquire);
 }
 
 static int nvme_pr_clear(struct block_device *bdev, u64 key)
 {
 	u32 cdw10 = 1 | (key ? 1 << 3 : 0);
+
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_register);
 }
 
 static int nvme_pr_release(struct block_device *bdev, u64 key, enum pr_type type)
 {
 	u32 cdw10 = nvme_pr_type(type) << 8 | (key ? 1 << 3 : 0);
+
 	return nvme_pr_command(bdev, cdw10, key, 0, nvme_cmd_resv_release);
 }
 
-- 
2.35.1



