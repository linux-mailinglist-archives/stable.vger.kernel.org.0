Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F09B4A96CB
	for <lists+stable@lfdr.de>; Fri,  4 Feb 2022 10:29:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357916AbiBDJ3q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Feb 2022 04:29:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358298AbiBDJ2E (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 4 Feb 2022 04:28:04 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2242BC06176F;
        Fri,  4 Feb 2022 01:26:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BBEF61747;
        Fri,  4 Feb 2022 09:26:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D8B8C004E1;
        Fri,  4 Feb 2022 09:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643966812;
        bh=QrZLry4insApv+gQ37l7e+SnTkVoC6w8ESMnHsJwm00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fvbBr/re62sUpX1StsxuuOyv2Echx3Ht2+xoEPUkrlAER2+EGJ1eDbW7+Jg20BpRt
         m3l20ywmu3e7IulcUTlxH3fvgjSReXG6PdogT+IH3vgkJPOLROIazaN7limpWZuvJ1
         Vu6T4pMASHXFwnEHeREZATl7icO5+FXbf3mWzQ2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.16 32/43] net: amd-xgbe: ensure to reset the tx_timer_active flag
Date:   Fri,  4 Feb 2022 10:22:39 +0100
Message-Id: <20220204091918.217272476@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220204091917.166033635@linuxfoundation.org>
References: <20220204091917.166033635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Raju Rangoju <Raju.Rangoju@amd.com>

commit 7674b7b559b683478c3832527c59bceb169e701d upstream.

Ensure to reset the tx_timer_active flag in xgbe_stop(),
otherwise a port restart may result in tx timeout due to
uncleared flag.

Fixes: c635eaacbf77 ("amd-xgbe: Remove Tx coalescing")
Co-developed-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Sudheesh Mavila <sudheesh.mavila@amd.com>
Signed-off-by: Raju Rangoju <Raju.Rangoju@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://lore.kernel.org/r/20220127060222.453371-1-Raju.Rangoju@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
+++ b/drivers/net/ethernet/amd/xgbe/xgbe-drv.c
@@ -721,7 +721,9 @@ static void xgbe_stop_timers(struct xgbe
 		if (!channel->tx_ring)
 			break;
 
+		/* Deactivate the Tx timer */
 		del_timer_sync(&channel->tx_timer);
+		channel->tx_timer_active = 0;
 	}
 }
 


