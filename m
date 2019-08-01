Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C45617D753
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 10:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730700AbfHAIVO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 04:21:14 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34434 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731106AbfHAIVO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Aug 2019 04:21:14 -0400
Received: by mail-pg1-f196.google.com with SMTP id n9so27510306pgc.1
        for <stable@vger.kernel.org>; Thu, 01 Aug 2019 01:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/rNw3tnBxgbMcdBdzBneQcQUsRPBm5GaeGzxs7tkgFw=;
        b=oN+aQ42TkqS/ZeSiy3PDVQMFYJwaMygZDYjh2qN8hDnDvIcJXJV2xpqOJsfr2J87Vb
         HeXPSEp5GcxRtJuCXOKlcDE0H84nRUB/twMJAH4jd/ZRQ2XVQgi3URaW62kWUFpPqhvx
         VWkcO50KK0MHGygwXTdMFgPeTJlYbSSFLDzu1sgoU/zfeXdgQg51br4OgEkEcdJH7Lzk
         5i4gx5frWTr2aRqQyJrFvT/4HICocdqzcTYe2qbKmjtEUEJkGpNm+nulY/vpSEPHBKFq
         F6bqs230Y4TzLP/JVePgx7etwDRWQKZEMwVpsDX3zL1VhLFRyfY4sqoDKQ1VqFNTrw1w
         JK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/rNw3tnBxgbMcdBdzBneQcQUsRPBm5GaeGzxs7tkgFw=;
        b=ulaalJX5sD1HK86DM5Mgohu6ad/EcVCNBOLzIMHqH3bMC7Ei45pfbHcvDU7puRtMM4
         CN8orfy1MOFs187RUC28/FM+b0JT3Z8dz/mIU6NypiPPHe2Gh4Rq2gUIM7RTml5hsgzE
         jf4jfe1gDdFow5DfvEjWz8x9EBM8Nl6e0joYpU72ubAibYYJFGQwgT5ycAj413CSykpr
         9dVi0T7KB48fl+ZCJP9XAyOXmkCpb12+/U4fi104+vLCaji42qJchqB/96lzxoBnZ7Xd
         2xuVy5or4m3UN1ao95BLs4InaOJdBAnUT7WpshYgBv2UIqAwS6x9D5NjvRk5sYJ+29mM
         a9VA==
X-Gm-Message-State: APjAAAV5Ymsh2AhMSf8G4zjcZhQiQEojMKZTZZV+hOS4n468xWT088KW
        EvC2WAH9/TBgKjjjBBwKHVbKbejtsb0=
X-Google-Smtp-Source: APXvYqyaed19XnqHQXWpNSnB4vgpCpEBf18uaExgzvHFuu8wKI9CVeBs5nx9R212iN+ptzJnz/i5ww==
X-Received: by 2002:a63:c006:: with SMTP id h6mr83873722pgg.290.1564647673509;
        Thu, 01 Aug 2019 01:21:13 -0700 (PDT)
Received: from localhost ([122.172.28.117])
        by smtp.gmail.com with ESMTPSA id f7sm69426237pfd.43.2019.08.01.01.21.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 01 Aug 2019 01:21:13 -0700 (PDT)
From:   Viresh Kumar <viresh.kumar@linaro.org>
To:     stable@vger.kernel.org
Cc:     Viresh Kumar <viresh.kumar@linaro.org>,
        Julien Thierry <Julien.Thierry@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        mark.brown@arm.com, guohanjun@huawei.com
Subject: [PATCH ARM32 v4.4 V2 38/47] ARM: 8810/1: vfp: Fix wrong assignement to ufp_exc
Date:   Thu,  1 Aug 2019 13:46:22 +0530
Message-Id: <17ef1620483a77f70c7c27e64cba3ad1684626c7.1564646727.git.viresh.kumar@linaro.org>
X-Mailer: git-send-email 2.21.0.rc0.269.g1a574e7a288b
In-Reply-To: <cover.1564646727.git.viresh.kumar@linaro.org>
References: <cover.1564646727.git.viresh.kumar@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Julien Thierry <julien.thierry@arm.com>

Commit 5df7a99bdd0de4a0480320264c44c04543c29d5a upstream.

In vfp_preserve_user_clear_hwstate, ufp_exc->fpinst2 gets assigned to
itself. It should actually be hwstate->fpinst2 that gets assigned to the
ufp_exc field.

Fixes commit 3aa2df6ec2ca6bc143a65351cca4266d03a8bc41 ("ARM: 8791/1:
vfp: use __copy_to_user() when saving VFP state").

Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Julien Thierry <julien.thierry@arm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
---
 arch/arm/vfp/vfpmodule.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/vfp/vfpmodule.c b/arch/arm/vfp/vfpmodule.c
index f07567eedd82..f9392fb060ea 100644
--- a/arch/arm/vfp/vfpmodule.c
+++ b/arch/arm/vfp/vfpmodule.c
@@ -583,7 +583,7 @@ int vfp_preserve_user_clear_hwstate(struct user_vfp *ufp,
 	 */
 	ufp_exc->fpexc = hwstate->fpexc;
 	ufp_exc->fpinst = hwstate->fpinst;
-	ufp_exc->fpinst2 = ufp_exc->fpinst2;
+	ufp_exc->fpinst2 = hwstate->fpinst2;
 
 	/* Ensure that VFP is disabled. */
 	vfp_flush_hwstate(thread);
-- 
2.21.0.rc0.269.g1a574e7a288b

