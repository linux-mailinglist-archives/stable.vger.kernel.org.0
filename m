Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0E554922C
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383763AbiFMO1V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:27:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384127AbiFMOYx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:24:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EEC54832A;
        Mon, 13 Jun 2022 04:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51826B80EB2;
        Mon, 13 Jun 2022 11:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8AAC36B0A;
        Mon, 13 Jun 2022 11:46:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655120802;
        bh=bFOZl1c9xmgdlvh+sQk2E6uWOw4KyEixfTX6tBQkcWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p0tAjvIeBsG8onGNIii/4KE4cKc8wYPjSvBgTuxstBv6akP5bvB0y/rIo0yHjjUSg
         INcHC6IEnS9KEZMnQhojVmoJOGI6T5cGRlD5kKPAIfxLhB3MbQjrGsXECEkwL40Nfy
         VaKnZSc4btK4cAR+GxL5vKFVkenGCDUA/cQEr8v0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 162/298] SUNRPC: Trap RDMA segment overflows
Date:   Mon, 13 Jun 2022 12:10:56 +0200
Message-Id: <20220613094929.847724426@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
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
index 5f0155fdefc7..11cf7c646644 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
@@ -478,10 +478,10 @@ svc_rdma_build_writes(struct svc_rdma_write_info *info,
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



