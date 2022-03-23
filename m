Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8A7E4E5721
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 18:05:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234527AbiCWRGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 13:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230309AbiCWRGq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 13:06:46 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D55FE517E3
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 10:05:16 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id e5so2118418pls.4
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 10:05:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=74D/U/90Uf1pf4AvU85/YAaYtZaeBZkBo+JC5Lf1iEY=;
        b=JNcubnE2zcYoCl28/CXfqDUB8jcw1XrhROCoezFtUE74fZ1pUZsnxSIr6XuOU/WlL2
         z82ss2qBVcQ79ewfNdMSod4Nw05Cy699JGvWXbsQDmZXc4WkEQ6PAQMcaYGaTmtlBYFw
         1ckk9usZ3kao456Q1kLUUMNDG+11lgG3FNoJ6ZQUkrEYsfHjk8IeecWadVD3k/RjuvZQ
         kfgKvPjDyJiPE/Ige9NWfTxHyZZ5tsyYD8hsGNapySH72EtY4yQaK/dVgQSlMbk+8ubO
         PMy877gpiFE0a7B2Qam0b9e+TBD+cV4asj/wNM7DC/V702qkf2MVV7liUU6J30hVvvPT
         8mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=74D/U/90Uf1pf4AvU85/YAaYtZaeBZkBo+JC5Lf1iEY=;
        b=L+PMqkAVMaZVJOiURudQ8tjDtBXE/Z430fiGqF7JH695F0gK1CpuREGdujxzMpKim4
         F5CBGF6bXZbw7f5mvCg7cHPpyKKz9ZDIj6Y1Oyjf8Dscvx/Ne8PoqNGCTqzJJPRYy0TQ
         DUSbKTRxSrRYXBVOc2GUemdDKWVAmMWfNXEV3VwAcsoDFcTrTCKx26shLlv4rlDhj44h
         IXNZMND1U6T5qRYYMoHPS+oiaspGXqyPj28DAkDi3JG8fVIdWIY695MTL6eyWZoEMWP3
         6WHuhf09TjHgZUaZF3HQLq54V8zGjQdLa9Tcq5cnLTjvDaxGKGlEfSfM6lIWHhHPdfYL
         XNVQ==
X-Gm-Message-State: AOAM531J3iadrSMzhMiMqd2smJu6o37kJlIxTUuJZK7gIrn6Rxgi3+zq
        4LOpkhpPNtiTmvvPvk6KZNY=
X-Google-Smtp-Source: ABdhPJzQw/BaMmdY86uQD0UijO+q0SVHd1cS4Yj0jlP9xF+CEDTpi9KfF8AeIxPI+EDPaau6M4CpWA==
X-Received: by 2002:a17:90b:224e:b0:1c6:d9ed:576b with SMTP id hk14-20020a17090b224e00b001c6d9ed576bmr766538pjb.26.1648055116282;
        Wed, 23 Mar 2022 10:05:16 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:98c:eff5:b721:5f7b])
        by smtp.gmail.com with ESMTPSA id u12-20020a17090a890c00b001b8efcf8e48sm6649709pjn.14.2022.03.23.10.05.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 10:05:15 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Thu, 24 Mar 2022 02:04:54 +0900
Message-Id: <20220323170458.5608-1-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
check correct value") buffered writes fail on S29GL064N. This is
because, on S29GL064N, reads return 0xFF at the end of DQ polling for
write completion, where as, chip_good() check expects actual data
written to the last location to be returned post DQ polling completion.
Fix is to revert to using chip_good() for S29GL064N which only checks
for DQ lines to settle down to determine write completion.

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

Tokunori Ikegami (4):
  mtd: cfi_cmdset_0002: Move and rename
    chip_check/chip_ready/chip_good_for_write
  mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
  mtd: cfi_cmdset_0002: Add S29GL064N ID definition
  mtd: cfi_cmdset_0002: Rename chip_ready variables

 drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++--------------
 include/linux/mtd/cfi.h             |   1 +
 2 files changed, 55 insertions(+), 58 deletions(-)

-- 
2.32.0

