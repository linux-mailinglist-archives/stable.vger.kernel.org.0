Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5049C5F996A
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbiJJHMH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:12:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231704AbiJJHLT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:11:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97D9E5E575;
        Mon, 10 Oct 2022 00:07:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF66DB80E5D;
        Mon, 10 Oct 2022 07:07:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3367BC433C1;
        Mon, 10 Oct 2022 07:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385644;
        bh=ChhT3O4/jVJQsfuVPoIwoEQwBds6ECYEVClaA463q7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ST1Y3aEv+5ZIjc5GbWz/sVllqqa3xZVpkYT25+1e/yXOs+fj+VcpHF9Qp1GQMGv2X
         19KVXMV5HFShWewp3RsR6KpJt/6yWcNuVM5Ds2C6w8hyCzNjl0nBRtOFVhV7sHXFQe
         O3iWyEhuLI9sa3QC/Yp3QjoxN7VNOiNERO1tioS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Qilong <zhangqilong3@huawei.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 37/48] i2c: davinci: fix PM disable depth imbalance in davinci_i2c_probe
Date:   Mon, 10 Oct 2022 09:05:35 +0200
Message-Id: <20221010070334.656210536@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
References: <20221010070333.676316214@linuxfoundation.org>
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

From: Zhang Qilong <zhangqilong3@huawei.com>

[ Upstream commit e2062df704dea47efe16edcaa2316d7b5ecca64f ]

The pm_runtime_enable will increase power disable depth. Thus a
pairing decrement is needed on the error handling path to keep
it balanced according to context.

Fixes: 17f88151ff190 ("i2c: davinci: Add PM Runtime Support")
Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
Reviewed-by: Bartosz Golaszewski <brgl@bgdev.pl>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-davinci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
index 9e09db31a937..5343c82c8594 100644
--- a/drivers/i2c/busses/i2c-davinci.c
+++ b/drivers/i2c/busses/i2c-davinci.c
@@ -823,7 +823,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 	r = pm_runtime_resume_and_get(dev->dev);
 	if (r < 0) {
 		dev_err(dev->dev, "failed to runtime_get device: %d\n", r);
-		return r;
+		goto err_pm;
 	}
 
 	i2c_davinci_init(dev);
@@ -882,6 +882,7 @@ static int davinci_i2c_probe(struct platform_device *pdev)
 err_unuse_clocks:
 	pm_runtime_dont_use_autosuspend(dev->dev);
 	pm_runtime_put_sync(dev->dev);
+err_pm:
 	pm_runtime_disable(dev->dev);
 
 	return r;
-- 
2.35.1



