Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743E15830EF
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242760AbiG0Row (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242793AbiG0Rna (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:43:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A15C18AB0F;
        Wed, 27 Jul 2022 09:52:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4D54B8200D;
        Wed, 27 Jul 2022 16:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02C8FC433C1;
        Wed, 27 Jul 2022 16:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940753;
        bh=zpgNjnfSpwP+s2pDPQsvK7PQ9b8gheUQM579VcK0bLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zLAYF6OWJMypTYaDSs4PCBwtLxAInSVVoYRWOUN04vcMLWN/d1kMgSRxyZ0tfUMEB
         GbR2QsMLogPLLj1hQepf3Nb9RsiUpA1z9qCnANSYf7/EsM6Wy34jZxLitaYPwFX1Ye
         m2l89vfR0jE3NJlchl/seEPWCrZZ9pSw/0i8cXWg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 104/158] amt: add missing regeneration nonce logic in request logic
Date:   Wed, 27 Jul 2022 18:12:48 +0200
Message-Id: <20220727161025.629946179@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 627f16931bf3cb20d50274d9341380ac2c3035fd ]

When AMT gateway starts sending a new request message, it should
regenerate the nonce variable.

Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/amt.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/amt.c b/drivers/net/amt.c
index ff859d4a4b50..2fe56640e493 100644
--- a/drivers/net/amt.c
+++ b/drivers/net/amt.c
@@ -963,9 +963,13 @@ static void amt_event_send_request(struct amt_dev *amt)
 		amt->remote_ip = 0;
 		amt_update_gw_status(amt, AMT_STATUS_INIT, false);
 		amt->req_cnt = 0;
+		amt->nonce = 0;
 		goto out;
 	}
 
+	if (!amt->req_cnt)
+		get_random_bytes(&amt->nonce, sizeof(__be32));
+
 	amt_send_request(amt, false);
 	amt_send_request(amt, true);
 	amt_update_gw_status(amt, AMT_STATUS_SENT_REQUEST, true);
-- 
2.35.1



