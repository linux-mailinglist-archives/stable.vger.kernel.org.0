Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429DC50121F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345037AbiDNNt6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344332AbiDNNkz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:40:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D70A1C6;
        Thu, 14 Apr 2022 06:38:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 197866190F;
        Thu, 14 Apr 2022 13:38:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264FCC385A5;
        Thu, 14 Apr 2022 13:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943509;
        bh=cO3csObAGATj8OcIKsCInFNJuzbOnf1Jb70tYNG1yr8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g4fBotCKod4jnFyPFPRMn2HaCCRr6EImSZ0vHj4fAzwk8GnNvdtFRhP4kOk9Oq8u0
         7VS0QScrseI0yv4lEwpE8BcXyKrtzkfU5dJm+kHawWddHxxLpLxHjqT3t2kXVPROmp
         sMUG3vk0rXO+cfPCmmAoS3AkdSWLXYoLGsvR+Vuo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jia-Ju Bai <baijiaju1990@gmail.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/475] memory: emif: check the pointer temp in get_device_details()
Date:   Thu, 14 Apr 2022 15:08:45 +0200
Message-Id: <20220414110859.065354083@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia-Ju Bai <baijiaju1990@gmail.com>

[ Upstream commit 5b5ab1bfa1898c6d52936a57c25c5ceba2cb2f87 ]

The pointer temp is allocated by devm_kzalloc(), so it should be
checked for error handling.

Fixes: 7ec944538dde ("memory: emif: add basic infrastructure for EMIF driver")
Signed-off-by: Jia-Ju Bai <baijiaju1990@gmail.com>
Link: https://lore.kernel.org/r/20220225132552.27894-1-baijiaju1990@gmail.com
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/memory/emif.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/memory/emif.c b/drivers/memory/emif.c
index 0d6b975616bb..9c4c668f9a88 100644
--- a/drivers/memory/emif.c
+++ b/drivers/memory/emif.c
@@ -1423,7 +1423,7 @@ static struct emif_data *__init_or_module get_device_details(
 	temp	= devm_kzalloc(dev, sizeof(*pd), GFP_KERNEL);
 	dev_info = devm_kzalloc(dev, sizeof(*dev_info), GFP_KERNEL);
 
-	if (!emif || !pd || !dev_info) {
+	if (!emif || !temp || !dev_info) {
 		dev_err(dev, "%s:%d: allocation error\n", __func__, __LINE__);
 		goto error;
 	}
-- 
2.34.1



