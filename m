Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD0D8603CF0
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiJSIzM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:55:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232012AbiJSIyU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:54:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C22983F0E;
        Wed, 19 Oct 2022 01:51:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DE6BB61865;
        Wed, 19 Oct 2022 08:50:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDD6AC433D6;
        Wed, 19 Oct 2022 08:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169405;
        bh=E0P5Plv7o5uoE/gCMwmS7YD7vzFnZnNz9sL7HO26qXM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awoqGgPSumNEPXSdTqZ0f86QE5UbUKC04Z213z999ECKTSjdMsMWyVY69wglU+FHq
         TRwql9B1737101OJPKMne/ieMoVZ/lmpM4RGoB3fTGAU1nyhPCECDo0rDNLXupBG8U
         s6yFwbPygwJJb9Do1Um+9OTvq89j9jODyx3LhBOs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>, Kalle Valo <kvalo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 263/862] wifi: wfx: prevent underflow in wfx_send_pds()
Date:   Wed, 19 Oct 2022 10:25:50 +0200
Message-Id: <20221019083301.648139574@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f97c81f5b7f8047810b0d79a8f759a83951210a0 ]

This does a "chunk_len - 4" subtraction later when it calls:

	ret = wfx_hif_configuration(wdev, buf + 4, chunk_len - 4);

so check for "chunk_len" is less than 4.

Fixes: dcbecb497908 ("staging: wfx: allow new PDS format")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/Yv8eX7Xv2ubUOvW7@kili
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/silabs/wfx/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/silabs/wfx/main.c b/drivers/net/wireless/silabs/wfx/main.c
index e015bfb8d221..84d82ddded56 100644
--- a/drivers/net/wireless/silabs/wfx/main.c
+++ b/drivers/net/wireless/silabs/wfx/main.c
@@ -181,7 +181,7 @@ int wfx_send_pds(struct wfx_dev *wdev, u8 *buf, size_t len)
 	while (len > 0) {
 		chunk_type = get_unaligned_le16(buf + 0);
 		chunk_len = get_unaligned_le16(buf + 2);
-		if (chunk_len > len) {
+		if (chunk_len < 4 || chunk_len > len) {
 			dev_err(wdev->dev, "PDS:%d: corrupted file\n", chunk_num);
 			return -EINVAL;
 		}
-- 
2.35.1



