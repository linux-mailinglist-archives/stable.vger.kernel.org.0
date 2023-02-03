Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADF816894F2
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233095AbjBCKP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:15:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232209AbjBCKP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:15:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2BBE8E68D
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:15:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3C13561E92
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:15:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A5CBC433EF;
        Fri,  3 Feb 2023 10:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419326;
        bh=coGMrlm5fe48LP0mx3hQPmQs+TBFplvV12g0EHKn7TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vH3MTjQ3O1d1R36H3VZ6IDbuXq3ucp4lj+aRwJK6KSMT2DJBPYB0pbc00LpX2S8BH
         opSn8NKFc9SlvF1fvRsaywlQqpiE7mVv9btQJvzh/xlJwM8QxCFny8TjVrhbDvvCj0
         12IdkT+yBvfykYyE3d2iBy5aHXTgAINnHu3enA9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 05/62] IB/hfi1: Reject a zero-length user expected buffer
Date:   Fri,  3 Feb 2023 11:12:01 +0100
Message-Id: <20230203101013.207989807@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101012.959398849@linuxfoundation.org>
References: <20230203101012.959398849@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit 0a0a6e80472c98947d73c3d13bcd7d101895f55d ]

A zero length user buffer makes no sense and the code
does not handle it correctly.  Instead, reject a
zero length as invalid.

Fixes: 97736f36dbeb ("IB/hfi1: Validate page aligned for a given virtual addres")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328547120.1472310.6362802432127399257.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index c6d085e1c10d..056ffab86a06 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -323,6 +323,8 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 
 	if (!PAGE_ALIGNED(tinfo->vaddr))
 		return -EINVAL;
+	if (tinfo->length == 0)
+		return -EINVAL;
 
 	tidbuf = kzalloc(sizeof(*tidbuf), GFP_KERNEL);
 	if (!tidbuf)
-- 
2.39.0



