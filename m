Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCAA4F2B6B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbiDEJ3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245035AbiDEIxC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:53:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B949E4F;
        Tue,  5 Apr 2022 01:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5397B81BBF;
        Tue,  5 Apr 2022 08:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3213CC385A0;
        Tue,  5 Apr 2022 08:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148620;
        bh=Sj/DwQPdk+OkqD45CWF3GBdQWWnxYbtVOIv0SUNhoOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qINKVppcfjt4DMfBe2kVW/jkbnuVn4lZIrFZ7GodLed0/YlPCrGgkk0HLMd+UdDh4
         /iaODM7ij8xWWbNMo9aA/BQk3p0m8vdBGHFxGOqzYmCaWIZkj1U9CtHw0Ph6uS8OCo
         mUogJzgCgLkuYNTLtHhVqQluW8XNp26SJEPHjfzM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0420/1017] selftests, xsk: Fix rx_full stats test
Date:   Tue,  5 Apr 2022 09:22:13 +0200
Message-Id: <20220405070406.756369419@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

[ Upstream commit b4ec6a19231224f6b08dc54ea07da4c4090e8ee3 ]

Fix the rx_full stats test so that it correctly reports pass even when
the fill ring is not full of buffers.

Fixes: 872a1184dbf2 ("selftests: xsk: Put the same buffer only once in the fill ring")
Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/bpf/20220121123508.12759-1-magnus.karlsson@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 621342ec30c4..37d4873d9a2e 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -902,7 +902,10 @@ static bool rx_stats_are_valid(struct ifobject *ifobject)
 			return true;
 		case STAT_TEST_RX_FULL:
 			xsk_stat = stats.rx_ring_full;
-			expected_stat -= RX_FULL_RXQSIZE;
+			if (ifobject->umem->num_frames < XSK_RING_PROD__DEFAULT_NUM_DESCS)
+				expected_stat = ifobject->umem->num_frames - RX_FULL_RXQSIZE;
+			else
+				expected_stat = XSK_RING_PROD__DEFAULT_NUM_DESCS - RX_FULL_RXQSIZE;
 			break;
 		case STAT_TEST_RX_FILL_EMPTY:
 			xsk_stat = stats.rx_fill_ring_empty_descs;
-- 
2.34.1



