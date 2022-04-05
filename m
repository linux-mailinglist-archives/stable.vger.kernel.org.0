Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5754F29FB
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 12:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243686AbiDEKhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239003AbiDEJdP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B51351B78C;
        Tue,  5 Apr 2022 02:21:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61D57B81C77;
        Tue,  5 Apr 2022 09:21:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4EC7C385A0;
        Tue,  5 Apr 2022 09:21:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150493;
        bh=oNJJptU9u/zceqK/D8gBY0xZZHowfss4cI6kI7VcPaI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rn+WaevP5fWQ5v3vKr9oIpDFx+3kYjv3CJxt1k2DnBY6D1lGBb/Awg/cYuZaMUQw6
         TooB/UjfIRjSzkBJflXOZG4QTmSCsJ4Qb/KILIhzxsXyavCrzU+XRz458uKkAMzDva
         JnswptBXg22k5q2fu+GRmDGtYDUIMceFE5lNtpvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 074/913] net: bnxt_ptp: fix compilation error
Date:   Tue,  5 Apr 2022 09:18:56 +0200
Message-Id: <20220405070342.041921381@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

commit dcf500065fabe27676dfe7b4ba521a4f1e0fc8ac upstream.

The Broadcom bnxt_ptp driver does not compile with GCC 11.2.2 when
CONFIG_WERROR is enabled. The following error is generated:

drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c: In function ‘bnxt_ptp_enable’:
drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:400:43: error: array
subscript 255 is above array bounds of ‘struct pps_pin[4]’
[-Werror=array-bounds]
  400 |  ptp->pps_info.pins[pin_id].event = BNXT_PPS_EVENT_EXTERNAL;
      |  ~~~~~~~~~~~~~~~~~~^~~~~~~~
In file included from drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c:20:
drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h:75:24: note: while
referencing ‘pins’
   75 |         struct pps_pin pins[BNXT_MAX_TSIO_PINS];
      |                        ^~~~
cc1: all warnings being treated as errors

This is due to the function ptp_find_pin() returning a pin ID of -1 when
a valid pin is not found and this error never being checked.
Change the TSIO_PIN_VALID() function to also check that a pin ID is not
negative and use this macro in bnxt_ptp_enable() to check the result of
the calls to ptp_find_pin() to return an error early for invalid pins.
This fixes the compilation error.

Cc: <stable@vger.kernel.org>
Fixes: 9e518f25802c ("bnxt_en: 1PPS functions to configure TSIO pins")
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://lore.kernel.org/r/20220328062708.207079-1-damien.lemoal@opensource.wdc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c |    6 +++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h |    2 +-
 2 files changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c
@@ -331,7 +331,7 @@ static int bnxt_ptp_enable(struct ptp_cl
 	struct bnxt_ptp_cfg *ptp = container_of(ptp_info, struct bnxt_ptp_cfg,
 						ptp_info);
 	struct bnxt *bp = ptp->bp;
-	u8 pin_id;
+	int pin_id;
 	int rc;
 
 	switch (rq->type) {
@@ -339,6 +339,8 @@ static int bnxt_ptp_enable(struct ptp_cl
 		/* Configure an External PPS IN */
 		pin_id = ptp_find_pin(ptp->ptp_clock, PTP_PF_EXTTS,
 				      rq->extts.index);
+		if (!TSIO_PIN_VALID(pin_id))
+			return -EOPNOTSUPP;
 		if (!on)
 			break;
 		rc = bnxt_ptp_cfg_pin(bp, pin_id, BNXT_PPS_PIN_PPS_IN);
@@ -352,6 +354,8 @@ static int bnxt_ptp_enable(struct ptp_cl
 		/* Configure a Periodic PPS OUT */
 		pin_id = ptp_find_pin(ptp->ptp_clock, PTP_PF_PEROUT,
 				      rq->perout.index);
+		if (!TSIO_PIN_VALID(pin_id))
+			return -EOPNOTSUPP;
 		if (!on)
 			break;
 
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.h
@@ -28,7 +28,7 @@ struct pps_pin {
 	u8 state;
 };
 
-#define TSIO_PIN_VALID(pin) ((pin) < (BNXT_MAX_TSIO_PINS))
+#define TSIO_PIN_VALID(pin) ((pin) >= 0 && (pin) < (BNXT_MAX_TSIO_PINS))
 
 #define EVENT_DATA2_PPS_EVENT_TYPE(data2)				\
 	((data2) & ASYNC_EVENT_CMPL_PPS_TIMESTAMP_EVENT_DATA2_EVENT_TYPE)


