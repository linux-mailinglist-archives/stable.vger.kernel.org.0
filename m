Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8EF329C664
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 19:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1826141AbgJ0SQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 14:16:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:33018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756199AbgJ0OL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:11:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5CD5022384;
        Tue, 27 Oct 2020 14:11:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807909;
        bh=QvSdFh5t0exaz47crqbjZDZ8bMrDoZY9J6D4p9jy+AE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aiOf5Pw1pk0lttqrqwekVQW1D99OsG+9+bgM/tzifZq7ooiFqK8GXOD7hD1klk3Ms
         hyJPI5TOjXWbBGzfBf/3EbzXYjCbKvCMk9hwx9l/WKqhSF82iHZ/6DnUC5FIwCD+mA
         fkcpRlgudfbHAfsiVgPYluuaUW4DctdRZJgvSGqM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        Felipe Balbi <balbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 069/191] usb: dwc2: Fix parameter type in function pointer prototype
Date:   Tue, 27 Oct 2020 14:48:44 +0100
Message-Id: <20201027134913.050809157@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134909.701581493@linuxfoundation.org>
References: <20201027134909.701581493@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <natechancellor@gmail.com>

[ Upstream commit 362b9398c962c9ec563653444e15ef9032ef3a90 ]

When booting up on a Raspberry Pi 4 with Control Flow Integrity checking
enabled, the following warning/panic happens:

[    1.626435] CFI failure (target: dwc2_set_bcm_params+0x0/0x4):
[    1.632408] WARNING: CPU: 0 PID: 32 at kernel/cfi.c:30 __cfi_check_fail+0x54/0x5c
[    1.640021] Modules linked in:
[    1.643137] CPU: 0 PID: 32 Comm: kworker/0:1 Not tainted 5.8.0-rc6-next-20200724-00051-g89ba619726de #1
[    1.652693] Hardware name: Raspberry Pi 4 Model B Rev 1.2 (DT)
[    1.658637] Workqueue: events deferred_probe_work_func
[    1.663870] pstate: 60000005 (nZCv daif -PAN -UAO BTYPE=--)
[    1.669542] pc : __cfi_check_fail+0x54/0x5c
[    1.673798] lr : __cfi_check_fail+0x54/0x5c
[    1.678050] sp : ffff8000102bbaa0
[    1.681419] x29: ffff8000102bbaa0 x28: ffffab09e21c7000
[    1.686829] x27: 0000000000000402 x26: ffff0000f6e7c228
[    1.692238] x25: 00000000fb7cdb0d x24: 0000000000000005
[    1.697647] x23: ffffab09e2515000 x22: ffffab09e069a000
[    1.703055] x21: 4c550309df1cf4c1 x20: ffffab09e2433c60
[    1.708462] x19: ffffab09e160dc50 x18: ffff0000f6e8cc78
[    1.713870] x17: 0000000000000041 x16: ffffab09e0bce6f8
[    1.719278] x15: ffffab09e1c819b7 x14: 0000000000000003
[    1.724686] x13: 00000000ffffefff x12: 0000000000000000
[    1.730094] x11: 0000000000000000 x10: 00000000ffffffff
[    1.735501] x9 : c932f7abfc4bc600 x8 : c932f7abfc4bc600
[    1.740910] x7 : 077207610770075f x6 : ffff0000f6c38f00
[    1.746317] x5 : 0000000000000000 x4 : 0000000000000000
[    1.751723] x3 : 0000000000000000 x2 : 0000000000000000
[    1.757129] x1 : ffff8000102bb7d8 x0 : 0000000000000032
[    1.762539] Call trace:
[    1.765030]  __cfi_check_fail+0x54/0x5c
[    1.768938]  __cfi_check+0x5fa6c/0x66afc
[    1.772932]  dwc2_init_params+0xd74/0xd78
[    1.777012]  dwc2_driver_probe+0x484/0x6ec
[    1.781180]  platform_drv_probe+0xb4/0x100
[    1.785350]  really_probe+0x228/0x63c
[    1.789076]  driver_probe_device+0x80/0xc0
[    1.793247]  __device_attach_driver+0x114/0x160
[    1.797857]  bus_for_each_drv+0xa8/0x128
[    1.801851]  __device_attach.llvm.14901095709067289134+0xc0/0x170
[    1.808050]  bus_probe_device+0x44/0x100
[    1.812044]  deferred_probe_work_func+0x78/0xb8
[    1.816656]  process_one_work+0x204/0x3c4
[    1.820736]  worker_thread+0x2f0/0x4c4
[    1.824552]  kthread+0x174/0x184
[    1.827837]  ret_from_fork+0x10/0x18

CFI validates that all indirect calls go to a function with the same
exact function pointer prototype. In this case, dwc2_set_bcm_params
is the target, which has a parameter of type 'struct dwc2_hsotg *',
but it is being implicitly cast to have a parameter of type 'void *'
because that is the set_params function pointer prototype. Make the
function pointer protoype match the definitions so that there is no
more violation.

Fixes: 7de1debcd2de ("usb: dwc2: Remove platform static params")
Link: https://github.com/ClangBuiltLinux/linux/issues/1107
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
Signed-off-by: Felipe Balbi <balbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/dwc2/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/params.c b/drivers/usb/dwc2/params.c
index a3ffe97170ffd..cf6ff8bfd7f61 100644
--- a/drivers/usb/dwc2/params.c
+++ b/drivers/usb/dwc2/params.c
@@ -711,7 +711,7 @@ int dwc2_get_hwparams(struct dwc2_hsotg *hsotg)
 int dwc2_init_params(struct dwc2_hsotg *hsotg)
 {
 	const struct of_device_id *match;
-	void (*set_params)(void *data);
+	void (*set_params)(struct dwc2_hsotg *data);
 
 	dwc2_set_default_params(hsotg);
 	dwc2_get_device_properties(hsotg);
-- 
2.25.1



