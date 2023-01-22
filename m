Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5458F676E11
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:06:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjAVPGm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:06:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjAVPGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:06:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189991E1F0
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:06:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4CB1B80B14
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:06:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 176C8C433D2;
        Sun, 22 Jan 2023 15:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674399998;
        bh=kJbh4IWqiu7YRxGLfwtVGh5/Ybzeqpq8bySyWOs9qV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MaWwWSAfMRPd79eCyWzJQ1XY0mWCuK+XI22dSSKjB71itcASYbxwynomFKjQPvdWx
         a+7LIpkYvRKrzsMTc4UPzJGf6MRsmpoBj2O0Sw+dUM+Q8ecdss5PnGis8H40YlulYk
         vDOeuL4lr1iq8oYQrJO5fWOJLa3kyWcM6Z8NTz/g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Jiri Slaby (SUSE)" <jirislaby@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 03/25] RDMA/srp: Move large values to a new enum for gcc13
Date:   Sun, 22 Jan 2023 16:04:03 +0100
Message-Id: <20230122150217.956473096@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150217.788215473@linuxfoundation.org>
References: <20230122150217.788215473@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Slaby (SUSE) <jirislaby@kernel.org>

[ Upstream commit 56c5dab20a6391604df9521f812c01d1e3fe1bd0 ]

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided these two:
  SRP_TAG_NO_REQ        = ~0U,
  SRP_TAG_TSK_MGMT	= 1U << 31
all other members are unsigned ints.

Esp. with SRP_MAX_SGE and SRP_TSK_MGMT_SQ_SIZE and their use in min(),
this results in the following warnings:
  include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast
  drivers/infiniband/ulp/srp/ib_srp.c:563:42: note: in expansion of macro 'min'

  include/linux/minmax.h:20:35: error: comparison of distinct pointer types lacks a cast
  drivers/infiniband/ulp/srp/ib_srp.c:2369:27: note: in expansion of macro 'min'

So move the large values away to a separate enum, so that they don't
affect other members.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Link: https://lore.kernel.org/r/20221212120411.13750-1-jirislaby@kernel.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srp/ib_srp.h | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.h b/drivers/infiniband/ulp/srp/ib_srp.h
index ab9077b81d5a..89b5133ceaa6 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.h
+++ b/drivers/infiniband/ulp/srp/ib_srp.h
@@ -62,12 +62,14 @@ enum {
 	SRP_DEFAULT_CMD_SQ_SIZE = SRP_DEFAULT_QUEUE_SIZE - SRP_RSP_SQ_SIZE -
 				  SRP_TSK_MGMT_SQ_SIZE,
 
-	SRP_TAG_NO_REQ		= ~0U,
-	SRP_TAG_TSK_MGMT	= 1U << 31,
-
 	SRP_MAX_PAGES_PER_MR	= 512,
 };
 
+enum {
+	SRP_TAG_NO_REQ		= ~0U,
+	SRP_TAG_TSK_MGMT	= BIT(31),
+};
+
 enum srp_target_state {
 	SRP_TARGET_SCANNING,
 	SRP_TARGET_LIVE,
-- 
2.35.1



