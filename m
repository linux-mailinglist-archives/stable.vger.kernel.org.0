Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A353A4C317F
	for <lists+stable@lfdr.de>; Thu, 24 Feb 2022 17:34:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229639AbiBXQdS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Feb 2022 11:33:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiBXQdR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Feb 2022 11:33:17 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8131FE56D
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:32:41 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id p9so5557426ejd.6
        for <stable@vger.kernel.org>; Thu, 24 Feb 2022 08:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TtmeV9bgxOIabhJpHOR897CD9xgb87UemODU6yGgV2U=;
        b=kuPalLo0ngHOxMvZ6qIgbB+moVrh17o+Lv9Ez7Ucqyo8MJkTddP+53mAdrQrjT/iIS
         NBbuQpY9+EyL7o0cF9EUX6BiaG/emCBJwgZ7/O8LOzPt3zwXXcdR7BdF3oPNbstEtaWI
         IEpIbLKdf7RuUHHHH74BbrDqcA7itr0BCaBeyWEfVAkr1eXo6yITFooJcpQfXjpLSX/N
         Q00TNT7VNos313AB95PZ1Ztfl68NEuVi3Ghw1As1wnhd+/t9fByKElDKdjKiVesNlmeG
         vgsJyynXcSf5AHf2vzLpP1zEFsoWFYmp1lebeWmVkb4/Y4nnwgoLUfDxWnIwz1JXLLGa
         7GGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TtmeV9bgxOIabhJpHOR897CD9xgb87UemODU6yGgV2U=;
        b=zPhcBsht7Ljg5aeGTPKpqg+SjsgNYrjZufLvH4I/vCtRFJnto318VVfaMmgLSxOzwU
         tkNFRqGCgzVUx301lmTNYxUq4nqtWYjDyxPs6/PtzN0fd28x5KI9WhPwCttQZyrT8Ehb
         CmyqWcLjF13+UC+PL0nFz4FqmhtMRLfSLeQJY7b/1tRJkNL1oI3zh8OmWvBFkI+hCJ+K
         ZBu9Na65IPIVc8cgdyPZ8Th6p01dEbWUX7lKaX3fJVz/re/+TZc1iwIOmSFFXMJYB+3I
         8+vaTz9LdNAbcgAusX8QvPy9uPoKzvpspkh9msN4szTMmfjd1ytqlpPLNTEKgjlgfpg9
         9TJw==
X-Gm-Message-State: AOAM531J8ArLK/cSTxuHcNhVkt3D/6tXMpgUgHc45Q0qCnUMPpuqFMT9
        DpadFstCQUYCkzEqGJCrwdxC8D8p77Dm5Q==
X-Google-Smtp-Source: ABdhPJwiKP+dfsndf3VPpMglOVWrIIfHrXym6SEpHnxWV0ApQvGlhQKCMMsZmT1onUav3oJu2Z4OkQ==
X-Received: by 2002:ac2:5d67:0:b0:442:f135:3bcc with SMTP id h7-20020ac25d67000000b00442f1353bccmr2267428lft.452.1645719756809;
        Thu, 24 Feb 2022 08:22:36 -0800 (PST)
Received: from localhost (c-9b28e555.07-21-73746f28.bbcust.telenor.se. [85.229.40.155])
        by smtp.gmail.com with ESMTPSA id v9sm242600lfr.130.2022.02.24.08.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Feb 2022 08:22:36 -0800 (PST)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     mpe@ellerman.id.au
Cc:     linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: [PATCHv2 1/3] powerpc: lib: sstep: fix 'sthcx' instruction
Date:   Thu, 24 Feb 2022 17:22:13 +0100
Message-Id: <20220224162215.3406642-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Looks like there been a copy paste mistake when added the instruction
'stbcx' twice and one was probably meant to be 'sthcx'.
Changing to 'sthcx' from 'stbcx'.

Cc: <stable@vger.kernel.org> # v4.13+
Fixes: 350779a29f11 ("powerpc: Handle most loads and stores in instruction emulation code")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 arch/powerpc/lib/sstep.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/sstep.c b/arch/powerpc/lib/sstep.c
index bd3734d5be89..d2d29243fa6d 100644
--- a/arch/powerpc/lib/sstep.c
+++ b/arch/powerpc/lib/sstep.c
@@ -3389,7 +3389,7 @@ int emulate_loadstore(struct pt_regs *regs, struct instruction_op *op)
 			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
 			break;
 		case 2:
-			__put_user_asmx(op->val, ea, err, "stbcx.", cr);
+			__put_user_asmx(op->val, ea, err, "sthcx.", cr);
 			break;
 #endif
 		case 4:
-- 
2.34.1

