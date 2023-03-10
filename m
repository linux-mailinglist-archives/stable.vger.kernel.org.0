Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B4E86B4478
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbjCJOYd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:24:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232280AbjCJOYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:24:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B957567AC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:23:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64F9617B4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:23:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4821C433EF;
        Fri, 10 Mar 2023 14:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678458193;
        bh=67Q2YPk65wzm91ieI5uoY53IAZu4XDX5tCVRjcnvYwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qomfdqs4Ap95honlxU6oYQs1rmPPE0q27rfr9OLhim1oQOzsOYXRSUe4Q1hiLPXvT
         OdAo6BRscPKgDKIXYu+V8DQLSYj/pms3vvMp1NdNI3FSHKoZki1bbpqv8PwbgxNE5j
         LlMzCOFFiRLAP2GT0aosCKnNeUngcLtYyKW5gYEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jan Palus <jpalus+gnu@fastmail.com>,
        Dmitry Goncharov <dgoncharov@users.sf.net>,
        Masahiro Yamada <masahiroy@kernel.org>
Subject: [PATCH 4.19 196/252] kbuild: Port silent mode detection to future gnu make.
Date:   Fri, 10 Mar 2023 14:39:26 +0100
Message-Id: <20230310133724.920854773@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Goncharov <dgoncharov@users.sf.net>

commit 4bf73588165ba7d32131a043775557a54b6e1db5 upstream.

Port silent mode detection to the future (post make-4.4) versions of gnu make.

Makefile contains the following piece of make code to detect if option -s is
specified on the command line.

ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)

This code is executed by make at parse time and assumes that MAKEFLAGS
does not contain command line variable definitions.
Currently if the user defines a=s on the command line, then at build only
time MAKEFLAGS contains " -- a=s".
However, starting with commit dc2d963989b96161472b2cd38cef5d1f4851ea34
MAKEFLAGS contains command line definitions at both parse time and
build time.

This '-s' detection code then confuses a command line variable
definition which contains letter 's' with option -s.

$ # old make
$ make net/wireless/ocb.o a=s
  CALL    scripts/checksyscalls.sh
  DESCEND objtool
$ # this a new make which defines makeflags at parse time
$ ~/src/gmake/make/l64/make net/wireless/ocb.o a=s
$

We can see here that the letter 's' from 'a=s' was confused with -s.

This patch checks for presence of -s using a method recommended by the
make manual here
https://www.gnu.org/software/make/manual/make.html#Testing-Flags.

Link: https://lists.gnu.org/archive/html/bug-make/2022-11/msg00190.html
Reported-by: Jan Palus <jpalus+gnu@fastmail.com>
Signed-off-by: Dmitry Goncharov <dgoncharov@users.sf.net>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -88,10 +88,17 @@ endif
 
 # If the user is running make -s (silent mode), suppress echoing of
 # commands
+# make-4.0 (and later) keep single letter options in the 1st word of MAKEFLAGS.
 
-ifneq ($(findstring s,$(filter-out --%,$(MAKEFLAGS))),)
-  quiet=silent_
-  tools_silent=s
+ifeq ($(filter 3.%,$(MAKE_VERSION)),)
+silence:=$(findstring s,$(firstword -$(MAKEFLAGS)))
+else
+silence:=$(findstring s,$(filter-out --%,$(MAKEFLAGS)))
+endif
+
+ifeq ($(silence),s)
+quiet=silent_
+tools_silent=s
 endif
 
 export quiet Q KBUILD_VERBOSE


