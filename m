Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83F6C4ABC27
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:45:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384927AbiBGLao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:30:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384022AbiBGLY2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:24:28 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02079C043188;
        Mon,  7 Feb 2022 03:24:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7743461388;
        Mon,  7 Feb 2022 11:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F435C004E1;
        Mon,  7 Feb 2022 11:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233066;
        bh=+nRe8g/tE2F5FU0y+dnQVbMd4p5XFCbxsci5pHSsjd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aEdry7Sq6sC33w2NQ9LLuk8p2PDLAZ05m5O/RbPLgOU8Wa0gZXXIS1RO3Embs8cR2
         Vi/M9dEpoZGxVDh8DCw/RfH6SJ1QQqFpPatFni+wlfnWW9ZOXT/PcPjWQkgcEmlz6e
         pdLIPf7JayzAKOsIXCrmhdstzvjkwlM0ilWhc6OM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.10 56/74] selftests/exec: Remove pipe from TEST_GEN_FILES
Date:   Mon,  7 Feb 2022 12:06:54 +0100
Message-Id: <20220207103759.060911912@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.232676988@linuxfoundation.org>
References: <20220207103757.232676988@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

commit 908a26e139e8cf21093acc56d8e90ddad2ad1eff upstream.

pipe named FIFO special file is being created in execveat.c to perform
some tests. Makefile doesn't need to do anything with the pipe. When it
isn't found, Makefile generates the following build error:

make: *** No rule to make target
'../tools/testing/selftests/exec/pipe', needed by 'all'.  Stop.

pipe is created and removed during test run-time.

Amended change log to add pipe remove info:
Shuah Khan <skhan@linuxfoundation.org>

Fixes: 61016db15b8e ("selftests/exec: Verify execve of non-regular files fail")
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/exec/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/exec/Makefile
+++ b/tools/testing/selftests/exec/Makefile
@@ -5,7 +5,7 @@ CFLAGS += -D_GNU_SOURCE
 
 TEST_PROGS := binfmt_script non-regular
 TEST_GEN_PROGS := execveat load_address_4096 load_address_2097152 load_address_16777216
-TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir pipe
+TEST_GEN_FILES := execveat.symlink execveat.denatured script subdir
 # Makefile is a run-time dependency, since it's accessed by the execveat test
 TEST_FILES := Makefile
 


