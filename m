Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 028DDCA9C1
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405136AbfJCQrV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:47:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:60884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393024AbfJCQrV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:47:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 08D5C2070B;
        Thu,  3 Oct 2019 16:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121240;
        bh=A5X2Og1r81lOw6mPlGwfMS/sB3j/vqTSU+w3envdz6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R/8jWroqudHt+Qa/k8aKWk20ygmAkoK6YKMu2Zersc4apHyyl/bRc86t0YqAlxw92
         CBR8NLNt3fURBbk4dMG4QzOKHYJf9cmkt3yNq1WQDiuxD3Zevi5JUt3/OE5+wsreGd
         VGxc1txdERVAVDYwiGBFV4Z28HnqE5CwFgIu10uE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        David Arcari <darcari@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 206/344] tools/power/x86/intel-speed-select: Fix memory leak
Date:   Thu,  3 Oct 2019 17:52:51 +0200
Message-Id: <20191003154600.609328069@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



