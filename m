Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7D68604361
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 13:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiJSLgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 07:36:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231510AbiJSLfx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 07:35:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F439DF9C;
        Wed, 19 Oct 2022 04:13:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54974B82429;
        Wed, 19 Oct 2022 08:56:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0035C433C1;
        Wed, 19 Oct 2022 08:56:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169816;
        bh=OIyPrmQIsCOKB3WtDB3t9YMhRPWseYg73YUNm3OcaiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1/bnvQQ1JTeuq02twOXIb6iiWRJFKeB2bYfLpoLzxxsi0u2DGyCY1H1yN+JJGdu1x
         KTjk7dVBftJHpIf8c2J/v/vmds6PDQBMgFkUkdpKB/SvXw4PsFfoVo7KA+NKmUc47l
         ignQnY4iaixRzhfZt6YUHe8qRBDEOZlIjMWLrIKw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 420/862] soc: qcom: smem_state: Add refcounting for the state->of_node
Date:   Wed, 19 Oct 2022 10:28:27 +0200
Message-Id: <20221019083308.525235431@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 90681f53b9381c23ff7762a3b13826d620c272de ]

In qcom_smem_state_register() and qcom_smem_state_release(), we
should better use of_node_get() and of_node_put() for the reference
creation and destruction of 'device_node'.

Fixes: 9460ae2ff308 ("soc: qcom: Introduce common SMEM state machine code")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220721135217.1301039-2-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/qcom/smem_state.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem_state.c b/drivers/soc/qcom/smem_state.c
index 31faf4aa868e..e848cc9a3cf8 100644
--- a/drivers/soc/qcom/smem_state.c
+++ b/drivers/soc/qcom/smem_state.c
@@ -136,6 +136,7 @@ static void qcom_smem_state_release(struct kref *ref)
 	struct qcom_smem_state *state = container_of(ref, struct qcom_smem_state, refcount);
 
 	list_del(&state->list);
+	of_node_put(state->of_node);
 	kfree(state);
 }
 
@@ -205,7 +206,7 @@ struct qcom_smem_state *qcom_smem_state_register(struct device_node *of_node,
 
 	kref_init(&state->refcount);
 
-	state->of_node = of_node;
+	state->of_node = of_node_get(of_node);
 	state->ops = *ops;
 	state->priv = priv;
 
-- 
2.35.1



