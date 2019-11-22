Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9298107113
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728129AbfKVKen (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:34:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727563AbfKVKen (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:34:43 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 18F4220656;
        Fri, 22 Nov 2019 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574418882;
        bh=BpAp6XH2uSlXE1JsPhrWmKuprZOOpZwsT4hO8c9rf1g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S+vXuF2H9iDw5RQnxKMKXynjRlDp6TkJs0DdzYJaOOTd4/1NeD6rAu/j3JScFY4g8
         2YHjh1bKPKAb6Ozt/ChtEmois1Y0zOZhJKTXeDfLaCdgS2za69FVojtqxZU4sA+src
         jjRS0zdJVnsNoMCa9jQYxiRnK97OJoFgVl1/H2JE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 085/159] misc: kgdbts: Fix restrict error
Date:   Fri, 22 Nov 2019 11:27:56 +0100
Message-Id: <20191122100808.326794878@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100704.194776704@linuxfoundation.org>
References: <20191122100704.194776704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laura Abbott <labbott@redhat.com>

[ Upstream commit fa0218ef733e6f247a1a3986e3eb12460064ac77 ]

kgdbts current fails when compiled with restrict:

drivers/misc/kgdbts.c: In function ‘configure_kgdbts’:
drivers/misc/kgdbts.c:1070:2: error: ‘strcpy’ source argument is the same as destination [-Werror=restrict]
  strcpy(config, opt);
  ^~~~~~~~~~~~~~~~~~~

As the error says, config is being used in both the source and destination.
Refactor the code to avoid the extra copy and put the parsing closer to
the actual location.

Signed-off-by: Laura Abbott <labbott@redhat.com>
Acked-by: Daniel Thompson <daniel.thompson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/kgdbts.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index bb3a76ad80da2..fc8cb855c6e66 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -979,6 +979,12 @@ static void kgdbts_run_tests(void)
 	int nmi_sleep = 0;
 	int i;
 
+	verbose = 0;
+	if (strstr(config, "V1"))
+		verbose = 1;
+	if (strstr(config, "V2"))
+		verbose = 2;
+
 	ptr = strchr(config, 'F');
 	if (ptr)
 		fork_test = simple_strtol(ptr + 1, NULL, 10);
@@ -1062,13 +1068,6 @@ static int kgdbts_option_setup(char *opt)
 		return -ENOSPC;
 	}
 	strcpy(config, opt);
-
-	verbose = 0;
-	if (strstr(config, "V1"))
-		verbose = 1;
-	if (strstr(config, "V2"))
-		verbose = 2;
-
 	return 0;
 }
 
@@ -1080,9 +1079,6 @@ static int configure_kgdbts(void)
 
 	if (!strlen(config) || isspace(config[0]))
 		goto noconfig;
-	err = kgdbts_option_setup(config);
-	if (err)
-		goto noconfig;
 
 	final_ack = 0;
 	run_plant_and_detach_test(1);
-- 
2.20.1



