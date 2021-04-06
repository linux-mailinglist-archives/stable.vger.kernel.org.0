Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4CD3551F6
	for <lists+stable@lfdr.de>; Tue,  6 Apr 2021 13:23:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242197AbhDFLXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Apr 2021 07:23:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241465AbhDFLXb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Apr 2021 07:23:31 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C575C06174A;
        Tue,  6 Apr 2021 04:23:23 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id y32so6929403pga.11;
        Tue, 06 Apr 2021 04:23:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=O4phrYeUUbsfvsJh88wd3ET5VrsBh8Qxjkdc2Metveg=;
        b=oW7Y6cf0v/yl6GRPjRnrbbsc2geh1rDE8wfJWMBrBvwvT+Tm6xFy5IDn9naa4LZF0/
         fnTuMQFqeTKSTBuHJiW6MTGAhEIkYxMHdhwT3M7Rjx+54l/RnMPU8CAQKv7sWqZ47ooL
         UWoGqDp9gXLeljhXUDu4BmMpJdlAVjFTDbw1e5l3l9X4Es5AreMiRw58WMaLJYMwG0Fx
         AZ/oFRYs/p8wIRFIVSajfSIKuCbrB2VeJMrwf29E+CnS0tqnChMAXpk3WoKo2wbp5ca+
         NAFwwQCP1Yg1T9VqB4Qqm5vjR2UYus2E+gEOVUglSELCCRMZCA/xiebsBxrawKfJz7Rx
         rUCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=O4phrYeUUbsfvsJh88wd3ET5VrsBh8Qxjkdc2Metveg=;
        b=gJGQT3xmGU14Q3ftGxRJNoXDekMtBwXNh4Xowb4VyJ4GiyNFAwEHq1DqZATMPx32GX
         unPXD0KFSGbd8+QIFyuxdz7VCiVyvJwlSgGt017Z5BBj9e3tue0yfbLObe4FQSwmrnHf
         4T2kA/djkyU8bZqfl2iTP/z2CCnti53h3JZZEcN75Tq4agczBe9KqBnXVuKsjbneEgIu
         6c1SRLKGRZfQsbB5j2bSaasMuB4gILez+Jkk20qdQUddlJo7PZoAbWOL53L1xUcc2Bq/
         UA+9oRwc0RpB94geQsEUOCOKMfUXQPIcH9K56g6Bv7DzKOPH20thByz7ieYaq7eBv56O
         SaYg==
X-Gm-Message-State: AOAM533/b/qKFCJIGEP0jSziAlD8RmLdvwzNtR0oOG0YvElXApzsabEl
        vrubH7lHRXSiEXxQ3oxKlBeTaCEi1zg=
X-Google-Smtp-Source: ABdhPJw9M4TWOX0V/5BI8PMeVpFphj0SmIDzgNsS6j4CJ0gQCX4FRHOxphkGTi9npUfptEhKq/Y9qg==
X-Received: by 2002:a63:604:: with SMTP id 4mr26793057pgg.267.1617708203116;
        Tue, 06 Apr 2021 04:23:23 -0700 (PDT)
Received: from localhost.localdomain ([132.145.85.142])
        by smtp.gmail.com with ESMTPSA id v18sm18869645pfn.117.2021.04.06.04.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Apr 2021 04:23:22 -0700 (PDT)
Sender: Huacai Chen <chenhuacai@gmail.com>
From:   Huacai Chen <chenhuacai@kernel.org>
X-Google-Original-From: Huacai Chen <chenhuacai@loongson.cn>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     linux-mips@vger.kernel.org, Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Huacai Chen <chenhuacai@loongson.cn>, stable@vger.kernel.org
Subject: [PATCH] MIPS: Fix a longstanding error in div64.h
Date:   Tue,  6 Apr 2021 19:24:03 +0800
Message-Id: <20210406112404.2671507-1-chenhuacai@loongson.cn>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Only 32bit kernel need __div64_32(), but commit c21004cd5b4cb7d479514d4
("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.") makes it depend
on 64bit kernel by mistake. This patch fix this longstanding error.

Fixes: c21004cd5b4cb7d479514d4 ("MIPS: Rewrite <asm/div64.h> to work with gcc 4.4.0.")
Cc: stable@vger.kernel.org
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
---
 arch/mips/include/asm/div64.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/div64.h b/arch/mips/include/asm/div64.h
index dc5ea5736440..d199fe36eb46 100644
--- a/arch/mips/include/asm/div64.h
+++ b/arch/mips/include/asm/div64.h
@@ -11,7 +11,7 @@
 
 #include <asm-generic/div64.h>
 
-#if BITS_PER_LONG == 64
+#if BITS_PER_LONG == 32
 
 #include <linux/types.h>
 
-- 
2.27.0

