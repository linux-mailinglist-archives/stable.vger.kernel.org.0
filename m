Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96B824ABC9C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386933AbiBGLiG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:38:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385604AbiBGLcB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:32:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DD1C03E937;
        Mon,  7 Feb 2022 03:31:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4355BB80EC3;
        Mon,  7 Feb 2022 11:31:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57CB5C004E1;
        Mon,  7 Feb 2022 11:31:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233464;
        bh=UBUGUaJZe93yLz+nk7Ton8WJCc+VGhP2Z/SUcF67TSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YFvrwteB+mdXqWaI/TEqe9p+HZVz/ssmC7faZDfiqz2w6yaAdXubolA2H6fgUqu3Z
         5cNB74YztiImKAE4WdRGGT2B8eR2S/A4kPDWHx1CgghewNpGFcmFzJ82+JNRKDuyjr
         NQWH7NaHwj+obOgIRTqczbIAD6MoBue0dhM8lDIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Shakeel Butt <shakeelb@google.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        Arnd Bergmann <arnd@arndb.de>, Yang Guang <cgel.zte@gmail.com>,
        Davidlohr Bueso <dbueso@suse.de>,
        Randy Dunlap <rdunlap@infradead.org>,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Vasily Averin <vvs@virtuozzo.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.16 004/126] ipc/sem: do not sleep with a spin lock held
Date:   Mon,  7 Feb 2022 12:05:35 +0100
Message-Id: <20220207103804.211134497@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Minghao Chi <chi.minghao@zte.com.cn>

commit 520ba724061cef59763e2b6f5b26e8387c2e5822 upstream.

We can't call kvfree() with a spin lock held, so defer it.

Link: https://lkml.kernel.org/r/20211223031207.556189-1-chi.minghao@zte.com.cn
Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo allocation")
Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Manfred Spraul <manfred@colorfullife.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Yang Guang <cgel.zte@gmail.com>
Cc: Davidlohr Bueso <dbueso@suse.de>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc: Vasily Averin <vvs@virtuozzo.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 ipc/sem.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/ipc/sem.c
+++ b/ipc/sem.c
@@ -1964,6 +1964,7 @@ static struct sem_undo *find_alloc_undo(
 	 */
 	un = lookup_undo(ulp, semid);
 	if (un) {
+		spin_unlock(&ulp->lock);
 		kvfree(new);
 		goto success;
 	}
@@ -1976,9 +1977,8 @@ static struct sem_undo *find_alloc_undo(
 	ipc_assert_locked_object(&sma->sem_perm);
 	list_add(&new->list_id, &sma->list_id);
 	un = new;
-
-success:
 	spin_unlock(&ulp->lock);
+success:
 	sem_unlock(sma, -1);
 out:
 	return un;


