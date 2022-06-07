Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8A540B96
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242314AbiFGS3r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352512AbiFGS0Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:26:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305CA16A525;
        Tue,  7 Jun 2022 10:54:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A099B8236A;
        Tue,  7 Jun 2022 17:54:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D51CAC3411C;
        Tue,  7 Jun 2022 17:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624490;
        bh=j4qLntO3VaOtB7btRAveV4YpRZHf6JXJpBSgnbjuGuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wzgJ7sEcKgWRm6RaTdm0KfwHwKG2JfRf70Quk2Ql6Inowli180+9lHhfZyyFCJD/n
         GQ6tGCSoPGAnjPSNJKU1denMWhTyQosUWWdr990UFFAPv2F4RseOnP4mjbAYLEEFAA
         nIVyB+oksgPyz61IqrTzm8KeGgcC46z7djilwKgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 344/667] regulator: scmi: Fix refcount leak in scmi_regulator_probe
Date:   Tue,  7 Jun 2022 19:00:09 +0200
Message-Id: <20220607164945.077569797@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
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

[ Upstream commit 68d6c8476fd4f448e70e0ab31ff972838ac41dae ]

of_find_node_by_name() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: 0fbeae70ee7c ("regulator: add SCMI driver")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Link: https://lore.kernel.org/r/20220516074433.32433-1-linmq006@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/scmi-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/scmi-regulator.c b/drivers/regulator/scmi-regulator.c
index 1f02f60ad136..41ae7ac27ff6 100644
--- a/drivers/regulator/scmi-regulator.c
+++ b/drivers/regulator/scmi-regulator.c
@@ -352,7 +352,7 @@ static int scmi_regulator_probe(struct scmi_device *sdev)
 			return ret;
 		}
 	}
-
+	of_node_put(np);
 	/*
 	 * Register a regulator for each valid regulator-DT-entry that we
 	 * can successfully reach via SCMI and has a valid associated voltage
-- 
2.35.1



