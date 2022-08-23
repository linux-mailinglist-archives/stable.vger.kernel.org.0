Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC3959DF6C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:35:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244475AbiHWMDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 08:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376295AbiHWMC7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 08:02:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1D4DC0B1;
        Tue, 23 Aug 2022 02:36:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCEB761467;
        Tue, 23 Aug 2022 09:36:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1944C433C1;
        Tue, 23 Aug 2022 09:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247395;
        bh=DAYJonRs7LjKvtgIVwiyR/rWsbgcVoRZpTz2zs8P7tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qTOu4ou2D2v7v8LSUW5haO8FI4/AfpDcKfPRL5Y/nNPXgQberqmiFgI1hhuc020Yc
         B255lxhGQtu5f/7ToI5nSLHWRa6ch1u7En+xLrMVUIkXHeHiZEhN7ckVkynLchv/Th
         +sHQk14ojB4WRgQeBhtc47SXZubs0VAPf6H4Leb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 022/158] NFSv4.1: Dont decrease the value of seq_nr_highest_sent
Date:   Tue, 23 Aug 2022 10:25:54 +0200
Message-Id: <20220823080046.977103783@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080046.056825146@linuxfoundation.org>
References: <20220823080046.056825146@linuxfoundation.org>
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

commit f07a5d2427fc113dc50c5c818eba8929bc27b8ca upstream.

When we're trying to figure out what the server may or may not have seen
in terms of request numbers, do not assume that requests with a larger
number were missed, just because we saw a reply to a request with a
smaller number.

Fixes: 3453d5708b33 ("NFSv4.1: Avoid false retries when RPC calls are interrupted")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/nfs4proc.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -790,10 +790,9 @@ static void nfs4_slot_sequence_record_se
 	if ((s32)(seqnr - slot->seq_nr_highest_sent) > 0)
 		slot->seq_nr_highest_sent = seqnr;
 }
-static void nfs4_slot_sequence_acked(struct nfs4_slot *slot,
-		u32 seqnr)
+static void nfs4_slot_sequence_acked(struct nfs4_slot *slot, u32 seqnr)
 {
-	slot->seq_nr_highest_sent = seqnr;
+	nfs4_slot_sequence_record_sent(slot, seqnr);
 	slot->seq_nr_last_acked = seqnr;
 }
 


