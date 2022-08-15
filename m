Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4202594BE8
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351613AbiHPA3P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357561AbiHPA1Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:27:16 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2B91180B5E;
        Mon, 15 Aug 2022 13:34:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC698CE12C4;
        Mon, 15 Aug 2022 20:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E924BC433C1;
        Mon, 15 Aug 2022 20:34:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595653;
        bh=4Qx3TpTzRNC8GP0eSyB6JcW988m841SDnRGg73iCp10=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZZzifybzRxrYJ8U1l+2ZlthsMs9DYo6osGP/rYBubxxKT4rNIbSRaBghrEkGHiFA
         0Dg4NTaSR32DmRtfCwD7IqcwXfdHJ8xngF44WboA4p2gTbZszP7/aJTdQYXhawhdIU
         sMvDAI79eRRMKs86H71ei2VY1JRdrHOTojCRtgJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>,
        Miaoqian Lin <linmq006@gmail.com>
Subject: [PATCH 5.19 0800/1157] of: device: Fix missing of_node_put() in of_dma_set_restricted_buffer
Date:   Mon, 15 Aug 2022 20:02:36 +0200
Message-Id: <20220815180511.486332585@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liang He <windhl@126.com>

[ Upstream commit d17e37c41b7ed38459957a5d2968ba61516fd5c2 ]

We should use of_node_put() for the reference 'node' returned by
of_parse_phandle() which will increase the refcount.

Fixes: fec9b625095f ("of: Add plumbing for restricted DMA pool")
Co-authored-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220702014449.263772-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/device.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index 874f031442dc..75b6cbffa755 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -81,8 +81,11 @@ of_dma_set_restricted_buffer(struct device *dev, struct device_node *np)
 		 * restricted-dma-pool region is allowed.
 		 */
 		if (of_device_is_compatible(node, "restricted-dma-pool") &&
-		    of_device_is_available(node))
+		    of_device_is_available(node)) {
+			of_node_put(node);
 			break;
+		}
+		of_node_put(node);
 	}
 
 	/*
-- 
2.35.1



