Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C3C051A97E
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 19:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355781AbiEDRMf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 13:12:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356875AbiEDRJr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 13:09:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECF37443C4;
        Wed,  4 May 2022 09:56:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EBEAB82795;
        Wed,  4 May 2022 16:56:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46A49C385AA;
        Wed,  4 May 2022 16:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651683371;
        bh=64AJ4qdk/b55bLZ0FpkDpOa0tmr6z4FH7U3T6pElt1k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ensa036+atoGZTJviQHo2iM1J12ZYwlz2Ng20RjMEC8li/gJHk8OtjDV6vCatxt+Y
         FNyEnNoX5OEbniRLLLrjaJpTKAjjksXuuEnCFXLIoAh2PorKzfSeLiMlAOo9LHLY4G
         PKfrGFsPYunNlrTGVDR8ydoLybOHJejFf6zSIXpg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hemant Kumar <quic_hemantk@quicinc.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: [PATCH 5.17 042/225] bus: mhi: host: pci_generic: Add missing poweroff() PM callback
Date:   Wed,  4 May 2022 18:44:40 +0200
Message-Id: <20220504153113.904051485@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220504153110.096069935@linuxfoundation.org>
References: <20220504153110.096069935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit e64d5fa5044f225ac87d96a7e4be11389999c4c6 upstream.

During hibernation process, once thaw() stage completes, the MHI endpoint
devices will be in M0 state post recovery. After that, the devices will be
powered down so that the system can enter the target sleep state. During
this stage, the PCI core will put the devices in D3hot. But this transition
is allowed by the MHI spec. The devices can only enter D3hot when it is in
M3 state.

So for fixing this issue, let's add the poweroff() callback that will get
executed before putting the system in target sleep state during
hibernation. This callback will power down the device properly so that it
could be restored during restore() or thaw() stage.

Cc: stable@vger.kernel.org
Fixes: 5f0c2ee1fe8d ("bus: mhi: pci-generic: Fix hibernation")
Reported-by: Hemant Kumar <quic_hemantk@quicinc.com>
Suggested-by: Hemant Kumar <quic_hemantk@quicinc.com>
Link: https://lore.kernel.org/r/20220405125907.5644-1-manivannan.sadhasivam@linaro.org
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bus/mhi/pci_generic.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bus/mhi/pci_generic.c
+++ b/drivers/bus/mhi/pci_generic.c
@@ -1085,6 +1085,7 @@ static const struct dev_pm_ops mhi_pci_p
 	.resume = mhi_pci_resume,
 	.freeze = mhi_pci_freeze,
 	.thaw = mhi_pci_restore,
+	.poweroff = mhi_pci_freeze,
 	.restore = mhi_pci_restore,
 #endif
 };


