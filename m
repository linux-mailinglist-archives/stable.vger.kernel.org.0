Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04C41521ABA
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:59:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242462AbiEJODf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 10:03:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245149AbiEJOCK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 10:02:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 590F22DFF45;
        Tue, 10 May 2022 06:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0FA2B81D24;
        Tue, 10 May 2022 13:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A67C385A6;
        Tue, 10 May 2022 13:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652190011;
        bh=5FHKqCevaZ4Z6CAFDYNCySqWPWHqfsu1Z0kLppqCT9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cddB+MWVm1qFeXQHy8NKx1LrhOz3zg8QYVFl3BWFQ8rGjaqv6D1dwa4woOf0kjkn9
         AEKKULVvFycjoo67qiGcYFDGphw0FhGRYioj4d0aJMOGXuXj0Nlrm9cBdp2RGmwS63
         zO/sG1CpPAjy8AjqLDNGxqIuYTDX8asyHw+lbSi0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.17 101/140] bnxt_en: Fix unnecessary dropping of RX packets
Date:   Tue, 10 May 2022 15:08:11 +0200
Message-Id: <20220510130744.493573240@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130741.600270947@linuxfoundation.org>
References: <20220510130741.600270947@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

commit 195af57914d15229186658ed26dab24b9ada4122 upstream.

In bnxt_poll_p5(), we first check cpr->has_more_work.  If it is true,
we are in NAPI polling mode and we will call __bnxt_poll_cqs() to
continue polling.  It is possible to exhanust the budget again when
__bnxt_poll_cqs() returns.

We then enter the main while loop to check for new entries in the NQ.
If we had previously exhausted the NAPI budget, we may call
__bnxt_poll_work() to process an RX entry with zero budget.  This will
cause packets to be dropped unnecessarily, thinking that we are in the
netpoll path.  Fix it by breaking out of the while loop if we need
to process an RX NQ entry with no budget left.  We will then exit
NAPI and stay in polling mode.

Fixes: 389a877a3b20 ("bnxt_en: Process the NQ under NAPI continuous polling.")
Reviewed-by: Andy Gospodarek <andrew.gospodarek@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -2678,6 +2678,10 @@ static int bnxt_poll_p5(struct napi_stru
 			u32 idx = le32_to_cpu(nqcmp->cq_handle_low);
 			struct bnxt_cp_ring_info *cpr2;
 
+			/* No more budget for RX work */
+			if (budget && work_done >= budget && idx == BNXT_RX_HDL)
+				break;
+
 			cpr2 = cpr->cp_ring_arr[idx];
 			work_done += __bnxt_poll_work(bp, cpr2,
 						      budget - work_done);


