Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCE01BA63D
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391559AbfIVSsl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:48:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:45610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391711AbfIVSsl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:48:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B917F208C2;
        Sun, 22 Sep 2019 18:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178120;
        bh=A5X2Og1r81lOw6mPlGwfMS/sB3j/vqTSU+w3envdz6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fp/m5hM/Rw0duo9SmgsfuQGLex0xKJMuz1YHdqWlw9zURHLD+3eCfS7S9fWuyNvHo
         +dZinFnUAbXvmgozoaBleJnDyui9OsiZXCc29D4WBt1iH7538UfOm/avpERhPBsZnz
         8CqgupovYcZ5TefwPQY2EC9MVTg+vJXXB7xIdaoA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prarit Bhargava <prarit@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Arcari <darcari@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 176/203] tools/power/x86/intel-speed-select: Fix memory leak
Date:   Sun, 22 Sep 2019 14:43:22 -0400
Message-Id: <20190922184350.30563-176-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prarit Bhargava <prarit@redhat.com>

[ Upstream commit 3bc3d30ca324bfc3045a1a7fe1f5fe5ad5d92fd9 ]

cpumasks are allocated by calling the alloc_cpu_mask() function and are
never free'd.  They should be free'd after the commands have run.

Fix the memory leaks by calling free_cpu_set().

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: David Arcari <darcari@redhat.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/intel-speed-select/isst-config.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/tools/power/x86/intel-speed-select/isst-config.c b/tools/power/x86/intel-speed-select/isst-config.c
index 91c5ad1685a15..6a10dea01eefc 100644
--- a/tools/power/x86/intel-speed-select/isst-config.c
+++ b/tools/power/x86/intel-speed-select/isst-config.c
@@ -603,6 +603,10 @@ static int isst_fill_platform_info(void)
 
 	close(fd);
 
+	if (isst_platform_info.api_version > supported_api_ver) {
+		printf("Incompatible API versions; Upgrade of tool is required\n");
+		return -1;
+	}
 	return 0;
 }
 
@@ -1529,6 +1533,7 @@ static void cmdline(int argc, char **argv)
 {
 	int opt;
 	int option_index = 0;
+	int ret;
 
 	static struct option long_options[] = {
 		{ "cpu", required_argument, 0, 'c' },
@@ -1590,13 +1595,14 @@ static void cmdline(int argc, char **argv)
 	set_max_cpu_num();
 	set_cpu_present_cpu_mask();
 	set_cpu_target_cpu_mask();
-	isst_fill_platform_info();
-	if (isst_platform_info.api_version > supported_api_ver) {
-		printf("Incompatible API versions; Upgrade of tool is required\n");
-		exit(0);
-	}
+	ret = isst_fill_platform_info();
+	if (ret)
+		goto out;
 
 	process_command(argc, argv);
+out:
+	free_cpu_set(present_cpumask);
+	free_cpu_set(target_cpumask);
 }
 
 int main(int argc, char **argv)
-- 
2.20.1

