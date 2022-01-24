Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D354499E66
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 00:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349746AbiAXWdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1587813AbiAXW3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:29:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E039C02B867;
        Mon, 24 Jan 2022 12:55:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B777B80FA3;
        Mon, 24 Jan 2022 20:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5FBC340E5;
        Mon, 24 Jan 2022 20:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057727;
        bh=rKQhAgl7yFVxM0g7KAZgcV30xVzU86ro9qPVgo2ZozQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZUaq+jbNCUp2ZX3HJjUiUSk0X9xZhM1iN+z2jTpBTkZziuH6332zhJruASyrfFSiO
         dUZDzLQvHG4mlcAQqxMq0DqHd7OaXiLcti/9g0Yl6GbNa999l+w5UOkKllCt0orX0M
         FxDHw0bKlct2yJg5bpoYk+uoXXtqrpQuLVsWn4qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bhaumik Bhatt <bbhatt@codeaurora.org>,
        Hemant Kumar <hemantk@codeaurora.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Loic Poulain <loic.poulain@linaro.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.16 0060/1039] bus: mhi: pci_generic: Graceful shutdown on freeze
Date:   Mon, 24 Jan 2022 19:30:49 +0100
Message-Id: <20220124184127.165238435@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Loic Poulain <loic.poulain@linaro.org>

commit f77097ec8c0141a4b5cf3722a246be0cb5677e29 upstream.

There is no reason for shutting down MHI ungracefully on freeze,
this causes the MHI host stack & device stack to not be aligned
anymore since the proper MHI reset sequence is not performed for
ungraceful shutdown.

Link: https://lore.kernel.org/r/1635268180-13699-1-git-send-email-loic.poulain@linaro.org
Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
Cc: stable@vger.kernel.org
Suggested-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Bhaumik Bhatt <bbhatt@codeaurora.org>
Reviewed-by: Hemant Kumar <hemantk@codeaurora.org>
Reviewed-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Loic Poulain <loic.poulain@linaro.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20211216081227.237749-3-manivannan.sadhasivam@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -1018,7 +1018,7 @@ static int __maybe_unused mhi_pci_freeze
 	 * context.
 	 */
 	if (test_and_clear_bit(MHI_PCI_DEV_STARTED, &mhi_pdev->status)) {
-		mhi_power_down(mhi_cntrl, false);
+		mhi_power_down(mhi_cntrl, true);
 		mhi_unprepare_after_power_down(mhi_cntrl);
 	}
 


