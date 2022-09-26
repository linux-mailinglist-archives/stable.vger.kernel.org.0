Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE265E9FBD
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 12:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235514AbiIZK3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 06:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235560AbiIZK2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 06:28:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AA44DB71;
        Mon, 26 Sep 2022 03:18:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BFDD3B80936;
        Mon, 26 Sep 2022 10:18:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7045C433D6;
        Mon, 26 Sep 2022 10:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664187528;
        bh=5yVkGeIa9tVEy8jpr69BZmy26C/8lkf9me70+HR20uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObD+37BJFWKHV/6CpWjVhmT+P+UYDotgm0hVv/HQBrYK41t4CUJpPAnf5Qy4+WdIS
         /DEfBVbNEXgjvPhowEGxgikhCIz+SlsGAyakqZ+qBRYj4WwIgvbfMzm7lt57WkNE9e
         sN04xTHF5npxcldVaAw3/vQEIkbhN+NTyxY6MglA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Igor Ryzhov <iryzhov@nfware.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/58] netfilter: nf_conntrack_sip: fix ct_sip_walk_headers
Date:   Mon, 26 Sep 2022 12:11:55 +0200
Message-Id: <20220926100742.797555771@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100741.430882406@linuxfoundation.org>
References: <20220926100741.430882406@linuxfoundation.org>
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
index c8d2b6688a2a..046f118dea06 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -471,7 +471,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 				return ret;
 			if (ret == 0)
 				break;
-			dataoff += *matchoff;
+			dataoff = *matchoff;
 		}
 		*in_header = 0;
 	}
@@ -483,7 +483,7 @@ static int ct_sip_walk_headers(const struct nf_conn *ct, const char *dptr,
 			break;
 		if (ret == 0)
 			return ret;
-		dataoff += *matchoff;
+		dataoff = *matchoff;
 	}
 
 	if (in_header)
-- 
2.35.1



