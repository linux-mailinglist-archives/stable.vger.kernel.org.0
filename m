Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 883AD333048
	for <lists+stable@lfdr.de>; Tue,  9 Mar 2021 21:52:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhCIUvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Mar 2021 15:51:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231863AbhCIUvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Mar 2021 15:51:13 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C138CC061760
        for <stable@vger.kernel.org>; Tue,  9 Mar 2021 12:51:12 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id jt13so31671008ejb.0
        for <stable@vger.kernel.org>; Tue, 09 Mar 2021 12:51:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gWcqe+g4PYvymlA7EinAD2uSQgU+3l68r0HRW1HJRww=;
        b=crrbLNlQsrwE5LqsAy+1poy/6Ac6lfVlWoix+jdBu3iWgoNmnANhkpg8cyIQf9GUOE
         bYjtzXXamzIoCBBS/cfqfNJglpksRte2VZDslKuNjWe/4xuhwspYqUOHhSdZQ1Rfoinp
         AxNT4t1fw9R3Pk370D2M/454sCONqE7vTewfo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gWcqe+g4PYvymlA7EinAD2uSQgU+3l68r0HRW1HJRww=;
        b=ZTgT7eTDUrNXSS5LqbPQJ10B4f5nmIoTdfbozlMxLfMwRaoc0mcDH06Gsxjk1KyfEF
         /hL4R8uuUWmZcd+ILAvziuKBZ1r9/UHyhen06QfI5u3DUTHk7wI+zZlMkY+AbQdUcqeE
         FT/3FJfSKz9vrpz1sxLctZlpRuBZ6j1LifOH9lW7FyN/rl+67LgVh4RY/e0a+LBAi+R9
         p/yaV1lJIscwjl4KeVHX0PlOCygis9oAxjOLo8kTGMfHFSmdbSIMbCmtEMkXv8GLI2gy
         MaoAo01K2r97tOkP0CEPLPMQnH9AYfS1otojUuqnuo8Wi6nAJeiuelYuNrZiJkB7jszo
         J8fw==
X-Gm-Message-State: AOAM532XJjD76pLeS7SeT7sBnb47mrf6vBsy/DUJEaooQffff9+adtfS
        XDPMEnUF9Gk/mWbzACMPmRPfPcx6eS41EGR8
X-Google-Smtp-Source: ABdhPJxA5gE3B9NFp5PkqdN0pK/gj7+CwSk1Uy/wi/8Bp89EhqExlMOpBEbEGsjaXieJIlj/0qPXMw==
X-Received: by 2002:a17:906:150f:: with SMTP id b15mr13427176ejd.363.1615323071549;
        Tue, 09 Mar 2021 12:51:11 -0800 (PST)
Received: from alco.lan ([80.71.134.83])
        by smtp.gmail.com with ESMTPSA id mc10sm8861190ejb.56.2021.03.09.12.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Mar 2021 12:51:11 -0800 (PST)
From:   Ricardo Ribalda <ribalda@chromium.org>
To:     Tomasz Figa <tfiga@chromium.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Ricardo Ribalda <ribalda@chromium.org>, stable@vger.kernel.org
Subject: [PATCH 1/2] lib/scatterlist: Fix NULL pointer deference
Date:   Tue,  9 Mar 2021 21:51:07 +0100
Message-Id: <20210309205108.997166-1-ribalda@chromium.org>
X-Mailer: git-send-email 2.30.1.766.gb4fecdf3b7-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When sg_alloc_table_from_pages is called with n_pages = 0, we write in a
non-allocated page. Fix it by checking early the error condition.

[    7.666801] BUG: kernel NULL pointer dereference, address: 0000000000000010
[    7.667487] #PF: supervisor read access in kernel mode
[    7.667970] #PF: error_code(0x0000) - not-present page
[    7.668448] PGD 0 P4D 0
[    7.668690] Oops: 0000 [#1] SMP NOPTI
[    7.669037] CPU: 0 PID: 184 Comm: modprobe Not tainted 5.11.0+ #2
[    7.669606] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
[    7.670378] RIP: 0010:__sg_alloc_table_from_pages+0x2c5/0x4a0
[    7.670924] Code: c9 01 48 c7 40 08 00 00 00 00 48 89 08 8b 47 0c 41 8d 44 00 ff 89 47 0c 48 81 fa 00 f0 ff ff 0f 87 d4 01 00 00 49 8b 16 89 d8 <4a> 8b 74 fd 00 4c 89 d1 44 29 f8 c1 e0 0c 44 29 d8 4c 39 d0 48 0f
[    7.672643] RSP: 0018:ffffba1e8028fb30 EFLAGS: 00010287
[    7.673133] RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000002
[    7.673791] RDX: 0000000000000002 RSI: ffffffffada6d0ba RDI: ffff9afe01fff820
[    7.674448] RBP: 0000000000000010 R08: 0000000000000001 R09: 0000000000000001
[    7.675100] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[    7.675754] R13: 00000000fffff000 R14: ffff9afe01fff800 R15: 0000000000000000
[    7.676409] FS:  00007fb0f448f540(0000) GS:ffff9afe07a00000(0000) knlGS:0000000000000000
[    7.677151] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    7.677681] CR2: 0000000000000010 CR3: 0000000002184001 CR4: 0000000000370ef0
[    7.678342] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[    7.679019] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[    7.680349] Call Trace:
[    7.680605]  ? device_add+0x146/0x810
[    7.681021]  sg_alloc_table_from_pages+0x11/0x30
[    7.681511]  vb2_dma_sg_alloc+0x162/0x280 [videobuf2_dma_sg]

Cc: stable@vger.kernel.org
Fixes: efc42bc98058 ("scatterlist: add sg_alloc_table_from_pages function")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
---
 lib/scatterlist.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/scatterlist.c b/lib/scatterlist.c
index a59778946404..1e83b6a3d930 100644
--- a/lib/scatterlist.c
+++ b/lib/scatterlist.c
@@ -435,6 +435,9 @@ struct scatterlist *__sg_alloc_table_from_pages(struct sg_table *sgt,
 	unsigned int added_nents = 0;
 	struct scatterlist *s = prv;
 
+	if (n_pages == 0)
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * The algorithm below requires max_segment to be aligned to PAGE_SIZE
 	 * otherwise it can overshoot.
-- 
2.30.1.766.gb4fecdf3b7-goog

