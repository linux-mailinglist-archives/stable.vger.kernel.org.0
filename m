Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A725659452B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 01:00:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244562AbiHOWVp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 18:21:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350950AbiHOWS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 18:18:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58C9C67CA5;
        Mon, 15 Aug 2022 12:43:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 818F9B81141;
        Mon, 15 Aug 2022 19:43:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC3FFC433C1;
        Mon, 15 Aug 2022 19:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660592586;
        bh=Z/b5BWHJW+g75sTUAQz13S8RCfehdjJmeZQfNNJWBK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pRCcoW1SGIb2elqJnAdnxrw7igROnMI3PJQjqtlDfGJbkDrxkpENro8vj09mz86uw
         gw/8XCxlrzwZdPndOUkljB3s9/wbZhcZr4Ai4Y/Zqqx0UR8qNgF7/cQ6mseHxHO5hS
         8hm6aa7R9W2h0bhvZMBJQG3he9EAw4YvdQ+kLOHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0812/1095] of/fdt: declared return type does not match actual return type
Date:   Mon, 15 Aug 2022 20:03:31 +0200
Message-Id: <20220815180502.859861917@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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
index 0f30496ce80b..d624e8b185aa 100644
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



