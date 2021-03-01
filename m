Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97F25328413
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234741AbhCAQ2t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:28:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:60756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233630AbhCAQYl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:24:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DB45164EC4;
        Mon,  1 Mar 2021 16:20:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614615647;
        bh=fggumwaUnRufx7qx4y6eor8MCt+pJxBONCKC/+HB41E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j44jVyCz51jTybmz5hS8sFuv11wESXXq7z19u7RnF4sO8JOXHhoA2K726BlpWc1uA
         8k0m2naTnpyUVafVx+RrtSMg3Kf+e3JwgJE1uJgqurEvXVLy3uc8Ovpng8xKyoCK8r
         KM0/2YPwUWGadS52ylfnpcQozgTxhHOx63K6l/iQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-crypto@vger.kernel.org,
        Andy Lutomirski <luto@kernel.org>,
        Jann Horn <jannh@google.com>, Theodore Tso <tytso@mit.edu>,
        Ard Biesheuvel <ardb@kernel.org>,
        Eric Biggers <ebiggers@google.com>
Subject: [PATCH 4.9 011/134] random: fix the RNDRESEEDCRNG ioctl
Date:   Mon,  1 Mar 2021 17:11:52 +0100
Message-Id: <20210301161014.138128462@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161013.585393984@linuxfoundation.org>
References: <20210301161013.585393984@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

commit 11a0b5e0ec8c13bef06f7414f9e914506140d5cb upstream.

The RNDRESEEDCRNG ioctl reseeds the primary_crng from itself, which
doesn't make sense.  Reseed it from the input_pool instead.

Fixes: d848e5f8e1eb ("random: add new ioctl RNDRESEEDCRNG")
Cc: stable@vger.kernel.org
Cc: linux-crypto@vger.kernel.org
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Theodore Ts'o <tytso@mit.edu>
Reviewed-by: Jann Horn <jannh@google.com>
Acked-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Eric Biggers <ebiggers@google.com>
Link: https://lore.kernel.org/r/20210112192818.69921-1-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -1913,7 +1913,7 @@ static long random_ioctl(struct file *f,
 			return -EPERM;
 		if (crng_init < 2)
 			return -ENODATA;
-		crng_reseed(&primary_crng, NULL);
+		crng_reseed(&primary_crng, &input_pool);
 		crng_global_init_time = jiffies - 1;
 		return 0;
 	default:


