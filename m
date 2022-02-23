Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745214C159B
	for <lists+stable@lfdr.de>; Wed, 23 Feb 2022 15:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiBWOmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Feb 2022 09:42:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229893AbiBWOmc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Feb 2022 09:42:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D9DFB3E6C;
        Wed, 23 Feb 2022 06:42:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1339EB81FCE;
        Wed, 23 Feb 2022 14:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABBBC340E7;
        Wed, 23 Feb 2022 14:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645627321;
        bh=54knkAHgw4FVQ6bPw0gxjMifXkkf7pu6KINdWoLri+c=;
        h=From:To:Cc:Subject:Date:From;
        b=rkQtj8PDP2Deulram9ERTWwLjDnlpnC2sBniN8+liD+2uHbKr1Kf63qH9E5vKC2cu
         TaRTlmooVLtbpbbSPgE/6oMo0qGBspX3dhfcq2DpSFyahkIGqtoZpmSRxzx++qaC9T
         8rFD1ghTUCPHv8qPHhjfwOMf2hrpqKT+gbxScNeZDajJ/VRHEGvdgoP1nMxMYQdUx+
         p94GK5cekpWzW9sAgDFTkqO2WtWbHTtE3jgd92lA0eoFOJg5/D4mreEGSIRp+hkU8b
         GbUBZqiR3WNFkolC/Wcd058whKkQFqsTDzi2DUDRNUrk/XvdJVGlRUYkPla+ZTvQ0E
         ze78UZuKW7S7Q==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     dinguyen@kernel.org, linux-fpga@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Ang Tien Sung <tien.sung.ang@intel.com>,
        stable@vger.kernel.org
Subject: [PATCH] firmware: stratix10-svc: add missing callback parameter on RSU
Date:   Wed, 23 Feb 2022 08:41:46 -0600
Message-Id: <20220223144146.399263-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Ang Tien Sung <tien.sung.ang@intel.com>

Fix a bug whereby, the return response of parameter a1 from an
SMC call is not properly set to the callback data during an
INTEL_SIP_SMC_RSU_ERROR command.

Cc: stable@vger.kernel.org
Fixes: 6b50d882d38d ("firmware: add remote status update client support")
Link: https://lore.kernel.org/lkml/20220216081513.28319-1-tien.sung.ang@intel.com
Signed-off-by: Ang Tien Sung <tien.sung.ang@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/firmware/stratix10-svc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/stratix10-svc.c b/drivers/firmware/stratix10-svc.c
index 29c0a616b317..c4bf934e3553 100644
--- a/drivers/firmware/stratix10-svc.c
+++ b/drivers/firmware/stratix10-svc.c
@@ -477,7 +477,7 @@ static int svc_normal_to_secure_thread(void *data)
 		case INTEL_SIP_SMC_RSU_ERROR:
 			pr_err("%s: STATUS_ERROR\n", __func__);
 			cbdata->status = BIT(SVC_STATUS_ERROR);
-			cbdata->kaddr1 = NULL;
+			cbdata->kaddr1 = &res.a1;
 			cbdata->kaddr2 = NULL;
 			cbdata->kaddr3 = NULL;
 			pdata->chan->scl->receive_cb(pdata->chan->scl, cbdata);
-- 
2.25.1

