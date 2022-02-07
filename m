Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA5F4ABA1A
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:27:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353453AbiBGLXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358086AbiBGLOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:14:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D124C03F91E;
        Mon,  7 Feb 2022 03:14:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9B210B81158;
        Mon,  7 Feb 2022 11:14:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA124C004E1;
        Mon,  7 Feb 2022 11:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232449;
        bh=p9gzYhntkEFFU0kZCVkx2X3WS7L38CrCbtyOn9AY4Z0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dc3UTnCZ1AFRGMcalLjU/nRVy2TC++WKa8PifD+bHbHMyh579kA94mMjm1dzS0SvM
         Rv0mTt8zwL9nCLxQNpdSy/ycOdbpabGedqfBm/U5eAn50m6H8yUcSLYk4kt/eZZ3gW
         OvLeIzmzMg0AoiHKPpAlsTOivIFf+H2YkwfLDPGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, DocMAX <mail@vacharakis.de>,
        Alan Stern <stern@rowland.harvard.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>
Subject: [PATCH 4.19 13/86] usb-storage: Add unusual-devs entry for VL817 USB-SATA bridge
Date:   Mon,  7 Feb 2022 12:05:36 +0100
Message-Id: <20220207103757.994684774@linuxfoundation.org>
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

From: Alan Stern <stern@rowland.harvard.edu>

commit 5b67b315037250a61861119683e7fcb509deea25 upstream.

Two people have reported (and mentioned numerous other reports on the
web) that VIA's VL817 USB-SATA bridge does not work with the uas
driver.  Typical log messages are:

[ 3606.232149] sd 14:0:0:0: [sdg] tag#2 uas_zap_pending 0 uas-tag 1 inflight: CMD
[ 3606.232154] sd 14:0:0:0: [sdg] tag#2 CDB: Write(16) 8a 00 00 00 00 00 18 0c c9 80 00 00 00 80 00 00
[ 3606.306257] usb 4-4.4: reset SuperSpeed Plus Gen 2x1 USB device number 11 using xhci_hcd
[ 3606.328584] scsi host14: uas_eh_device_reset_handler success

Surprisingly, the devices do seem to work okay for some other people.
The cause of the differing behaviors is not known.

In the hope of getting the devices to work for the most users, even at
the possible cost of degraded performance for some, this patch adds an
unusual_devs entry for the VL817 to block it from binding to the uas
driver by default.  Users will be able to override this entry by means
of a module parameter, if they want.

CC: <stable@vger.kernel.org>
Reported-by: DocMAX <mail@vacharakis.de>
Reported-and-tested-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/Ye8IsK2sjlEv1rqU@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_devs.h |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/usb/storage/unusual_devs.h
+++ b/drivers/usb/storage/unusual_devs.h
@@ -2301,6 +2301,16 @@ UNUSUAL_DEV(  0x2027, 0xa001, 0x0000, 0x
 		USB_SC_DEVICE, USB_PR_DEVICE, usb_stor_euscsi_init,
 		US_FL_SCM_MULT_TARG ),
 
+/*
+ * Reported by DocMAX <mail@vacharakis.de>
+ * and Thomas Weißschuh <linux@weissschuh.net>
+ */
+UNUSUAL_DEV( 0x2109, 0x0715, 0x9999, 0x9999,
+		"VIA Labs, Inc.",
+		"VL817 SATA Bridge",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 UNUSUAL_DEV( 0x2116, 0x0320, 0x0001, 0x0001,
 		"ST",
 		"2A",


