Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3B355B7405
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 17:19:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235625AbiIMPOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 11:14:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235760AbiIMPNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 11:13:44 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AE8A78BC1;
        Tue, 13 Sep 2022 07:33:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FB18614DD;
        Tue, 13 Sep 2022 14:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2973CC433D6;
        Tue, 13 Sep 2022 14:31:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663079471;
        bh=0IlhPDcg+N1l9IGYJ4pYlrDwi/O4Kivf2evnYygpIEQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5V/ciNKGKWjWg0ZV9iZMoFFs5uetJh4iRTHFCORphlwQpA6Lm3OVSVRLP5BxPsNs
         Od/STPeO4MQtoR9ThKciHGiBgiAAxuMqjmqx8RuRnyX4/XDxFO06q3UanNSiyDOv3u
         /9yoUk/yiObWYuSYc0/Il/1x7vxEeV33Ldn7A7YE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@kernel.org>,
        Witold Lipieta <witold.lipieta@thaumatec.com>
Subject: [PATCH 4.19 40/79] usb-storage: Add ignore-residue quirk for NXP PN7462AU
Date:   Tue, 13 Sep 2022 16:06:58 +0200
Message-Id: <20220913140350.845038185@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140348.835121645@linuxfoundation.org>
References: <20220913140348.835121645@linuxfoundation.org>
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

From: Witold Lipieta <witold.lipieta@thaumatec.com>

commit 2aa48857ad52236a9564c71183d6cc8893becd41 upstream.

This is USB mass storage primary boot loader for code download on
NXP PN7462AU.

Without the quirk it is impossible to write whole memory at once as
device restarts during the write due to bogus residue values reported.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Witold Lipieta <witold.lipieta@thaumatec.com>
Link: https://lore.kernel.org/r/20220809112911.462776-1-witold.lipieta@thaumatec.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2294,6 +2294,13 @@ UNUSUAL_DEV( 0x1e74, 0x4621, 0x0000, 0x0
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_BULK_IGNORE_TAG | US_FL_MAX_SECTORS_64 ),
 
+/* Reported by Witold Lipieta <witold.lipieta@thaumatec.com> */
+UNUSUAL_DEV( 0x1fc9, 0x0117, 0x0100, 0x0100,
+		"NXP Semiconductors",
+		"PN7462AU",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_RESIDUE ),
+
 /* Supplied with some Castlewood ORB removable drives */
 UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x9999,
 		"Double-H Technology",


