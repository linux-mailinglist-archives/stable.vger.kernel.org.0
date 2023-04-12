Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39B2F6DEF53
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:49:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231296AbjDLItg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:49:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231314AbjDLIta (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:49:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC65F1
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:49:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10FC263149
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:49:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2379CC433EF;
        Wed, 12 Apr 2023 08:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289347;
        bh=8yvw5nfTbRF0oJZP2vUQoe80x2q+tz0LWnS0w2/oPjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YpBBNwv6Wbzsjml562hUhlms+Qr04R1tDBL/jLKtc/jJGHysRHlduiBzmiKpq3KG2
         or4P+mWbXSTkOuQC5WUxShywEjYJh5vFM2tyOw5zbcNWHJyWoT1XuoL99sV096Aznm
         uYHNrxdbODcyWIE1xICQt7HeqJKgcTfeo7byRecI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pawel Laszczak <pawell@cadence.com>
Subject: [PATCH 6.2 065/173] usb: cdnsp: Fixes error: uninitialized symbol len
Date:   Wed, 12 Apr 2023 10:33:11 +0200
Message-Id: <20230412082840.706949384@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

commit 1edf48991a783d00a3a18dc0d27c88139e4030a2 upstream.

The patch 5bc38d33a5a1: "usb: cdnsp: Fixes issue with redundant
Status Stage" leads to the following Smatch static checker warning:

  drivers/usb/cdns3/cdnsp-ep0.c:470 cdnsp_setup_analyze()
  error: uninitialized symbol 'len'.

cc: <stable@vger.kernel.org>
Fixes: 5bc38d33a5a1 ("usb: cdnsp: Fixes issue with redundant Status Stage")
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20230331090600.454674-1-pawell@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/cdns3/cdnsp-ep0.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/cdns3/cdnsp-ep0.c
+++ b/drivers/usb/cdns3/cdnsp-ep0.c
@@ -414,7 +414,7 @@ static int cdnsp_ep0_std_request(struct
 void cdnsp_setup_analyze(struct cdnsp_device *pdev)
 {
 	struct usb_ctrlrequest *ctrl = &pdev->setup;
-	int ret = 0;
+	int ret = -EINVAL;
 	u16 len;
 
 	trace_cdnsp_ctrl_req(ctrl);
@@ -424,7 +424,6 @@ void cdnsp_setup_analyze(struct cdnsp_de
 
 	if (pdev->gadget.state == USB_STATE_NOTATTACHED) {
 		dev_err(pdev->dev, "ERR: Setup detected in unattached state\n");
-		ret = -EINVAL;
 		goto out;
 	}
 


