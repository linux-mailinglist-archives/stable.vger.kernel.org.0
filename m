Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 375F4404E2C
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239526AbhIIMKV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:10:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344436AbhIIMG2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:06:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D765E6124F;
        Thu,  9 Sep 2021 11:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188050;
        bh=2K+jeZhi6NWGxwSm3736qe8/WFfuxqbpxEPeczVvA9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0EpBVsYYj0wtdVDrHaxTcqz81wKc3I2jpp/kw+6VmNavE4bAAorE/8xCPWnfbVfg
         CXNEPPb2UAw4ZXPbOB++TphW5xhP+0GTu5AhspU8bMnrnESTnqDrpKLIfrFM8Ic5nD
         uSeSWwJ/JwIiASIVtKdlYzzaQkmNZEqEGXxRaf9Q5ykP/5b18Li8ICfx8QwdWURqiG
         4Kr1GjbNRl798uzbgIYV4U4gtlF1cd8my5uhtQpefswkCnpxXzwqojye2QaT6M5r5p
         LmIH0Uf0u08X0KmajB0ukbw+BNwfN49fQM7ks6KMXcj4LLMD+ZTISsgZpkdECExt4Y
         I+oImYWg6fBtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 043/219] selftests: firmware: Fix ignored return val of asprintf() warn
Date:   Thu,  9 Sep 2021 07:43:39 -0400
Message-Id: <20210909114635.143983-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114635.143983-1-sashal@kernel.org>
References: <20210909114635.143983-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shuah Khan <skhan@linuxfoundation.org>

[ Upstream commit fe968ca2cac91888310b143a483123c84906e3fc ]

Fix the following ingonred return val of asprintf() warn during
build:

cc -Wall -O2    fw_namespace.c  -o ../tools/testing/selftests/firmware/fw_namespace
fw_namespace.c: In function ‘main’:
fw_namespace.c:132:2: warning: ignoring return value of ‘asprintf’ declared with attribute ‘warn_unused_result’ [-Wunused-result]
  132 |  asprintf(&fw_path, "/lib/firmware/%s", fw_name);
      |  ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20210708031827.51293-1-skhan@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/firmware/fw_namespace.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/testing/selftests/firmware/fw_namespace.c b/tools/testing/selftests/firmware/fw_namespace.c
index 0e393cb5f42d..4c6f0cd83c5b 100644
--- a/tools/testing/selftests/firmware/fw_namespace.c
+++ b/tools/testing/selftests/firmware/fw_namespace.c
@@ -129,7 +129,8 @@ int main(int argc, char **argv)
 		die("mounting tmpfs to /lib/firmware failed\n");
 
 	sys_path = argv[1];
-	asprintf(&fw_path, "/lib/firmware/%s", fw_name);
+	if (asprintf(&fw_path, "/lib/firmware/%s", fw_name) < 0)
+		die("error: failed to build full fw_path\n");
 
 	setup_fw(fw_path);
 
-- 
2.30.2

