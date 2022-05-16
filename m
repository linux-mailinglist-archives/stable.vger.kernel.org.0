Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE093529091
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345848AbiEPULO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:11:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351138AbiEPUCD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:02:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B5E5FCF;
        Mon, 16 May 2022 12:59:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D7E860BAC;
        Mon, 16 May 2022 19:59:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A2AC385AA;
        Mon, 16 May 2022 19:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731170;
        bh=gAF9QkJ8n4r0KvHDf7oKdqFvbg1AdydfWIN71I3LAy8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kg2eGO0tmCE9CniVK+nrs9ESGCg/JRyr/qW47+jOK0uOJsdm4CVVa17UMTMm2F4Gl
         AnJWXzkGrAaETNzxyYOOX077k0hv+EaKUwwY7b2eJQAGgHHZz1GuiPUSnJimKiv41U
         +peHvrN319QntbJT4XbRfsYXBAKtF3TuFvYTuB24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ethan Yang <etyang@sierrawireless.com>,
        Johan Hovold <johan@kernel.org>
Subject: [PATCH 5.17 084/114] USB: serial: qcserial: add support for Sierra Wireless EM7590
Date:   Mon, 16 May 2022 21:36:58 +0200
Message-Id: <20220516193627.894148502@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ethan Yang <etyang@sierrawireless.com>

commit 870b1eee2d844727b06e238c121d260bc5645580 upstream.

Add support for Sierra Wireless EM7590 0xc080/0xc081 compositions.

Signed-off-by: Ethan Yang <etyang@sierrawireless.com>
Link: https://lore.kernel.org/r/20220425055840.5693-1-etyang@sierrawireless.com
Cc: stable@vger.kernel.org
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/serial/qcserial.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -166,6 +166,8 @@ static const struct usb_device_id id_tab
 	{DEVICE_SWI(0x1199, 0x9090)},	/* Sierra Wireless EM7565 QDL */
 	{DEVICE_SWI(0x1199, 0x9091)},	/* Sierra Wireless EM7565 */
 	{DEVICE_SWI(0x1199, 0x90d2)},	/* Sierra Wireless EM9191 QDL */
+	{DEVICE_SWI(0x1199, 0xc080)},	/* Sierra Wireless EM7590 QDL */
+	{DEVICE_SWI(0x1199, 0xc081)},	/* Sierra Wireless EM7590 */
 	{DEVICE_SWI(0x413c, 0x81a2)},	/* Dell Wireless 5806 Gobi(TM) 4G LTE Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a3)},	/* Dell Wireless 5570 HSPA+ (42Mbps) Mobile Broadband Card */
 	{DEVICE_SWI(0x413c, 0x81a4)},	/* Dell Wireless 5570e HSPA+ (42Mbps) Mobile Broadband Card */


