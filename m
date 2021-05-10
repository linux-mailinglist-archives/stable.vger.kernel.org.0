Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F098B3787E4
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235551AbhEJLTo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:19:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:34812 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234573AbhEJLEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 36EE16192C;
        Mon, 10 May 2021 10:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644097;
        bh=C6LzDeT77xCN7lbU3u03G5Ls4LwvgmbO3cY/DTI8pvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUT0AqsxwvaQys0eHCOJ1UvimgIye20IhzRkxk264g+qQAA0F4uGu52zikcgqWUmT
         0PK6wjPGgnYQeuVxry2hovzfOxC5rEFhcTEFkk6CfzdtiUCIOv3bEwkh7XrOcKdZD7
         tMC1opjBp/lUJvSWnArP/9vpmdlcJ8Be/9WXbCMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, youling257 <youling257@gmail.com>,
        Kurt Garloff <kurt@garloff.de>,
        Bingsong Si <owen.si@ucloud.cn>,
        "Artem S. Tashkinov" <aros@gmx.com>,
        Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>,
        Chen Yu <yu.c.chen@intel.com>, Len Brown <len.brown@intel.com>,
        Salvatore Bonaccorso <carnil@debian.org>,
        Terry Bowman <terry.bowman@amd.com>
Subject: [PATCH 5.11 251/342] tools/power/turbostat: Fix turbostat for AMD Zen CPUs
Date:   Mon, 10 May 2021 12:20:41 +0200
Message-Id: <20210510102018.386487977@linuxfoundation.org>
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

From: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>

commit 301b1d3a9104f4f3a8ab4171cf88d0f55d632b41 upstream.

It was reported that on Zen+ system turbostat started exiting,
which was tracked down to the MSR_PKG_ENERGY_STAT read failing because
offset_to_idx wasn't returning a non-negative index.

This patch combined the modification from Bingsong Si and
Bas Nieuwenhuizen and addd the MSR to the index system as alternative for
MSR_PKG_ENERGY_STATUS.

Fixes: 9972d5d84d76 ("tools/power turbostat: Enable accumulate RAPL display")
Reported-by: youling257 <youling257@gmail.com>
Tested-by: youling257 <youling257@gmail.com>
Tested-by: Kurt Garloff <kurt@garloff.de>
Tested-by: Bingsong Si <owen.si@ucloud.cn>
Tested-by: Artem S. Tashkinov <aros@gmx.com>
Co-developed-by: Bingsong Si <owen.si@ucloud.cn>
Co-developed-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
Reviewed-by: Chen Yu <yu.c.chen@intel.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/power/x86/turbostat/turbostat.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -297,7 +297,10 @@ int idx_to_offset(int idx)
 
 	switch (idx) {
 	case IDX_PKG_ENERGY:
-		offset = MSR_PKG_ENERGY_STATUS;
+		if (do_rapl & RAPL_AMD_F17H)
+			offset = MSR_PKG_ENERGY_STAT;
+		else
+			offset = MSR_PKG_ENERGY_STATUS;
 		break;
 	case IDX_DRAM_ENERGY:
 		offset = MSR_DRAM_ENERGY_STATUS;
@@ -326,6 +329,7 @@ int offset_to_idx(int offset)
 
 	switch (offset) {
 	case MSR_PKG_ENERGY_STATUS:
+	case MSR_PKG_ENERGY_STAT:
 		idx = IDX_PKG_ENERGY;
 		break;
 	case MSR_DRAM_ENERGY_STATUS:
@@ -353,7 +357,7 @@ int idx_valid(int idx)
 {
 	switch (idx) {
 	case IDX_PKG_ENERGY:
-		return do_rapl & RAPL_PKG;
+		return do_rapl & (RAPL_PKG | RAPL_AMD_F17H);
 	case IDX_DRAM_ENERGY:
 		return do_rapl & RAPL_DRAM;
 	case IDX_PP0_ENERGY:


