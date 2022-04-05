Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 26E924F344C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235194AbiDEJBV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:01:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237425AbiDEImO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DEE5DF85;
        Tue,  5 Apr 2022 01:34:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E5D3B81B13;
        Tue,  5 Apr 2022 08:34:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8068DC385A1;
        Tue,  5 Apr 2022 08:34:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147685;
        bh=fKGsAcnGkdDH2Ic2fcQgnLFdX1e9rvKJlOCEFRK4Q3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wiI/Nh5K9kJQrs9safV9bp0RhGI0EYBWCGH8luJl/wxofn2sOy8GsjMThEYxKupFh
         3UPCq+7IkZddiJUut1o+epyH1v/os/PqEw3QNn1kgRBpq20KtTlS21I9DQhQzbYbbm
         IHO/CPPzXV1q346umdeP+fUHUeXgulcuxeZCB/7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
        Chris Goldsworthy <cgoldswo@codeaurora.org>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        John Dias <joaodias@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 0086/1017] mm: fs: fix lru_cache_disabled race in bh_lru
Date:   Tue,  5 Apr 2022 09:16:39 +0200
Message-Id: <20220405070356.745892359@linuxfoundation.org>
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

From: Minchan Kim <minchan@kernel.org>

commit c0226eb8bde854e016a594a16f5c0d98aca426fa upstream.

Check lru_cache_disabled under bh_lru_lock.  Otherwise, it could introduce
race below and it fails to migrate pages containing buffer_head.

   CPU 0					CPU 1

bh_lru_install
                                       lru_cache_disable
  lru_cache_disabled = false
                                       atomic_inc(&lru_disable_count);
				       invalidate_bh_lrus_cpu of CPU 0
				       bh_lru_lock
				       __invalidate_bh_lrus
				       bh_lru_unlock
  bh_lru_lock
  install the bh
  bh_lru_unlock

WHen this race happens a CMA allocation fails, which is critical for
the workload which depends on CMA.

Link: https://lkml.kernel.org/r/20220308180709.2017638-1-minchan@kernel.org
Fixes: 8cc621d2f45d ("mm: fs: invalidate BH LRU during page migration")
Signed-off-by: Minchan Kim <minchan@kernel.org>
Cc: Chris Goldsworthy <cgoldswo@codeaurora.org>
Cc: Marcelo Tosatti <mtosatti@redhat.com>
Cc: John Dias <joaodias@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/buffer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -1235,16 +1235,18 @@ static void bh_lru_install(struct buffer
 	int i;
 
 	check_irqs_on();
+	bh_lru_lock();
+
 	/*
 	 * the refcount of buffer_head in bh_lru prevents dropping the
 	 * attached page(i.e., try_to_free_buffers) so it could cause
 	 * failing page migration.
 	 * Skip putting upcoming bh into bh_lru until migration is done.
 	 */
-	if (lru_cache_disabled())
+	if (lru_cache_disabled()) {
+		bh_lru_unlock();
 		return;
-
-	bh_lru_lock();
+	}
 
 	b = this_cpu_ptr(&bh_lrus);
 	for (i = 0; i < BH_LRU_SIZE; i++) {


