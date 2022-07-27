Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CED9B582F60
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238384AbiG0RZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:25:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiG0RXu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:23:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F6537AC39;
        Wed, 27 Jul 2022 09:45:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6E88600BE;
        Wed, 27 Jul 2022 16:45:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C78CFC4314E;
        Wed, 27 Jul 2022 16:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940353;
        bh=Fu+RQZP2lBIVjrGU4m9Qhg1VGiP+0En1tD5IuKWsy6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UUwdUa7oDJdFxOucTc1dWM/2pSfx1/Qyu2e7Lq830lI1Dk0+ugcm1gKdQS2oXAJoO
         t6Z4WkVy4Hj+6SEKsiA4ka33Rw8GFT5saBrv41o1s3k5FQWd7En/kZzixUlnVu29dx
         /njQ6NOFlz2oMqVQr0/LKGX/B1mJSE+b3qyrP1fQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.15 194/201] watch-queue: remove spurious double semicolon
Date:   Wed, 27 Jul 2022 18:11:38 +0200
Message-Id: <20220727161035.807389817@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
 


