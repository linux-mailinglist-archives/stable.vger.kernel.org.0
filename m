Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 996F65580C0
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 18:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiFWQxd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 12:53:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233747AbiFWQve (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 12:51:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 294744BFFB;
        Thu, 23 Jun 2022 09:49:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9217B82491;
        Thu, 23 Jun 2022 16:49:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22123C3411B;
        Thu, 23 Jun 2022 16:49:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656002975;
        bh=wELGr6wfnEeJMKhlZ+9+4rWjcNU9BYgROo8OgipK76I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JQFJzoPf+KR+nNv+/3s0FUdCAX8H3UM/D++jX7V3c+ZzrqsMSJXXy096KfYLQY3oh
         A5IDh44C16hQGPVvRN4BFDaAbPRj4JgH5ZYjiNDL52k5vt+rHxSC1voyBhx26EzOA/
         efQaoXihN1acdaW7VniWr7Id44Z62ou1GvowtTUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 4.9 047/264] char/random: Add a newline at the end of the file
Date:   Thu, 23 Jun 2022 18:40:40 +0200
Message-Id: <20220623164345.402094704@linuxfoundation.org>
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
@@ -2504,4 +2504,4 @@ void add_bootloader_randomness(const voi
 	else
 		add_device_randomness(buf, size);
 }
-EXPORT_SYMBOL_GPL(add_bootloader_randomness);
\ No newline at end of file
+EXPORT_SYMBOL_GPL(add_bootloader_randomness);


