Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76659414D45
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 17:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236340AbhIVPpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 11:45:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231712AbhIVPpT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 11:45:19 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FA52C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:43:49 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id v22so11120735edd.11
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 08:43:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGmWf9h2Oys9OTSYFZidnwcKqOl8xWLGshr0pceMPSU=;
        b=ABc/2iI5GCN0NwDQRC96K+bfa6suTzg6fEA0fs5j8uK5ch3T90WZ+r9A7WF6kCGW0C
         BC8cZrf4yY0ltP7OZo+ayl+uXkNfX9Bm0kcFDsZYu6WSf3VE99KNQZ3ymIIzvCBZaqJ3
         4PL00+CEHIjkq19YwTO3Lp/xLdq0K8FZZT/pxeL4/PSIr2MSPNTJSSC4dC1ajDEDFVeu
         PjY3GruBcmCu4ej3ohTFElT2zoo4xhMXHUOMPk+su13jmcJXd9uwj4eYuAuQH6sxnyNR
         UdMZVP7DcWOnGY9eR2YLqyV1RnPBXSScbspj17H/zo7Qh+Bin4i/E1NfHMOhXxz8iOIB
         BLxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=IGmWf9h2Oys9OTSYFZidnwcKqOl8xWLGshr0pceMPSU=;
        b=HoxMTVSKLfMe+YpH3im355/bVSAZXmvHnt2gpu8WWCdQGLSI5y11DxM6yr3p0iXqvc
         1DEBTbLAXkCElMqhf67brUOv+LFw+aRO9eMFweDvIcNp4wnVSYYpZMJXfWERn5bJkhCN
         ptUQOGaNmhinFC/zhdqvMGyU4obq4ys3jRAdx2xGUizTGNlBjPowUtkqLfcoSZ9Rqs9T
         AvGo0dH8F+T5uWXqeNl2VCekGiW+iAX5EWLiTIMDoLWg8luaLIbDdqvSmzWgdrib9gyk
         paS/2t41kIQos73aMkGMDgFcI1YBpVIjIENySOGnUGENRX4XN9b+JP5zKHvlmAvx5yzE
         bZbQ==
X-Gm-Message-State: AOAM533sfoZwi9NSsD06Cxfv2LQuxA6uNvZHP2xx3Fys5L0RRiY/4X3o
        9t9SaBw0TkRQ5RlSpWHFeLkhOBW8mqJZ9g==
X-Google-Smtp-Source: ABdhPJyqnmTOHx/so9QNWmsMPNxOP9gy6DaEat5ZIhQkedk1DkuD21mzeuQoiMYzO7pXQPyz5yRmQw==
X-Received: by 2002:a17:906:660f:: with SMTP id b15mr179146ejp.491.1632325425806;
        Wed, 22 Sep 2021 08:43:45 -0700 (PDT)
Received: from srini-hackbox.lan (cpc86377-aztw32-2-0-cust226.18-1.cable.virginm.net. [92.233.226.227])
        by smtp.gmail.com with ESMTPSA id ck10sm1382114edb.43.2021.09.22.08.43.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 08:43:45 -0700 (PDT)
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] misc: fastrpc: Add missing lock before accessing find_vma()
Date:   Wed, 22 Sep 2021 16:43:26 +0100
Message-Id: <20210922154326.8927-1-srinivas.kandagatla@linaro.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

fastrpc driver is using find_vma() without any protection, as a
result we see below warning due to recent patch 5b78ed24e8ec
("mm/pagemap: add mmap_assert_locked() annotations to find_vma*()")
which added mmap_assert_locked() in find_vma() function.

This bug went un-noticed in previous versions. Fix this issue by adding
required protection while calling find_vma().

CPU: 0 PID: 209746 Comm: benchmark_model Not tainted 5.15.0-rc2-00445-ge14fe2bf817a-dirty #969
Hardware name: Qualcomm Technologies, Inc. Robotics RB5 (DT)
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : find_vma+0x64/0xd0
lr : find_vma+0x60/0xd0
sp : ffff8000158ebc40
...

Call trace:
 find_vma+0x64/0xd0
 fastrpc_internal_invoke+0x570/0xda8
 fastrpc_device_ioctl+0x3e0/0x928
 __arm64_sys_ioctl+0xac/0xf0
 invoke_syscall+0x44/0x100
 el0_svc_common.constprop.3+0x70/0xf8
 do_el0_svc+0x24/0x88
 el0_svc+0x3c/0x138
 el0t_64_sync_handler+0x90/0xb8
 el0t_64_sync+0x180/0x184

Fixes: 80f3afd72bd4 ("misc: fastrpc: consider address offset before sending to DSP")
Cc: stable@vger.kernel.org
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
---
 drivers/misc/fastrpc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
index beda610e6b30..ad6ced454655 100644
--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -814,10 +814,12 @@ static int fastrpc_get_args(u32 kernel, struct fastrpc_invoke_ctx *ctx)
 			rpra[i].pv = (u64) ctx->args[i].ptr;
 			pages[i].addr = ctx->maps[i]->phys;
 
+			mmap_read_lock(current->mm);
 			vma = find_vma(current->mm, ctx->args[i].ptr);
 			if (vma)
 				pages[i].addr += ctx->args[i].ptr -
 						 vma->vm_start;
+			mmap_read_unlock(current->mm);
 
 			pg_start = (ctx->args[i].ptr & PAGE_MASK) >> PAGE_SHIFT;
 			pg_end = ((ctx->args[i].ptr + len - 1) & PAGE_MASK) >>
-- 
2.21.0

