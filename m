Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5E4F558504
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232807AbiFWRx6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:53:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbiFWRxG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2123AA308;
        Thu, 23 Jun 2022 10:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27BC5B824B4;
        Thu, 23 Jun 2022 17:13:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F2D7C36AEA;
        Thu, 23 Jun 2022 17:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656004429;
        bh=TXlJw9jpEOS1fyd0OpgzA5Jz8hgGqgEotnlXApTzPMk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=X52KbEDGy+e6AoiaxYhUixSlreNTu6jeIXYfPrtSpN+nfW1ACzsXfeRUmJtx29rnA
         Ps4rLbBiS21gZGxPF+EaSY+AfPSd7JUsDSyzdG1mBcqfwPbqI3nX/SCPSp4rlIA72b
         08hp9kBzzwPXN0QlqYKMdhpZYkIqq6MrsyrNRzDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.19 004/234] drivers/char/random.c: make primary_crng static
Date:   Thu, 23 Jun 2022 18:41:11 +0200
Message-Id: <20220623164343.175186212@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
References: <20220623164343.042598055@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>

commit 764ed189c82090c1d85f0e30636156736d8f09a8 upstream.

Since the definition of struct crng_state is private to random.c, and
primary_crng is neither declared or used elsewhere, there's no reason
for that symbol to have external linkage.

Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -415,7 +415,7 @@ struct crng_state {
 	spinlock_t	lock;
 };
 
-struct crng_state primary_crng = {
+static struct crng_state primary_crng = {
 	.lock = __SPIN_LOCK_UNLOCKED(primary_crng.lock),
 };
 


