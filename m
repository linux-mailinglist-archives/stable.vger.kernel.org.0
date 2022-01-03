Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 741C648321F
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 15:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbiACOZV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 09:25:21 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:46928 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232569AbiACOY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 09:24:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 16FB9CE1105;
        Mon,  3 Jan 2022 14:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC76C36AEB;
        Mon,  3 Jan 2022 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641219894;
        bh=U4qUf864Xt45TsipElrNiBNVlfjKWOwAXE5fuZZX5uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ND4UsWq0e1Emmp6/9HoW79nL86TMNGcfhYiWcrvhFloSvFGchLcIUC2BDIKSg++G5
         dVQ4JuoGrsmVZIWAqSsIptvGIBAEVs4EALQa//QmnACexbIy+MfxIhcMxaHwELhRli
         a+uUtJ7PxIBxaz5bvxhv2E0xNDRz4s6zsFdDqOZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coco Li <lixiaoyan@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/27] selftests: Calculate udpgso segment count without header adjustment
Date:   Mon,  3 Jan 2022 15:23:50 +0100
Message-Id: <20220103142052.522014215@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220103142052.162223000@linuxfoundation.org>
References: <20220103142052.162223000@linuxfoundation.org>
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
index 270c17ab071e4..23177b6436067 100644
--- a/tools/testing/selftests/net/udpgso.c
+++ b/tools/testing/selftests/net/udpgso.c
@@ -157,13 +157,13 @@ struct testcase testcases_v4[] = {
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
@@ -260,13 +260,13 @@ struct testcase testcases_v6[] = {
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



