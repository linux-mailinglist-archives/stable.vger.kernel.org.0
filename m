Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC2E420FAE
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237882AbhJDNhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:37:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237389AbhJDNfP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:35:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD8E163230;
        Mon,  4 Oct 2021 13:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353351;
        bh=qUyqRiL9D71CgTgOkxHhi3E5zzNyTsMJqzAA+/VsS7Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FiOsdRbW+4ifxp/X3GZ6VHKu04cWfHQCULYBgP5zfjq6Q/Iddu8w8xGDqgAPXq+uU
         9WPV54NCel7BmnZoR6FV85qtptlCcrF5lmdOgTXy08qw14clu8ccY84D89fDPxFlqn
         PLKGc9+MpFuq2wgBDj3SzsEfIkL3BA4T7mzBJEYI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.14 062/172] mmc: renesas_sdhi: fix regression with hard reset on old SDHIs
Date:   Mon,  4 Oct 2021 14:51:52 +0200
Message-Id: <20211004125046.994170864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wolfram Sang <wsa+renesas@sang-engineering.com>

commit b81bede4d138ce62f7342e27bf55ac93c8071818 upstream.

Old SDHI instances have a default value for the reset register which
keeps it in reset state by default. So, when applying a hard reset we
need to manually leave the soft reset state as well. Later SDHI
instances have a different default value, the one we write manually now.

Fixes: b4d86f37eacb ("mmc: renesas_sdhi: do hard reset if possible")
Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reported-by: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210826082107.47299-1-wsa+renesas@sang-engineering.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/renesas_sdhi_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mmc/host/renesas_sdhi_core.c
+++ b/drivers/mmc/host/renesas_sdhi_core.c
@@ -582,6 +582,8 @@ static void renesas_sdhi_reset(struct tm
 		/* Unknown why but without polling reset status, it will hang */
 		read_poll_timeout(reset_control_status, ret, ret == 0, 1, 100,
 				  false, priv->rstc);
+		/* At least SDHI_VER_GEN2_SDR50 needs manual release of reset */
+		sd_ctrl_write16(host, CTL_RESET_SD, 0x0001);
 		priv->needs_adjust_hs400 = false;
 		renesas_sdhi_set_clock(host, host->clk_cache);
 	} else if (priv->scc_ctl) {


