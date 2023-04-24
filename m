Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CFC56ECE2C
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbjDXN36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232389AbjDXN3r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:29:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4DCC6A63
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:29:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 686646232A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BF45C433EF;
        Mon, 24 Apr 2023 13:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682342966;
        bh=6u2MYrJCQVP+kQtDD11PZr43LKzYTKiWvu9/y+8jgTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XwuS9hYIWZXjuufQpOUuk7KWEKEBmGnR33HxbC4J3Dwei0/6Ft1tkoK55R4nVd9A2
         EEyDsRA9mHJhDcCGYEv6gb3jR7ptlmdZ7bBYNSxH32d7fPV861/WuPW+1zm1PoZn47
         e68wgFQ1vgjlVrLuSD7Y4NDgY7WZpynbC7ew5PFI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Michael Chan <michael.chan@broadcom.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 026/110] bnxt_en: Do not initialize PTP on older P3/P4 chips
Date:   Mon, 24 Apr 2023 15:16:48 +0200
Message-Id: <20230424131137.118159916@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit e8b51a1a15d5a3cce231e0669f6a161dc5bb9b75 ]

The driver does not support PTP on these older chips and it is assuming
that firmware on these older chips will not return the
PORT_MAC_PTP_QCFG_RESP_FLAGS_HWRM_ACCESS flag in __bnxt_hwrm_ptp_qcfg(),
causing the function to abort quietly.

But newer firmware now sets this flag and so __bnxt_hwrm_ptp_qcfg()
will proceed further.  Eventually it will fail in bnxt_ptp_init() ->
bnxt_map_ptp_regs() because there is no code to support the older chips.
The driver will then complain:

"PTP initialization failed.\n"

Fix it so that we abort quietly earlier without going through the
unnecessary steps and alarming the user with the warning log.

Fixes: ae5c42f0b92c ("bnxt_en: Get PTP hardware capability from firmware")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 015b5848b9583..beab68e22e371 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7628,7 +7628,7 @@ static int __bnxt_hwrm_ptp_qcfg(struct bnxt *bp)
 	u8 flags;
 	int rc;
 
-	if (bp->hwrm_spec_code < 0x10801) {
+	if (bp->hwrm_spec_code < 0x10801 || !BNXT_CHIP_P5_THOR(bp)) {
 		rc = -ENODEV;
 		goto no_ptp;
 	}
-- 
2.39.2



