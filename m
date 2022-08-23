Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4C759D87E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:03:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345775AbiHWJm3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352327AbiHWJlO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4917A760;
        Tue, 23 Aug 2022 01:42:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BE4C8B81C4F;
        Tue, 23 Aug 2022 08:42:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA9EC433D6;
        Tue, 23 Aug 2022 08:42:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244121;
        bh=n+2iOGiB+qch6T//Hq81dKR36CGWfTGsY3B/xUddBgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ig+Z7bXSqc/w2f6asXBTYIeonnzw60P3qdYRP8tYmlKU2GfgFLUOuf9ft5bc2dSTR
         UWUwFmX3EU387236JTnfw2rYwW2Y4Ou3S5q0o5QBp+tvsx6/mN1c6oRxsm+dQ0wu8B
         J4MbLrAmLkP74PRxJOBgo4YTFgvYNp1wDH7QYtk0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Peter Rosin <peda@axentia.se>, Wolfram Sang <wsa@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 089/229] i2c: mux-gpmux: Add of_node_put() when breaking out of loop
Date:   Tue, 23 Aug 2022 10:24:10 +0200
Message-Id: <20220823080056.892342856@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

[ Upstream commit 6435319c34704994e19b0767f6a4e6f37439867b ]

In i2c_mux_probe(), we should call of_node_put() when breaking out
of for_each_child_of_node() which will automatically increase and
decrease the refcount.

Fixes: ac8498f0ce53 ("i2c: i2c-mux-gpmux: new driver")
Signed-off-by: Liang He <windhl@126.com>
Acked-by: Peter Rosin <peda@axentia.se>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/muxes/i2c-mux-gpmux.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/i2c/muxes/i2c-mux-gpmux.c b/drivers/i2c/muxes/i2c-mux-gpmux.c
index 92cf5f48afe6..5053f1675a29 100644
--- a/drivers/i2c/muxes/i2c-mux-gpmux.c
+++ b/drivers/i2c/muxes/i2c-mux-gpmux.c
@@ -141,6 +141,7 @@ static int i2c_mux_probe(struct platform_device *pdev)
 	return 0;
 
 err_children:
+	of_node_put(child);
 	i2c_mux_del_adapters(muxc);
 err_parent:
 	i2c_put_adapter(parent);
-- 
2.35.1



