Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559825939B7
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244383AbiHOT2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245192AbiHOTZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:25:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0BB3E759;
        Mon, 15 Aug 2022 11:41:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F02D161029;
        Mon, 15 Aug 2022 18:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1483C433C1;
        Mon, 15 Aug 2022 18:41:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588874;
        bh=0kvt60j2xLMDGX4/p5w7TBRFw0hJQ5k87RL9avNFBVw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yeRZiq+P7OkMJb/snf+HdXWCrTMx0P2pHqoi43P4rV0fZKfo2/hHYnqvn6O8QByhc
         VoIo5HgskgkwvTGaZKsdWjREdRw8KM6ZtYFVTAuWpAiagXDn1q0toFiTklj+5WxSlR
         prc4PwlSM23tH0nB7A6a2vIXKDr/R4Z30g0nYxGQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xu Qiang <xuqiang36@huawei.com>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 542/779] of/fdt: declared return type does not match actual return type
Date:   Mon, 15 Aug 2022 20:03:06 +0200
Message-Id: <20220815180400.484353850@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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
index 59a7a9ee58ef..d245628b15dd 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -245,7 +245,7 @@ static int populate_node(const void *blob,
 	}
 
 	*pnp = np;
-	return true;
+	return 0;
 }
 
 static void reverse_nodes(struct device_node *parent)
-- 
2.35.1



