Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 747A03788CE
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhEJLYE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:24:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:46088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237318AbhEJLLt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 93A7861931;
        Mon, 10 May 2021 11:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644932;
        bh=C6LzDeT77xCN7lbU3u03G5Ls4LwvgmbO3cY/DTI8pvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=midzy1h5qz4EG5f3diggxN5NOgIPMFIy5DEzU265YLDHvG4tpf+0yn9ge2YgleGGy
         o7N+Dqkf7IKUldMeB+5qnUHsdqrPP30en9jTchzad885elb+BgLJp4h7CBEtw1j4YP
         UZPJ0tXnBckZ72hU/Uvn1mFyGNpFYDsTFmWeFGNo=
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
Subject: [PATCH 5.12 282/384] tools/power/turbostat: Fix turbostat for AMD Zen CPUs
Date:   Mon, 10 May 2021 12:21:11 +0200
Message-Id: <20210510102024.117262974@linuxfoundation.org>
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


