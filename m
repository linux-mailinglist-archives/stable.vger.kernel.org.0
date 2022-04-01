Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926AB4EF340
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349467AbiDAOzv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:55:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350006AbiDAOrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:47:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2DA22A03CC;
        Fri,  1 Apr 2022 07:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B3B660B9F;
        Fri,  1 Apr 2022 14:36:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEADC2BBE4;
        Fri,  1 Apr 2022 14:36:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823813;
        bh=1JoZfE6UdxHEB+nH3V/p32G6m+oS2lKo835qRMi3X5E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fDUAxvwFlSBH8/bDMJtr9m5/u3ffvEUNjFDWIF3CYWpjE21gI09a6rpHQCU8OC+Se
         JXWYrVdvci1cIqCWpsC9hDAsu7LZQsQwqtx7FAXcWAUprN3RDDonYcsQRpss9VnLPz
         ngw2wOcAK65wg4lpPjnLLn56cN/GMv/c3Up4pBlEZImSU24rag0Y6/tR0TQVv4xnp0
         L3Ry34CCM+S4nABhii80/gdH4FXjrPMX7tbcjOMqwM47uxg8/p8ORGhf5TCYLtbq8K
         5vMNv9LdZMd7G+HVBlbVt2X4s8ePhlkn7ZIF8ZQ0IthKXibO4Deb9Qsvx/UTxILWsR
         QafxC1l6V8XJQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.16 087/109] powerpc/secvar: fix refcount leak in format_show()
Date:   Fri,  1 Apr 2022 10:32:34 -0400
Message-Id: <20220401143256.1950537-87-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220401143256.1950537-1-sashal@kernel.org>
References: <20220401143256.1950537-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Hangyu Hua <hbh25y@gmail.com>

[ Upstream commit d601fd24e6964967f115f036a840f4f28488f63f ]

Refcount leak will happen when format_show returns failure in multiple
cases. Unified management of of_node_put can fix this problem.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220302021959.10959-1-hbh25y@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/secvar-sysfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/secvar-sysfs.c b/arch/powerpc/kernel/secvar-sysfs.c
index a0a78aba2083..1ee4640a2641 100644
--- a/arch/powerpc/kernel/secvar-sysfs.c
+++ b/arch/powerpc/kernel/secvar-sysfs.c
@@ -26,15 +26,18 @@ static ssize_t format_show(struct kobject *kobj, struct kobj_attribute *attr,
 	const char *format;
 
 	node = of_find_compatible_node(NULL, NULL, "ibm,secvar-backend");
-	if (!of_device_is_available(node))
-		return -ENODEV;
+	if (!of_device_is_available(node)) {
+		rc = -ENODEV;
+		goto out;
+	}
 
 	rc = of_property_read_string(node, "format", &format);
 	if (rc)
-		return rc;
+		goto out;
 
 	rc = sprintf(buf, "%s\n", format);
 
+out:
 	of_node_put(node);
 
 	return rc;
-- 
2.34.1

