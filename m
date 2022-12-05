Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D149A643398
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:37:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234594AbiLEThv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:37:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234597AbiLETh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:37:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C436B2A955
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:34:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3D3EDCE139A
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FA04C433D7;
        Mon,  5 Dec 2022 19:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268862;
        bh=bx2QDi+70ZC7WKXvJ5K7xand1bn0lSxKl62Tv4c0qWY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VWAFHybaatuVAqYL5PX+YT0UszVP3wzGU02urOWBnUOormG9HkPTxfy/F7DtuYiDc
         g8m58vbdVH7dneADuuDJqU6fqLsNwmi9clu24wRq6xD5p2kJR+uvZ8lQlZ6igsGfbX
         /YdV1dWRxiTaiJICv60G18LTAtx14C22nnA9yQ4g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/120] can: sja1000_isa: sja1000_isa_probe(): add missing free_sja1000dev()
Date:   Mon,  5 Dec 2022 20:09:38 +0100
Message-Id: <20221205190807.689768324@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ Upstream commit 92dfd9310a71d28cefe6a2d5174d43fab240e631 ]

Add the missing free_sja1000dev() before return from
sja1000_isa_probe() in the register_sja1000dev() error handling case.

In addition, remove blanks before goto labels.

Fixes: 2a6ba39ad6a2 ("can: sja1000: legacy SJA1000 ISA bus driver")
Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Link: https://lore.kernel.org/all/1668168521-5540-1-git-send-email-zhangchangzhong@huawei.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/sja1000/sja1000_isa.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/net/can/sja1000/sja1000_isa.c b/drivers/net/can/sja1000/sja1000_isa.c
index d513fac50718..db3e767d5320 100644
--- a/drivers/net/can/sja1000/sja1000_isa.c
+++ b/drivers/net/can/sja1000/sja1000_isa.c
@@ -202,22 +202,24 @@ static int sja1000_isa_probe(struct platform_device *pdev)
 	if (err) {
 		dev_err(&pdev->dev, "registering %s failed (err=%d)\n",
 			DRV_NAME, err);
-		goto exit_unmap;
+		goto exit_free;
 	}
 
 	dev_info(&pdev->dev, "%s device registered (reg_base=0x%p, irq=%d)\n",
 		 DRV_NAME, priv->reg_base, dev->irq);
 	return 0;
 
- exit_unmap:
+exit_free:
+	free_sja1000dev(dev);
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



