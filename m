Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0FE874B45B3
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242970AbiBNJ2T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:28:19 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbiBNJ2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D437860A9A;
        Mon, 14 Feb 2022 01:28:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7C28CB80DC4;
        Mon, 14 Feb 2022 09:28:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A03C340EF;
        Mon, 14 Feb 2022 09:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644830887;
        bh=M+7Y0vn+BxRton0UAEjJx00c6EcBPBpbms0IRen0pFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PmmI5aHngHgzKkPVgL8KMQ0VVrr0d4xdWSPtO9aByxmboOCjuXhiDNPGzO7XerUNU
         ixoVZqU42qQWy9GZRnSK9EVu7j4v+XiwQHrH4XdTKmlFbpXviVolQzMA3UKfFHZ0H/
         nNXC2voLr/lF1rfUSOTbIOm6AtBo1WLhWM9DORRQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, ZouMingzhe <mingzhe.zou@easystack.cn>,
        Mike Christie <michael.christie@oracle.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 12/34] scsi: target: iscsi: Make sure the np under each tpg is unique
Date:   Mon, 14 Feb 2022 10:25:38 +0100
Message-Id: <20220214092446.345752613@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092445.946718557@linuxfoundation.org>
References: <20220214092445.946718557@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 761b065a40bb3..b2a76ecb5789c 100644
--- a/drivers/target/iscsi/iscsi_target_tpg.c
+++ b/drivers/target/iscsi/iscsi_target_tpg.c
@@ -452,6 +452,9 @@ static bool iscsit_tpg_check_network_portal(
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



