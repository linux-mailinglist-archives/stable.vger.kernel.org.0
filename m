Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04EEF4A419B
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359264AbiAaLEx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358328AbiAaLDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:03:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF36C061758;
        Mon, 31 Jan 2022 03:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4FA5C60B28;
        Mon, 31 Jan 2022 11:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328EFC340E8;
        Mon, 31 Jan 2022 11:03:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643626996;
        bh=1Q6eTWeiWtR6LSvwQnJSzAWZZD9k4gQvDPMrLqZSTwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cF0Dy9NKoOeyL7RpIm1GXTnScWt9s2hgD0qdoBejEeAV1+qaZH75FE16i+vq7y8EK
         Zilk7Q+mLYzXF0BFig8f6VuT8XTsBceSWDEKxBxzYTzPpGqjs+e6mu3Kju1P4qWQof
         zyT0EyEGqx8AptHr3vjXNRyt2p0w2uKxo8YfDC/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Sing-Han Chen <singhanc@nvidia.com>,
        Wayne Chang <waynec@nvidia.com>
Subject: [PATCH 5.10 034/100] ucsi_ccg: Check DEV_INT bit only when starting CCG4
Date:   Mon, 31 Jan 2022 11:55:55 +0100
Message-Id: <20220131105221.599194183@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105220.424085452@linuxfoundation.org>
References: <20220131105220.424085452@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sing-Han Chen <singhanc@nvidia.com>

commit 825911492eb15bf8bb7fb94bc0c0421fe7a6327d upstream.

CCGx clears Bit 0:Device Interrupt in the INTR_REG
if CCGx is reset successfully. However, there might
be a chance that other bits in INTR_REG are not
cleared due to internal data queued in PPM. This case
misleads the driver that CCGx reset failed.

The commit checks bit 0 in INTR_REG and ignores other
bits. The ucsi driver would reset PPM later.

Fixes: 247c554a14aa ("usb: typec: ucsi: add support for Cypress CCGx")
Cc: stable@vger.kernel.org
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sing-Han Chen <singhanc@nvidia.com>
Signed-off-by: Wayne Chang <waynec@nvidia.com>
Link: https://lore.kernel.org/r/20220112094143.628610-1-waynec@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -325,7 +325,7 @@ static int ucsi_ccg_init(struct ucsi_ccg
 		if (status < 0)
 			return status;
 
-		if (!data)
+		if (!(data & DEV_INT))
 			return 0;
 
 		status = ccg_write(uc, CCGX_RAB_INTR_REG, &data, sizeof(data));


