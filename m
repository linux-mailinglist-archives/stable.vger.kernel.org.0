Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089E322D554
	for <lists+stable@lfdr.de>; Sat, 25 Jul 2020 08:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgGYGEl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jul 2020 02:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726273AbgGYGEk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jul 2020 02:04:40 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 930E6C0619D3;
        Fri, 24 Jul 2020 23:04:40 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 11so10762763qkn.2;
        Fri, 24 Jul 2020 23:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8vmqEFkkhuc83ajpghYQrC7IIiCrJVCK+qai3kO/Nh0=;
        b=n/Y556oHtWThq9k02J6p4NlstrrUlu24H0ROko8CgA1zXORv+Ci/GmaMf6LIhl6KJT
         tStzU6gS7onMVs0zYdmAkRMkjoxtzI+UYPMb2XPiRBLwQzhuF24jWPtYhJhuX/9k1jv9
         m8E0WdZ08rHy7tOA5SUNDFDCnA4mAHHgnSzSJP7iXMNmC5/PZEIVaalR0cgESK+xPALa
         vUqaXhGHioWuxMjmTVY+n/GNmutb5z80yK2upN/VaqPXsFjNx4zmgTDxWXD/8KdLcW94
         9O/Zmt5PAvkaeo3wWVfVv9yTNvk6vjKDm4y2CFJewiNzhD5VA3rtfttrnO4/t6opxFIa
         K8+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8vmqEFkkhuc83ajpghYQrC7IIiCrJVCK+qai3kO/Nh0=;
        b=C8+NG0Z9VWb2CItELS8+Mh2wGJSgwTBIXFow6SbIoVoKW5+YZ+LoplBUVkSGXrJ++b
         JsgVK85t+uXrdU5KwTnYsmvxOVzv0RNSlTARhEPIosaOp83HQ3un2nSbxXgA70Cz8Z5R
         GcndZpUOuHhCu3oRprC2s5njn314yShLkviPRPepNDFnzEJnnHKbUhvGuK0wPTwStz4q
         yypXmAqpO5iMU6M7CW+3KhFf8J4qkrFv/iOzHRT68zZhHNgQMo49dvDkhpDUO4yQ+tGS
         sX26hnpLX57bd0bbJ1JSQQJrOZBQnmxk7wYgKJrsxoLjO2rCcZJseH9V5XuCfo3ctBU/
         DFXg==
X-Gm-Message-State: AOAM533vbkZHx+FDRgkXaubElkNII3oIADdpzbw/b8BE1TTBhlwP8WHg
        fUK2yqMZ24rM7NHOJEUFwFo=
X-Google-Smtp-Source: ABdhPJwtnnHQ01RLq4pKY3XEJgGBDv5enPBTjDkFUg+CjpA0ZhCxkTrCrY0MA/XzPplnVHpP3xrmJQ==
X-Received: by 2002:a05:620a:22b4:: with SMTP id p20mr13437598qkh.340.1595657079586;
        Fri, 24 Jul 2020 23:04:39 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:45d1:2600::1])
        by smtp.gmail.com with ESMTPSA id 139sm9781548qkl.13.2020.07.24.23.04.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2020 23:04:38 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Minas Harutyunyan <hminas@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <felipe.balbi@linux.intel.com>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH] usb: dwc2: Fix parameter type in function pointer prototype
Date:   Fri, 24 Jul 2020 23:03:54 -0700
Message-Id: <20200725060354.177009-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.28.0.rc1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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

Cc: stable@vger.kernel.org
Fixes: 7de1debcd2de ("usb: dwc2: Remove platform static params")
Link: https://github.com/ClangBuiltLinux/linux/issues/1107
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/usb/dwc2/params.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/dwc2/params.c b/drivers/usb/dwc2/params.c
index ce736d67c7c3..fd73ddd8eb75 100644
--- a/drivers/usb/dwc2/params.c
+++ b/drivers/usb/dwc2/params.c
@@ -860,7 +860,7 @@ int dwc2_get_hwparams(struct dwc2_hsotg *hsotg)
 int dwc2_init_params(struct dwc2_hsotg *hsotg)
 {
 	const struct of_device_id *match;
-	void (*set_params)(void *data);
+	void (*set_params)(struct dwc2_hsotg *data);
 
 	dwc2_set_default_params(hsotg);
 	dwc2_get_device_properties(hsotg);

base-commit: 23ee3e4e5bd27bdbc0f1785eef7209ce872794c7
-- 
2.28.0.rc1

