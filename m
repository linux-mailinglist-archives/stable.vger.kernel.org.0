Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A087C59E3B9
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231184AbiHWM3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241713AbiHWM3G (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:29:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4043D9A958;
        Tue, 23 Aug 2022 02:44:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D30CAB81B1F;
        Tue, 23 Aug 2022 09:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12116C433C1;
        Tue, 23 Aug 2022 09:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247817;
        bh=HkMScfXmII+cpUmWSaLVtvIHTrO0ZrRCfD+PbfeV+Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uL+Bo7QnrL3INV2PC8I3EijtxFdqVp839fInac/qOJ4zqPuyeH6KRydlfgOiaLzo5
         c9xCCOThmFdhPeZuUdSDZ2CF2y9s3TuGWfJpoFL+I1rAPOmBV1C7zlxzOuK50/qDZk
         PmqAduRglBeoIh6zbc6kEx3b13Dd4sn3a+0FYo58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hinko Kocevar <hinko.kocevar@ess.eu>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Keith Busch <kbusch@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sean V Kelley <sean.v.kelley@intel.com>,
        Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.10 156/158] PCI/ERR: Retain status from error notification
Date:   Tue, 23 Aug 2022 10:28:08 +0200
Message-Id: <20220823080052.060267888@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

From: Keith Busch <kbusch@kernel.org>

commit 387c72cdd7fb6bef650fb078d0f6ae9682abf631 upstream.

Overwriting the frozen detected status with the result of the link reset
loses the NEED_RESET result that drivers are depending on for error
handling to report the .slot_reset() callback. Retain this status so
that subsequent error handling has the correct flow.

Link: https://lore.kernel.org/r/20210104230300.1277180-4-kbusch@kernel.org
Reported-by: Hinko Kocevar <hinko.kocevar@ess.eu>
Tested-by: Hedi Berriche <hedi.berriche@hpe.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Sean V Kelley <sean.v.kelley@intel.com>
Acked-by: Hedi Berriche <hedi.berriche@hpe.com>
Cc: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/pcie/err.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -196,8 +196,7 @@ pci_ers_result_t pcie_do_recovery(struct
 	pci_dbg(bridge, "broadcast error_detected message\n");
 	if (state == pci_channel_io_frozen) {
 		pci_walk_bridge(bridge, report_frozen_detected, &status);
-		status = reset_subordinates(bridge);
-		if (status != PCI_ERS_RESULT_RECOVERED) {
+		if (reset_subordinates(bridge) != PCI_ERS_RESULT_RECOVERED) {
 			pci_warn(bridge, "subordinate device reset failed\n");
 			goto failed;
 		}


