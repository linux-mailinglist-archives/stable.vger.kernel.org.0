Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30CC5540E5C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353531AbiFGSyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354371AbiFGSq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:46:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F98C24F2F;
        Tue,  7 Jun 2022 11:00:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E5605617B4;
        Tue,  7 Jun 2022 18:00:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF57FC385A5;
        Tue,  7 Jun 2022 18:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624856;
        bh=50r0S2yycIIRdpqgRSzhdSQvB3+XeKxyRgl5F6GPwts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eCW3TgiaiPrUF7wfKeiRfaTloG42k5HshlvWhadL/iSeHh+vAaSdRHlPT62U9R0ne
         nQrJYdIqCCYE6VJqJ2JJ47BJqQMNjV1ks2LPbxKAL2vpzRl2CHjqpcf8UTo8FaBIn0
         EaFyWe5BOitaRdTaiHvNHh68S1f7wAXDWW+S6Lvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 476/667] OPP: call of_node_put() on error path in _bandwidth_supported()
Date:   Tue,  7 Jun 2022 19:02:21 +0200
Message-Id: <20220607164948.978346863@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 907ed123b9d096c73e9361f6cd4097f0691497f2 ]

This code does not call of_node_put(opp_np) if of_get_next_available_child()
returns NULL.  But it should.

Fixes: 45679f9b508f ("opp: Don't parse icc paths unnecessarily")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/opp/of.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/opp/of.c b/drivers/opp/of.c
index c32ae7497392..3028353afece 100644
--- a/drivers/opp/of.c
+++ b/drivers/opp/of.c
@@ -437,11 +437,11 @@ static int _bandwidth_supported(struct device *dev, struct opp_table *opp_table)
 
 	/* Checking only first OPP is sufficient */
 	np = of_get_next_available_child(opp_np, NULL);
+	of_node_put(opp_np);
 	if (!np) {
 		dev_err(dev, "OPP table empty\n");
 		return -EINVAL;
 	}
-	of_node_put(opp_np);
 
 	prop = of_find_property(np, "opp-peak-kBps", NULL);
 	of_node_put(np);
-- 
2.35.1



