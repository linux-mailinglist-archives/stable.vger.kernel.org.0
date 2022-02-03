Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E64614A8F03
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230474AbiBCUmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233677AbiBCUjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:39:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A82CC0612FE;
        Thu,  3 Feb 2022 12:36:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CD69E608C4;
        Thu,  3 Feb 2022 20:36:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF20C340E8;
        Thu,  3 Feb 2022 20:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920588;
        bh=b/GaCLAENV1tdYTHB6/+xYH6uKWcAyiEtzI6xWLYlDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r+XbpE+pLBi1cmaF5c2craBNoXYzzp6pn6Qy3M8S4j8bsc/Qq6PfOv6BzaWTxPN+o
         GhMZze+X0P+4IaBSpuah0dskMdz49eyhd+AYpwbXIvYtPWaWomxLUrd92ytjFq1YEo
         OaJFquP+hqoN5DJD1+tbhmTDPVyXHwOIfS8XSSz77FApu7tR5NHAzwmICR8M7y0iKc
         OyJwia1fUorOLdM60eWah8KQVrurFSlHEOV7gR6kd3S9l1F/WN3G93dApCX1YO0PHf
         zjA2Unel6b+RZ8BkKnlA5OarS1prwPx93NNMjQyhUpI26GQAVPSh2ghzf0S3eEdh/Z
         YA2UU5itXy+Ow==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     ZouMingzhe <mingzhe.zou@easystack.cn>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 08/10] scsi: target: iscsi: Make sure the np under each tpg is unique
Date:   Thu,  3 Feb 2022 15:36:11 -0500
Message-Id: <20220203203613.4165-8-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203203613.4165-1-sashal@kernel.org>
References: <20220203203613.4165-1-sashal@kernel.org>
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
index 101d62105c932..f3671ffdf1495 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -451,6 +451,9 @@ static bool iscsit_tpg_check_network_portal(
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

