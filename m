Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA737582D6B
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241038AbiG0Q5h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:57:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240816AbiG0Q5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:57:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03D5A664C5;
        Wed, 27 Jul 2022 09:36:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 69FC161AA5;
        Wed, 27 Jul 2022 16:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5D4C433D7;
        Wed, 27 Jul 2022 16:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939782;
        bh=Fu+RQZP2lBIVjrGU4m9Qhg1VGiP+0En1tD5IuKWsy6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wrlzgVN+GYIiK1skDqumeWFzoe8zjDrSBoDCM288epegzoknLRFw2aCIZpTs/epS4
         xOkczbEx5pO5Y/5pLnZWklE9ZeCyJV8u7bzTm21dbJRPunN9cpClgID4s3BymFlu5S
         f1HAwA4rfEbFU/xigIY1nUdmrlbTksSs7QLNywUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 103/105] watch-queue: remove spurious double semicolon
Date:   Wed, 27 Jul 2022 18:11:29 +0200
Message-Id: <20220727161016.245059455@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 44e29e64cf1ac0cffb152e0532227ea6d002aa28 upstream.

Sedat Dilek noticed that I had an extraneous semicolon at the end of a
line in the previous patch.

It's harmless, but unintentional, and while compilers just treat it as
an extra empty statement, for all I know some other tooling might warn
about it. So clean it up before other people notice too ;)

Fixes: 353f7988dd84 ("watchqueue: make sure to serialize 'wqueue->defunct' properly")
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/watch_queue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -227,7 +227,7 @@ void __post_watch_notification(struct wa
 
 		if (lock_wqueue(wqueue)) {
 			post_one_notification(wqueue, n);
-			unlock_wqueue(wqueue);;
+			unlock_wqueue(wqueue);
 		}
 	}
 


