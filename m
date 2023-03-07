Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC866AECDB
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbjCGR63 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:58:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjCGR6F (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:58:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 730A0A6151
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:52:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C82906150B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF991C4339B;
        Tue,  7 Mar 2023 17:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211555;
        bh=6QFpprwxNxWGCJnU4ckFCIwDFaGo2yNuPuK25RkdlPc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b7BXmhONHLAT25QdKq2/wgAbDVSZfxUelCua6mLuYMU2OMp1FwhZMcfvChnjcOrlN
         eTEKYSj7rfEpJ4qpRSEs9pDZdRjkwJQ8F59THQOW3oWhPdkW08ENPyeKskc2EWCDqB
         evRHnPjGIZgJgBWiUfuCxsgIwil3F4FIrMkLNneY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Pingfan Liu <piliu@redhat.com>,
        Ming Lei <ming.lei@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.2 0901/1001] dm: add cond_resched() to dm_wq_work()
Date:   Tue,  7 Mar 2023 18:01:13 +0100
Message-Id: <20230307170101.102707582@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pingfan Liu <piliu@redhat.com>

commit 0ca44fcef241768fd25ee763b3d203b9852f269b upstream.

Otherwise the while() loop in dm_wq_work() can result in a "dead
loop" on systems that have preemption disabled. This is particularly
problematic on single cpu systems.

Cc: stable@vger.kernel.org
Signed-off-by: Pingfan Liu <piliu@redhat.com>
Acked-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2565,6 +2565,7 @@ static void dm_wq_work(struct work_struc
 			break;
 
 		submit_bio_noacct(bio);
+		cond_resched();
 	}
 }
 


