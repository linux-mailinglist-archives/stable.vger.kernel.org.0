Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53F0A5218C4
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243347AbiEJNkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245122AbiEJNid (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31F84245795;
        Tue, 10 May 2022 06:27:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4304B81DA2;
        Tue, 10 May 2022 13:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05924C385C2;
        Tue, 10 May 2022 13:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189230;
        bh=3HnBQ7RhhvY/fdtAei+Bol5vyNmEEQsKf84c57Q1evE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lT8MaNmPRWSqtFr4gX9tfvmriOGqFt4WfFCzW00oPBGfzH2RLRCi9+f66YE2/6xiL
         YszKSHph94dRNSJyfELV5t1uS8QZJtRVi3BxMFg7aDSGfp3qUxB4raCcwV6VA8sVJ0
         oz1qpN02JwBvOuwlq1eFQwZ4o9TrFZNzq20H8oRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Gospodarek <andrew.gospodarek@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 53/70] bnxt_en: Fix unnecessary dropping of RX packets
Date:   Tue, 10 May 2022 15:08:12 +0200
Message-Id: <20220510130734.414249197@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
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
@@ -2575,6 +2575,10 @@ static int bnxt_poll_p5(struct napi_stru
 			u32 idx = le32_to_cpu(nqcmp->cq_handle_low);
 			struct bnxt_cp_ring_info *cpr2;
 
+			/* No more budget for RX work */
+			if (budget && work_done >= budget && idx == BNXT_RX_HDL)
+				break;
+
 			cpr2 = cpr->cp_ring_arr[idx];
 			work_done += __bnxt_poll_work(bp, cpr2,
 						      budget - work_done);


