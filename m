Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A17B8551B00
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 15:46:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345342AbiFTNaK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 09:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347338AbiFTN3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 09:29:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54FBA24BF1;
        Mon, 20 Jun 2022 06:12:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DBC78CE138F;
        Mon, 20 Jun 2022 13:11:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7EDDC3411B;
        Mon, 20 Jun 2022 13:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655730686;
        bh=DWXhcP2qQyfBGwBLLbzt5ZQ443Pbhgi0xkV+QO/Xe50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKXjYf5kj60ZDaON6DtlEu4n0fp5jLYU7QEizwaEJ7URY542+qEqE//CBGdOFiH1P
         x+1i3NTAIFgx/dVi2oF3mmK3j1HCg0GDXMOFe/ha0MuFbdyFvsgGU0BvKa4QUnt8zp
         BkGxdoNfz/CRejBDYLSamUDwtrXOXY2cGIGCaR7g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.4 007/240] compat_ioctl: remove /dev/random commands
Date:   Mon, 20 Jun 2022 14:48:28 +0200
Message-Id: <20220620124738.019462501@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit 507e4e2b430b6a27b66f4745564ecaee7967737f upstream.

These are all handled by the random driver, so instead of listing
each ioctl, we can use the generic compat_ptr_ioctl() helper.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    1 +
 fs/compat_ioctl.c     |    7 -------
 2 files changed, 1 insertion(+), 7 deletions(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2190,6 +2190,7 @@ const struct file_operations random_fops
 	.write = random_write,
 	.poll  = random_poll,
 	.unlocked_ioctl = random_ioctl,
+	.compat_ioctl = compat_ptr_ioctl,
 	.fasync = random_fasync,
 	.llseek = noop_llseek,
 };
--- a/fs/compat_ioctl.c
+++ b/fs/compat_ioctl.c
@@ -808,13 +808,6 @@ COMPATIBLE_IOCTL(WDIOC_SETTIMEOUT)
 COMPATIBLE_IOCTL(WDIOC_GETTIMEOUT)
 COMPATIBLE_IOCTL(WDIOC_SETPRETIMEOUT)
 COMPATIBLE_IOCTL(WDIOC_GETPRETIMEOUT)
-/* Big R */
-COMPATIBLE_IOCTL(RNDGETENTCNT)
-COMPATIBLE_IOCTL(RNDADDTOENTCNT)
-COMPATIBLE_IOCTL(RNDGETPOOL)
-COMPATIBLE_IOCTL(RNDADDENTROPY)
-COMPATIBLE_IOCTL(RNDZAPENTCNT)
-COMPATIBLE_IOCTL(RNDCLEARPOOL)
 /* Bluetooth */
 COMPATIBLE_IOCTL(HCIDEVUP)
 COMPATIBLE_IOCTL(HCIDEVDOWN)


