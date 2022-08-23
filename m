Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63D1A59DCD5
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:25:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358658AbiHWLwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:52:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358546AbiHWLte (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:49:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 215E2D291A;
        Tue, 23 Aug 2022 02:30:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D426B81C8B;
        Tue, 23 Aug 2022 09:30:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBC85C433C1;
        Tue, 23 Aug 2022 09:30:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247049;
        bh=O1HOSy3XoltlXK/XqNgNBM5Ojwhn0levpE/iC5tAod4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cp/5nFq1b78qUXMaYHxssOuWvqxi4shgdRtWOKy53uQP+8aefJGL0KglMuxKoLKN8
         tvVzCcBWwo5qbfmoHpui1owwyAqpKgB2nGbS1uDc739NltiUFD/hSC0UwvDJHO5DJh
         UJZl19EOFvcEQalJQ7ih5+q/Zs2rdfz4zt4vIoBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.4 303/389] NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly
Date:   Tue, 23 Aug 2022 10:26:21 +0200
Message-Id: <20220823080128.226687662@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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
@@ -848,7 +848,6 @@ static int nfs41_sequence_process(struct
 			__func__,
 			slot->slot_nr,
 			slot->seq_nr);
-		nfs4_slot_sequence_acked(slot, slot->seq_nr);
 		goto out_retry;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
 	case -NFS4ERR_SEQ_FALSE_RETRY:


