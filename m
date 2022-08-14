Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE6E9592064
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 17:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231348AbiHNPYn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 11:24:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiHNPYn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 11:24:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EB0765E7;
        Sun, 14 Aug 2022 08:24:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 264B260B9F;
        Sun, 14 Aug 2022 15:24:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DCBBC433D6;
        Sun, 14 Aug 2022 15:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660490680;
        bh=ebo6kPnfZ6o+Q1fsjAA8jeQY9HT8MUugEfOa0/b02xE=;
        h=From:To:Cc:Subject:Date:From;
        b=KJl1IjqkM8tIPfkWtU0OdEDNWny/vh2eYKzzLZiyVvgh4K0xbJVJr89Cvk509Rh3v
         YD+OrKP4rfJJxPx7jzrrwV5ujfPwJMmn+XG4MVymIeH+r7s8ZLSTe8pktcsGTVjmeT
         vZV74qyvDcIkJ8eIJnmwKLlh6xlTCk+K00O9/8hf7fsfL41LBHsDQxNP0cGYYie9JU
         huBxztY5T+FXX954T2+bk9iSTBOEyUi0EYRvxslWpFNDezyPjvNfA8jSTiPDjM60Bg
         W/AKsopd/auyWWuZWI672UdxqfqLsy72haJL9zgF6Cw17zQ/Vti6kRUarHkPHRvGW1
         lthSqx2t32enw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gil Fine <gil.fine@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>, andreas.noever@gmail.com,
        michael.jamet@intel.com, YehezkelShB@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 01/64] thunderbolt: Change downstream router's TMU rate in both TMU uni/bidir mode
Date:   Sun, 14 Aug 2022 11:23:34 -0400
Message-Id: <20220814152437.2374207-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gil Fine <gil.fine@intel.com>

[ Upstream commit 5fd6b9a5cbe63fea4c490fee8af34144a139a266 ]

In case of uni-directional time sync, TMU handshake is
initiated by upstream router. In case of bi-directional
time sync, TMU handshake is initiated by downstream router.
In order to handle correctly the case of uni-directional mode,
we avoid changing the upstream router's rate to off,
because it might have another downstream router plugged that is set to
uni-directional mode (and we don't want to change its mode).
Instead, we always change downstream router's rate.

Signed-off-by: Gil Fine <gil.fine@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/tmu.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/tmu.c b/drivers/thunderbolt/tmu.c
index e4a07a26f693..93ba1d00335b 100644
--- a/drivers/thunderbolt/tmu.c
+++ b/drivers/thunderbolt/tmu.c
@@ -359,13 +359,14 @@ int tb_switch_tmu_disable(struct tb_switch *sw)
 		 * In case of uni-directional time sync, TMU handshake is
 		 * initiated by upstream router. In case of bi-directional
 		 * time sync, TMU handshake is initiated by downstream router.
-		 * Therefore, we change the rate to off in the respective
-		 * router.
+		 * We change downstream router's rate to off for both uni/bidir
+		 * cases although it is needed only for the bi-directional mode.
+		 * We avoid changing upstream router's mode since it might
+		 * have another downstream router plugged, that is set to
+		 * uni-directional mode and we don't want to change it's TMU
+		 * mode.
 		 */
-		if (unidirectional)
-			tb_switch_tmu_rate_write(parent, TB_SWITCH_TMU_RATE_OFF);
-		else
-			tb_switch_tmu_rate_write(sw, TB_SWITCH_TMU_RATE_OFF);
+		tb_switch_tmu_rate_write(sw, TB_SWITCH_TMU_RATE_OFF);
 
 		tb_port_tmu_time_sync_disable(up);
 		ret = tb_port_tmu_time_sync_disable(down);
-- 
2.35.1

