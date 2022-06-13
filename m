Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7454E548DD9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359551AbiFMNNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358927AbiFMNIg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:08:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88751387BD;
        Mon, 13 Jun 2022 04:18:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D5C3B80E59;
        Mon, 13 Jun 2022 11:18:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67D6FC34114;
        Mon, 13 Jun 2022 11:18:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119135;
        bh=7QwqXo9WjHkvHUzsG/HwftUa0vGNKXOY1EDRXi2pBc4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HV5POb8lNcx4bvZXn85+4Hr3A46G1L0zCRH/Wa5O4H38FJZjt5LxnilUXn2a4AyZj
         +kHb3TMu2C21oU4SDDHc1AYPkMVuLhAgDbOAa7aDBsKTV76TleJN1Ti6Tf+8CpWi29
         kldxPw6SlPG4UjkDCbHyXGe3zMHkCIxOCN1oRW80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 136/247] SUNRPC: Trap RDMA segment overflows
Date:   Mon, 13 Jun 2022 12:10:38 +0200
Message-Id: <20220613094927.083029335@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094922.843438024@linuxfoundation.org>
References: <20220613094922.843438024@linuxfoundation.org>
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

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit f012e95b377c73c0283f009823c633104dedb337 ]

Prevent svc_rdma_build_writes() from walking off the end of a Write
chunk's segment array. Caught with KASAN.

The test that this fix replaces is invalid, and might have been left
over from an earlier prototype of the PCL work.

Fixes: 7a1cbfa18059 ("svcrdma: Use parsed chunk lists to construct RDMA Writes")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/xprtrdma/svc_rdma_rw.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c b/net/sunrpc/xprtrdma/svc_rdma_rw.c
index e27433f08ca7..50bf62f85166 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -456,10 +456,10 @@ svc_rdma_build_writes(struct svc_rdma_write_info *info,
 		unsigned int write_len;
 		u64 offset;
 
-		seg = &info->wi_chunk->ch_segments[info->wi_seg_no];
-		if (!seg)
+		if (info->wi_seg_no >= info->wi_chunk->ch_segcount)
 			goto out_overflow;
 
+		seg = &info->wi_chunk->ch_segments[info->wi_seg_no];
 		write_len = min(remaining, seg->rs_length - info->wi_seg_off);
 		if (!write_len)
 			goto out_overflow;
-- 
2.35.1



