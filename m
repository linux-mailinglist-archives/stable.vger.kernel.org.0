Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D70659374D
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245171AbiHOTG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245117AbiHOTF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:05:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039314E612;
        Mon, 15 Aug 2022 11:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2562C6111E;
        Mon, 15 Aug 2022 18:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ED77C4314A;
        Mon, 15 Aug 2022 18:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588460;
        bh=9u+RPsdKAXeHUNT7S87LWCUibPX9fT0Xx0jOa0D91Us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2pDXpvL+eCK8hLIOxmLCaCWTUqPOSDLHRS26bm73fq4iGU+Eu8B8FgetglIVOVjuj
         SZL+3tG5IdHvQJmyeJQkQi51j58LM2oMXAUk9dsr6evVPMZSS0r0s3+SW+fABlnL2a
         4iAcAg9bxShs0fWFVebXkQSKgtEK+t0h974qCgCY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 410/779] mtd: parsers: ofpart: Fix refcount leak in bcm4908_partitions_fw_offset
Date:   Mon, 15 Aug 2022 20:00:54 +0200
Message-Id: <20220815180354.803350491@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit e607879b0da18c451de5e91daf239cc2f2f8ff2d ]

of_find_node_by_path() returns a node pointer with refcount incremented,
we should use of_node_put() on it when not need anymore.
Add missing of_node_put() to avoid refcount leak.

Fixes: bb17230c61a6 ("mtd: parsers: ofpart: support BCM4908 fixed partitions")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220605070726.5979-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/parsers/ofpart_bcm4908.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/mtd/parsers/ofpart_bcm4908.c b/drivers/mtd/parsers/ofpart_bcm4908.c
index 0eddef4c198e..bb072a0940e4 100644
--- a/drivers/mtd/parsers/ofpart_bcm4908.c
+++ b/drivers/mtd/parsers/ofpart_bcm4908.c
@@ -35,12 +35,15 @@ static long long bcm4908_partitions_fw_offset(void)
 		err = kstrtoul(s + len + 1, 0, &offset);
 		if (err) {
 			pr_err("failed to parse %s\n", s + len + 1);
+			of_node_put(root);
 			return err;
 		}
 
+		of_node_put(root);
 		return offset << 10;
 	}
 
+	of_node_put(root);
 	return -ENOENT;
 }
 
-- 
2.35.1



