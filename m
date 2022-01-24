Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6971149A5D0
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2371143AbiAYAHF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:07:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2362669AbiAXXmp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:42:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19713C0BD10F;
        Mon, 24 Jan 2022 13:39:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7DFBB8123D;
        Mon, 24 Jan 2022 21:39:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF09C36B02;
        Mon, 24 Jan 2022 21:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060342;
        bh=q6x/bI0ZH2aNMZANdaqG3USj1WkC9T8TO3G2sZLfuoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HNs78kNM1HfuAFojoJFJL4w8qJpQARaqiAF+JCOarJ7vdBZ+htgHUBBal5gSihlRO
         3zwnFrCOJeir1kOdZsb1mtVRJA5M7omOlHhRB/WMOPMnPdkjgN0xpczRdgU5IfqyDh
         +/ibjxzj9FPK4T8YipRDK4n/PEvvSAjVgBhgbJKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Mark Chen <mark-yw.chen@mediatek.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.16 0917/1039] Bluetooth: btusb: Return error code when getting patch status failed
Date:   Mon, 24 Jan 2022 19:45:06 +0100
Message-Id: <20220124184156.119846200@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Chen <mark-yw.chen@mediatek.com>

commit 995d948cf2e45834275f07afc1c9881a9902e73c upstream.

If there are failure cases in getting patch status, it should return the
error code (-EIO).

Fixes: fc342c4dc4087 ("Bluetooth: btusb: Add protocol support for MediaTek MT7921U USB devices")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Mark Chen <mark-yw.chen@mediatek.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2600,6 +2600,7 @@ static int btusb_mtk_setup_firmware_79xx
 				} else {
 					bt_dev_err(hdev, "Failed wmt patch dwnld status (%d)",
 						   status);
+					err = -EIO;
 					goto err_release_fw;
 				}
 			}


