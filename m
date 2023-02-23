Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB26E6A0A21
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:13:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234429AbjBWNNQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234534AbjBWNNL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:13:11 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58B5B57083
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 6524BCE2070
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:12:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84761C433D2;
        Thu, 23 Feb 2023 13:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157945;
        bh=ySUSo9134a+nqZ7BU1XbfH7P7iek9JK3lkMp6DHI0Yc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XtEvEBXK/f7Yltvk5tpqoOx6y64CN+ZVFRCyS6xgjqkmZrZ0VXJo8xvektpPqxQRQ
         vwPRTo9kDx6yXMMmBa/4t2m8I32VGE9dlY2P9fQrqBqkdHcfLn0BuX5aHkt2bXtXh0
         7V+FZSispoUPq2U6NNWziKdN0XideYk5QHJwCRm4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Matthias Maennich <maennich@google.com>
Subject: [PATCH 5.15 34/36] lib/Kconfig.debug: Use CONFIG_PAHOLE_VERSION
Date:   Thu, 23 Feb 2023 14:07:10 +0100
Message-Id: <20230223130430.620363070@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130429.072633724@linuxfoundation.org>
References: <20230223130429.072633724@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

commit 6323c81350b73a4569cf52df85f80273faa64071 upstream.

Now that CONFIG_PAHOLE_VERSION exists, use it in the definition of
CONFIG_PAHOLE_HAS_SPLIT_BTF and CONFIG_PAHOLE_HAS_BTF_TAG to reduce the
amount of duplication across the tree.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20220201205624.652313-5-nathan@kernel.org
[maennich: omitted patching non-existing config PAHOLE_HAS_BTF_TAG]
Signed-off-by: Matthias Maennich <maennich@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/Kconfig.debug |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/Kconfig.debug
+++ b/lib/Kconfig.debug
@@ -328,7 +328,7 @@ config DEBUG_INFO_BTF
 	  DWARF type info into equivalent deduplicated BTF type info.
 
 config PAHOLE_HAS_SPLIT_BTF
-	def_bool $(success, test `$(PAHOLE) --version | sed -E 's/v([0-9]+)\.([0-9]+)/\1\2/'` -ge "119")
+	def_bool PAHOLE_VERSION >= 119
 
 config DEBUG_INFO_BTF_MODULES
 	def_bool y


