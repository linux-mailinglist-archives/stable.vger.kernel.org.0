Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 530D44F3333
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:14:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiDEJEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:04:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243820AbiDEIvH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:51:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BC06C6ECD;
        Tue,  5 Apr 2022 01:39:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED7F0B81C69;
        Tue,  5 Apr 2022 08:38:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50258C385A2;
        Tue,  5 Apr 2022 08:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147900;
        bh=uFktpmXq//VwMEg/Xye+cAieCQG7ieCXEqG53n4shp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x4OeW+ZWYL1RdHHueL9SJsyndCaew5dEDZQ+TMToEgHv3NOOzfsElKEaUdV5MJUgW
         JEms1dEMiWx6z8yIv7EowzbAdkWttyXy2yjJWWtVjHcrc6dOuX9PSRSKfRzPkD45LI
         EaLg8FlVucRVrYx2YZ1JOOM+H50PfJKkiUWc3MX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Dirk=20M=C3=BCller?= <dmueller@suse.de>,
        Paul Menzel <pmenzel@molgen.mpg.de>, Song Liu <song@kernel.org>
Subject: [PATCH 5.16 0163/1017] lib/raid6/test: fix multiple definition linking error
Date:   Tue,  5 Apr 2022 09:17:56 +0200
Message-Id: <20220405070359.059456052@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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

From: Dirk Müller <dmueller@suse.de>

commit a5359ddd052860bacf957e65fe819c63e974b3a6 upstream.

GCC 10+ defaults to -fno-common, which enforces proper declaration of
external references using "extern". without this change a link would
fail with:

  lib/raid6/test/algos.c:28: multiple definition of `raid6_call';
  lib/raid6/test/test.c:22: first defined here

the pq.h header that is included already includes an extern declaration
so we can just remove the redundant one here.

Cc: <stable@vger.kernel.org>
Signed-off-by: Dirk Müller <dmueller@suse.de>
Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>
Signed-off-by: Song Liu <song@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/raid6/test/test.c |    1 -
 1 file changed, 1 deletion(-)

--- a/lib/raid6/test/test.c
+++ b/lib/raid6/test/test.c
@@ -19,7 +19,6 @@
 #define NDISKS		16	/* Including P and Q */
 
 const char raid6_empty_zero_page[PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));
-struct raid6_calls raid6_call;
 
 char *dataptrs[NDISKS];
 char data[NDISKS][PAGE_SIZE] __attribute__((aligned(PAGE_SIZE)));


