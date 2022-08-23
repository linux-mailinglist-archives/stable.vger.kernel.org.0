Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4203559D39C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242041AbiHWIMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:12:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242102AbiHWIKi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:10:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DBAD69F59;
        Tue, 23 Aug 2022 01:07:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1903CB81C19;
        Tue, 23 Aug 2022 08:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE53C433D6;
        Tue, 23 Aug 2022 08:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242064;
        bh=2FtPi5InGe8zR+ZqyxViScWdsfKTn2773GtUa3NxpfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FIyGPL2NDCHX1DuxUz+E3pQ0h4lyZua2b2tvXdTOrePM4vqRQcGpbfZswWrPkKktp
         ppCcSF06bfhFFrNalC+KgpwmDJqAaEtovSmK0B3B48qZFeVwNGB/y+M5iq+iVUySNo
         odSJvh+d0BDiiHPaK1tPah294qWRyKjTy6WzhkuM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.19 053/365] NFSv4.1: Handle NFS4ERR_DELAY replies to OP_SEQUENCE correctly
Date:   Tue, 23 Aug 2022 09:59:14 +0200
Message-Id: <20220823080120.412492864@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
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
@@ -853,7 +853,6 @@ static int nfs41_sequence_process(struct
 			__func__,
 			slot->slot_nr,
 			slot->seq_nr);
-		nfs4_slot_sequence_acked(slot, slot->seq_nr);
 		goto out_retry;
 	case -NFS4ERR_RETRY_UNCACHED_REP:
 	case -NFS4ERR_SEQ_FALSE_RETRY:


