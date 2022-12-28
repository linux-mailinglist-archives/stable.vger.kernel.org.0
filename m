Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DE17657FAE
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:07:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbiL1QHv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234419AbiL1QHV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:07:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0360BFF6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:07:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A797BB81719
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2473C433D2;
        Wed, 28 Dec 2022 16:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672243638;
        bh=xZ55kEjwoQY0Fd8jyqoPFAi+N5l7g3TvRFM9aE2oJpo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HORKZ/NtZTsDlUH9Fz8Ja4m1e+MSLT0Q1l0dv2rEE5fXjPPAm0xTgN+Sl9MuP/7iZ
         uLZVMWNA9EXBprG558cUu1oGRMy6Qm6zJOPau6aT2jiEbk5izkZo8AaGE5Z5zLhbwd
         55LfsMhspUEa6gwUEFo6SzCuYpC+SN+/v09Ku4yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Natalia Petrova <n.petrova@fintech.ru>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0561/1073] crypto: nitrox - avoid double free on error path in nitrox_sriov_init()
Date:   Wed, 28 Dec 2022 15:35:49 +0100
Message-Id: <20221228144343.291637506@linuxfoundation.org>
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
index 9e7308e39b30..d4e06999af9b 100644
--- a/drivers/crypto/cavium/nitrox/nitrox_mbx.c
+++ b/drivers/crypto/cavium/nitrox/nitrox_mbx.c
@@ -195,6 +195,7 @@ int nitrox_mbox_init(struct nitrox_device *ndev)
 	ndev->iov.pf2vf_wq = alloc_workqueue("nitrox_pf2vf", 0, 0);
 	if (!ndev->iov.pf2vf_wq) {
 		kfree(ndev->iov.vfdev);
+		ndev->iov.vfdev = NULL;
 		return -ENOMEM;
 	}
 	/* enable pf2vf mailbox interrupts */
-- 
2.35.1



