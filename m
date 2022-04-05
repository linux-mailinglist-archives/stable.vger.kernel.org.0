Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29BA34F278B
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 10:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233284AbiDEIH0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:07:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233089AbiDEH4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:56:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 904C13A5EC;
        Tue,  5 Apr 2022 00:50:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C8D961725;
        Tue,  5 Apr 2022 07:50:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94C49C340EE;
        Tue,  5 Apr 2022 07:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649145041;
        bh=Jc+JzbY33FN9h8pyG2ldw03fJ9OJVncRfFwxDY8PMaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZIw8S9Y5hsGxKSrGLlZ/bNJku5LnQdtdL07OiKrA/n4nZVIVeqKyQUInXpLCk/dIH
         7GtZsRgQ2qxXqEFN70KSe7OM9MPIVwYT/dNRtefR5KPd1qGPG9eAQLkiLptMi34kCh
         iL5RDbIMOLYcLLukEUnv4q/8Dx3BhOyj2XINZvOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "kernelci.org bot" <bot@kernelci.org>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 0224/1126] selftests/x86: Add validity check and allow field splitting
Date:   Tue,  5 Apr 2022 09:16:11 +0200
Message-Id: <20220405070414.184138002@linuxfoundation.org>
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

From: Muhammad Usama Anjum <usama.anjum@collabora.com>

[ Upstream commit b06e15ebd5bfb670f93c7f11a29b8299c1178bc6 ]

Add check to test if CC has a string. CC can have multiple sub-strings
like "ccache gcc". Erorr pops up if it is treated as single string and
double quotes are used around it. This can be fixed by removing the
quotes and not treating CC as a single string.

Fixes: e9886ace222e ("selftests, x86: Rework x86 target architecture detection")
Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20220214184109.3739179-2-usama.anjum@collabora.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/x86/check_cc.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/x86/check_cc.sh b/tools/testing/selftests/x86/check_cc.sh
index 3e2089c8cf54..8c669c0d662e 100755
--- a/tools/testing/selftests/x86/check_cc.sh
+++ b/tools/testing/selftests/x86/check_cc.sh
@@ -7,7 +7,7 @@ CC="$1"
 TESTPROG="$2"
 shift 2
 
-if "$CC" -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
+if [ -n "$CC" ] && $CC -o /dev/null "$TESTPROG" -O0 "$@" 2>/dev/null; then
     echo 1
 else
     echo 0
-- 
2.34.1



