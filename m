Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5E247AFAD
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 16:17:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238149AbhLTPRW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 10:17:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238392AbhLTPPt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 10:15:49 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE451C110F1D;
        Mon, 20 Dec 2021 06:57:51 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E4306118D;
        Mon, 20 Dec 2021 14:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F260C36AE9;
        Mon, 20 Dec 2021 14:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640012270;
        bh=dBR9e+I1zPC7tFizqEuvHXiU4a6tTX8Z3InWUQg2uAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uzqrGrjmvbNBdWTwR7wqTMTOULUmocLwLXOlCDtx8QzJtC7E5Q0tw/i45DKllIUCG
         idz2wtNGHdqktb7QpAUD8y3UesRm0O6zALSdIJ6eImzpcrvSZG2BRTGCBlgUuNO2lf
         TIWiwBJOjm6W+tKiNyPxJBfNm1DlDsfqjTqMPpjA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        kernel test robot <lkp@intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/177] arm64: kexec: Fix missing error code ret warning in load_other_segments()
Date:   Mon, 20 Dec 2021 15:34:19 +0100
Message-Id: <20211220143043.744254897@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143040.058287525@linuxfoundation.org>
References: <20211220143040.058287525@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>

[ Upstream commit 9c5d89bc10551f1aecd768b00fca3339a7b8c8ee ]

Since commit ac10be5cdbfa ("arm64: Use common
of_kexec_alloc_and_setup_fdt()"), smatch reports the following warning:

  arch/arm64/kernel/machine_kexec_file.c:152 load_other_segments()
  warn: missing error code 'ret'

Return code is not set to an error code in load_other_segments() when
of_kexec_alloc_and_setup_fdt() call returns a NULL dtb. This results
in status success (return code set to 0) being returned from
load_other_segments().

Set return code to -EINVAL if of_kexec_alloc_and_setup_fdt() returns
NULL dtb.

Signed-off-by: Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: ac10be5cdbfa ("arm64: Use common of_kexec_alloc_and_setup_fdt()")
Link: https://lore.kernel.org/r/20211210010121.101823-1-nramas@linux.microsoft.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec_file.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 63634b4d72c15..59c648d518488 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -149,6 +149,7 @@ int load_other_segments(struct kimage *image,
 					   initrd_len, cmdline, 0);
 	if (!dtb) {
 		pr_err("Preparing for new dtb failed\n");
+		ret = -EINVAL;
 		goto out_err;
 	}
 
-- 
2.33.0



