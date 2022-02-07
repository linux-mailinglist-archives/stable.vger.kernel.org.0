Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07E234ABAD5
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:31:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384090AbiBGLYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:24:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379137AbiBGLQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930E0C0401CC;
        Mon,  7 Feb 2022 03:16:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39694B81028;
        Mon,  7 Feb 2022 11:16:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5754FC004E1;
        Mon,  7 Feb 2022 11:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232563;
        bh=cqdxJHRXvkiuPyL1bxilU0eE4v8ZoH9JbzQvJTgPsB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BLe7bW9rVBKqrPBskKNTFYSuoy8imUy/n0IsjMy5if9RaHvUxCEcKM7KZ+3Jr4lRC
         BT1uw+0hHSy25ltrQDmmbOhD+IaclVt3VnBPt56VrYZOuZqQTExRcGRlVYXrXXaF0u
         OGMFJECD6TefoQBhdCtvZAXx3cxY5xa7NnoK9OJc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudheesh Mavila <sudheesh.mavila@amd.com>,
        Raju Rangoju <Raju.Rangoju@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 50/86] net: amd-xgbe: ensure to reset the tx_timer_active flag
Date:   Mon,  7 Feb 2022 12:06:13 +0100
Message-Id: <20220207103759.194851868@linuxfoundation.org>
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
@@ -722,7 +722,9 @@ static void xgbe_stop_timers(struct xgbe
 		if (!channel->tx_ring)
 			break;
 
+		/* Deactivate the Tx timer */
 		del_timer_sync(&channel->tx_timer);
+		channel->tx_timer_active = 0;
 	}
 }
 


