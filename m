Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A9B44050EC
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348707AbhIIMcq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:33230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353003AbhIIM1J (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:27:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F37F61B21;
        Thu,  9 Sep 2021 11:51:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188317;
        bh=reU0cyggiRXlCOoC8r79/ZpqbrPAprKiA8MNgItW210=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTOcTzT4x9NPu4Csku5lkQZ+7IrhPGniWTdPDB17vISSn/cMT3LMuLk4UwEcLAl4V
         CdEybsTYpVRDNiz5Dm19DluXexLm1o9Y5ISHQHNTeYX8Hx2k7y3G6kv23jmigIM7FP
         Gd48K/OR7/hqZNYVv3xITv1XP1cynft4iEg4v2Xd7q4lrVykct36pA47fNJd+C+8LB
         dwhkejuoRtVeKqjHnnKjeKpm3YEtaiA3l00q/jqkrz/lezoxceCoxiaosRfwOHp9oa
         DkmNv06DlT7uay3EEzKgXJhE4Ai2PjO1zkEmupD9GHGjw+CVs8K0SZeXGTYXxJRoog
         79vh8veGFj4hw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 031/176] selftests: firmware: Fix ignored return val of asprintf() warn
Date:   Thu,  9 Sep 2021 07:48:53 -0400
Message-Id: <20210909115118.146181-31-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 5ebc1aec7923..817b2f1e8ee6 100644
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

