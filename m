Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5082B65EC0D
	for <lists+stable@lfdr.de>; Thu,  5 Jan 2023 14:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234037AbjAENFq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234087AbjAENF2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 08:05:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A662C5AC79
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 05:05:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57A0FB81AD2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 13:05:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE7DFC433D2;
        Thu,  5 Jan 2023 13:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672923923;
        bh=wu1voDtzG5hmMJa1qNHG4LgUTDAJlN5jn2B7XmnY0es=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hMHxO84m5fv/POt+fj90sxKvMjlJ8L3RWLxrvVD16KDP/YOGcudiXSNcKaeO2q/N5
         OZbTcmq1s+HSKFrUpTziGdQOPip67OZALsuNRzWxBTEF0VbX13YmEtBd3ASlfl25mM
         xxxwhDogcXwdqKp2ZV0i84VmSMsQ6fCHepW0wuxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 177/251] myri10ge: Fix an error handling path in myri10ge_probe()
Date:   Thu,  5 Jan 2023 13:55:14 +0100
Message-Id: <20230105125342.899077329@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit d83b950d44d2982c0e62e3d81b0f35ab09431008 ]

Some memory allocated in myri10ge_probe_slices() is not released in the
error handling path of myri10ge_probe().

Add the corresponding kfree(), as already done in the remove function.

Fixes: 0dcffac1a329 ("myri10ge: add multislices support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 5eeba263b5f8..d50cee7aae4d 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -4152,6 +4152,7 @@ static int myri10ge_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 	myri10ge_free_slices(mgp);
 
 abort_with_firmware:
+	kfree(mgp->msix_vectors);
 	myri10ge_dummy_rdma(mgp, 0);
 
 abort_with_ioremap:
-- 
2.35.1



