Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0432328DF3
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:22:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236045AbhCATVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:21:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241178AbhCATPS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:15:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EAEEE651BC;
        Mon,  1 Mar 2021 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618994;
        bh=E/xjog0OVqxHXt7s9wNYEhmoWkH1qiyAUbY2IKVwaWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RxFW4RF1R/X74zqgaOOgPzHj3Ah8+Ezn5XO7kRJiqwUvLyGp0585VWFg5J2VavjS
         hs6EEXGUCSKXZq6YukMnWmMWFRY8gI57NdDd8wrDtzLgY7Ks327NwLiAIerVhgMh1r
         qJE6oWUqBNyMRZTypxH4R9psHkX+k/KMFnz32eMI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Po-Hsu Lin <po-hsu.lin@canonical.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 263/663] selftests/powerpc: Make the test check in eeh-basic.sh posix compliant
Date:   Mon,  1 Mar 2021 17:08:31 +0100
Message-Id: <20210301161154.826745964@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Po-Hsu Lin <po-hsu.lin@canonical.com>

[ Upstream commit 3db380570af7052620ace20c29e244938610ca71 ]

The == operand is a bash extension, thus this will fail on Ubuntu
with:
  ./eeh-basic.sh: 89: test: 2: unexpected operator

As the /bin/sh on Ubuntu is pointed to DASH.

Use -eq to fix this posix compatibility issue.

Fixes: 996f9e0f93f162 ("selftests/powerpc: Fix eeh-basic.sh exit codes")
Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
Reviewed-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201228043459.14281-1-po-hsu.lin@canonical.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/powerpc/eeh/eeh-basic.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/powerpc/eeh/eeh-basic.sh b/tools/testing/selftests/powerpc/eeh/eeh-basic.sh
index 0d783e1065c86..64779f073e177 100755
--- a/tools/testing/selftests/powerpc/eeh/eeh-basic.sh
+++ b/tools/testing/selftests/powerpc/eeh/eeh-basic.sh
@@ -86,5 +86,5 @@ echo "$failed devices failed to recover ($dev_count tested)"
 lspci | diff -u $pre_lspci -
 rm -f $pre_lspci
 
-test "$failed" == 0
+test "$failed" -eq 0
 exit $?
-- 
2.27.0



