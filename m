Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F1A49A251
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 02:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365678AbiAXXv3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376878AbiAXWjp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:39:45 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12318C055A82;
        Mon, 24 Jan 2022 13:03:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A759D6135E;
        Mon, 24 Jan 2022 21:03:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65974C340E5;
        Mon, 24 Jan 2022 21:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058196;
        bh=2kVKJqHtcxVJW0NOQq1o96/VtVRgd9Gc0cgLyrd3S30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KdW8qaJufB0i97aLVsNFLt2RGLDHb6GR+7OnVbCsWSqWN6ggKs2tcCUe0rnpaY1SW
         rlGRJdH49Yep9cyA1jpObyJ6xzSASFhkspWKiPfgG1oj8mqtoaNIPnZvgXxPAj0Y9A
         nhYVI7GqJGJs71el0dYpdyH/+fE9c8iQP7T86/Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0210/1039] pinctrl: mediatek: uninitialized variable in mtk_pctrl_show_one_pin()
Date:   Mon, 24 Jan 2022 19:33:19 +0100
Message-Id: <20220124184132.386134617@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 67bbbcb49b968a93251de7b23616d5aff5d3a726 ]

The "try_all_type" variable is not set if (hw->soc->pull_type) is false
leading to the following Smatch warning:

    drivers/pinctrl/mediatek/pinctrl-paris.c:599 mtk_pctrl_show_one_pin()
    error: uninitialized symbol 'try_all_type'.

Fixes: fb34a9ae383a ("pinctrl: mediatek: support rsel feature")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20211127140750.GA24002@kili
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-paris.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-paris.c b/drivers/pinctrl/mediatek/pinctrl-paris.c
index d4e02c5d74a89..4c6f6d967b18a 100644
--- a/drivers/pinctrl/mediatek/pinctrl-paris.c
+++ b/drivers/pinctrl/mediatek/pinctrl-paris.c
@@ -581,7 +581,7 @@ ssize_t mtk_pctrl_show_one_pin(struct mtk_pinctrl *hw,
 {
 	int pinmux, pullup, pullen, len = 0, r1 = -1, r0 = -1, rsel = -1;
 	const struct mtk_pin_desc *desc;
-	u32 try_all_type;
+	u32 try_all_type = 0;
 
 	if (gpio >= hw->soc->npins)
 		return -EINVAL;
-- 
2.34.1



