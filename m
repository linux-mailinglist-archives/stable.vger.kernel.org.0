Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964E64832BE
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:31:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiACOak (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:30:40 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59926 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234262AbiACO2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:28:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5C8C3B80EFD;
        Mon,  3 Jan 2022 14:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A891C36AED;
        Mon,  3 Jan 2022 14:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641220114;
        bh=Ib8gO1VchfdE4ELJOYZMfVmbmbG1+Tm5qLKyL+hbCPs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wgDPZIm2Q7NRrAo1u/MrQ0q0Qy9NyfDq4L8hW0MHPQPvSNhL9f3c68rTtYkdRKUan
         9f67XLDOWR28UmWMX0S0cTEKsuj4OAjJ92jBoQ0nhlfAD6xIMJJ6EbQgLAwa78GFL7
         BkoVUpEBUxkOgsJSAjAp6y4bvGD3PUNOsVSwY378=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 15/48] selftests: Calculate udpgso segment count without header adjustment
Date:   Mon,  3 Jan 2022 15:23:52 +0100
Message-Id: <20220103142053.990809225@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142053.466768714@linuxfoundation.org>
References: <20220103142053.466768714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coco Li <lixiaoyan@google.com>

[ Upstream commit 5471d5226c3b39b3d2f7011c082d5715795bd65c ]

The below referenced commit correctly updated the computation of number
of segments (gso_size) by using only the gso payload size and
removing the header lengths.

With this change the regression test started failing. Update
the tests to match this new behavior.

Both IPv4 and IPv6 tests are updated, as a separate patch in this series
will update udp_v6_send_skb to match this change in udp_send_skb.

Fixes: 158390e45612 ("udp: using datalen to cap max gso segments")
Signed-off-by: Coco Li <lixiaoyan@google.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://lore.kernel.org/r/20211223222441.2975883-2-lixiaoyan@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/udpgso.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/net/udpgso.c b/tools/testing/selftests/net/udpgso.c
index c66da6ffd6d8d..7badaf215de28 100644
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -156,13 +156,13 @@ struct testcase testcases_v4[] = {
 	},
 	{
 		/* send max number of min sized segments */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V4,
+		.tlen = UDP_MAX_SEGMENTS,
 		.gso_len = 1,
-		.r_num_mss = UDP_MAX_SEGMENTS - CONST_HDRLEN_V4,
+		.r_num_mss = UDP_MAX_SEGMENTS,
 	},
 	{
 		/* send max number + 1 of min sized segments: fail */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V4 + 1,
+		.tlen = UDP_MAX_SEGMENTS + 1,
 		.gso_len = 1,
 		.tfail = true,
 	},
@@ -259,13 +259,13 @@ struct testcase testcases_v6[] = {
 	},
 	{
 		/* send max number of min sized segments */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V6,
+		.tlen = UDP_MAX_SEGMENTS,
 		.gso_len = 1,
-		.r_num_mss = UDP_MAX_SEGMENTS - CONST_HDRLEN_V6,
+		.r_num_mss = UDP_MAX_SEGMENTS,
 	},
 	{
 		/* send max number + 1 of min sized segments: fail */
-		.tlen = UDP_MAX_SEGMENTS - CONST_HDRLEN_V6 + 1,
+		.tlen = UDP_MAX_SEGMENTS + 1,
 		.gso_len = 1,
 		.tfail = true,
 	},
-- 
2.34.1



