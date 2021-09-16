Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D98940E373
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:20:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245492AbhIPQsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:48:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:57528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344721AbhIPQqi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:46:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC33E601FA;
        Thu, 16 Sep 2021 16:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809599;
        bh=2K+jeZhi6NWGxwSm3736qe8/WFfuxqbpxEPeczVvA9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xv9DptAN42U28yRYQ3isCD/rksikPkptu7QtR8wg6o5SfLz8iThRdmoNM/5xy+YG4
         3/mcz+miuynQ+QMniiShUP5vKq90dj9uDV5FH235mh0e2c0kCoi1H5O4wggv2n8ahT
         yMwuPo1gkQGUCq6dUEld5t+zDhqv6KFHtuU7bzWs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 181/380] selftests: firmware: Fix ignored return val of asprintf() warn
Date:   Thu, 16 Sep 2021 17:58:58 +0200
Message-Id: <20210916155810.233553247@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



