Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7555952198A
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237771AbiEJNta (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:49:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244125AbiEJNpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:45:08 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7092887A1D;
        Tue, 10 May 2022 06:31:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 3EB35CE1EF3;
        Tue, 10 May 2022 13:31:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B23FC385C2;
        Tue, 10 May 2022 13:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189470;
        bh=P3SVQNOO3B7N/QZLCcWPzgOahP2/LyoDyJ/f3OPaNKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=q3i++jFZ9yrmkW3Zj/uvk9aU+sUeN5kYaKkte2xrZLn2peb+WYLvZtFcz067VXMFw
         IEcotpl9A1W5dVwrs5FqdMO9ryQ/r/jBe6edMhM+n2IgilSaLQBhnGI6qaie1lUu6i
         ToGdWGUVb8ReRyBvqb3cdTn3bVd/w8CaDBnF31C8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 061/135] net: ethernet: mediatek: add missing of_node_put() in mtk_sgmii_init()
Date:   Tue, 10 May 2022 15:07:23 +0200
Message-Id: <20220510130742.158023778@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit ff5265d45345d01fefc98fcb9ae891b59633c919 upstream.

The node pointer returned by of_parse_phandle() with refcount incremented,
so add of_node_put() after using it in mtk_sgmii_init().

Fixes: 9ffee4a8276c ("net: ethernet: mediatek: Extend SGMII related functions")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220428062543.64883-1-yangyingliang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mediatek/mtk_sgmii.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/ethernet/mediatek/mtk_sgmii.c
+++ b/drivers/net/ethernet/mediatek/mtk_sgmii.c
@@ -26,6 +26,7 @@ int mtk_sgmii_init(struct mtk_sgmii *ss,
 			break;
 
 		ss->regmap[i] = syscon_node_to_regmap(np);
+		of_node_put(np);
 		if (IS_ERR(ss->regmap[i]))
 			return PTR_ERR(ss->regmap[i]);
 	}


