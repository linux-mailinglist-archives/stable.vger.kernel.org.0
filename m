Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07AD35937D5
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244946AbiHOTC7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:02:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245360AbiHOTBv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:01:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BDFA4BD1E;
        Mon, 15 Aug 2022 11:33:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED306B8106C;
        Mon, 15 Aug 2022 18:33:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DF7DC433C1;
        Mon, 15 Aug 2022 18:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588386;
        bh=jGYDKm0Tw+bfYKYZH5hqWm2mnwiYORDMGSxt/7Z6A0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e2itnGBRP/8Ps4gyFvhJHG7K7fesmFCpvnKFk+Ta96Buwox2e9+I4cU2x9WN+fdZ4
         VNCoS3p2YqKjVX7WULRxpsyfx4CCas5aMe3vdnR9UMUPRIvR5r7/VjS1sgn4cwqanY
         xov8X/RREU+QZIaHsdjfeXQygfAXmKPjtP9FhVD0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 359/779] can: error: specify the values of data[5..7] of CAN error frames
Date:   Mon, 15 Aug 2022 20:00:03 +0200
Message-Id: <20220815180352.587551937@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

[ Upstream commit e70a3263a7eed768d5f947b8f2aff8d2a79c9d97 ]

Currently, data[5..7] of struct can_frame, when used as a CAN error
frame, are defined as being "controller specific". Device specific
behaviours are problematic because it prevents someone from writing
code which is portable between devices.

As a matter of fact, data[5] is never used, data[6] is always used to
report TX error counter and data[7] is always used to report RX error
counter. can-utils also relies on this.

This patch updates the comment in the uapi header to specify that
data[5] is reserved (and thus should not be used) and that data[6..7]
are used for error counters.

Fixes: 0d66548a10cb ("[CAN]: Add PF_CAN core module")
Link: https://lore.kernel.org/all/20220719143550.3681-11-mailhol.vincent@wanadoo.fr
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/uapi/linux/can/error.h | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/can/error.h b/include/uapi/linux/can/error.h
index 34633283de64..a1000cb63063 100644
--- a/include/uapi/linux/can/error.h
+++ b/include/uapi/linux/can/error.h
@@ -120,6 +120,9 @@
 #define CAN_ERR_TRX_CANL_SHORT_TO_GND  0x70 /* 0111 0000 */
 #define CAN_ERR_TRX_CANL_SHORT_TO_CANH 0x80 /* 1000 0000 */
 
-/* controller specific additional information / data[5..7] */
+/* data[5] is reserved (do not use) */
+
+/* TX error counter / data[6] */
+/* RX error counter / data[7] */
 
 #endif /* _UAPI_CAN_ERROR_H */
-- 
2.35.1



