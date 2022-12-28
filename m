Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCC1B657AD7
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:15:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbiL1PPj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233042AbiL1PPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:15:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E79A513F05
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:15:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9A393B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1099DC433D2;
        Wed, 28 Dec 2022 15:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240526;
        bh=YWXyEml4yqDY5LK05CcTctoFxzyp7bkqjDqjGEZa82E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MrUzqyk+wh7QMQTI5E5+QW0W8w42ArmBIKVv2k9KSoNgdG60nksy9U3B7tf4uvC+1
         ShGNx1HwPoEHp0oirS44o/luW74L1iTC1FI4Hz8x7DgrQPAmkib7LKdL1+arQIGSic
         D+2SDTq8mjPeWxTsg9zVNbG2iBt2aW18WuDVcLok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Natalia Petrova <n.petrova@fintech.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 363/731] crypto: nitrox - avoid double free on error path in nitrox_sriov_init()
Date:   Wed, 28 Dec 2022 15:37:50 +0100
Message-Id: <20221228144307.082713718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
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

From: Natalia Petrova <n.petrova@fintech.ru>

[ Upstream commit 094528b6a5a755b1195a01e10b13597d67d1a0e6 ]

If alloc_workqueue() fails in nitrox_mbox_init() it deallocates
ndev->iov.vfdev and returns error code, but then nitrox_sriov_init()
calls nitrox_sriov_cleanup() where ndev->iov.vfdev is deallocated
again.

Fix this by nulling ndev->iov.vfdev after the first deallocation.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 9e5de3e06e54 ("crypto: cavium/nitrox - Add mailbox...")
Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/cavium/nitrox/nitrox_mbx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/crypto/cavium/nitrox/nitrox_mbx.c b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
index 2e9c0d214363..199fcec9b8d0 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -191,6 +191,7 @@ int nitrox_mbox_init(struct nitrox_device *ndev)
 	ndev->iov.pf2vf_wq = alloc_workqueue("nitrox_pf2vf", 0, 0);
 	if (!ndev->iov.pf2vf_wq) {
 		kfree(ndev->iov.vfdev);
+		ndev->iov.vfdev = NULL;
 		return -ENOMEM;
 	}
 	/* enable pf2vf mailbox interrupts */
-- 
2.35.1



