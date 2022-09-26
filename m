Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF4C45EA471
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238371AbiIZLqH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:46:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238921AbiIZLpI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:45:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3D7773939;
        Mon, 26 Sep 2022 03:47:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F368460C13;
        Mon, 26 Sep 2022 10:31:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B3CEC433D6;
        Mon, 26 Sep 2022 10:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188307;
        bh=HopNTFdcmTqxm/bXN7v1c7b6TVs8bWw71xRLQwPXREQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ucWcPlSSvsXamq2BCgcrYmwHEIhXNkn+ad9V2XJWQ3Ex44Ax/3FwkZIHBUDOUAe/Y
         E7ihju4AHSOsT/v8yr6IPRUdME8RtCJHFFC/Eqow28dyLSAMGpn5P5aMu6XOKFCGpl
         6U376K0GCtYDSLhAPPKhiog1x/+MmzOoYqjXky+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+a24c5252f3e3ab733464@syzkaller.appspotmail.com
Subject: [PATCH 5.10 107/141] netfilter: ebtables: fix memory leak when blob is malformed
Date:   Mon, 26 Sep 2022 12:12:13 +0200
Message-Id: <20220926100758.314011924@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100754.639112000@linuxfoundation.org>
References: <20220926100754.639112000@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 62ce44c4fff947eebdf10bb582267e686e6835c9 ]

The bug fix was incomplete, it "replaced" crash with a memory leak.
The old code had an assignment to "ret" embedded into the conditional,
restore this.

Fixes: 7997eff82828 ("netfilter: ebtables: reject blobs that don't provide all entry points")
Reported-and-tested-by: syzbot+a24c5252f3e3ab733464@syzkaller.appspotmail.com
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/netfilter/ebtables.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 310740cc684a..06b80b584381 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -999,8 +999,10 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_iterate;
 	}
 
-	if (repl->valid_hooks != t->valid_hooks)
+	if (repl->valid_hooks != t->valid_hooks) {
+		ret = -EINVAL;
 		goto free_unlock;
+	}
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
 		ret = -EINVAL;
-- 
2.35.1



