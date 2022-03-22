Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DDE64E366F
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 03:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiCVCMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 22:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235223AbiCVCMC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 22:12:02 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC471C118
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:10:31 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id t5so17038837pfg.4
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 19:10:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piMJsfse5nDZzPrYdbJei29P+QaKxOakG4LoynFh010=;
        b=Kcl1CGLecUSoYYN6ufeg4H2Icny9zfpVgQO3LbeWED1mxrci4k+fHwN5NREmTzLmSF
         gUieROM/f0LDt94VuFqI1aj6gpK/SppvjlysD6LwPqO47qjhfh3FPa7JnXX1Rqt6gOOd
         O7sfCc4VW8Oe6YzUpmic33+dsBsfuX2A5S3b5EmIwLwtiIYm7GhlUpfywsgqSJh9JgHh
         oy85OUDZLKYIktgQ7viBsmC3TPzLUNlfUcujFfkg1cyJWBsNh5SzHIMUp5FevY9R3T3f
         Hs/RVGJ22CR52dMuYdo9Wm8peQPh0wKIewIN8jf9WNL934md+q9Jlv56w1eLR4Jmf7x/
         cUDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=piMJsfse5nDZzPrYdbJei29P+QaKxOakG4LoynFh010=;
        b=0lgfKcMeqrqab7OK+N836aEOTCiHjv+I5W62Zdt1Lw+//p2vJkAdVF/QlPOvfL8wpm
         XcpM099sEyheW4Bbac6IKsYKPUutNJkd39gmudwldLw/MkJ08q2OxYe9jnqILWgoclbD
         JALEjeovZCA3GHpeMl4e2cRUjSO1Ncic9kyUCW4Mh9mqro/OIuRs7zBmAwcGqkT3FXX1
         meR5oIpKfMaVHl69fw8GvQupymPF6rnWPt+te97IFPDYIyuJs7tn6ns9/2Ll/CbaCPvJ
         QaOmYO4g7NSI/hGKOFwEapXKFMnAhCL4gznBpEv2EDhQ0m5ugL/cNvkUf/v+E/FNOcUn
         ngYQ==
X-Gm-Message-State: AOAM530uPLrejpOaI1Rx3sgkHAKRikFE95sO4pLgDjjiwaNPySq+8rKj
        XUSluZ9LvduiPMtImfjnrSY=
X-Google-Smtp-Source: ABdhPJyDrRlEWKnc/NGv9PIQWSTfjJ/tCa+Q2ScF+XE8IUSVSr1oBo5Hh0vZdI6XMnHEYdmNILN3Tw==
X-Received: by 2002:a05:6a00:a1d:b0:4f6:5051:6183 with SMTP id p29-20020a056a000a1d00b004f650516183mr26883061pfh.42.1647915030807;
        Mon, 21 Mar 2022 19:10:30 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:1847:b4dd:1227:a1f6])
        by smtp.gmail.com with ESMTPSA id o5-20020a655bc5000000b00372f7ecfcecsm15673579pgr.37.2022.03.21.19.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 19:10:30 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>, stable@vger.kernel.org
Subject: [PATCH v5 0/3] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Tue, 22 Mar 2022 11:09:58 +0900
Message-Id: <20220322021001.138206-1-ikegami.t@gmail.com>
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

Tokunori Ikegami (3):
  mtd: cfi_cmdset_0002: Move and rename
    chip_check/chip_ready/chip_good_for_write
  mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
  mtd: cfi_cmdset_0002: Add S29GL064N ID definition

 drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++--------------
 include/linux/mtd/cfi.h             |   1 +
 2 files changed, 55 insertions(+), 58 deletions(-)

-- 
2.32.0

