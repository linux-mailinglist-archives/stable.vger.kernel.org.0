Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E161566BA4
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:09:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234314AbiGEMJU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:09:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234401AbiGEMH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:07:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DD65183BF;
        Tue,  5 Jul 2022 05:06:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D1226B817CC;
        Tue,  5 Jul 2022 12:06:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F2F5C341C7;
        Tue,  5 Jul 2022 12:06:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657022778;
        bh=KLewugvlQfnHhOK3fgli2q9qbyOzLhQxzieXn0BcCdI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wud7+8EY9Dj5s+fbYoNYwxLohxCvwxsHxvbqhTae8oNwn6WC/j/bfKG5mSE7xkJ85
         p3RzamGU6qo48MeuvDq+gbqtG4EfGrwWN/DMfBe40Pa/2KghkxxS3lPxh9a/1ySh0T
         bGoMjRyjuilwFvbtli154oGy1At0eVk3VP2zjXw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.4 35/58] selftests/rseq: remove ARRAY_SIZE define from individual tests
Date:   Tue,  5 Jul 2022 13:58:11 +0200
Message-Id: <20220705115611.278426912@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
References: <20220705115610.236040773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit 07ad4f7629d4802ff0d962b0ac23ea6445964e2a upstream.

ARRAY_SIZE is defined in several selftests. Remove definitions from
individual test files and include header file for the define instead.
ARRAY_SIZE define is added in a separate patch to prepare for this
change.

Remove ARRAY_SIZE from rseq tests and pickup the one defined in
kselftest.h.

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/rseq/basic_percpu_ops_test.c |    3 +--
 tools/testing/selftests/rseq/rseq.c                  |    3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

--- a/tools/testing/selftests/rseq/basic_percpu_ops_test.c
+++ b/tools/testing/selftests/rseq/basic_percpu_ops_test.c
@@ -9,10 +9,9 @@
 #include <string.h>
 #include <stddef.h>
 
+#include "../kselftest.h"
 #include "rseq.h"
 
-#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
-
 struct percpu_lock_entry {
 	intptr_t v;
 } __attribute__((aligned(128)));
--- a/tools/testing/selftests/rseq/rseq.c
+++ b/tools/testing/selftests/rseq/rseq.c
@@ -27,10 +27,9 @@
 #include <signal.h>
 #include <limits.h>
 
+#include "../kselftest.h"
 #include "rseq.h"
 
-#define ARRAY_SIZE(arr)	(sizeof(arr) / sizeof((arr)[0]))
-
 __thread volatile struct rseq __rseq_abi = {
 	.cpu_id = RSEQ_CPU_ID_UNINITIALIZED,
 };


