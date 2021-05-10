Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 088C637884D
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239137AbhEJLVJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236927AbhEJLLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24A8061490;
        Mon, 10 May 2021 11:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644753;
        bh=+wccCjzA60YTh/aYIuzJXLgDe3FSQk+9jQJ1eYJtsCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOTSqp5Eris1qNmBsbtJ0CJoaVNFbstUfEe2NaHSo8IUmluamuNRUj8m6/X2ikJ2h
         VfSvHQAhjBTNd55RBCz8HLh2dl67ckWuN235uvxUQhTppBvvKGzT7FjiAK8ELwbCJG
         8V3iClOoLozw7J1LB4Od9M8uk9glUuV4xAw2dpvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 210/384] selftests/resctrl: Fix missing options "-n" and "-p"
Date:   Mon, 10 May 2021 12:19:59 +0200
Message-Id: <20210510102021.816463520@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
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



