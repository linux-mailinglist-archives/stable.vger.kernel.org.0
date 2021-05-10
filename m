Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCA2A378629
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:30:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233954AbhEJLEX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:04:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234977AbhEJK5U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:57:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF177619C5;
        Mon, 10 May 2021 10:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643851;
        bh=zCIXw1C/sFH1de0h7EkCdQbVW7yzWhOzPy7vGicll/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=molx8U4dVGWJp7iEnB5glll4tjSpxqWRsPZHhbUEKAkl5cM8F9LTzzC7O6PB5dXbx
         fR/EJ4V/NndhG2akuxVgLyzcEgLLT68BQxCLB7EkkLvpXUeOuPywV03w9UIpTEKLRX
         T9w0viTsfWG3RE8yU6s623Gztk1QM0+Gn8GOSh0I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Reinette Chatre <reinette.chatre@intel.com>,
        Babu Moger <babu.moger@amd.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 186/342] selftests/resctrl: Fix compilation issues for other global variables
Date:   Mon, 10 May 2021 12:19:36 +0200
Message-Id: <20210510102016.232680707@linuxfoundation.org>
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

[ Upstream commit 896016d2ad051811ff9c9c087393adc063322fbc ]

Reinette reported following compilation issue on Fedora 32, gcc version
10.1.1

/usr/bin/ld: resctrl_tests.o:<src_dir>/resctrl.h:65: multiple definition
of `bm_pid'; cache.o:<src_dir>/resctrl.h:65: first defined here

Other variables are ppid, tests_run, llc_occup_path, is_amd. Compiler
isn't happy because these variables are defined globally in two .c files
but are not declared as extern.

To fix issues for the global variables, declare them as extern.

Chang Log:
- Split this patch from v4's patch 1 (Shuah).

Reported-by: Reinette Chatre <reinette.chatre@intel.com>
Tested-by: Babu Moger <babu.moger@amd.com>
Signed-off-by: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/resctrl/resctrl.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/resctrl/resctrl.h b/tools/testing/selftests/resctrl/resctrl.h
index 959c71e39bdc..12b77182cb44 100644
--- a/tools/testing/selftests/resctrl/resctrl.h
+++ b/tools/testing/selftests/resctrl/resctrl.h
@@ -62,11 +62,11 @@ struct resctrl_val_param {
 	int		(*setup)(int num, ...);
 };
 
-pid_t bm_pid, ppid;
-int tests_run;
+extern pid_t bm_pid, ppid;
+extern int tests_run;
 
-char llc_occup_path[1024];
-bool is_amd;
+extern char llc_occup_path[1024];
+extern bool is_amd;
 
 bool check_resctrlfs_support(void);
 int filter_dmesg(void);
-- 
2.30.2



