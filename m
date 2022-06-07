Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DEA1541558
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:35:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347627AbiFGUfU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:35:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376877AbiFGU2P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:28:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D8A01D9B47;
        Tue,  7 Jun 2022 11:33:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8A55612EC;
        Tue,  7 Jun 2022 18:33:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D0FC385A5;
        Tue,  7 Jun 2022 18:33:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626802;
        bh=7xMcwb9TiKoQhDGVCSyKHR4w3KZW+4Mbltbx2mEeF3k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NTgH8x7jF4Ac4qMsa6Ctvzh+NUotLyVjXz7R+eaq5VdA3y4xz08mdtAStciazRG9B
         MGphp1BYGNT9E1D4qLU2qZir9bqXuy7i+/cLOPOtnIJtzuyJvZiXUP2xalua77MasF
         ROPYIKJ4hT8u7SRfKT9nCSJrfIOcIicZ6V/pnod8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Arunachalam Ganapathy <arunachalam.ganapathy@arm.com>,
        Sudeep Holla <sudeep.holla@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 508/772] firmware: arm_ffa: Fix uuid parameter to ffa_partition_probe
Date:   Tue,  7 Jun 2022 19:01:40 +0200
Message-Id: <20220607165003.947845590@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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



