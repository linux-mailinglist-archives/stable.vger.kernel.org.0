Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4DC44891DF
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240772AbiAJHgw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:36:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240945AbiAJHea (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:34:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF34EC025393;
        Sun,  9 Jan 2022 23:29:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D4E1611BB;
        Mon, 10 Jan 2022 07:29:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E354C36AED;
        Mon, 10 Jan 2022 07:29:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799788;
        bh=amkLwSEaFB8ELixfHTAcmT95x8/YFpi2ur/98Fmnou8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UbtnyqRQws2EL4w7fjHK8pyzCAyTbvhCcIQOXSNPXSN2Y0zCMX9SyYCqfG1kgDKsg
         dJg4OklPG4d/lrk6X3PDbFyvkqBPIFmJGCtOE41obp9f8S3EOZi7Zc3pXcNMNwxei9
         rmWGPkXSWkue+8o4dxHurZOpmiIdKN3Nm9cku0C0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.10 02/43] selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()
Date:   Mon, 10 Jan 2022 08:22:59 +0100
Message-Id: <20220110071817.417485930@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071817.337619922@linuxfoundation.org>
References: <20220110071817.337619922@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

commit dd40f44eabe1e122c6852fabb298aac05b083fce upstream.

Fix the following [-Wstringop-overread] by passing in the variable
instead of the value.

test_vsyscall.c: In function ‘test_process_vm_readv’:
test_vsyscall.c:500:22: warning: ‘__builtin_memcmp_eq’ specified bound 4096 exceeds source size 0 [-Wstringop-overread]
  500 |                 if (!memcmp(buf, (const void *)0xffffffffff600000, 4096)) {
      |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/x86/test_vsyscall.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/tools/testing/selftests/x86/test_vsyscall.c
+++ b/tools/testing/selftests/x86/test_vsyscall.c
@@ -497,7 +497,7 @@ static int test_process_vm_readv(void)
 	}
 
 	if (vsyscall_map_r) {
-		if (!memcmp(buf, (const void *)0xffffffffff600000, 4096)) {
+		if (!memcmp(buf, remote.iov_base, sizeof(buf))) {
 			printf("[OK]\tIt worked and read correct data\n");
 		} else {
 			printf("[FAIL]\tIt worked but returned incorrect data\n");


