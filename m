Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C13575582C0
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 19:19:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232859AbiFWRTB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 13:19:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbiFWRRf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 13:17:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D676B60C60;
        Thu, 23 Jun 2022 09:59:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 176B861408;
        Thu, 23 Jun 2022 16:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC61BC3411B;
        Thu, 23 Jun 2022 16:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656003590;
        bh=/cipB65XXSwV6v6f6npwY4IX8FITeDxg38s9Lz6i3jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zJaMq4RvWRwvvYhcsfhvSCMyRRBexSnFoLMVYTs93UesknljOAdzagF5Hmo1M9DGh
         9BeDHXNgwQ1NaEEjZtFiN96ywJKL1OdUE/LohmRl09ZAK/Mw6coTRLbUfoBNESlW38
         D7qXK3Py0X/S7a4bAcn+Q3dNTWCQMkHEM+vQQ5W4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.14 023/237] char/random: Add a newline at the end of the file
Date:   Thu, 23 Jun 2022 18:40:57 +0200
Message-Id: <20220623164343.821440415@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220623164343.132308638@linuxfoundation.org>
References: <20220623164343.132308638@linuxfoundation.org>
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

From: Borislav Petkov <bp@alien8.de>

commit 3fd57e7a9e66b9a8bcbf0560ff09e84d0b8de1bd upstream.

On Tue, Oct 01, 2019 at 10:14:40AM -0700, Linus Torvalds wrote:
> The previous state of the file didn't have that 0xa at the end, so you get that
>
>
>   -EXPORT_SYMBOL_GPL(add_bootloader_randomness);
>   \ No newline at end of file
>   +EXPORT_SYMBOL_GPL(add_bootloader_randomness);
>
> which is "the '-' line doesn't have a newline, the '+' line does" marker.

Aaha, that makes total sense, thanks for explaining. Oh well, let's fix
it then so that people don't scratch heads like me.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -2451,4 +2451,4 @@ void add_bootloader_randomness(const voi
 	else
 		add_device_randomness(buf, size);
 }
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);
\ No newline at end of file
+EXPORT_SYMBOL_GPL(add_bootloader_randomness);


