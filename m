Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3041A55804D
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232493AbiFWQrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232478AbiFWQrV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:47:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24E6349C82;
        Thu, 23 Jun 2022 09:47:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8E896CE25DE;
        Thu, 23 Jun 2022 16:47:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E31C341DA;
        Thu, 23 Jun 2022 16:47:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002836;
        bh=cmmyeAgpxGhy8P8hXLYAyi9xEgnudIeUVJlvOi7PvOg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CkwirAD9Xb3lsXDQn6qVH67vvmY0i6qWZFMcli6biUOzIqvtVPhpkSBlVMFA7hPV/
         bkAWxkuMqhvWcXLCsZNVBoBtfUFArKbu9u6wkCADCtUMc38FLh4L8vNTuM6G98BiL2
         xHo89Y6noehl4vLMmKaFOgQDA9+8dISFmdENbFBQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Fabio Estevam <fabio.estevam@nxp.com>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 007/264] random: move random_min_urandom_seed into CONFIG_SYSCTL ifdef block
Date:   Thu, 23 Jun 2022 18:40:00 +0200
Message-Id: <20220623164344.267645441@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
References: <20220623164344.053938039@linuxfoundation.org>
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

From: Fabio Estevam <fabio.estevam@nxp.com>

commit db61ffe3a71c697aaa91c42c862a5f7557a0e562 upstream.

Building arm allnodefconfig causes the following build warning:

drivers/char/random.c:318:12: warning: 'random_min_urandom_seed' defined but not used [-Wunused-variable]

Fix the warning by moving 'random_min_urandom_seed' declaration inside
the CONFIG_SYSCTL ifdef block, where it is actually used.

While at it, remove the comment prior to the variable declaration.

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -314,11 +314,6 @@ static int random_read_wakeup_bits = 64;
 static int random_write_wakeup_bits = 28 * OUTPUT_POOL_WORDS;
 
 /*
- * Variable is currently unused by left for user space compatibility.
- */
-static int random_min_urandom_seed = 60;
-
-/*
  * Originally, we used a primitive polynomial of degree .poolwords
  * over GF(2).  The taps for various sizes are defined below.  They
  * were chosen to be evenly spaced except for the last tap, which is 1
@@ -1957,6 +1952,7 @@ SYSCALL_DEFINE3(getrandom, char __user *
 static int min_read_thresh = 8, min_write_thresh;
 static int max_read_thresh = OUTPUT_POOL_WORDS * 32;
 static int max_write_thresh = INPUT_POOL_WORDS * 32;
+static int random_min_urandom_seed = 60;
 static char sysctl_bootid[16];
 
 /*


