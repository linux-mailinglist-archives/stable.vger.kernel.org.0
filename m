Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7244ABB05
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355932AbiBGLZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:25:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359452AbiBGLOx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:14:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A65FBC0401F2;
        Mon,  7 Feb 2022 03:14:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88766B811AF;
        Mon,  7 Feb 2022 11:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED44C004E1;
        Mon,  7 Feb 2022 11:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232455;
        bh=ENdP0HiCeo/ou9suAY2/M17r/tqT17x+t6XVJsAoOcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YRa+GUFdEWR/SC90vncd2mIKx4O1x+oDhyds9lo6SQFRq/fuAe4jO6BLeE51T7K0x
         YiCK9sZLBnRKs8J+vbfXPrMwDGsYeNvs9Q9veKGLZD0sZyypQbZoUE3TKw7Fq8kIhe
         IRLT1kh1oKNATbqQg9YW2RJPZskzvxbGFNDKU9/c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Subject: [PATCH 4.19 15/86] usb: gadget: f_sourcesink: Fix isoc transfer for USB_SPEED_SUPER_PLUS
Date:   Mon,  7 Feb 2022 12:05:38 +0100
Message-Id: <20220207103758.058388761@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Pavankumar Kondeti <quic_pkondeti@quicinc.com>

commit 904edf8aeb459697129be5fde847e2a502f41fd9 upstream.

Currently when gadget enumerates in super speed plus, the isoc
endpoint request buffer size is not calculated correctly. Fix
this by checking the gadget speed against USB_SPEED_SUPER_PLUS
and update the request buffer size.

Fixes: 90c4d05780d4 ("usb: fix various gadgets null ptr deref on 10gbps cabling.")
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Pavankumar Kondeti <quic_pkondeti@quicinc.com>
Link: https://lore.kernel.org/r/1642820602-20619-1-git-send-email-quic_pkondeti@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_sourcesink.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/function/f_sourcesink.c
+++ b/drivers/usb/gadget/function/f_sourcesink.c
@@ -583,6 +583,7 @@ static int source_sink_start_ep(struct f
 
 	if (is_iso) {
 		switch (speed) {
+		case USB_SPEED_SUPER_PLUS:
 		case USB_SPEED_SUPER:
 			size = ss->isoc_maxpacket *
 					(ss->isoc_mult + 1) *


