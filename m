Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60CCA595075
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231810AbiHPEmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232244AbiHPEk7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:40:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6844A7220;
        Mon, 15 Aug 2022 13:32:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B33B611FE;
        Mon, 15 Aug 2022 20:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D2DFC4314A;
        Mon, 15 Aug 2022 20:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595577;
        bh=+J+Q8LniD2ZXHJOSoRNy/SiVung7frjPqTcLHzcd/cE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tddFERDdRtharrdoFnU6dTc0aYwH6lC70qhO+l08mriyKNbbcTvM1dtgAEaSFZcJ+
         b0F1nZON7bA7Afbursb2g36yY34htmn8n0h8hmatafOF5Ka2fR8VU9SU9AU7wL+Jah
         GGM9ni+3PNVHMrEnZgBYUQd6P/jpv7wWzUUatddA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0809/1157] usb: aspeed-vhub: Fix refcount leak bug in ast_vhub_init_desc()
Date:   Mon, 15 Aug 2022 20:02:45 +0200
Message-Id: <20220815180511.855035481@linuxfoundation.org>
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

[ Upstream commit 220fafb4ed04187e9c17be4152da5a7f2ffbdd8c ]

We should call of_node_put() for the reference returned by
of_get_child_by_name() which has increased the refcount.

Fixes: 30d2617fd7ed ("usb: gadget: aspeed: allow to set usb strings in device tree")
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220713120528.368168-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/aspeed-vhub/hub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/aspeed-vhub/hub.c b/drivers/usb/gadget/udc/aspeed-vhub/hub.c
index 65cd4e46f031..e2207d014620 100644
--- a/drivers/usb/gadget/udc/aspeed-vhub/hub.c
+++ b/drivers/usb/gadget/udc/aspeed-vhub/hub.c
@@ -1059,8 +1059,10 @@ static int ast_vhub_init_desc(struct ast_vhub *vhub)
 	/* Initialize vhub String Descriptors. */
 	INIT_LIST_HEAD(&vhub->vhub_str_desc);
 	desc_np = of_get_child_by_name(vhub_np, "vhub-strings");
-	if (desc_np)
+	if (desc_np) {
 		ret = ast_vhub_of_parse_str_desc(vhub, desc_np);
+		of_node_put(desc_np);
+	}
 	else
 		ret = ast_vhub_str_alloc_add(vhub, &ast_vhub_strings);
 
-- 
2.35.1



