Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA984B47A7
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243861AbiBNJfM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:35:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:52638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244060AbiBNJes (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:34:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D72869286;
        Mon, 14 Feb 2022 01:32:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B377B60FA2;
        Mon, 14 Feb 2022 09:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAF6C340F2;
        Mon, 14 Feb 2022 09:32:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831150;
        bh=k8li0rbyuLmDg+tAiLENpQPLXkvUb6PfoEEdtHStkQ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMFfK8HilijNOqo0wKT2xsp1DnyqpXt4RmEC9XhpbEK10INGI/GtP3BvLFsm6Wh8v
         gU9da+G+NdJaL6jIHsiN/m+USGreoO4b7dgxPFpKIR4nF/w2bV00fH3AH0iajRCB65
         Eifx/HZ94C1X9AsIMCOT+4Rzis+I0v55ySqKa6ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Victor Nogueira <victor@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 14/49] net: sched: Clarify error message when qdisc kind is unknown
Date:   Mon, 14 Feb 2022 10:25:40 +0100
Message-Id: <20220214092448.769554509@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092448.285381753@linuxfoundation.org>
References: <20220214092448.285381753@linuxfoundation.org>
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

From: Victor Nogueira <victor@mojatatu.com>

[ Upstream commit 973bf8fdd12f0e70ea351c018e68edd377a836d1 ]

When adding a tc rule with a qdisc kind that is not supported or not
compiled into the kernel, the kernel emits the following error: "Error:
Specified qdisc not found.". Found via tdc testing when ETS qdisc was not
compiled in and it was not obvious right away what the message meant
without looking at the kernel code.

Change the error message to be more explicit and say the qdisc kind is
unknown.

Signed-off-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/sch_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/sch_api.c b/net/sched/sch_api.c
index af035431bec60..424e70907b967 100644
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1131,7 +1131,7 @@ static struct Qdisc *qdisc_create(struct net_device *dev,
 
 	err = -ENOENT;
 	if (!ops) {
-		NL_SET_ERR_MSG(extack, "Specified qdisc not found");
+		NL_SET_ERR_MSG(extack, "Specified qdisc kind is unknown");
 		goto err_out;
 	}
 
-- 
2.34.1



