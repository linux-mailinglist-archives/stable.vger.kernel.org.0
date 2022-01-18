Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788FD492AB2
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:12:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346531AbiARQMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:12:36 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:40572 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347067AbiARQK5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:10:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89D52612D3;
        Tue, 18 Jan 2022 16:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52345C36AEB;
        Tue, 18 Jan 2022 16:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642522256;
        bh=euUqpoJamjbQtoMt2wX7hkoWVdt15chwwxCFqoDKJu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vH7MrSOvMbw3a9j6d1QOn+Xmts+wR+rnA+OEi1/nomr/i5z9RKXitQVGex5O88AB1
         61HCl9GFJD9noJw1Z9jfPfqvpBH/R4oMM3gt/MDn2SDzsSl1rcVTGBzE1pLaWt2qbN
         emM61Zlh+x/nzifnTFDpFoe0CMQ66Uhv/P95xHTM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: [PATCH 5.16 04/28] remoteproc: qcom: pil_info: Dont memcpy_toio more than is provided
Date:   Tue, 18 Jan 2022 17:05:59 +0100
Message-Id: <20220118160452.542527418@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

commit fdc12231d885119cc2e2b4f3e0fbba3155f37a56 upstream.

If the string passed into qcom_pil_info_store() isn't as long as
PIL_RELOC_NAME_LEN we'll try to copy the string assuming the length is
PIL_RELOC_NAME_LEN to the io space and go beyond the bounds of the
string. Let's only copy as many byes as the string is long, ignoring the
NUL terminator.

This fixes the following KASAN error:

 BUG: KASAN: global-out-of-bounds in __memcpy_toio+0x124/0x140
 Read of size 1 at addr ffffffd35086e386 by task rmtfs/2392

 CPU: 2 PID: 2392 Comm: rmtfs Tainted: G        W         5.16.0-rc1-lockdep+ #10
 Hardware name: Google Lazor (rev3+) with KB Backlight (DT)
 Call trace:
  dump_backtrace+0x0/0x410
  show_stack+0x24/0x30
  dump_stack_lvl+0x7c/0xa0
  print_address_description+0x78/0x2bc
  kasan_report+0x160/0x1a0
  __asan_report_load1_noabort+0x44/0x50
  __memcpy_toio+0x124/0x140
  qcom_pil_info_store+0x298/0x358 [qcom_pil_info]
  q6v5_start+0xdf0/0x12e0 [qcom_q6v5_mss]
  rproc_start+0x178/0x3a0
  rproc_boot+0x5f0/0xb90
  state_store+0x78/0x1bc
  dev_attr_store+0x70/0x90
  sysfs_kf_write+0xf4/0x118
  kernfs_fop_write_iter+0x208/0x300
  vfs_write+0x55c/0x804
  ksys_pwrite64+0xc8/0x134
  __arm64_compat_sys_aarch32_pwrite64+0xc4/0xdc
  invoke_syscall+0x78/0x20c
  el0_svc_common+0x11c/0x1f0
  do_el0_svc_compat+0x50/0x60
  el0_svc_compat+0x5c/0xec
  el0t_32_sync_handler+0xc0/0xf0
  el0t_32_sync+0x1a4/0x1a8

 The buggy address belongs to the variable:
  .str.59+0x6/0xffffffffffffec80 [qcom_q6v5_mss]

 Memory state around the buggy address:
  ffffffd35086e280: 00 00 00 00 02 f9 f9 f9 f9 f9 f9 f9 00 00 00 00
  ffffffd35086e300: 00 02 f9 f9 f9 f9 f9 f9 00 00 00 06 f9 f9 f9 f9
 >ffffffd35086e380: 06 f9 f9 f9 05 f9 f9 f9 00 00 00 00 00 06 f9 f9
                    ^
  ffffffd35086e400: f9 f9 f9 f9 01 f9 f9 f9 04 f9 f9 f9 00 00 01 f9
  ffffffd35086e480: f9 f9 f9 f9 00 00 00 00 00 00 00 01 f9 f9 f9 f9

Fixes: 549b67da660d ("remoteproc: qcom: Introduce helper to store pil info in IMEM")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20211117065454.4142936-1-swboyd@chromium.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/remoteproc/qcom_pil_info.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/remoteproc/qcom_pil_info.c
+++ b/drivers/remoteproc/qcom_pil_info.c
@@ -104,7 +104,7 @@ int qcom_pil_info_store(const char *imag
 	return -ENOMEM;
 
 found_unused:
-	memcpy_toio(entry, image, PIL_RELOC_NAME_LEN);
+	memcpy_toio(entry, image, strnlen(image, PIL_RELOC_NAME_LEN));
 found_existing:
 	/* Use two writel() as base is only aligned to 4 bytes on odd entries */
 	writel(base, entry + PIL_RELOC_NAME_LEN);


