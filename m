Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9DE9689699
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjBCK3D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:29:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233632AbjBCK2k (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:28:40 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BE9A0034
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:27:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79BB561E5D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:27:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54717C433D2;
        Fri,  3 Feb 2023 10:27:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675420071;
        bh=CIFkJZf8sCdAydqdQGyJEX/FTSLpU5hjgwBIQF+up5c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+zetsGxBiE1brdMMnk30tpPoqGe2goUA6Pcvk2uUf2fNR9JUjOMXTPZVVVxVmqhy
         bbzU1dp0jx0XISkh7pybBC+EoGOUP741HaMPeVF4UfwILr9C6rWDBKr1Eg7H1EH8TN
         iYoiT/GRWUTxI9vdXB917+rQIoYSXmvVvuA4oQsE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 071/134] Revert "Revert "xhci: Set HCD flag to defer primary roothub registration""
Date:   Fri,  3 Feb 2023 11:12:56 +0100
Message-Id: <20230203101027.048263237@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This reverts commit 049849492b77aa0df7f7130f1d522f3553c4084b.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 35d96796854d..b8915790a20a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -693,6 +693,7 @@ int xhci_run(struct usb_hcd *hcd)
 		if (ret)
 			xhci_free_command(xhci, command);
 	}
+	set_bit(HCD_FLAG_DEFER_RH_REGISTER, &hcd->flags);
 	xhci_dbg_trace(xhci, trace_xhci_dbg_init,
 			"Finished xhci_run for USB2 roothub");
 
-- 
2.39.0



