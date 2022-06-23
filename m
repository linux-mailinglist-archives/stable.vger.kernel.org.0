Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23F82558052
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:52:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232113AbiFWQrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:47:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232498AbiFWQqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:46:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C41FA45ACF;
        Thu, 23 Jun 2022 09:46:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83556B8248E;
        Thu, 23 Jun 2022 16:46:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D95EEC341C4;
        Thu, 23 Jun 2022 16:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002801;
        bh=6Uxw7wD3IxPwXL1pf/Ywr603SKq2ovRIdwRj3oZ2iMc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YDzo4crkgoCalUeJKB+q76WgmtTBtDYYz882DPQcxTmEd4l5g8vme+AwhM/cATDwz
         wXjy6IVGl5ToLCJP1Dw7T/rFgKrifIAK/mgLW391XytobK0eyItycTIdc9eXzIqoq9
         ydTzsoYKBrWYELrZmKxzS5oHdSD6jeTzrdNUI7NU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephan Mueller <smueller@chronox.de>,
        Theodore Tso <tytso@mit.edu>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 003/264] random: remove stale urandom_init_wait
Date:   Thu, 23 Jun 2022 18:39:56 +0200
Message-Id: <20220623164344.155479686@linuxfoundation.org>
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

From: "Stephan Müller" <smueller@chronox.de>

commit 2e03c36f25ebb52d3358b8baebcdf96895c33a87 upstream.

The urandom_init_wait wait queue is a left over from the pre-ChaCha20
times and can therefore be savely removed.

Signed-off-by: Stephan Mueller <smueller@chronox.de>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -410,7 +410,6 @@ static struct poolinfo {
  */
 static DECLARE_WAIT_QUEUE_HEAD(random_read_wait);
 static DECLARE_WAIT_QUEUE_HEAD(random_write_wait);
-static DECLARE_WAIT_QUEUE_HEAD(urandom_init_wait);
 static struct fasync_struct *fasync;
 
 static DEFINE_SPINLOCK(random_ready_list_lock);


