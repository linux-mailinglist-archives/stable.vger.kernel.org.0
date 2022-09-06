Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 073CA5AED2B
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238987AbiIFOFP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:05:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241103AbiIFOCj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:02:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6879FED;
        Tue,  6 Sep 2022 06:44:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E0D9F61558;
        Tue,  6 Sep 2022 13:44:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED1C8C433D7;
        Tue,  6 Sep 2022 13:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662471870;
        bh=/kphMfvmy1N44Mxd+GftXLtvXOVvSnNM2bEouU3MPoE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xaAoTn7PO2+E7UPO++SXjkfWRKELRLE8twAjEvSfi4p2O9ZOlFqQfrLBxbvY8848O
         4crwQb4qs+kD3dXktcYVjDmCrDAw8/v655w2uLRJ7uStZPPVxChxcE1PHRS1grYGx1
         IPxzHQOSS0V8Irm5q834CmWVDT+u5r8hig5bHKEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tianyu Yuan <tianyu.yuan@corigine.com>,
        Baowen Zheng <baowen.zheng@corigine.com>,
        Louis Peens <louis.peens@corigine.com>,
        Simon Horman <simon.horman@corigine.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 036/155] nfp: flower: fix ingress police using matchall filter
Date:   Tue,  6 Sep 2022 15:29:44 +0200
Message-Id: <20220906132830.951055764@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Tianyu Yuan <tianyu.yuan@corigine.com>

[ Upstream commit ebe5555c2f34505cdb1ae5c3de8b24e33740b3e0 ]

Referenced commit introduced nfp_policer_validate in the progress
installing rate limiter. This validate check the action id and will
reject police with CONTINUE, which is required to support ingress
police offload.

Fix this issue by allowing FLOW_ACTION_CONTINUE as notexceed action
id in nfp_policer_validate

Fixes: d97b4b105ce7 ("flow_offload: reject offload for all drivers with invalid police parameters")
Signed-off-by: Tianyu Yuan <tianyu.yuan@corigine.com>
Reviewed-by: Baowen Zheng <baowen.zheng@corigine.com>
Reviewed-by: Louis Peens <louis.peens@corigine.com>
Signed-off-by: Simon Horman <simon.horman@corigine.com>
Link: https://lore.kernel.org/r/20220825080845.507534-1-simon.horman@corigine.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/netronome/nfp/flower/qos_conf.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
index 3206ba83b1aaa..de2ef5bf8c694 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/qos_conf.c
@@ -127,10 +127,11 @@ static int nfp_policer_validate(const struct flow_action *action,
 		return -EOPNOTSUPP;
 	}
 
-	if (act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
+	if (act->police.notexceed.act_id != FLOW_ACTION_CONTINUE &&
+	    act->police.notexceed.act_id != FLOW_ACTION_PIPE &&
 	    act->police.notexceed.act_id != FLOW_ACTION_ACCEPT) {
 		NL_SET_ERR_MSG_MOD(extack,
-				   "Offload not supported when conform action is not pipe or ok");
+				   "Offload not supported when conform action is not continue, pipe or ok");
 		return -EOPNOTSUPP;
 	}
 
-- 
2.35.1



