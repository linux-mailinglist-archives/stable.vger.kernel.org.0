Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B54B35A7B7D
	for <lists+stable@lfdr.de>; Wed, 31 Aug 2022 12:39:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbiHaKjh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 31 Aug 2022 06:39:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiHaKjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 31 Aug 2022 06:39:35 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3432B99CE;
        Wed, 31 Aug 2022 03:39:34 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q63so13141848pga.9;
        Wed, 31 Aug 2022 03:39:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=wOwY8itHt8uazUdkq94DxdZkg/SDR8+3Y3ahMNupefU=;
        b=nfkSlY53P23F3x03xQrP4eu/bkO3JWBCJ9iyfQAQq4qWiJ7daGlQUwntPXT3PITeif
         y16sWZr+GrhAwMAOp5gW3N+Y6jenP385CCPBdu6R6bGVsUmO7qCjntFspMzdVAeUMHfn
         Z0zrxMhmvlEIC7omwrBrw26gwnStad+hRNooWWLyEcAbvsn8hfi6sIB4EhABufoYBNzh
         qLUJv5asLy/ltrAvAF2bqRBELRXwW7psuNrQ92LDFMsX3u45Fr7kbKpQvKeuM5n74ZIi
         Mdt0SC9Z4wxaCgmFJek8DCwm8z0lp1Uwwpa0bZvclZI0B9pEFIC6CkPEVPchF7HLOu7D
         Xfng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=wOwY8itHt8uazUdkq94DxdZkg/SDR8+3Y3ahMNupefU=;
        b=rwt3b/Pjf1LoqPmQReim0VXyw2/BU8XqF3ZhGsoWSeQxlb5EdzdwUVhdeJUP6i1n3h
         Q/GqSYkPeC1woGJ/pwVFX/0LnFesYZIGORkBHtMaquRpdeeXnmXOVskHd7nrHcgRQrUR
         CpAt1llwBxucusRand4KH0FlAXQ2Svp+oTYJ5LKeHJXx6q1IRkIQxRCsNToccRN15NrG
         E1ip/+C06gzYV9qWX2+s/rqFwiKWhDRP3S8deK8w6tOUKpgGVT9IMN43jOuyGWLDHl0T
         TLK/dChDOQ5hbAexxU2eq8dumdv7vpOZaMrb2nvnRCHAJnn5DtcZXDXLAKzYcBzu/P2j
         zQ/A==
X-Gm-Message-State: ACgBeo2Hr7rnoLK1+BCZb4jYjTj3vLiUHPqtuuMWTsvaUBMOSFRnOUh1
        7rTNCbumxCKRJMjZikY5Gl4=
X-Google-Smtp-Source: AA6agR64P8U6wtu7FrDxOOS6p0FSnkiFLrwL6YILZB/NVOFoS+0twPVgULY7Qms4kloVOzZ9yLqIhw==
X-Received: by 2002:a62:2503:0:b0:538:426a:af11 with SMTP id l3-20020a622503000000b00538426aaf11mr13608844pfl.22.1661942374066;
        Wed, 31 Aug 2022 03:39:34 -0700 (PDT)
Received: from localhost.localdomain ([118.235.13.86])
        by smtp.gmail.com with ESMTPSA id jj22-20020a170903049600b00172dc6e1916sm11245808plb.220.2022.08.31.03.39.29
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 31 Aug 2022 03:39:33 -0700 (PDT)
From:   Levi Yun <ppbuk5246@gmail.com>
To:     catalin.marinas@arm.com, bhe@redhat.com
Cc:     will@kernel.org, nramas@linux.microsoft.com,
        thunder.leizhen@huawei.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        Levi Yun <ppbuk5246@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v3] arm64/kexec: Fix missing extra range for crashkres_low.
Date:   Wed, 31 Aug 2022 19:39:13 +0900
Message-Id: <20220831103913.12661-1-ppbuk5246@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <CAM7-yPRp7wpP1a=SrH4o2SBijF4ZfxkLTe7vpRXq_D_y1Kz-1g@mail.gmail.com>
References: <CAM7-yPRp7wpP1a=SrH4o2SBijF4ZfxkLTe7vpRXq_D_y1Kz-1g@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Like crashk_res, Calling crash_exclude_mem_range function with
crashk_low_res area would need extra crash_mem range too.

Add one more extra cmem slot in case of crashk_low_res is used.

Signed-off-by: Levi Yun <ppbuk5246@gmail.com>
Fixes: 944a45abfabc ("arm64: kdump: Reimplement crashkernel=X")
Cc: <stable@vger.kernel.org> # 5.19.x
Acked-by: Baoquan He <bhe@redhat.com>
Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
---
 arch/arm64/kernel/machine_kexec_file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/machine_kexec_file.c b/arch/arm64/kernel/machine_kexec_file.c
index 889951291cc0..a11a6e14ba89 100644
--- a/arch/arm64/kernel/machine_kexec_file.c
+++ b/arch/arm64/kernel/machine_kexec_file.c
@@ -47,7 +47,7 @@ static int prepare_elf_headers(void **addr, unsigned long *sz)
 	u64 i;
 	phys_addr_t start, end;

-	nr_ranges = 1; /* for exclusion of crashkernel region */
+	nr_ranges = 2; /* for exclusion of crashkernel region */
 	for_each_mem_range(i, &start, &end)
 		nr_ranges++;

--
2.35.1
