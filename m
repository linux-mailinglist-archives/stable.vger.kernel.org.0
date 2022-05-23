Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 916F7531AA1
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:55:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241276AbiEWR34 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:29:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242849AbiEWR2H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:28:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 148668D68F;
        Mon, 23 May 2022 10:24:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 774EEB81204;
        Mon, 23 May 2022 17:24:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1E76C385AA;
        Mon, 23 May 2022 17:24:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326673;
        bh=AbRLW6KpKD4tIN4tfMldWC0Y7qjHWvaSMDBU+t7g3Ps=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JzbfKBi5/UE1Xc+p1jLuo7muT7hcmx2hEuXQfO9BaNOdp0ueuIyujJZ9+3ytlmoIS
         Faksfmyh0vEWl8lLG10YjCqm3/s2Cx0YLvyOlllatKwKfN/E5XjHVVUZLdOHCKFVGm
         AM3VH1F/L0w21wrzqDfMI1Zs/YgjEfOCpCmwmnZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 024/158] Input: stmfts - fix reference leak in stmfts_input_open
Date:   Mon, 23 May 2022 19:03:01 +0200
Message-Id: <20220523165834.573273762@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 26623eea0da3476446909af96c980768df07bbd9 ]

pm_runtime_get_sync() will increment pm usage counter even it
failed. Forgetting to call pm_runtime_put_noidle will result
in reference leak in stmfts_input_open, so we should fix it.

Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Link: https://lore.kernel.org/r/20220317131604.53538-1-zhengyongjun3@huawei.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/stmfts.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/input/touchscreen/stmfts.c b/drivers/input/touchscreen/stmfts.c
index bc11203c9cf7..72e0b767e1ba 100644
--- a/drivers/input/touchscreen/stmfts.c
+++ b/drivers/input/touchscreen/stmfts.c
@@ -339,11 +339,11 @@ static int stmfts_input_open(struct input_dev *dev)
 
 	err = pm_runtime_get_sync(&sdata->client->dev);
 	if (err < 0)
-		return err;
+		goto out;
 
 	err = i2c_smbus_write_byte(sdata->client, STMFTS_MS_MT_SENSE_ON);
 	if (err)
-		return err;
+		goto out;
 
 	mutex_lock(&sdata->mutex);
 	sdata->running = true;
@@ -366,7 +366,9 @@ static int stmfts_input_open(struct input_dev *dev)
 				 "failed to enable touchkey\n");
 	}
 
-	return 0;
+out:
+	pm_runtime_put_noidle(&sdata->client->dev);
+	return err;
 }
 
 static void stmfts_input_close(struct input_dev *dev)
-- 
2.35.1



