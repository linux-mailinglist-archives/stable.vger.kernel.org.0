Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C9B54B4C22
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:44:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348538AbiBNKhU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:37:20 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348855AbiBNKgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:36:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 482B8205CD;
        Mon, 14 Feb 2022 02:02:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ECD66B80DCA;
        Mon, 14 Feb 2022 10:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15E71C340EF;
        Mon, 14 Feb 2022 10:02:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832938;
        bh=t432ehytwEm0n0pKMk01J/w73y/O1PlVDyrqrXrTCqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pc11JNtkspuEy0MX5HYNwHaubWt6migG3PqWCmVFwZ0x8FUkS+Rz4fM9YeiXGti/I
         iLoq7IZIPoYCWg2IgrzpH4EV5pIf9h5zBoPOBewnmTmVWDEWtqXuTZ6YoLANjzezqg
         c5faa4QKKC0TsBYA9in+WZzpbARrWg5Wv7l0UyMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>
Subject: [PATCH 5.16 171/203] usb: dwc3: gadget: Prevent core from processing stale TRBs
Date:   Mon, 14 Feb 2022 10:26:55 +0100
Message-Id: <20220214092516.057852698@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Udipto Goswami <quic_ugoswami@quicinc.com>

commit 117b4e96c7f362eb6459543883fc07f77662472c upstream.

With CPU re-ordering on write instructions, there might
be a chance that the HWO is set before the TRB is updated
with the new mapped buffer address.
And in the case where core is processing a list of TRBs
it is possible that it fetched the TRBs when the HWO is set
but before the buffer address is updated.
Prevent this by adding a memory barrier before the HWO
is updated to ensure that the core always process the
updated TRBs.

Fixes: f6bafc6a1c9d ("usb: dwc3: convert TRBs into bitshifts")
Cc: stable <stable@vger.kernel.org>
Reviewed-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Signed-off-by: Udipto Goswami <quic_ugoswami@quicinc.com>
Link: https://lore.kernel.org/r/1644207958-18287-1-git-send-email-quic_ugoswami@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |   13 +++++++++++++
 1 file changed, 13 insertions(+)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1271,6 +1271,19 @@ static void __dwc3_prepare_one_trb(struc
 	if (usb_endpoint_xfer_bulk(dep->endpoint.desc) && dep->stream_capable)
 		trb->ctrl |= DWC3_TRB_CTRL_SID_SOFN(stream_id);
 
+	/*
+	 * As per data book 4.2.3.2TRB Control Bit Rules section
+	 *
+	 * The controller autonomously checks the HWO field of a TRB to determine if the
+	 * entire TRB is valid. Therefore, software must ensure that the rest of the TRB
+	 * is valid before setting the HWO field to '1'. In most systems, this means that
+	 * software must update the fourth DWORD of a TRB last.
+	 *
+	 * However there is a possibility of CPU re-ordering here which can cause
+	 * controller to observe the HWO bit set prematurely.
+	 * Add a write memory barrier to prevent CPU re-ordering.
+	 */
+	wmb();
 	trb->ctrl |= DWC3_TRB_CTRL_HWO;
 
 	dwc3_ep_inc_enq(dep);


