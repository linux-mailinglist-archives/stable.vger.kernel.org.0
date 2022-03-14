Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09C3A4D8407
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:21:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240973AbiCNMWf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241394AbiCNMSE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13EF04B43F;
        Mon, 14 Mar 2022 05:12:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E3E5612FF;
        Mon, 14 Mar 2022 12:12:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8383C340E9;
        Mon, 14 Mar 2022 12:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259949;
        bh=moZZ85LDf9khSYKSwiQkuRWcmP/GMvfFbmMPYnMwabY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EOQ1oZFiHkYsoWGSWW13nnqAky9EaFQf1KPWLS79lUp1hbSgl65xasfmXMGqfnSrd
         XkNFgLtYi55smHkeYo37Kz2hxcQvJ/l26kdNgIPfmJ45DJERTnXoBn+VthQrAQGQqO
         n7rEMmS+O04vZOJfyLuRBVyJHkCGoZbjAzGmV/T8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Khoroshilov <khoroshilov@ispras.ru>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 016/121] mISDN: Fix memory leak in dsp_pipeline_build()
Date:   Mon, 14 Mar 2022 12:53:19 +0100
Message-Id: <20220314112744.580635482@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Khoroshilov <khoroshilov@ispras.ru>

[ Upstream commit c6a502c2299941c8326d029cfc8a3bc8a4607ad5 ]

dsp_pipeline_build() allocates dup pointer by kstrdup(cfg),
but then it updates dup variable by strsep(&dup, "|").
As a result when it calls kfree(dup), the dup variable contains NULL.

Found by Linux Driver Verification project (linuxtesting.org) with SVACE.

Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>
Fixes: 960366cf8dbb ("Add mISDN DSP")
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/isdn/mISDN/dsp_pipeline.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_pipeline.c b/drivers/isdn/mISDN/dsp_pipeline.c
index e11ca6bbc7f4..c3b2c99b5cd5 100644
--- a/drivers/isdn/mISDN/dsp_pipeline.c
+++ b/drivers/isdn/mISDN/dsp_pipeline.c
@@ -192,7 +192,7 @@ void dsp_pipeline_destroy(struct dsp_pipeline *pipeline)
 int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 {
 	int found = 0;
-	char *dup, *tok, *name, *args;
+	char *dup, *next, *tok, *name, *args;
 	struct dsp_element_entry *entry, *n;
 	struct dsp_pipeline_entry *pipeline_entry;
 	struct mISDN_dsp_element *elem;
@@ -203,10 +203,10 @@ int dsp_pipeline_build(struct dsp_pipeline *pipeline, const char *cfg)
 	if (!list_empty(&pipeline->list))
 		_dsp_pipeline_destroy(pipeline);
 
-	dup = kstrdup(cfg, GFP_ATOMIC);
+	dup = next = kstrdup(cfg, GFP_ATOMIC);
 	if (!dup)
 		return 0;
-	while ((tok = strsep(&dup, "|"))) {
+	while ((tok = strsep(&next, "|"))) {
 		if (!strlen(tok))
 			continue;
 		name = strsep(&tok, "(");
-- 
2.34.1



