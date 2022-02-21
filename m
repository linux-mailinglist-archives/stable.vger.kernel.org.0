Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 787114BE49B
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:59:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343645AbiBUJte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352918AbiBUJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:02 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E8E924592;
        Mon, 21 Feb 2022 01:21:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B40EDCE0E80;
        Mon, 21 Feb 2022 09:21:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DDC9C340E9;
        Mon, 21 Feb 2022 09:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435281;
        bh=qdKhP+Yu3uEce58zCR/FGGWQkn0rFoSPSBzckS41AFc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=heWIxeL26J94x6exQM3tnv6vnRZ4nkHl4T4rYXE+iO4eYxPjzFUZ0Y6s8Sy7jla5/
         8HZoE2unjixVBXspBm98uz7a6YIcet9A8Z/fYrT7B/cghbMHBZISpM2Bslo0ZzPaQk
         +LwdxLTpRXUO3/xPuCDgtzQHnFsEU3GNCZgGJO18=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Phil Elwell <phil@raspberrypi.com>,
        Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 5.16 107/227] brcmfmac: firmware: Fix crash in brcm_alt_fw_path
Date:   Mon, 21 Feb 2022 09:48:46 +0100
Message-Id: <20220221084938.429668418@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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

From: Phil Elwell <phil@raspberrypi.com>

commit 665408f4c3a5c83e712871daa062721624b2b79e upstream.

The call to brcm_alt_fw_path in brcmf_fw_get_firmwares is not protected
by a check to the validity of the fwctx->req->board_type pointer. This
results in a crash in strlcat when, for example, the WLAN chip is found
in a USB dongle.

Prevent the crash by adding the necessary check.

See: https://github.com/raspberrypi/linux/issues/4833

Fixes: 5ff013914c62 ("brcmfmac: firmware: Allow per-board firmware binaries")
Signed-off-by: Phil Elwell <phil@raspberrypi.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220118154514.3245524-1-phil@raspberrypi.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/firmware.c
@@ -693,7 +693,7 @@ int brcmf_fw_get_firmwares(struct device
 {
 	struct brcmf_fw_item *first = &req->items[0];
 	struct brcmf_fw *fwctx;
-	char *alt_path;
+	char *alt_path = NULL;
 	int ret;
 
 	brcmf_dbg(TRACE, "enter: dev=%s\n", dev_name(dev));
@@ -712,7 +712,9 @@ int brcmf_fw_get_firmwares(struct device
 	fwctx->done = fw_cb;
 
 	/* First try alternative board-specific path if any */
-	alt_path = brcm_alt_fw_path(first->path, fwctx->req->board_type);
+	if (fwctx->req->board_type)
+		alt_path = brcm_alt_fw_path(first->path,
+					    fwctx->req->board_type);
 	if (alt_path) {
 		ret = request_firmware_nowait(THIS_MODULE, true, alt_path,
 					      fwctx->dev, GFP_KERNEL, fwctx,


