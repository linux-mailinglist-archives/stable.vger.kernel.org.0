Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A904363542D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:05:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236943AbiKWJFI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:05:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236945AbiKWJEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:04:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13DD610558A
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:04:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB4FDB81ECB
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:04:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E20D5C433C1;
        Wed, 23 Nov 2022 09:04:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669194284;
        bh=NgcgWbgq+NHzd1MVDmZVgA4UGHow7sBhCZKIKBlN88o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lKBoli9W+wE8IDtdw7bZHAx/SdEneLMQWhR+ejHPvEEAA85JVQDRsRBuGmk9tHV07
         kDO9FRAYs3GtEEsOCiXcp2HwiWZGX88UZuDFDlXE3oNRR3Pjnrj7cL0LNbgjeW4pTE
         qjwfTqsT/pJNIMMit3H9vAo349M/2UNpX8X9F+X8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 034/114] cert host tools: Stop complaining about deprecated OpenSSL functions
Date:   Wed, 23 Nov 2022 09:50:21 +0100
Message-Id: <20221123084553.199336838@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 6bfb56e93bcef41859c2d5ab234ffd80b691be35 upstream.

OpenSSL 3.0 deprecated the OpenSSL's ENGINE API.  That is as may be, but
the kernel build host tools still use it.  Disable the warning about
deprecated declarations until somebody who cares fixes it.

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/extract-cert.c |    7 +++++++
 scripts/sign-file.c    |    7 +++++++
 2 files changed, 14 insertions(+)

--- a/scripts/extract-cert.c
+++ b/scripts/extract-cert.c
@@ -23,6 +23,13 @@
 #include <openssl/err.h>
 #include <openssl/engine.h>
 
+/*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
 #define PKEY_ID_PKCS7 2
 
 static __attribute__((noreturn))
--- a/scripts/sign-file.c
+++ b/scripts/sign-file.c
@@ -30,6 +30,13 @@
 #include <openssl/engine.h>
 
 /*
+ * OpenSSL 3.0 deprecates the OpenSSL's ENGINE API.
+ *
+ * Remove this if/when that API is no longer used
+ */
+#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
+
+/*
  * Use CMS if we have openssl-1.0.0 or newer available - otherwise we have to
  * assume that it's not available and its header file is missing and that we
  * should use PKCS#7 instead.  Switching to the older PKCS#7 format restricts


