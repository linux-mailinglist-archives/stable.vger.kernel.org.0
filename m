Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDB0C643341
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbiLETfL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232894AbiLETeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:34:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE1141159
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:30:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA2DFB81200
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 143C9C433C1;
        Mon,  5 Dec 2022 19:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268636;
        bh=3nqWMvNrybhqd1/ZT/1pPraz7foUQ9vI1qB5affJDcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yQiYu6NT1oC/BVyTWQCHyIwlSzMuXX2r4XH3Cl+nH5x5OIDFmx/SAc59lZ0oqftgB
         zyE15B8AOU1PGGQo6YP0yI7BSvHJFMjHE1/XtvZzGYRz77ncG9Qk7gsCjtka1n3Csf
         sQZR+rhisR+/zs4BJYAKMHn1yH8E9vwLQfKxGi/E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tho Vu <tho.vu.wh@renesas.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        Sergey Shtylyov <s.shtylyov@omp.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 50/92] net: ethernet: renesas: ravb: Fix promiscuous mode after system resumed
Date:   Mon,  5 Dec 2022 20:10:03 +0100
Message-Id: <20221205190805.146883961@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190803.464934752@linuxfoundation.org>
References: <20221205190803.464934752@linuxfoundation.org>
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

From: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>

[ Upstream commit d66233a312ec9013af3e37e4030b479a20811ec3 ]

After system resumed on some environment board, the promiscuous mode
is disabled because the SoC turned off. So, call ravb_set_rx_mode() in
the ravb_resume() to fix the issue.

Reported-by: Tho Vu <tho.vu.wh@renesas.com>
Fixes: 0184165b2f42 ("ravb: add sleep PM suspend/resume support")
Signed-off-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Link: https://lore.kernel.org/r/20221128065604.1864391-1-yoshihiro.shimoda.uh@renesas.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/ravb_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/renesas/ravb_main.c b/drivers/net/ethernet/renesas/ravb_main.c
index f96eed67e1a2..9e7b85e178fd 100644
--- a/drivers/net/ethernet/renesas/ravb_main.c
+++ b/drivers/net/ethernet/renesas/ravb_main.c
@@ -2364,6 +2364,7 @@ static int __maybe_unused ravb_resume(struct device *dev)
 		ret = ravb_open(ndev);
 		if (ret < 0)
 			return ret;
+		ravb_set_rx_mode(ndev);
 		netif_device_attach(ndev);
 	}
 
-- 
2.35.1



