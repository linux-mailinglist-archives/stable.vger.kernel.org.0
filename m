Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F7D4A8E34
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354611AbiBCUfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:35:30 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39656 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354466AbiBCUdg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:33:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76C3061A56;
        Thu,  3 Feb 2022 20:33:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05EE6C340E8;
        Thu,  3 Feb 2022 20:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920415;
        bh=/T57QsHEXzWRyz9ngAgfSuXzq9rnlQ9xNPWF7J/q3zk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KBrtZX0mfbUpDovOGXd6uVvXKLe3P2g8AFZgAPQKqYmuXSrO9Iwutni1GcHIfE/qK
         DqyZpYRNQbUc9sdX3rc7tibq/I/lEpC0UwKbNRr0DcnHOMlttDQ/6zAh359AwaLRFE
         RS54UE6eaH5z9YqvzfrCO37CmlF017jbj8Nqow0U7j50fpbjmqjitx3F/nWprsF3pG
         KxQORtL0qXPY/7T3q7IcT+M8aKRCXSS4sfY7wxY+/ufQKYEzX8Sn4DEwCeOQheI5OH
         q5+U0j1/NtYmbwfpSLeJuJkkaAF2Oa/538mqt0Xj/OQjiK7UMXuEz9Np5nM+iMpRiE
         lwHc7xIFTRgCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZouMingzhe <mingzhe.zou@easystack.cn>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 23/41] scsi: target: iscsi: Make sure the np under each tpg is unique
Date:   Thu,  3 Feb 2022 15:32:27 -0500
Message-Id: <20220203203245.3007-23-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203245.3007-1-sashal@kernel.org>
References: <20220203203245.3007-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: ZouMingzhe <mingzhe.zou@easystack.cn>

[ Upstream commit a861790afaa8b6369eee8a88c5d5d73f5799c0c6 ]

iscsit_tpg_check_network_portal() has nested for_each loops and is supposed
to return true when a match is found. However, the tpg loop will still
continue after existing the tpg_np loop. If this tpg_np is not the last the
match value will be changed.

Break the outer loop after finding a match and make sure the np under each
tpg is unique.

Link: https://lore.kernel.org/r/20220111054742.19582-1-mingzhe.zou@easystack.cn
Signed-off-by: ZouMingzhe <mingzhe.zou@easystack.cn>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/target/iscsi/iscsi_target_tpg.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/target/iscsi/iscsi_target_tpg.c b/drivers/target/iscsi/iscsi_target_tpg.c
index 8075f60fd02c3..2d5cf1714ae05 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -443,6 +443,9 @@ static bool iscsit_tpg_check_network_portal(
 				break;
 		}
 		spin_unlock(&tpg->tpg_np_lock);
+
+		if (match)
+			break;
 	}
 	spin_unlock(&tiqn->tiqn_tpg_lock);
 
-- 
2.34.1

