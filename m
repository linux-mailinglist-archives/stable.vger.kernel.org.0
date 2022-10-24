Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A761960A62F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233934AbiJXMcF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:32:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234369AbiJXMaK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:30:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D6E11A24;
        Mon, 24 Oct 2022 05:04:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C09C2B811A6;
        Mon, 24 Oct 2022 11:52:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD7DC433D6;
        Mon, 24 Oct 2022 11:52:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612326;
        bh=0lbPNCsDRrqENwaCBcpPeVLGu2TkgjKhDAEw/yHaLpw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=U5CAAWGeR+YW9yPkjnbUbT3KF6bgJkueqzAeaWDCsUyVhzXNcnJThen8YIcwJl0K1
         UzRqU4g2uKE7CvP2DSa+C333Nwdt5jGoZrZQKq6DHkCPjOT/SwXoMKbzvGzwBOcJLT
         6dYdSU6pwkTDeThbD5gfcGNVl6ZkVqZaKUZv7y58=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheng Yongjun <zhengyongjun3@huawei.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 155/210] powerpc/powernv: add missing of_node_put() in opal_export_attrs()
Date:   Mon, 24 Oct 2022 13:31:12 +0200
Message-Id: <20221024113002.010570901@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112956.797777597@linuxfoundation.org>
References: <20221024112956.797777597@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Yongjun <zhengyongjun3@huawei.com>

[ Upstream commit 71a92e99c47900cc164620948b3863382cec4f1a ]

After using 'np' returned by of_find_node_by_path(), of_node_put()
need be called to decrease the refcount.

Fixes: 11fe909d2362 ("powerpc/powernv: Add OPAL exports attributes to sysfs")
Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220906141703.118192-1-zhengyongjun3@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/opal.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/platforms/powernv/opal.c b/arch/powerpc/platforms/powernv/opal.c
index 597fcbf7a39e..c8bc9accd858 100644
--- a/arch/powerpc/platforms/powernv/opal.c
+++ b/arch/powerpc/platforms/powernv/opal.c
@@ -677,6 +677,7 @@ static void opal_export_attrs(void)
 	kobj = kobject_create_and_add("exports", opal_kobj);
 	if (!kobj) {
 		pr_warn("kobject_create_and_add() of exports failed\n");
+		of_node_put(np);
 		return;
 	}
 
-- 
2.35.1



