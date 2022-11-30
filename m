Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5298C63DFC2
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231407AbiK3SuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiK3SuP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:50:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 408D24666D
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:50:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED32EB81CAA
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DD75C433D6;
        Wed, 30 Nov 2022 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669834212;
        bh=4U3+mb3n70ovb4Lg9tEv9Oo48vEG3Fcv7bNdFjel2yw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WDtVx2N2Mn4G8nSLOjkgoZSrP1ZJFg9TWX0FK1evl2crp2wxX2w/j6PblYeTCzumD
         3bkMgGkNIs5RQDuKHg4bX40z0PX/ZcaX77M1foQIOMN+obyc4lCpR1cKbzHacsAwRb
         o+JoNG4VThqqIdG8jVapQCRZCWZdUBVgJZPJSoYE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wei Yongjun <weiyongjun1@huawei.com>,
        Harald Freudenberger <freude@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 143/289] s390/ap: fix memory leak in ap_init_qci_info()
Date:   Wed, 30 Nov 2022 19:22:08 +0100
Message-Id: <20221130180547.379953035@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
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

From: Wei Yongjun <weiyongjun1@huawei.com>

[ Upstream commit 9ac74f0666ceab0b1047e9d59be846a3345e4e98 ]

If kzalloc() for 'ap_qci_info_old' failed, 'ap_qci_info' shold be
freed before return. Otherwise it is a memory leak.

Link: https://lore.kernel.org/r/20221114110830.542246-1-weiyongjun@huaweicloud.com
Fixes: 283915850a44 ("s390/ap: notify drivers on config changed and scan complete callbacks")
Signed-off-by: Wei Yongjun <weiyongjun1@huawei.com>
Signed-off-by: Harald Freudenberger <freude@linux.ibm.com>
Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/crypto/ap_bus.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
index 59ac98f2bd27..b02c631f3b71 100644
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -233,8 +233,11 @@ static void __init ap_init_qci_info(void)
 	if (!ap_qci_info)
 		return;
 	ap_qci_info_old = kzalloc(sizeof(*ap_qci_info_old), GFP_KERNEL);
-	if (!ap_qci_info_old)
+	if (!ap_qci_info_old) {
+		kfree(ap_qci_info);
+		ap_qci_info = NULL;
 		return;
+	}
 	if (ap_fetch_qci_info(ap_qci_info) != 0) {
 		kfree(ap_qci_info);
 		kfree(ap_qci_info_old);
-- 
2.35.1



