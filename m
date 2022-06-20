Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B97551CB5
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346134AbiFTNee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:34:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346163AbiFTNcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:32:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E53F26110;
        Mon, 20 Jun 2022 06:12:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA18F60A52;
        Mon, 20 Jun 2022 13:11:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E97B6C3411C;
        Mon, 20 Jun 2022 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730689;
        bh=1+E2pDWYvJHF8rDS+xtktmcYX3zlcPQWkYN/rPnJ1g0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bkOOSidIhi2XBls6qULvaSSzBsuJ5iwREIdw+nebsE7283cO+56ffgHF8bdj8RXYh
         U2pVXLfWV6nwpyBmeBmWnnyGhKDEHqewL7P35MfnQoGiZB3MrWpG8VP7/mwFfnO6Vc
         rCcW3QoHiwKEkjLwd0H7ExZDnCrTJgnRi8HF6WsU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 008/240] random: dont forget compat_ioctl on urandom
Date:   Mon, 20 Jun 2022 14:48:29 +0200
Message-Id: <20220620124738.048034618@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220620124737.799371052@linuxfoundation.org>
References: <20220620124737.799371052@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 4aa37c463764052c68c5c430af2a67b5d784c1e0 upstream.

Recently, there's been some compat ioctl cleanup, in which large
hardcoded lists were replaced with compat_ptr_ioctl. One of these
changes involved removing the random.c hardcoded list entries and adding
a compat ioctl function pointer to the random.c fops. In the process,
urandom was forgotten about, so this commit fixes that oversight.

Fixes: 507e4e2b430b ("compat_ioctl: remove /dev/random commands")
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://lore.kernel.org/r/20191217172455.186395-1-Jason@zx2c4.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2199,6 +2199,7 @@ const struct file_operations urandom_fop
 	.read  = urandom_read,
 	.write = random_write,
 	.unlocked_ioctl = random_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
 };


