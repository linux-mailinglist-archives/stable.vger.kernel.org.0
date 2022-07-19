Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5CF457994F
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:01:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbiGSMBW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:01:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237794AbiGSMAx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:00:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D6B245F5F;
        Tue, 19 Jul 2022 04:58:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0ED5CB81B2C;
        Tue, 19 Jul 2022 11:58:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C2BFC385A5;
        Tue, 19 Jul 2022 11:58:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231892;
        bh=SIc6DlfuX0l6uonIbPt33V4X9eiPE/u2ceNGgrYJ224=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vW4eiqYDwm6OWaVdWoalpLJbLUuwp0zx+4o3TAMalwzRWFXfwkwETbDneFq8/CWp0
         4jOeyYWbu6JK+nZnBe4XVO7SA/4pY4Rs1cKyIO0mXSavIoSQoeGi0qOj252MR1a8tc
         My4Z52tq84YolGyIvDxE/gtyAFpr1KXuhVxjDkvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jianglei Nie <niejianglei2021@163.com>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/43] net: sfp: fix memory leak in sfp_probe()
Date:   Tue, 19 Jul 2022 13:54:03 +0200
Message-Id: <20220719114524.759310436@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jianglei Nie <niejianglei2021@163.com>

[ Upstream commit 0a18d802d65cf662644fd1d369c86d84a5630652 ]

sfp_probe() allocates a memory chunk from sfp with sfp_alloc(). When
devm_add_action() fails, sfp is not freed, which leads to a memory leak.

We should use devm_add_action_or_reset() instead of devm_add_action().

Signed-off-by: Jianglei Nie <niejianglei2021@163.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20220629075550.2152003-1-niejianglei2021@163.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9f6e737d9fc9..c0f9de3be217 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -830,7 +830,7 @@ static int sfp_probe(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, sfp);
 
-	err = devm_add_action(sfp->dev, sfp_cleanup, sfp);
+	err = devm_add_action_or_reset(sfp->dev, sfp_cleanup, sfp);
 	if (err < 0)
 		return err;
 
-- 
2.35.1



