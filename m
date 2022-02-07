Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40EE74ABD8C
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 13:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385522AbiBGLo5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:44:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385269AbiBGLb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:31:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07D35C0401C7;
        Mon,  7 Feb 2022 03:30:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 98E1960B65;
        Mon,  7 Feb 2022 11:30:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75386C3411F;
        Mon,  7 Feb 2022 11:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233405;
        bh=+nRe8g/tE2F5FU0y+dnQVbMd4p5XFCbxsci5pHSsjd4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmxPtNh7GwONMW8yA6DhoSFOeieeaHw6jebG3Gz7TzzGVBa0vQZrTONV5RFL5LUxr
         AP2D101cCwP07sL787mqsEqxg0fOgMaen95zcBJKuSjpN+8/8ArUlyKc1qJKFKorbO
         20wfF4+fNtJeEXgjWyzf/b1HlNqq1zCI64tdQ7U4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: [PATCH 5.15 087/110] selftests/exec: Remove pipe from TEST_GEN_FILES
Date:   Mon,  7 Feb 2022 12:07:00 +0100
Message-Id: <20220207103805.348313211@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103802.280120990@linuxfoundation.org>
References: <20220207103802.280120990@linuxfoundation.org>
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
 


