Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CA5D4DA099
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 17:56:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350345AbiCOQ6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 12:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350330AbiCOQ6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 12:58:00 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E42A5574B2
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 09:56:47 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id p8so20664103pfh.8
        for <stable@vger.kernel.org>; Tue, 15 Mar 2022 09:56:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YJkWk99bLZw++rSGr2/IK3Rs1XoNvFcnuxKFkD7iXfQ=;
        b=HfWVhu5hvd7qeRccFco3HtFVm5PsbpepnDOYIuIcWqwjwJbBPhUkjW0jJTU9bJsw9s
         n65j2LUPAhuKGNqx8VCNX+hsswJHY4gf25DJnor6UcEqGhYoA5MzoRBB94LJSXYDAIqk
         t0ztzrf9wWcAnzUKsATm0nRUYGBryW2OSolE2h4SwPsT9eNJaVid55ceUQif5RZHQ+iT
         5jEPEdFRZ+n6VEx/ef8nzAaEkLox0b9WR5IKE8eGsGzBlrzx+rVUsgSANk123LtWIcW5
         X9rQ0J8ES8mSdxMNeFcUwoX2eg3BLcaiamF49HL/DrtPtDyJv3NvrsBt7PdyE7Dhv9Ec
         8l5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YJkWk99bLZw++rSGr2/IK3Rs1XoNvFcnuxKFkD7iXfQ=;
        b=RZQoPV9lyxtsmQ2D+j1H9KtN2f4X4IzXt0ebe4Mp4zxL73AC1a2wn1nMTAkchCQr1G
         r521/RLqwCsGtpAA94ZYiozSFXmdOI9oHZmMxFEdYfAdQqekZ7xzcFRBMsJZHesTxJ8E
         LCOJ6EzPla+iM8/1mp14hpBe6esaC/TiK5EzPsSnhQYrbWHiBf/GXqRC2zH9VUbaqdEY
         BFRgqSKU+UJENP76IB5Mxd2kHoOSgl4zw9W/QuKu0LY+kpGqHaf+6uPmS5nA28aPWXQV
         thV+12tQbJ8p40uiumTQV1tQiPKN0bnT3VffNTVfl2mHiW9wYOUc7zAg/lwgNwPdOwS5
         Xr9w==
X-Gm-Message-State: AOAM53097HrCZzlfL3QuSkUJt1mB9U8VxtOANqxlYs8khPlGZeVp8OnX
        7l0wjLupdEGHy4KWOe7NnQk=
X-Google-Smtp-Source: ABdhPJxHFbqVOmNHUuxR+neKszGPBNtKnYs0I9jRD3t+e3mY0TR4WuxOLTPugKbYcs1pvwkwR2BWgQ==
X-Received: by 2002:a63:4e4d:0:b0:381:640e:a373 with SMTP id o13-20020a634e4d000000b00381640ea373mr3905684pgl.379.1647363407195;
        Tue, 15 Mar 2022 09:56:47 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:3e36:8008:b94b:774d])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm24835809pfu.120.2022.03.15.09.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 09:56:46 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>, stable@vger.kernel.org
Subject: [PATCH v3 0/3] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Wed, 16 Mar 2022 01:56:04 +0900
Message-Id: <20220315165607.390070-1-ikegami.t@gmail.com>
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

As pointed out by this bug report [1], the buffered write is now broken on
S29GL064N. The reason is that changed the buffered write to use chip_good
instead of chip_ready. One way to solve the issue is to revert the change
partially to use chip_ready for S29GL064N since the way of least surprise.

[1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: Richard Weinberger <richard@nod.at>
Cc: Vignesh Raghavendra <vigneshr@ti.com>
Cc: linux-mtd@lists.infradead.org
Cc: stable@vger.kernel.org

Tokunori Ikegami (3):
  mtd: cfi_cmdset_0002: Add S29GL064N ID definition
  mtd: cfi_cmdset_0002: Move and rename
    chip_check/chip_ready/chip_good_for_write
  mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

 drivers/mtd/chips/cfi_cmdset_0002.c | 89 +++++++++++++++--------------
 1 file changed, 47 insertions(+), 42 deletions(-)

-- 
2.32.0

