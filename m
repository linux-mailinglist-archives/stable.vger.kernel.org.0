Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A55E4EF24F
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348778AbiDAOz5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:55:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350033AbiDAOrG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:47:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AD572A03E3;
        Fri,  1 Apr 2022 07:36:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8F6EB8240E;
        Fri,  1 Apr 2022 14:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B485FC34111;
        Fri,  1 Apr 2022 14:36:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823787;
        bh=OUyOOl54sxaGvC8uGjPJH5iu0OEiwKvOzm17ZD/Dil8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hOlPEIwjj/lYTe7TLFqAo/PzCng3WpPVdiDH8/c1xmqMg+IRy3l32N2b5sQUjxm33
         Fq7CGFG5nNqoDhrqMqWVsqiBPftR56u+9FB8bJglhhZ+iZ64dE6SeqFMSsnxRjokJi
         sIcC7/LVjpbfTlI7GOPEMoRbJJygHDSmaqbPgwsbsA9R8RQpwVA9EIUdGmD3jNQIx8
         SBazLg8zP7MAiMP1ynrmaM8wz+/SzvPCDa8qlL5SUK5hNMcH7QqYrgR8+vJPPFw9En
         9orwBumOCKfg0ScVZBpyy2gV7EY3aFWNpOGf8QcbWVFvjU6oxMaWUSEow54Oslwujl
         R8jirOUEzbUMA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, john@phrozen.org,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 077/109] mips: ralink: fix a refcount leak in ill_acc_of_setup()
Date:   Fri,  1 Apr 2022 10:32:24 -0400
Message-Id: <20220401143256.1950537-77-sashal@kernel.org>
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

[ Upstream commit 4a0a1436053b17e50b7c88858fb0824326641793 ]

of_node_put(np) needs to be called when pdev == NULL.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/ralink/ill_acc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/ralink/ill_acc.c b/arch/mips/ralink/ill_acc.c
index bdf53807d7c2..bea857c9da8b 100644
--- a/arch/mips/ralink/ill_acc.c
+++ b/arch/mips/ralink/ill_acc.c
@@ -61,6 +61,7 @@ static int __init ill_acc_of_setup(void)
 	pdev = of_find_device_by_node(np);
 	if (!pdev) {
 		pr_err("%pOFn: failed to lookup pdev\n", np);
+		of_node_put(np);
 		return -EINVAL;
 	}
 
-- 
2.34.1

