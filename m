Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B461855CC00
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235199AbiF1CaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 22:30:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244739AbiF1C1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 22:27:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F3925EBC;
        Mon, 27 Jun 2022 19:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 90918617BF;
        Tue, 28 Jun 2022 02:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D18E3C341CA;
        Tue, 28 Jun 2022 02:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656383148;
        bh=9BkiyLBsVzXzC2PyiRUjj1lfylL5hzUuyzqnpUyygY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kaajD7JwjM2hu5HPTIMsb+Sr0oQKr3vZI/hpCVnXpElO3VuKVBJRVQYk31LUL6jLl
         7e7eV88MnHI2fdB5szk4y7hm3zQF57/yOwJwg0B5FYBx4cyJOyxSMhy1EHX7I/BPpb
         rNKYsimMjpEve3t3pqpNkYf1y85+84A/6fR/tDVObvJKTdM/dv1r3kfYnsg/ufzoZ/
         0Dw2ibmHCvslJ1FvNfqQiZreamvjxvn1WG5LngNS9CCyfAN8iR/WnLgm9fny+uecAF
         /sX0mK60zZvX5wE5sMv97K8RZLe1+8n0DdGzE8NDylK1UeRl1pH3nvNX4VSXgVZxBR
         Z9ZPun2CzizYQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hyunwoo Kim <imv4bel@gmail.com>, Helge Deller <deller@gmx.de>,
        Sasha Levin <sashal@kernel.org>, yangyingliang@huawei.com,
        yang.lee@linux.alibaba.com, cai.huoqing@linux.dev,
        linux-fbdev@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 11/22] video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write
Date:   Mon, 27 Jun 2022 22:25:06 -0400
Message-Id: <20220628022518.596687-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220628022518.596687-1-sashal@kernel.org>
References: <20220628022518.596687-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hyunwoo Kim <imv4bel@gmail.com>

[ Upstream commit a09d2d00af53b43c6f11e6ab3cb58443c2cac8a7 ]

In pxa3xx_gcu_write, a count parameter of type size_t is passed to words of
type int.  Then, copy_from_user() may cause a heap overflow because it is used
as the third argument of copy_from_user().

Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/pxa3xx-gcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/pxa3xx-gcu.c b/drivers/video/fbdev/pxa3xx-gcu.c
index 43695a33f062..aec0b85db5bf 100644
--- a/drivers/video/fbdev/pxa3xx-gcu.c
+++ b/drivers/video/fbdev/pxa3xx-gcu.c
@@ -394,7 +394,7 @@ pxa3xx_gcu_write(struct file *file, const char *buff,
 	struct pxa3xx_gcu_batch	*buffer;
 	struct pxa3xx_gcu_priv *priv = to_pxa3xx_gcu_priv(file);
 
-	int words = count / 4;
+	size_t words = count / 4;
 
 	/* Does not need to be atomic. There's a lock in user space,
 	 * but anyhow, this is just for statistics. */
-- 
2.35.1

