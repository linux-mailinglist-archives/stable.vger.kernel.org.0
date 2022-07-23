Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 926E257EE99
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 12:13:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239543AbiGWKNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 06:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239265AbiGWKNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 06:13:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4C118C59A;
        Sat, 23 Jul 2022 03:03:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C94C5611CD;
        Sat, 23 Jul 2022 10:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5669C341C0;
        Sat, 23 Jul 2022 10:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658570611;
        bh=Q1TD7F9ns2LiP9OwYh3h/gmbzL6OmOLlOkUZovjoCiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xFpX/iLmmynZhwDeReVxBl3gVtlrYK8rAYt6x81vW8zQUj0aLG+HT84aS/lzSeOcD
         NlmPVp6HRsFduQnmsBzqtFxUAzs+kXemxig9GreHgPNf8txPaLItb9XXZ8kJ7WWfuO
         w4ztiFZyd/BOiwuNBtTZO/LuXssnWkJBqM9b8f9Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Borislav Petkov <bp@suse.de>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 148/148] tools headers: Remove broken definition of __LITTLE_ENDIAN
Date:   Sat, 23 Jul 2022 11:56:00 +0200
Message-Id: <20220723095305.747384732@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220723095224.302504400@linuxfoundation.org>
References: <20220723095224.302504400@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

commit fa2c02e5798c17c89cbb3135940086ebe07e5c9f upstream.

The linux/kconfig.h file was copied from the kernel but the line where
with the generated/autoconf.h include from where the CONFIG_ entries
would come from was deleted, as tools/ build system don't create that
file, so we ended up always defining just __LITTLE_ENDIAN as
CONFIG_CPU_BIG_ENDIAN was nowhere to be found.

This in turn ended up breaking the build in some systems where
__LITTLE_ENDIAN was already defined, such as the androind NDK.

So just ditch that block that depends on the CONFIG_CPU_BIG_ENDIAN
define.

The kconfig.h file was copied just to get IS_ENABLED() and a
'make -C tools/all' doesn't breaks with this removal.

Fixes: 93281c4a96572a34 ("x86/insn: Add an insn_decode() API")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Borislav Petkov <bp@suse.de>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/YO8hK7lqJcIWuBzx@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/include/linux/kconfig.h |    6 ------
 1 file changed, 6 deletions(-)

--- a/tools/include/linux/kconfig.h
+++ b/tools/include/linux/kconfig.h
@@ -4,12 +4,6 @@
 
 /* CONFIG_CC_VERSION_TEXT (Do not delete this comment. See help in Kconfig) */
 
-#ifdef CONFIG_CPU_BIG_ENDIAN
-#define __BIG_ENDIAN 4321
-#else
-#define __LITTLE_ENDIAN 1234
-#endif
-
 #define __ARG_PLACEHOLDER_1 0,
 #define __take_second_arg(__ignored, val, ...) val
 


