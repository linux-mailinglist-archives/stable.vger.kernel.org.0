Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4DD66CA61
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:02:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234121AbjAPRCw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:02:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232676AbjAPRCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:02:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A692799B
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:44:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4C686108A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:44:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04254C433F0;
        Mon, 16 Jan 2023 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887449;
        bh=nJalQ46jrFOqvjeVoeKhJ1+95DMpJMkXoK9jeVumufI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gsmr6i6lxC76srPLeJ+0zck4L94NmlWNLBUbV7QAuHx0reLCZd/v6hBM61MPz9qrC
         vrS6iJ4UOpMNpEhI3X1WMfblLo6z6ly2JUSeWALR/WpioWVsAm2NPeXuWmNMBUHkPM
         qC0WnBu3Bqg/LxMZzUf1dcxnguoJL7GedVKnDJh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wang Yufen <wangyufen@huawei.com>,
        Arend van Spriel <arend.vanspriel@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 153/521] wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()
Date:   Mon, 16 Jan 2023 16:46:55 +0100
Message-Id: <20230116154854.093009927@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wang Yufen <wangyufen@huawei.com>

[ Upstream commit c2f2924bc7f9ea75ef8d95863e710168f8196256 ]

Fix to return a negative error code instead of 0 when
brcmf_chip_set_active() fails. In addition, change the return
value for brcmf_pcie_exit_download_state() to keep consistent.

Fixes: d380ebc9b6fb ("brcmfmac: rename chip download functions")
Signed-off-by: Wang Yufen <wangyufen@huawei.com>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/1669959342-27144-1-git-send-email-wangyufen@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c | 2 +-
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
index a21529d2ccab..6ee04af85e9d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/pcie.c
@@ -612,7 +612,7 @@ static int brcmf_pcie_exit_download_state(struct brcmf_pciedev_info *devinfo,
 	}
 
 	if (!brcmf_chip_set_active(devinfo->ci, resetintr))
-		return -EINVAL;
+		return -EIO;
 	return 0;
 }
 
diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 0a96c1071e5b..6eb1daf51301 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -3337,6 +3337,7 @@ static int brcmf_sdio_download_firmware(struct brcmf_sdio *bus,
 	/* Take arm out of reset */
 	if (!brcmf_chip_set_active(bus->ci, rstvec)) {
 		brcmf_err("error getting out of ARM core reset\n");
+		bcmerror = -EIO;
 		goto err;
 	}
 
-- 
2.35.1



