Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C72A959D73B
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236827AbiHWJmk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:42:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352563AbiHWJld (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:41:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F1D979625;
        Tue, 23 Aug 2022 01:41:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19F6061446;
        Tue, 23 Aug 2022 08:41:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E77C433C1;
        Tue, 23 Aug 2022 08:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244112;
        bh=20lKauL1YVUqyPxh4iNRKgHY+P1m62xaHe6u7/78kJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YAHmlnZ48hQ8iS2n7fWa5pZfT5k6k+a5m5Dk1KB+yCycCcy89FsBQf7tLXCi/10nh
         7+aiW2cIye25f8mI/tRrBdnFB6KkYftYTbqXemwtN24m8fnuX6+ivkLVE5wyKGti7W
         sCuWWt9+88U7XMsxcDX4hIbmP0d+5NA/lqPfys9k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.15 038/244] NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly
Date:   Tue, 23 Aug 2022 10:23:17 +0200
Message-Id: <20220823080100.329675799@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080059.091088642@linuxfoundation.org>
References: <20220823080059.091088642@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 7ccafd4b2b9f34e6d8185f796f151c47424e273e upstream.

Don't assume that the NFS4ERR_DELAY means that the server is processing
this slot id.

Fixes: 3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    1 -
 1 file changed, 1 deletion(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -856,7 +856,6 @@ static int nfs41_sequence_process(struct
 			__func__,
 			slot->slot_nr,
 			slot->seq_nr);
-		nfs4_slot_sequence_acked(slot, slot->seq_nr);
 		goto out_retry;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
 	case -NFS4ERR_SEQ_FALSE_RETRY:


