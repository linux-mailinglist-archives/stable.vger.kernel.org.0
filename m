Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4477541233
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:44:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357187AbiFGToh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:44:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357962AbiFGTmg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:42:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E904B240;
        Tue,  7 Jun 2022 11:17:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8D3AB8237D;
        Tue,  7 Jun 2022 18:17:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 180F5C34115;
        Tue,  7 Jun 2022 18:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654625846;
        bh=fSFadVBx+9nhp9Vuit9XM8ZMa1aU8wtySBYdLPNXlHw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJ9E9ZVnCeBSIb6hCdExtOtVS5iC5/yDZfGtbfPvK4TKB2mCuAcLUBa1c84hr9+Zz
         uD545kmlws2NOt0enIwdPGhpjhB1KTeqCVdV5FTUcnvTFKLs+7KE9SV+EfhFDOEeb3
         N3C+UzT5LBV2mxsJ2wiyMSJqPdGvmS4E4RoT3brg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 125/772] net: remove two BUG() from skb_checksum_help()
Date:   Tue,  7 Jun 2022 18:55:17 +0200
Message-Id: <20220607164952.729252642@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d7ea0d9df2a6265b2b180d17ebc64b38105968fc ]

I have a syzbot report that managed to get a crash in skb_checksum_help()

If syzbot can trigger these BUG(), it makes sense to replace
them with more friendly WARN_ON_ONCE() since skb_checksum_help()
can instead return an error code.

Note that syzbot will still crash there, until real bug is fixed.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 5f1ac4812277..f2ce184d7223 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -3156,11 +3156,15 @@ int skb_checksum_help(struct sk_buff *skb)
 	}
 
 	offset = skb_checksum_start_offset(skb);
-	BUG_ON(offset >= skb_headlen(skb));
+	ret = -EINVAL;
+	if (WARN_ON_ONCE(offset >= skb_headlen(skb)))
+		goto out;
+
 	csum = skb_checksum(skb, offset, skb->len - offset, 0);
 
 	offset += skb->csum_offset;
-	BUG_ON(offset + sizeof(__sum16) > skb_headlen(skb));
+	if (WARN_ON_ONCE(offset + sizeof(__sum16) > skb_headlen(skb)))
+		goto out;
 
 	ret = skb_ensure_writable(skb, offset + sizeof(__sum16));
 	if (ret)
-- 
2.35.1



