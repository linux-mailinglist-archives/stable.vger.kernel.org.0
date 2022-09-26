Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B6E5EA135
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236557AbiIZKqq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236839AbiIZKos (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:44:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A0B5564D8;
        Mon, 26 Sep 2022 03:25:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 235EA60B9A;
        Mon, 26 Sep 2022 10:25:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 356A2C43140;
        Mon, 26 Sep 2022 10:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187943;
        bh=wYMWX1RdKzeoF4adCEB63kIZCJOyfUXgVp3rUBJ24FE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCYqNtnDOLuGH69uCMy8cMALO7FJApT4iWcZx2p8OaFAcEK+B7jwA7WLl1mS3ROR/
         NzRggAjoKRfRX1YlhghHzR8BohQ0Pi0lTCmP7x09uL5MWd6tQ5Ke6K38mjuEkBjxhX
         d4rNhKfMKRgmrq0qK6FfLXFcPZvy2eSchCbzFTQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Ryzhov <iryzhov@nfware.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/120] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
Date:   Mon, 26 Sep 2022 12:11:42 +0200
Message-Id: <20220926100753.514780869@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100750.519221159@linuxfoundation.org>
References: <20220926100750.519221159@linuxfoundation.org>
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

From: Igor Ryzhov <iryzhov@nfware.com>

[ Upstream commit 39aebedeaaa95757f5c1f2ddb5f43fdddbf478ca ]

ct_sip_next_header and ct_sip_get_header return an absolute
value of matchoff, not a shift from current dataoff.
So dataoff should be assigned matchoff, not incremented by it.

This issue can be seen in the scenario when there are multiple
Contact headers and the first one is using a hostname and other headers
use IP addresses. In this case, ct_sip_walk_headers will work as follows:

The first ct_sip_get_header call to will find the first Contact header
but will return -1 as the header uses a hostname. But matchoff will
be changed to the offset of this header. After that, dataoff should be
set to matchoff, so that the next ct_sip_get_header call find the next
Contact header. But instead of assigning dataoff to matchoff, it is
incremented by it, which is not correct, as matchoff is an absolute
value of the offset. So on the next call to the ct_sip_get_header,
dataoff will be incorrect, and the next Contact header may not be
found at all.

Fixes: 05e3ced297fe ("[NETFILTER]: nf_conntrack_sip: introduce SIP-URI parsing helper")
Signed-off-by: Igor Ryzhov <iryzhov@nfware.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_sip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_sip.c b/net/netfilter/nf_conntrack_sip.c
index b83dc9bf0a5d..78fd9122b70c 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -477,7 +477,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 				return ret;
 			if (ret == 0)
 				break;
-			dataoff += *matchoff;
+			dataoff = *matchoff;
 		}
 		*in_header = 0;
 	}
@@ -489,7 +489,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 			break;
 		if (ret == 0)
 			return ret;
-		dataoff += *matchoff;
+		dataoff = *matchoff;
 	}
 
 	if (in_header)
-- 
2.35.1



