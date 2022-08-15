Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0596859505D
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231315AbiHPEmA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231690AbiHPEkP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6605FA4B33;
        Mon, 15 Aug 2022 13:31:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21047B80EB1;
        Mon, 15 Aug 2022 20:31:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5996CC433C1;
        Mon, 15 Aug 2022 20:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595491;
        bh=sT5pL6cUl6cZxcolgG5Lty5iulljWSDOK+DQZab1v8I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nV3NqBTjoBHbcIW/hegfSRpfozF9y3UFqNPVgUy0Xsk5K7jvjHi2xSiHmA2YbQxXt
         sia6MCedH26eEy+lbRYnl/pcMt8v0DZs+EdtFj78bMDfqQPGEgd2p/BJmiUYQov6E1
         TVFVwjgm/8zpgpRhWwSCongWguOhAHbK04noyqkk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shunsuke Mie <mie@igel.co.jp>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0781/1157] PCI: endpoint: Dont stop controller when unbinding endpoint function
Date:   Mon, 15 Aug 2022 20:02:17 +0200
Message-Id: <20220815180510.738460720@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Shunsuke Mie <mie@igel.co.jp>

[ Upstream commit 1bc2b7bfba6e2f64edf5e246f3af2967261f6c3d ]

Unbinding an endpoint function from the endpoint controller shouldn't stop
the controller.  This is especially a problem for multi-function endpoints
where other endpoints may still be active.

Don't stop the controller when unbinding one of its endpoints.  Normally
the controller is stopped via configfs.

Fixes: 349e7a85b25f ("PCI: endpoint: functions: Add an EP function to test PCI")
Link: https://lore.kernel.org/r/20220622040924.113279-1-mie@igel.co.jp
Signed-off-by: Shunsuke Mie <mie@igel.co.jp>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-test.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-test.c b/drivers/pci/endpoint/functions/pci-epf-test.c
index 5b833f00e980..a5ed779b0a51 100644
--- a/drivers/pci/endpoint/functions/pci-epf-test.c
+++ b/drivers/pci/endpoint/functions/pci-epf-test.c
@@ -627,7 +627,6 @@ static void pci_epf_test_unbind(struct pci_epf *epf)
 
 	cancel_delayed_work(&epf_test->cmd_handler);
 	pci_epf_test_clean_dma_chan(epf_test);
-	pci_epc_stop(epc);
 	for (bar = 0; bar < PCI_STD_NUM_BARS; bar++) {
 		epf_bar = &epf->bar[bar];
 
-- 
2.35.1



