Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBB285496B9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:35:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359336AbiFMN0O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376296AbiFMNYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:24:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FAC06C0EF;
        Mon, 13 Jun 2022 04:24:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A3F12B80EA7;
        Mon, 13 Jun 2022 11:24:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C955C3411C;
        Mon, 13 Jun 2022 11:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119457;
        bh=fHAlRLI+3/lCqgz04xoSRTbSR4DvNtUqD7RhPAfiWzY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M53QXyH8Iq8UPB/qB0KlOeEMZYilbz9LegKIoNWm7Se4Ol/S3vgn7k1OLuESAyESy
         p9LG09qmG5JmuOAi8Ky+K/cRuU8abCJbcYq3T8N9P+wYfvaPixBNxv3mtLol9q/s9X
         WucX//sU0PSSNrJNA4vdF5FN0D8PHYePM2e+C+BY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 004/339] soundwire: qcom: fix an error message in swrm_wait_for_frame_gen_enabled()
Date:   Mon, 13 Jun 2022 12:07:09 +0200
Message-Id: <20220613094926.638046148@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit d146de3430d2b21054f6dc8a890f84062515f4d2 ]

The logical AND && is supposed to be bitwise AND & so it will sometimes
print "connected" instead of "disconnected".

Fixes: 74e79da9fd46 ("soundwire: qcom: add runtime pm support")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Link: https://lore.kernel.org/r/20220307125814.GD16710@kili
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/qcom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soundwire/qcom.c b/drivers/soundwire/qcom.c
index da1ad7ebb1aa..dd9f67f895b2 100644
--- a/drivers/soundwire/qcom.c
+++ b/drivers/soundwire/qcom.c
@@ -1452,7 +1452,7 @@ static bool swrm_wait_for_frame_gen_enabled(struct qcom_swrm_ctrl *swrm)
 	} while (retry--);
 
 	dev_err(swrm->dev, "%s: link status not %s\n", __func__,
-		comp_sts && SWRM_FRM_GEN_ENABLED ? "connected" : "disconnected");
+		comp_sts & SWRM_FRM_GEN_ENABLED ? "connected" : "disconnected");
 
 	return false;
 }
-- 
2.35.1



