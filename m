Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 046956CFAA7
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 07:17:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229524AbjC3FRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 01:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjC3FRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 01:17:31 -0400
Received: from mo-csw.securemx.jp (mo-csw1515.securemx.jp [210.130.202.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678715BB8
        for <stable@vger.kernel.org>; Wed, 29 Mar 2023 22:17:29 -0700 (PDT)
Received: by mo-csw.securemx.jp (mx-mo-csw1515) id 32U5Gxwg005516; Thu, 30 Mar 2023 14:16:59 +0900
X-Iguazu-Qid: 34trk59YiwuR70e3I7
X-Iguazu-QSIG: v=2; s=0; t=1680153418; q=34trk59YiwuR70e3I7; m=d3m9n2YXvDNWOo2E8ZGyTpQUhidAzX6U/lh9suTG6Sk=
Received: from imx2-a.toshiba.co.jp (imx2-a.toshiba.co.jp [106.186.93.35])
        by relay.securemx.jp (mx-mr1513) id 32U5Gwgl010735
        (version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NOT);
        Thu, 30 Mar 2023 14:16:58 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH for 4.14, 4.19] usb: host: ohci-pxa27x: Fix and & vs | typo
Date:   Thu, 30 Mar 2023 14:16:49 +0900
X-TSB-HOP2: ON
Message-Id: <20230330051649.431149-1-nobuhiro1.iwamatsu@toshiba.co.jp>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.7 required=5.0 tests=RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0709831a50d31b3caf2237e8d7fe89e15b0d919d upstream.

The code is supposed to clear the RH_A_NPS and RH_A_PSM bits, but it's
a no-op because of the & vs | typo.  This bug predates git and it was
only discovered using static analysis so it must not affect too many
people in real life.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20190817065520.GA29951@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Nobuhiro Iwamatsu (CIP) <nobuhiro1.iwamatsu@toshiba.co.jp>
---
 drivers/usb/host/ohci-pxa27x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/ohci-pxa27x.c b/drivers/usb/host/ohci-pxa27x.c
index 3e247495973591..7679fb583e4161 100644
--- a/drivers/usb/host/ohci-pxa27x.c
+++ b/drivers/usb/host/ohci-pxa27x.c
@@ -148,7 +148,7 @@ static int pxa27x_ohci_select_pmm(struct pxa27x_ohci *pxa_ohci, int mode)
 		uhcrhda |= RH_A_NPS;
 		break;
 	case PMM_GLOBAL_MODE:
-		uhcrhda &= ~(RH_A_NPS & RH_A_PSM);
+		uhcrhda &= ~(RH_A_NPS | RH_A_PSM);
 		break;
 	case PMM_PERPORT_MODE:
 		uhcrhda &= ~(RH_A_NPS);
-- 
2.36.1


