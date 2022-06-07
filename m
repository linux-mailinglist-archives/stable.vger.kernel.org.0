Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18A84541406
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359630AbiFGUMb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358610AbiFGUJB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:09:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9ECCED8D5;
        Tue,  7 Jun 2022 11:26:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 767F0B822C0;
        Tue,  7 Jun 2022 18:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E41B9C385A2;
        Tue,  7 Jun 2022 18:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626385;
        bh=Wv8LqfiVahQyHFgoG9Vecq8fraqBk8Ym4cTjhUqnw5A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mxiIfdkEw2+YSh/S21jkm4UKZdffpKcasgiDxSYOFb2+znpXE17J4Q/Ty0gcmBChp
         OWMfdXkXJIXVNL09iiiJnBm4WTpKD0VCOhCSJpEPQox8WktGJtEJArr7Dncrn/pM+t
         DIeEThofMPs6lzbfTZGNdx6WNyCaJEvD6CWd/evw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 359/772] regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt
Date:   Tue,  7 Jun 2022 18:59:11 +0200
Message-Id: <20220607164959.596112475@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit afaa7b933ef00a2d3262f4d1252087613fb5c06d ]

of_node_get() returns a node with refcount incremented.
Calling of_node_put() to drop the reference when not needed anymore.

Fixes: 3784b6d64dc5 ("regulator: pfuze100: add pfuze100 regulator driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220511113506.45185-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/pfuze100-regulator.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/regulator/pfuze100-regulator.c b/drivers/regulator/pfuze100-regulator.c
index d60d7d1b7fa2..aa55cfca9e40 100644
--- a/drivers/regulator/pfuze100-regulator.c
+++ b/drivers/regulator/pfuze100-regulator.c
@@ -521,6 +521,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	parent = of_get_child_by_name(np, "regulators");
 	if (!parent) {
 		dev_err(dev, "regulators node not found\n");
+		of_node_put(np);
 		return -EINVAL;
 	}
 
@@ -550,6 +551,7 @@ static int pfuze_parse_regulators_dt(struct pfuze_chip *chip)
 	}
 
 	of_node_put(parent);
+	of_node_put(np);
 	if (ret < 0) {
 		dev_err(dev, "Error parsing regulator init data: %d\n",
 			ret);
-- 
2.35.1



