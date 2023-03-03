Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D46FF6AA1EE
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232187AbjCCVo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232193AbjCCVoD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:03 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29C8362D9B;
        Fri,  3 Mar 2023 13:43:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00BF2B819F7;
        Fri,  3 Mar 2023 21:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B36FC433D2;
        Fri,  3 Mar 2023 21:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879746;
        bh=E9dtm9d4GQtF08b5rfr/y72R21hIOL/iumZCcyKmVjQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jaNSQJT6U7pBJ7Wpzr1GQA+KPpG19h5bh6UMLUV0qECjmQWUiC1JkJkbAHuRLTeqZ
         zDCbkSwSXdceVanP4gxYet7KK7bGEtL+pEI1gBZSYiAArpRh+/8oO2HaxeIGP5LfDD
         tApItK1KRQ9VuucjITvO6ogqHvXNkItk1Z2F+ibJ4odQ55/lfL0+Fgpsd4z96h+m0Z
         MT+yWkwo4GbvIMLEESyIHAgFSWS1F+1vUWpyptxAtzw8M3EjJ4sOkwfDttfGGjqfYg
         AkZYsilRxYBgNSwzs3w2N7aNLPqPUT6qCd8KbT6QrPs4xDA1p9YXZtDnE7kCDqoeE9
         Kgscdm/EWJo4g==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 37/64] USB: isp1362: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:39 -0500
Message-Id: <20230303214106.1446460-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit c26e682afc14caa87d44beed271eec8991e93c65 ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-7-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/isp1362-hcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 0e14d1d07709d..b0da143ef4be9 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2170,7 +2170,7 @@ static void create_debug_file(struct isp1362_hcd *isp1362_hcd)
 
 static void remove_debug_file(struct isp1362_hcd *isp1362_hcd)
 {
-	debugfs_remove(debugfs_lookup("isp1362", usb_debug_root));
+	debugfs_lookup_and_remove("isp1362", usb_debug_root);
 }
 
 /*-------------------------------------------------------------------------*/
-- 
2.39.2

