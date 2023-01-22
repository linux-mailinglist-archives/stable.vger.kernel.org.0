Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9338F676F36
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:18:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231192AbjAVPS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:18:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjAVPS5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:18:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3E4A1F905
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:18:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5595EB80B11
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC6EEC433EF;
        Sun, 22 Jan 2023 15:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674400734;
        bh=AGgRiUxW2WyNCtHhWR74Vkmi6U0/r3HGGNQR/DzksRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XfGCxSFsNX9NxDRqGvPSQHJK5t6L8wcDc0/3kAFS0Mu47j47F2kVmdewIMDtlKDhb
         w9KYw7iWv5LaIM+T/NYlrh+0KKtG3ryv9r/1i+VLBae8H+btDtNldilmlbJU9Qt5I+
         BLPOe/s56XAAX9O0qIlVjv5Nh33FD1ki7bv0qzpc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mohan Kumar <mkumard@nvidia.com>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 088/117] dmaengine: tegra210-adma: fix global intr clear
Date:   Sun, 22 Jan 2023 16:04:38 +0100
Message-Id: <20230122150236.453966941@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150232.736358800@linuxfoundation.org>
References: <20230122150232.736358800@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mohan Kumar <mkumard@nvidia.com>

commit 9c7e355ccbb33d239360c876dbe49ad5ade65b47 upstream.

The current global interrupt clear programming register offset
was not correct. Fix the programming with right offset

Fixes: ded1f3db4cd6 ("dmaengine: tegra210-adma: prepare for supporting newer Tegra chips")
Cc: stable@vger.kernel.org
Signed-off-by: Mohan Kumar <mkumard@nvidia.com>
Link: https://lore.kernel.org/r/20230102064844.31306-1-mkumard@nvidia.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/tegra210-adma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/dma/tegra210-adma.c
+++ b/drivers/dma/tegra210-adma.c
@@ -224,7 +224,7 @@ static int tegra_adma_init(struct tegra_
 	int ret;
 
 	/* Clear any interrupts */
-	tdma_write(tdma, tdma->cdata->global_int_clear, 0x1);
+	tdma_write(tdma, tdma->cdata->ch_base_offset + tdma->cdata->global_int_clear, 0x1);
 
 	/* Assert soft reset */
 	tdma_write(tdma, ADMA_GLOBAL_SOFT_RESET, 0x1);


