Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 576D1658119
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiL1QYt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234694AbiL1QYM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5751017E22
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA64861577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 016DEC433F0;
        Wed, 28 Dec 2022 16:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244473;
        bh=YouEOGUM/DdUuI29B6fQVpCzMYI26j2mBLdDb8TgWfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z7gNkvCiH71cWMle4pM+X+4TmUDo/OW6JTcH82TNsf8QT8foHi9aqdJUUah96MZGO
         WMEZF3lwgqmNqgVwNl2V2AOp9/PHRuR4Nq9RMBspFpSgC4RxCN5bVPvJmIXlUM/bB5
         dCkxgPNnc7QTll3crM3sZHWXAIeGd1lma8ObcAQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Weili Qian <qianweili@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0644/1146] crypto: hisilicon/qm - fix QM_XEQ_DEPTH_CAP mask value
Date:   Wed, 28 Dec 2022 15:36:23 +0100
Message-Id: <20221228144347.652775486@linuxfoundation.org>
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

[ Upstream commit 3901355624d14afe3230252cb36bc3da8ff6890e ]

'QM_XEQ_DEPTH_CAP' mask value is GENMASK(31, 0) instead of GENMASK(15, 0).
If the mask value is incorrect, will cause abnormal events cannot be
handled. So fix it.

Fixes: 129a9f340172 ("crypto: hisilicon/qm - get qp num and depth from hardware registers")
Signed-off-by: Weili Qian <qianweili@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index e5fefc466ac8..9282506d10c3 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -359,7 +359,7 @@ static const struct hisi_qm_cap_info qm_cap_info_vf[] = {
 static const struct hisi_qm_cap_info qm_basic_info[] = {
 	{QM_TOTAL_QP_NUM_CAP,   0x100158, 0,  GENMASK(10, 0), 0x1000,    0x400,     0x400},
 	{QM_FUNC_MAX_QP_CAP,    0x100158, 11, GENMASK(10, 0), 0x1000,    0x400,     0x400},
-	{QM_XEQ_DEPTH_CAP,      0x3104,   0,  GENMASK(15, 0), 0x800,     0x4000800, 0x4000800},
+	{QM_XEQ_DEPTH_CAP,      0x3104,   0,  GENMASK(31, 0), 0x800,     0x4000800, 0x4000800},
 	{QM_QP_DEPTH_CAP,       0x3108,   0,  GENMASK(31, 0), 0x4000400, 0x4000400, 0x4000400},
 	{QM_EQ_IRQ_TYPE_CAP,    0x310c,   0,  GENMASK(31, 0), 0x10000,   0x10000,   0x10000},
 	{QM_AEQ_IRQ_TYPE_CAP,   0x3110,   0,  GENMASK(31, 0), 0x0,       0x10001,   0x10001},
-- 
2.35.1



