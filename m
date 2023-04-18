Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 524F76E61DE
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:28:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbjDRM2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:28:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbjDRM2T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:28:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3784F9EEE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:27:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0ACEC63190
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:27:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EB14C433D2;
        Tue, 18 Apr 2023 12:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681820862;
        bh=gNijpVa9stuBi3k1FX5R8nNVbXTK4Nx9I3v+eEZ0G4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ra7y4Wuxvji5kLLgVr+UCHINtomq4BsB0Ch9/NMm2I3+2Y2Z3ZDvSDVeCA5yutrDW
         Xrtu0EofkxIwzqzfn/RQ8q2JpvbCRsf3D6vznFDGTJwxDMlkQtcsaicpul3JxqdDB2
         8GVz2C8wsao2ZXivJKhOCKe11BT+WT+4Co0r2qyw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xin Long <lucien.xin@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 39/57] sctp: fix a potential overflow in sctp_ifwdtsn_skip
Date:   Tue, 18 Apr 2023 14:21:39 +0200
Message-Id: <20230418120300.096512102@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 32832a2caf82663870126c5186cf8f86c8b2a649 ]

Currently, when traversing ifwdtsn skips with _sctp_walk_ifwdtsn, it only
checks the pos against the end of the chunk. However, the data left for
the last pos may be < sizeof(struct sctp_ifwdtsn_skip), and dereference
it as struct sctp_ifwdtsn_skip may cause coverflow.

This patch fixes it by checking the pos against "the end of the chunk -
sizeof(struct sctp_ifwdtsn_skip)" in sctp_ifwdtsn_skip, similar to
sctp_fwdtsn_skip.

Fixes: 0fc2ea922c8a ("sctp: implement validate_ftsn for sctp_stream_interleave")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Link: https://lore.kernel.org/r/2a71bffcd80b4f2c61fac6d344bb2f11c8fd74f7.1681155810.git.lucien.xin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sctp/stream_interleave.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/sctp/stream_interleave.c b/net/sctp/stream_interleave.c
index 0a78cdf864633..3290e6f5b6c6c 100644
--- a/net/sctp/stream_interleave.c
+++ b/net/sctp/stream_interleave.c
@@ -1151,7 +1151,8 @@ static void sctp_generate_iftsn(struct sctp_outq *q, __u32 ctsn)
 
 #define _sctp_walk_ifwdtsn(pos, chunk, end) \
 	for (pos = chunk->subh.ifwdtsn_hdr->skip; \
-	     (void *)pos < (void *)chunk->subh.ifwdtsn_hdr->skip + (end); pos++)
+	     (void *)pos <= (void *)chunk->subh.ifwdtsn_hdr->skip + (end) - \
+			    sizeof(struct sctp_ifwdtsn_skip); pos++)
 
 #define sctp_walk_ifwdtsn(pos, ch) \
 	_sctp_walk_ifwdtsn((pos), (ch), ntohs((ch)->chunk_hdr->length) - \
-- 
2.39.2



