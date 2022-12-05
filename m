Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5A1E64346F
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiLETqw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:46:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235027AbiLETq0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:46:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB3510FD9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9CF1B81157
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EE42C433C1;
        Mon,  5 Dec 2022 19:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269362;
        bh=NvfDMxx2d7R8BROHEfvBBMdHuyp1ZZaSUHN1dkXnrNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b14VCvVa63xPROiaflEBRVpvI7HJpkHeamOZvT+23yj4KxcYcRtKyKwe22CaeZr8e
         GwiRVDQUEBciM3jTnIPjFv5EDoPQt8IWhDB1XihzXD/YqGpt/D5vLjkZg0HIF3/C/H
         RjEIRRdfSqD+WKDMCmxYgnDC/U2Cn+fl02wlUtRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 100/153] can: cc770: cc770_isa_probe(): add missing free_cc770dev()
Date:   Mon,  5 Dec 2022 20:10:24 +0100
Message-Id: <20221205190811.615280613@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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

From: Zhang Changzhong <zhangchangzhong@huawei.com>

[ Upstream commit 62ec89e74099a3d6995988ed9f2f996b368417ec ]

Add the missing free_cc770dev() before return from cc770_isa_probe()
in the register_cc770dev() error handling case.

In addition, remove blanks before goto labels.

Fixes: 7e02e5433e00 ("can: cc770: legacy CC770 ISA bus driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/all/1668168557-6024-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/cc770/cc770_isa.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/cc770/cc770_isa.c b/drivers/net/can/cc770/cc770_isa.c
index b9047d8110d5..910e8c309a67 100644
--- a/drivers/net/can/cc770/cc770_isa.c
+++ b/drivers/net/can/cc770/cc770_isa.c
@@ -264,22 +264,24 @@ static int cc770_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev,
 			"couldn't register device (err=%d)\n", err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "device registered (reg_base=0x%p, irq=%d)\n",
 		 priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_cc770dev(dev);
+exit_unmap:
 	if (mem[idx])
 		iounmap(base);
- exit_release:
+exit_release:
 	if (mem[idx])
 		release_mem_region(mem[idx], iosize);
 	else
 		release_region(port[idx], iosize);
- exit:
+exit:
 	return err;
 }
 
-- 
2.35.1



