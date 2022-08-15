Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C955594DEA
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244123AbiHPAgo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:36:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350941AbiHPAgN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:36:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2A818A0A1;
        Mon, 15 Aug 2022 13:37:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC664611FC;
        Mon, 15 Aug 2022 20:37:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1457C433D6;
        Mon, 15 Aug 2022 20:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595868;
        bh=tCgbbTMFE+sb6E+5jCobyDRg7FlTRVX0HYOCBNbP5TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flYTTbnmsGsniRmAHNY7IC/THbLff3oNhv7A4pYRXjZzSZT7cyksIMxzYediylkT6
         WXcwalKNvTZ8zNPJvbsQHNxbwDf7ISiNo6Woir2TpR+yB6qLpu98auzlprZfaIz9x6
         jzkADKIxHTmufmACzC1Ghw5ACDZ9xa+PnGRzJmEI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sedat Dilek <sedat.dilek@gmail.com>,
        Daniel Bristot de Oliveira <bristot@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0868/1157] rtla: Fix Makefile when called from -C tools/
Date:   Mon, 15 Aug 2022 20:03:44 +0200
Message-Id: <20220815180514.194362232@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Bristot de Oliveira <bristot@kernel.org>

[ Upstream commit c7d8a598c5b1e21a0957f5dec2ef4139d2d1a23a ]

Sedat Dilek reported an error on rtla Makefile when running:

    $ make -C tools/ clean
    [...]
    make[2]: Entering directory
    '/home/dileks/src/linux-kernel/git/tools/tracing/rtla'
    [...]
    '/home/dileks/src/linux-kernel/git/Documentation/tools/rtla'
    /bin/sh: 1: test: rtla-make[2]:: unexpected operator    <------ The problem
    rm: cannot remove '/home/dileks/src/linux-kernel/git': Is a directory
    make[2]: *** [Makefile:120: clean] Error 1
    make[2]: Leaving directory

This occurred because the rtla calls kernel's Makefile to get the
version in silence mode, e.g.,

    $ make -sC ../../.. kernelversion
    5.19.0-rc4

But the -s is being ignored when rtla's makefile is called indirectly,
so the output looks like this:

    $ make -C ../../.. kernelversion
    make: Entering directory '/root/linux'
    5.19.0-rc4
    make: Leaving directory '/root/linux'

Using 'grep -v make' avoids this problem, e.g.,

    $ make -C ../../.. kernelversion | grep -v make
    5.19.0-rc4

Thus, add | grep -v make.

Link: https://lkml.kernel.org/r/870c02d4d97a921f02a31fa3b229fc549af61a20.1657747763.git.bristot@kernel.org

Fixes: 8619e32825fd ("rtla: Follow kernel version")
Reported-by: Sedat Dilek <sedat.dilek@gmail.com>
Tested-by: Sedat Dilek <sedat.dilek@gmail.com>
Signed-off-by: Daniel Bristot de Oliveira <bristot@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/tracing/rtla/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/tracing/rtla/Makefile b/tools/tracing/rtla/Makefile
index 3822f4ea5f49..1bea2d16d4c1 100644
--- a/tools/tracing/rtla/Makefile
+++ b/tools/tracing/rtla/Makefile
@@ -1,6 +1,6 @@
 NAME	:=	rtla
 # Follow the kernel version
-VERSION :=	$(shell cat VERSION 2> /dev/null || make -sC ../../.. kernelversion)
+VERSION :=	$(shell cat VERSION 2> /dev/null || make -sC ../../.. kernelversion | grep -v make)
 
 # From libtracefs:
 # Makefiles suck: This macro sets a default value of $(2) for the
-- 
2.35.1



