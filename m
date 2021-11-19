Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96241457353
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 17:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236634AbhKSQrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 11:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236641AbhKSQru (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 11:47:50 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FA40C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 08:44:49 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id p17so9141745pgj.2
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 08:44:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rivosinc-com.20210112.gappssmtp.com; s=20210112;
        h=subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding:cc:from:to;
        bh=SB6EgCTuUg8MJlUo+ml24NJI9nw+lDZjDHqU1EIISBQ=;
        b=xZBTX2fkClhsrAhAhHvzzo3gipmQJBe9KDtvFo2Al+JGruCpMlsfpmz+hHWMrOvMfv
         /CN0knlgAf9BQT/GfzTUnEpeNc+zQn6thds6pyjL/qxPhfTGCWm1TajlN3mY/hMKq3G1
         gbZy/bTOStCDE4xY7mN8NfhIwa49nLhVohe5Dtu56Y8EzjxkOus4igegCZM+ePXheS0U
         Y98Lac6ygTleo0oICOyMK/h8hDT5ayBcO5YwLn8al7NrFJQgymrth90UFq4ug6FB7HrZ
         Tk1G/fjf6w+EAGKJo1wChfVJcHIW/wTXacZUSPEScWlYuXufKzgXSx8NWcGvMGxfggsE
         uhJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding:cc:from:to;
        bh=SB6EgCTuUg8MJlUo+ml24NJI9nw+lDZjDHqU1EIISBQ=;
        b=NXeDEIFCDVTX/ypWZ2syBR0VyV1gcm8cIUvEoec/sH1GVYii60LBXrGr3HEjN7nqOo
         npORuFR/RlddJLGPAob3JCk+bzQsTYHtmvQ+5t309e2e7iaxUeoZTA1F0KXgXa1UHWI6
         w+zf2MnWtt4jxHMc45fV7mtkOntJwXccqyGA5JldhJCevL3EDXpL3rkZwAQzkZnsuM38
         Wdw7ZkG679DJSVOChOAv09JhJqLVUFSE6/Kb9HJjfMKqQ78q+JR4wjeNVFQmmrgaswGv
         oOEL+VFaqjakUmr+TAxAODLHz50ZRJSW6JVkw8vcICwn9Xt6yPEmrHZ3zQrzZlVk4yx5
         +JIQ==
X-Gm-Message-State: AOAM5303XldeSViIQ4fORmx0zjLyYe+RSnQhQkEUPrjQPtrBbgUDfbd6
        s4v1V0Ro8sFRUAVdhGsqukterg==
X-Google-Smtp-Source: ABdhPJzh8J4KCx4EO8kuEnK1oVC5fTwdJ/I9PGqYQcKUN1CBeBpJvZzXndIvprNjCMgwhkZQgvDsMA==
X-Received: by 2002:aa7:9af6:0:b0:4a2:fa4a:714c with SMTP id y22-20020aa79af6000000b004a2fa4a714cmr23848682pfp.40.1637340285451;
        Fri, 19 Nov 2021 08:44:45 -0800 (PST)
Received: from localhost (76-210-143-223.lightspeed.sntcca.sbcglobal.net. [76.210.143.223])
        by smtp.gmail.com with ESMTPSA id v10sm195914pfu.123.2021.11.19.08.44.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 08:44:44 -0800 (PST)
Subject: [PATCH 02/12] RISC-V: MAXPHYSMEM_2GB doesn't depend on CMODEL_MEDLOW
Date:   Fri, 19 Nov 2021 08:44:03 -0800
Message-Id: <20211119164413.29052-3-palmer@rivosinc.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211119164413.29052-1-palmer@rivosinc.com>
References: <20211119164413.29052-1-palmer@rivosinc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Cc:     Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>, aou@eecs.berkeley.edu,
        anup.patel@wdc.com, heinrich.schuchardt@canonical.com,
        atish.patra@wdc.com, bin.meng@windriver.com,
        sagar.kadam@sifive.com, damien.lemoal@wdc.com, axboe@kernel.dk,
        linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Palmer Dabbelt <palmer@rivosinc.com>, stable@vger.kernel.org
From:   Palmer Dabbelt <palmer@rivosinc.com>
To:         linux-riscv@lists.infradead.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Palmer Dabbelt <palmer@rivosinc.com>

For non-relocatable kernels we need to be able to link the kernel at
approximately PAGE_OFFSET, thus requiring medany (as medlow requires the
code to be linked within 2GiB of 0).  The inverse doesn't apply, though:
since medany code can be linked anywhere it's fine to link it close to
0, so we can support the smaller memory config.

Fixes: de5f4b8f634b ("RISC-V: Define MAXPHYSMEM_1GB only for RV32")
Cc: stable@vger.kernel.org
Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>

---

I found this when going through the savedefconfig diffs for the K210
defconfigs.  I'm not entirely sure they're doing the right thing here
(they should probably be setting CMODEL_LOW to take advantage of the
better code generation), but I don't have any way to test those
platforms so I don't want to change too much.
---
 arch/riscv/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/Kconfig b/arch/riscv/Kconfig
index 821252b65f89..61f64512dcde 100644
--- a/arch/riscv/Kconfig
+++ b/arch/riscv/Kconfig
@@ -280,7 +280,7 @@ choice
 		depends on 32BIT
 		bool "1GiB"
 	config MAXPHYSMEM_2GB
-		depends on 64BIT && CMODEL_MEDLOW
+		depends on 64BIT
 		bool "2GiB"
 	config MAXPHYSMEM_128GB
 		depends on 64BIT && CMODEL_MEDANY
-- 
2.32.0

