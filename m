Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113325A6DAD
	for <lists+stable@lfdr.de>; Tue, 30 Aug 2022 21:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231614AbiH3Tod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Aug 2022 15:44:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiH3ToF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Aug 2022 15:44:05 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DBCC7C194;
        Tue, 30 Aug 2022 12:43:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=RDyJdq5O7df2OV2FdkfRvLlzusAdIsvc83C2FbDGQIs=; b=fPy7BcmCgBdEseX82lm+TEog9U
        E4r3JyGrNWieDlqlUZmGtY9pHhVHd6prE1opovTSlATv6fB99zAc/XTHJWUEVwe5rEYB6z+0sCLp1
        bbPDpZlKnloRmiaaeSXpLKFuiW271Dc7bthumPqfBzrZ+2YDd/IjyXDkzaNpI+WKFc1nZpW6kg05t
        maF7ixPxotctRuqK8gJroUOfyl4E3tvCkN/a5GVQgvrtAov6tKETL8IAuRMUnv0L5gzViCWp1AJAr
        pbBxGRMk9Vw8To1G3sU8mWwigGGHW9yjOSfPrn+GxBVl2wnXK2uyRFjKSneglzNUQuvAVct50PnXS
        gvuUGGqw==;
Received: from [2601:1c0:6280:3f0::a6b3] (helo=casper.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oT78x-004N4N-6S; Tue, 30 Aug 2022 19:43:28 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, linux-sh@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] sh: nmi_debug: fix return value of __setup handler
Date:   Tue, 30 Aug 2022 12:43:21 -0700
Message-Id: <20220830194321.15723-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

__setup() handlers should return 1 to obsolete_checksetup() in
init/main.c to indicate that the boot option has been handled.
A return of 0 causes the boot option/value to be listed as an Unknown
kernel parameter and added to init's (limited) argument or environment
strings. Also, error return codes don't mean anything to
obsolete_checksetup() -- only non-zero (usually 1) or zero.
So return 1 from nmi_debug_setup().

Fixes: 1e1030dccb10 ("sh: nmi_debug support.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Cc: Rich Felker <dalias@libc.org>
Cc: linux-sh@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
---
v2: add more Cc's;
    refresh and resend;

 arch/sh/kernel/nmi_debug.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sh/kernel/nmi_debug.c
+++ b/arch/sh/kernel/nmi_debug.c
@@ -49,7 +49,7 @@ static int __init nmi_debug_setup(char *
 	register_die_notifier(&nmi_debug_nb);
 
 	if (*str != '=')
-		return 0;
+		return 1;
 
 	for (p = str + 1; *p; p = sep + 1) {
 		sep = strchr(p, ',');
@@ -70,6 +70,6 @@ static int __init nmi_debug_setup(char *
 			break;
 	}
 
-	return 0;
+	return 1;
 }
 __setup("nmi_debug", nmi_debug_setup);
