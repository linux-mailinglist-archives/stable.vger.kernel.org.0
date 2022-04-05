Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1174D4F2636
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:54:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232855AbiDEHzw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232745AbiDEHyO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:54:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B835033A30;
        Tue,  5 Apr 2022 00:50:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 442CBB81BAD;
        Tue,  5 Apr 2022 07:50:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B4BBC340EE;
        Tue,  5 Apr 2022 07:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145013;
        bh=L6p9n9Yb6I50Kgerajj1lRR+36C/t8bXwjz8d07YcoQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qwgq4uFLCmpRzLK5aBiSM1yIgf/I6gxVz9FXIRs9FwY9yBESa3zJVxYMvS9OEgOvp
         xOISt9SHR7LrpZAnHp33jzjouf5aqOhpuNkdSR8wChG8ptT0eK7DZ46Lta32UZYN68
         eN4cS/YahiMe8LkUQnaVfm3cizkn33JWqXhADoIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0252/1126] perf/arm-cmn: Hide XP PUB events for CMN-600
Date:   Tue,  5 Apr 2022 09:16:39 +0200
Message-Id: <20220405070415.006985895@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 205295c7e1abba9c1db1f9fe075f22f71351887f ]

CMN-600 doesn't have XP events for the PUB channel, but we missed
the appropriate check to avoid exposing them.

Fixes: 60d1504070c2 ("perf/arm-cmn: Support new IP features")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/4c108d39a0513def63acccf09ab52b328f242aeb.1645727871.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm-cmn.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/perf/arm-cmn.c b/drivers/perf/arm-cmn.c
index 0e48adce57ef..d45e8c17e1f8 100644
--- a/drivers/perf/arm-cmn.c
+++ b/drivers/perf/arm-cmn.c
@@ -595,6 +595,9 @@ static umode_t arm_cmn_event_attr_is_visible(struct kobject *kobj,
 		if ((intf & 4) && !(cmn->ports_used & BIT(intf & 3)))
 			return 0;
 
+		if (chan == 4 && cmn->model == CMN600)
+			return 0;
+
 		if ((chan == 5 && cmn->rsp_vc_num < 2) ||
 		    (chan == 6 && cmn->dat_vc_num < 2))
 			return 0;
-- 
2.34.1



