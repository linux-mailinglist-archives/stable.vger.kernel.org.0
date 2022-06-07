Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119CA541C39
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382268AbiFGV51 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:57:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382044AbiFGVzg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:55:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA96A24B62C;
        Tue,  7 Jun 2022 12:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C06F3B8233E;
        Tue,  7 Jun 2022 19:12:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CEECC385A2;
        Tue,  7 Jun 2022 19:12:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629177;
        bh=7xMcwb9TiKoQhDGVCSyKHR4w3KZW+4Mbltbx2mEeF3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeHcInzG8gWCFsvfmFqII8L7jP9EVhI1DjWCnw4C2LTIhenlevukx7L4NyylprMTv
         +OtCNlM8awY+xLckzDo61ZPlckO79K6GGXy8vUd4rssG/12V7HzziNpc+ab91xyMaE
         ez/PoUQkNfYbzdkwj2wqX9gedunDyoWIPLLBx1q0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arunachalam Ganapathy <arunachalam.ganapathy@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 598/879] firmware: arm_ffa: Fix uuid parameter to ffa_partition_probe
Date:   Tue,  7 Jun 2022 19:01:56 +0200
Message-Id: <20220607165020.210792995@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit f3c45c045e25ed52461829d2ce07954f72b6ad15 ]

While we pass uuid_null intentionally to ffa_partition_probe in
ffa_setup_partitions to get the count of the partitions, it must not be
uuid_null in ffa_partition_info_get which is used by the ffa_drivers
to fetch the specific partition info passing the UUID of the partition.

Fix ffa_partition_info_get by passing the received uuid down to
ffa_partition_probe so that the correct partition information is fetched.

Link: https://lore.kernel.org/r/20220429113946.2087145-1-sudeep.holla@arm.com
Fixes: d0c0bce83122 ("firmware: arm_ffa: Setup in-kernel users of FFA partitions")
Reported-by: Arunachalam Ganapathy <arunachalam.ganapathy@arm.com>
Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/arm_ffa/driver.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/arm_ffa/driver.c b/drivers/firmware/arm_ffa/driver.c
index 14f900047ac0..8fa1785afd42 100644
--- a/drivers/firmware/arm_ffa/driver.c
+++ b/drivers/firmware/arm_ffa/driver.c
@@ -582,7 +582,7 @@ static int ffa_partition_info_get(const char *uuid_str,
 		return -ENODEV;
 	}
 
-	count = ffa_partition_probe(&uuid_null, &pbuf);
+	count = ffa_partition_probe(&uuid, &pbuf);
 	if (count <= 0)
 		return -ENOENT;
 
-- 
2.35.1



