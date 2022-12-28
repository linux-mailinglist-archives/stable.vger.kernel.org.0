Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB21B65806D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbiL1QRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234620AbiL1QRB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:17:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F063B1A38A
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92669B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A184C433EF;
        Wed, 28 Dec 2022 16:14:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244088;
        bh=i8cFz/NGR+W2QvY2ThVU4pXhFpj7i6kk3Z/AMLdP7Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SbN7eVN/d4ok0juat544wNCVHCN5jVct2aLan9OrHP+JH0G3RRVTn1huxdC8eV5z9
         2SJAC5SZLiam0A0TYDdRms6tsF6Ry3XYMlcmu3KEnXISIsgB0tIrzdUS4KtoOWhKAs
         eKzjoDwbjMiJ1U9qCKQqksDnG644eAPzBGi+XgYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0576/1146] crypto: hisilicon/qm - re-enable communicate interrupt before notifying PF
Date:   Wed, 28 Dec 2022 15:35:15 +0100
Message-Id: <20221228144345.818470993@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

From: Weili Qian <qianweili@huawei.com>

[ Upstream commit ee1537fe3dd89860d0336563891f6cac707d0cb5 ]

After the device is reset, the VF needs to re-enable communication
interrupt before the VF sends restart complete message to the PF.
If the interrupt is re-enabled after the VF notifies the PF, the PF
may fail to send messages to the VF after receiving VF's restart
complete message.

Fixes: 760fe22cf5e9 ("crypto: hisilicon/qm - update reset flow")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c7e7fc49ec06..e5fefc466ac8 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -5725,6 +5725,7 @@ static void qm_pf_reset_vf_done(struct hisi_qm *qm)
 		cmd = QM_VF_START_FAIL;
 	}
 
+	qm_cmd_init(qm);
 	ret = qm_ping_pf(qm, cmd);
 	if (ret)
 		dev_warn(&pdev->dev, "PF responds timeout in reset done!\n");
@@ -5786,7 +5787,6 @@ static void qm_pf_reset_vf_process(struct hisi_qm *qm,
 		goto err_get_status;
 
 	qm_pf_reset_vf_done(qm);
-	qm_cmd_init(qm);
 
 	dev_info(dev, "device reset done.\n");
 
-- 
2.35.1



