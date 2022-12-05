Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8225664332B
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234295AbiLETen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:34:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234377AbiLETeQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D9925C68
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:29:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 853E2B81181
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:29:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCA82C433C1;
        Mon,  5 Dec 2022 19:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268584;
        bh=7jCnltHLPt9HnNgZepS3iEQQd3SHntJwFpw4hyf1u3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tMEm3/eacfuxrQEoN+AfhrAeUkI2ntKY1M6X7eW6UZyDdkZKQxB6ftWCiSh+b/RSO
         /fOSL/7uh6ONjElkR+fH13RNzVhUFFh9syVzApf5rgTIApLtDUyZr4tVf59wbrSk3M
         yzwFS3fWaIRukbB3VfbLh/HciOXJyahwJxQs90DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, YueHaibing <yuehaibing@huawei.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 30/92] net/mlx5: Fix uninitialized variable bug in outlen_write()
Date:   Mon,  5 Dec 2022 20:09:43 +0100
Message-Id: <20221205190804.460770104@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: YueHaibing <yuehaibing@huawei.com>

[ Upstream commit 3f5769a074c13d8f08455e40586600419e02a880 ]

If sscanf() return 0, outlen is uninitialized and used in kzalloc(),
this is unexpected. We should return -EINVAL if the string is invalid.

Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/cmd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
index c838d8698eab..39c17e903915 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/cmd.c
@@ -1422,8 +1422,8 @@ static ssize_t outlen_write(struct file *filp, const char __user *buf,
 		return -EFAULT;
 
 	err = sscanf(outlen_str, "%d", &outlen);
-	if (err < 0)
-		return err;
+	if (err != 1)
+		return -EINVAL;
 
 	ptr = kzalloc(outlen, GFP_KERNEL);
 	if (!ptr)
-- 
2.35.1



