Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13B7D4F357B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:50:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242027AbiDEIg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239621AbiDEIUQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:20:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D1CAF9;
        Tue,  5 Apr 2022 01:17:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DF5E2B81B92;
        Tue,  5 Apr 2022 08:17:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4719CC385A1;
        Tue,  5 Apr 2022 08:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649146640;
        bh=BvOMy4RbsI49sIO4SepK9xXqk0plSR56A0uhNkJ0EQs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQRdl9W3GWafRNq62HfTpCR12xcXBFPjg5DKSaoWfV5xcbtE9uLi23d/r5zV08ZaC
         kmdRNmb8RgrknPR2ox8Bzp/4HVEqdlI8Gw/lktMMkthzFR8Ii+iIw7MGuzKNtHiee7
         wLC/ohjKAQnlm3eDmpCToUMbgX+22YJq6CSphrRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kai Ye <yekai13@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0835/1126] crypto: hisilicon/qm - cleanup warning in qm_vf_read_qos
Date:   Tue,  5 Apr 2022 09:26:22 +0200
Message-Id: <20220405070432.066874750@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai Ye <yekai13@huawei.com>

[ Upstream commit 05b3bade290d6c940701f97f3233c07cfe27205d ]

The kernel test rebot report this warning: Uninitialized variable: ret.
The code flow may return value of ret directly. This value is an
uninitialized variable, here is fix it.

Signed-off-by: Kai Ye <yekai13@huawei.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/hisilicon/qm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/hisilicon/qm.c b/drivers/crypto/hisilicon/qm.c
index c5b84a5ea350..3b29c8993b8c 100644
--- a/drivers/crypto/hisilicon/qm.c
+++ b/drivers/crypto/hisilicon/qm.c
@@ -4295,7 +4295,7 @@ static void qm_vf_get_qos(struct hisi_qm *qm, u32 fun_num)
 static int qm_vf_read_qos(struct hisi_qm *qm)
 {
 	int cnt = 0;
-	int ret;
+	int ret = -EINVAL;
 
 	/* reset mailbox qos val */
 	qm->mb_qos = 0;
-- 
2.34.1



