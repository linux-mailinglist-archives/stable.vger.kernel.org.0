Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4345E9FD8
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235709AbiIZKaT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:30:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235849AbiIZK3Y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:29:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B60A146215;
        Mon, 26 Sep 2022 03:19:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4193EB80835;
        Mon, 26 Sep 2022 10:19:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5660CC433C1;
        Mon, 26 Sep 2022 10:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187553;
        bh=9BkiyLBsVzXzC2PyiRUjj1lfylL5hzUuyzqnpUyygY8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN0lLV9nU0beqZaC7GHnqply8jfrCem3YhRDsv+E8c2B38GoniwHuOn73CMp490zi
         YKdiYNrXBTW1atkJiUV4Xuo85bjcngzhIG3NPR9AUMEb7mTivHlSr5yw4cj1EujjX7
         bikASeEA9I6PVm0zOjbeGyWuxOsPF6Mrugc4qOFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hyunwoo Kim <imv4bel@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 17/58] video: fbdev: pxa3xx-gcu: Fix integer overflow in pxa3xx_gcu_write
Date:   Mon, 26 Sep 2022 12:11:36 +0200
Message-Id: <20220926100742.062048441@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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



