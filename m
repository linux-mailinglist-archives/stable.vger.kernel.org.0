Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 574BC658059
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:17:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232525AbiL1QRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:17:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233013AbiL1QQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:16:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B76D81AA05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:14:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5388EB81730
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:14:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 964B1C433EF;
        Wed, 28 Dec 2022 16:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244046;
        bh=UM2gO9+o7hnCGwcUNaEeEQAPY079Neovmli6/kdR7V4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a6Etal0rtT+NSm3i/KnBkRQDFF9gkpP4ft0EhKwtXgaQIQrPdEFZpHWYyPUXvz8/k
         NcYBwRESIVndmpO9aV4gES/cslk/Qvchtn3K7RD46C1qpSRGxexNHT5LkglLYsUjl7
         R6wA/PYHO5kFBB11EAjWWGl4PmiS5q+hdLXit5I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0637/1073] crypto: qat - fix error return code in adf_probe
Date:   Wed, 28 Dec 2022 15:37:05 +0100
Message-Id: <20221228144345.342380648@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit 31f81401e23fb88cc030cd586abd28740e6c8136 ]

Fix to return a negative error code -EINVAL instead of 0.

Fixes: 0cec19c761e5 ("crypto: qat - add support for compression for 4xxx")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/qat/qat_4xxx/adf_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/qat/qat_4xxx/adf_drv.c b/drivers/crypto/qat/qat_4xxx/adf_drv.c
index 2f212561acc4..670a58b25cb1 100644
--- a/drivers/crypto/qat/qat_4xxx/adf_drv.c
+++ b/drivers/crypto/qat/qat_4xxx/adf_drv.c
@@ -261,6 +261,7 @@ static int adf_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	hw_data->accel_capabilities_mask = hw_data->get_accel_cap(accel_dev);
 	if (!hw_data->accel_capabilities_mask) {
 		dev_err(&pdev->dev, "Failed to get capabilities mask.\n");
+		ret = -EINVAL;
 		goto out_err;
 	}
 
-- 
2.35.1



