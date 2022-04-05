Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 491A54F34CD
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245286AbiDEIyj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241019AbiDEIcn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F21B1888;
        Tue,  5 Apr 2022 01:26:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E12DD60FF7;
        Tue,  5 Apr 2022 08:26:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0409CC385A1;
        Tue,  5 Apr 2022 08:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147160;
        bh=ydGyx4p7///FDvur9+HuzBOOVf6P4H0f186iZTVpZG8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KvEcyEZrD/f0amiMEL+RSYCqw/7Nho+m+UzysgRRz17ELmGHr3gzPIyc9AwZ2PFhy
         acKsZJNQBwZzGSztfXJZzOrTJ3Ky6TDsb6xsoDfSTO6bAuohQvh18g62J/mUzY9/kq
         eixAbFAWXdspQqL+KgekXY0y9mQ2ZEpmpMdCvVJY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liam Howlett <liam.howlett@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>
Subject: [PATCH 5.17 1023/1126] XArray: Include bitmap.h from xarray.h
Date:   Tue,  5 Apr 2022 09:29:30 +0200
Message-Id: <20220405070437.510674310@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Matthew Wilcox (Oracle) <willy@infradead.org>

commit 22f56b8e890d4e2835951b437bb6eeebfd1cb18b upstream.

xas_find_chunk() calls find_next_bit(), which is defined in find.h,
included from bitmap.h.  Inside the kernel, this isn't a problem because
bitmap.h is included from cpumask.h which is dragged in (eventually)
by gfp.h.  When building the test-suite, that doesn't happen, so we need
to include bitmap.h explicitly.

Fixes: 4ade0818cf04 ("tools: sync tools/bitmap with mother linux")
Reported-by: Liam Howlett <liam.howlett@oracle.com>
Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/xarray.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index d6d5da6ed735..66e28bc1a023 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -9,6 +9,7 @@
  * See Documentation/core-api/xarray.rst for how to use the XArray.
  */
 
+#include <linux/bitmap.h>
 #include <linux/bug.h>
 #include <linux/compiler.h>
 #include <linux/gfp.h>
-- 
2.35.1



