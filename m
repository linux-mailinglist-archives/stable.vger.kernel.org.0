Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241B347AE78
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239415AbhLTPBM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbhLTO62 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:58:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38AB4C061394;
        Mon, 20 Dec 2021 06:49:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8E2AB80EDA;
        Mon, 20 Dec 2021 14:49:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25818C36AE7;
        Mon, 20 Dec 2021 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011772;
        bh=vmiKDqNKZcMNo0YFJt7fBJKb7F/kv+pcJAJFUaf++dE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SNUHmdRZxVmyaESOF0r0PxsQQpfgjdFOdraJiTXtuLA9SQ4LAYA5Rhno9jfy5fqm5
         n5v9gxMN8A4eV1Kb6Jt8+8EHRaT1zLIuvLcnlY2mFDWYzvL6Vle+AhqN+SG45pSG6z
         9QsVOCU74/xBfVMJivYHlonZ7y2OmxgpZNyGEP7Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, markpearson@lenovo.com,
        Jimmy Wang <wangjm221@gmail.com>
Subject: [PATCH 5.10 68/99] USB: NO_LPM quirk Lenovo USB-C to Ethernet Adapher(RTL8153-04)
Date:   Mon, 20 Dec 2021 15:34:41 +0100
Message-Id: <20211220143031.688525428@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143029.352940568@linuxfoundation.org>
References: <20211220143029.352940568@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jimmy Wang <wangjm221@gmail.com>

commit 0ad3bd562bb91853b9f42bda145b5db6255aee90 upstream.

This device doesn't work well with LPM, losing connectivity intermittently.
Disable LPM to resolve the issue.

Reviewed-by: <markpearson@lenovo.com>
Signed-off-by: Jimmy Wang <wangjm221@gmail.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20211214012652.4898-1-wangjm221@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/core/quirks.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -435,6 +435,9 @@ static const struct usb_device_id usb_qu
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo USB-C to Ethernet Adapter RTL8153-04 */
+	{ USB_DEVICE(0x17ef, 0x720c), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Lenovo Powered USB-C Travel Hub (4X90S92381, RTL8153 GigE) */
 	{ USB_DEVICE(0x17ef, 0x721e), .driver_info = USB_QUIRK_NO_LPM },
 


