Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527BE60BBD5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 23:16:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232524AbiJXVQC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 17:16:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbiJXVPl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 17:15:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90D99153E34;
        Mon, 24 Oct 2022 12:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D6282CE1331;
        Mon, 24 Oct 2022 11:45:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27D4C433C1;
        Mon, 24 Oct 2022 11:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611954;
        bh=j8D/KeJTXJxe8JNBywbRj9NUB4PG3noMKhqa5JgyQlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hsT4EGmP8noBEkpFE3KXDiLKfW/IYg6A0rSCcvcE3oUc5s18kz7Z8S0o+nOgZuWA
         sXLppNXgygWHKia9u9B9ssnpXo8C8ev+mQlMoJB7F81nzjSu4SEy2QPlfbhLTi3p41
         SeK8EKEVBhfMGACizzjd4udO22LmD+0IOaTWlOyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 015/210] nvme: add new line after variable declatation
Date:   Mon, 24 Oct 2022 13:28:52 +0200
Message-Id: <20221024112957.418380442@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 2d95755092e3..487226531a7d 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1345,18 +1345,21 @@ static int nvme_pr_preempt(struct block_device *bdev, u64 old, u64 new,
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



