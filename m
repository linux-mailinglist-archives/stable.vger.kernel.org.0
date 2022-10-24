Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBFA760AED3
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 17:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231181AbiJXPQu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 11:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232134AbiJXPQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 11:16:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27321BC440;
        Mon, 24 Oct 2022 06:55:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FBDF61274;
        Mon, 24 Oct 2022 11:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E90CC433C1;
        Mon, 24 Oct 2022 11:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666611938;
        bh=seFHqFqmEKe+2WHH8qWbEC8yoHQChYekB21rkTHJEvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OtlkLIhNssGHOUrlo6dBigDYlTRRxXucgxFYERVu4R/QKcQOvLWxyTcabnGQrA7eu
         wmBbIpOTS+s5mHRUPiz10ompIfx3D5kW0PyYFwpnB7ejZwD5MlSm8utVElvOEBPmto
         edGWOvs9slkKS2VogBhZ0dlHeJnXd4w8awYzITo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        stable <stable@kernel.org>,
        Hongling Zeng <zenghongling@kylinos.cn>
Subject: [PATCH 4.14 001/210] uas: add no-uas quirk for Hiksemi usb_disk
Date:   Mon, 24 Oct 2022 13:28:38 +0200
Message-Id: <20221024112956.876544846@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hongling Zeng <zenghongling@kylinos.cn>

commit a625a4b8806cc1e928b7dd2cca1fee709c9de56e upstream.

The UAS mode of Hiksemi is reported to fail to work on several platforms
with the following error message, then after re-connecting the device will
be offlined and not working at all.

[  592.518442][ 2] sd 8:0:0:0: [sda] tag#17 uas_eh_abort_handler 0 uas-tag 18
                   inflight: CMD
[  592.527575][ 2] sd 8:0:0:0: [sda] tag#17 CDB: Write(10) 2a 00 03 6f 88 00 00
                   04 00 00
[  592.536330][ 2] sd 8:0:0:0: [sda] tag#0 uas_eh_abort_handler 0 uas-tag 1
                   inflight: CMD
[  592.545266][ 2] sd 8:0:0:0: [sda] tag#0 CDB: Write(10) 2a 00 07 44 1a 88 00
                   00 08 00

These disks have a broken uas implementation, the tag field of the status
iu-s is not set properly,so we need to fall-back to usb-storage.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Cc: stable <stable@kernel.org>
Signed-off-by: Hongling Zeng <zenghongling@kylinos.cn>
Link: https://lore.kernel.org/r/1663901173-21020-1-git-send-email-zenghongling@kylinos.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/storage/unusual_uas.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -65,6 +65,13 @@ UNUSUAL_DEV(0x059f, 0x1061, 0x0000, 0x99
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NO_REPORT_OPCODES | US_FL_NO_SAME),
 
+/* Reported-by: Hongling Zeng <zenghongling@kylinos.cn> */
+UNUSUAL_DEV(0x090c, 0x2000, 0x0000, 0x9999,
+		"Hiksemi",
+		"External HDD",
+		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+		US_FL_IGNORE_UAS),
+
 /*
  * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
  * commands in UAS mode.  Observed with the 1.28 firmware; are there others?


