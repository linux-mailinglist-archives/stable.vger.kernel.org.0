Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A80A04F2515
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiDEHpE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:45:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232077AbiDEHoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:44:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AE9972B8;
        Tue,  5 Apr 2022 00:41:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 889C66150D;
        Tue,  5 Apr 2022 07:41:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9669AC340EE;
        Tue,  5 Apr 2022 07:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144462;
        bh=tv6arKi6rzEnPZRRIbINOvlsb8nTYzIr7Tyyr02e010=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pw0G5ZSx1k8gxj2BovGt/je5NLZE1KlcNSysJeZl59cGCAHgbiLhtUwyWK47zeDQQ
         LhkBADeBUWuoVE9p4BiTjGK/gPfXiW2vxLrEBx6gGvkcheWdH7MDdup/elsyNhyLB8
         df8gyfV3fTPCwE6GG3Mbz626Tt6bG53OMnpYmKTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Henry Lin <henryl@nvidia.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 5.17 0016/1126] xhci: fix runtime PM imbalance in USB2 resume
Date:   Tue,  5 Apr 2022 09:12:43 +0200
Message-Id: <20220405070408.018352716@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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

From: Henry Lin <henryl@nvidia.com>

commit 70c05e4cf63054cd755ca66c1819327b22cb085f upstream.

A race between system resume and device-initiated resume may result in
runtime PM imbalance on USB2 root hub. If a device-initiated resume
starts and system resume xhci_bus_resume() directs U0 before hub driver
sees the resuming device in RESUME state, device-initiated resume will
not be finished in xhci_handle_usb2_port_link_resume(). In this case,
usb_hcd_end_port_resume() call is missing.

This changes calls usb_hcd_end_port_resume() if resuming device reaches
U0 to keep runtime PM balance.

Fixes: a231ec41e6f6 ("xhci: refactor U0 link state handling in get_port_status")
Cc: stable@vger.kernel.org
Signed-off-by: Henry Lin <henryl@nvidia.com>
Signed-off-by: Mathias Nyman <mathias.nyman@linux.intel.com>
Link: https://lore.kernel.org/r/20220303110903.1662404-5-mathias.nyman@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/host/xhci-hub.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/host/xhci-hub.c
+++ b/drivers/usb/host/xhci-hub.c
@@ -1088,6 +1088,9 @@ static void xhci_get_usb2_port_status(st
 		if (link_state == XDEV_U2)
 			*status |= USB_PORT_STAT_L1;
 		if (link_state == XDEV_U0) {
+			if (bus_state->resume_done[portnum])
+				usb_hcd_end_port_resume(&port->rhub->hcd->self,
+							portnum);
 			bus_state->resume_done[portnum] = 0;
 			clear_bit(portnum, &bus_state->resuming_ports);
 			if (bus_state->suspended_ports & (1 << portnum)) {


