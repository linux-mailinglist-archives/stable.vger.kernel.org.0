Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4027594D71
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243876AbiHPAdB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:33:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354200AbiHPAbd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:31:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54DC01863C6;
        Mon, 15 Aug 2022 13:36:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41B07611FC;
        Mon, 15 Aug 2022 20:36:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB30C433D6;
        Mon, 15 Aug 2022 20:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595778;
        bh=cfS4LzqGH/rZMcbVLuMFUkaIzMKrRGLQzVcvKPvDyjE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2b+b7RDM9+PwZa+62YK93lBL9cSB+/jADZHy49AXpIYA7yoZwq+cd8lOOnOaHsJ22
         QBM4eI3VVf9r0uErivs8hdFYtJ0/mdeoVW7dI0F9d2eE30RPz3Ku5UIaDjcX2PU5Hk
         LylJUAEise6hcE5lRbhKnFCrmut06ujXgcqI9EZY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0873/1157] of/fdt: declared return type does not match actual return type
Date:   Mon, 15 Aug 2022 20:03:49 +0200
Message-Id: <20220815180514.381841548@linuxfoundation.org>
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

From: Xu Qiang <xuqiang36@huawei.com>

[ Upstream commit 7913145afa51bbed9eaf8e5b4ee55fa9884a71e5 ]

The commit 649cab56de8e (“of: properly check for error returned
by fdt_get_name()”) changed the return value type from bool to int,
but forgot to change the return value simultaneously.

populate_node was only called in unflatten_dt_nodes, and returns
with values greater than or equal to 0 were discarded without further
processing. Considering that return 0 usually indicates success,
return 0 instead of return true.

Fixes: 649cab56de8e (“of: properly check for error returned by fdt_get_name()”)
Signed-off-by: Xu Qiang <xuqiang36@huawei.com>
Signed-off-by: Rob Herring <robh@kernel.org>
Link: https://lore.kernel.org/r/20220801120506.11461-2-xuqiang36@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/fdt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index a8f5b6532165..520ed965bb7a 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -246,7 +246,7 @@ static int populate_node(const void *blob,
 	}
 
 	*pnp = np;
-	return true;
+	return 0;
 }
 
 static void reverse_nodes(struct device_node *parent)
-- 
2.35.1



