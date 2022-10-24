Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE40F60A630
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiJXMbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:31:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234243AbiJXM3s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05136895DE;
        Mon, 24 Oct 2022 05:03:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCC03612D2;
        Mon, 24 Oct 2022 12:02:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0894C433D6;
        Mon, 24 Oct 2022 12:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612972;
        bh=frh3ChJeHGWvclmldQc8G3du3v9eRy5i/YPzCKhzBE4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VmUb94R9hyyfBN01ngbXQwAUIytU+6LshE2HZwnxoJaG+YL/YCt7AM6yzAYPiMXXq
         GUawSdSiVt7fvIIGSpc6FH2ULr2+lZ098gSRXYul54xpM8KWyG6j35hBn3Im4YzaUG
         84QrgHhYK1R5yhZJbR36GG1XpMwLwCp+OSoeMEy8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jack Wang <jinpu.wang@ionos.com>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 158/229] mailbox: bcm-ferxrm-mailbox: Fix error check for dma_map_sg
Date:   Mon, 24 Oct 2022 13:31:17 +0200
Message-Id: <20221024113004.114523680@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 6b207ce8a96a71e966831e3a13c38143ba9a73c1 ]

dma_map_sg return 0 on error, fix the error check, and return -EIO
to caller.

Fixes: dbc049eee730 ("mailbox: Add driver for Broadcom FlexRM ring manager")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/bcm-flexrm-mailbox.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mailbox/bcm-flexrm-mailbox.c b/drivers/mailbox/bcm-flexrm-mailbox.c
index 96bcabfebc23..543c4a4a8fca 100644
--- a/drivers/mailbox/bcm-flexrm-mailbox.c
+++ b/drivers/mailbox/bcm-flexrm-mailbox.c
@@ -634,15 +634,15 @@ static int flexrm_spu_dma_map(struct device *dev, struct brcm_message *msg)
 
 	rc = dma_map_sg(dev, msg->spu.src, sg_nents(msg->spu.src),
 			DMA_TO_DEVICE);
-	if (rc < 0)
-		return rc;
+	if (!rc)
+		return -EIO;
 
 	rc = dma_map_sg(dev, msg->spu.dst, sg_nents(msg->spu.dst),
 			DMA_FROM_DEVICE);
-	if (rc < 0) {
+	if (!rc) {
 		dma_unmap_sg(dev, msg->spu.src, sg_nents(msg->spu.src),
 			     DMA_TO_DEVICE);
-		return rc;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.35.1



