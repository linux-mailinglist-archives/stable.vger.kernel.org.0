Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBBB37862C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234462AbhEJLEh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:52714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235002AbhEJK50 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F390619D2;
        Mon, 10 May 2021 10:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643856;
        bh=+wccCjzA60YTh/aYIuzJXLgDe3FSQk+9jQJ1eYJtsCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e7Zu5BM3pfTb12J8Xol0wwpJCDFx2m7DL5Jx7katqX4uE83kny1aR2eFPqd19HRjT
         bw9xYDQytGglGu/zF8YW/1OrMlS4GB/JhzkwQXSEs/x1zUdQfM0irvq3zSYBE8KJVo
         9Nve5wj/Kv+UDZfsIU8zjI1+e0KygsoaDuwZ7uwk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 188/342] selftests/resctrl: Fix missing options "-n" and "-p"
Date:   Mon, 10 May 2021 12:19:38 +0200
Message-Id: <20210510102016.302742504@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

[ Upstream commit d7af3d0d515cbdf63b6c3398a3c15ecb1bc2bd38 ]

resctrl test suite accepts command line arguments (like -b, -t, -n and -p)
as documented in the help. But passing -n and -p throws an invalid option
error. This happens because -n and -p are missing in the list of
characters that getopt() recognizes as valid arguments. Hence, they are
treated as invalid options.

Fix this by adding them to the list of characters that getopt() recognizes
as valid arguments. Please note that the main() function already has the
logic to deal with the values passed as part of these arguments and hence
no changes are needed there.

Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl_tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/resctrl/resctrl_tests.c b/tools/testing/selftests/resctrl/resctrl_tests.c
index 4b109a59f72d..ac2269610aa9 100644
--- a/tools/testing/selftests/resctrl/resctrl_tests.c
+++ b/tools/testing/selftests/resctrl/resctrl_tests.c
@@ -73,7 +73,7 @@ int main(int argc, char **argv)
 		}
 	}
 
-	while ((c = getopt(argc_new, argv, "ht:b:")) != -1) {
+	while ((c = getopt(argc_new, argv, "ht:b:n:p:")) != -1) {
 		char *token;
 
 		switch (c) {
-- 
2.30.2



