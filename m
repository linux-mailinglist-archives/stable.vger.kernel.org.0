Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17B95489135
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:31:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233789AbiAJHaM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:30:12 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:56806 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239546AbiAJH2M (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:28:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 71DE2B8120F;
        Mon, 10 Jan 2022 07:28:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 905F1C36AE9;
        Mon, 10 Jan 2022 07:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1641799690;
        bh=9z4vPHpad6g3b7hVkTRWbqTSuWEc35ZyzvS9vo3vfAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nqE01NNCQp1+Ku4vmOnvTvG/ryKLrMCd+aXHVcpK9xWhfOkb8w1Jnh1hyFBcKmk2M
         PEAlZefE+0djqqmDod7PI3Hl/E7UQYnblxrX8Tbr87XjFg+uFJ1C1NtY8lpxnT1nJr
         G/WG9R+CV/PNPZSEDGzaqPjeu8969dy31/UzDprw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: [PATCH 5.4 03/34] selftests: x86: fix [-Wstringop-overread] warn in test_process_vm_readv()
Date:   Mon, 10 Jan 2022 08:22:58 +0100
Message-Id: <20220110071815.771538163@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
References: <20220110071815.647309738@linuxfoundation.org>
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
@@ -480,7 +480,7 @@ static int test_process_vm_readv(void)
 	}
 
 	if (vsyscall_map_r) {
-		if (!memcmp(buf, (const void *)0xffffffffff600000, 4096)) {
+		if (!memcmp(buf, remote.iov_base, sizeof(buf))) {
 			printf("[OK]\tIt worked and read correct data\n");
 		} else {
 			printf("[FAIL]\tIt worked but returned incorrect data\n");


