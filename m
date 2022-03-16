Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 938424DB566
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:55:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357351AbiCPP4S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:56:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349797AbiCPP4S (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:56:18 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7531A5F4FC
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:55:04 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id n2so2151224plf.4
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/CrJ94TqaNXmyTFPfjBpxHH39VvVuJcaB748yr+PE4=;
        b=PU9Ue48X8/hZy9/1+cZ0ROnUN8cmI/3hLwf9JxIKTS2E0FGlK/mU6X7Si0yxyWChvz
         EqPKno21P6FIfQrmc3DEsNLa7EUqp9eTs41m1UubwX1/8BvjObth8dg2APr6xRFVPkOv
         4M/6y4lCdEZFG1P1MAFn/C4D4bdijYgY0PQI62zhXLiX/TodC1zd1WXeuZG6vPpdM+Dk
         2bq6y25hQrSirhcJFI8A2ARDa/UlGdpfzVRcOT25ZJYVcEDCqA76GuAp1uoBPjj8oYG8
         dM2rMZnTo7UHrx+j3cLfviJ46pw35lIvl1cPifSvW1QkGt/W69AxYh54uVfNEC0CW6/V
         U8gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=0/CrJ94TqaNXmyTFPfjBpxHH39VvVuJcaB748yr+PE4=;
        b=lsT2N3Q69FmIerfwieixAgGIXFjqRm0ELv3Kp6/sRRGOKyelgJHmjr1+g8TDtZTfu/
         D7ckeMtwTHxK61qBFUMXjU+vicWl2y82QxgBV2SZxqRPzYCle2C+NilkgbfoQ6aEoYP1
         DfgpwY4tHhkm6wFEexcPN4fn8WcPI3YL47mVwshUQNbFD96bV7oaYEKJKxqaeq9LJqF4
         ig2cbl08kMRqCqyUsHYciSKUqsRoUcyYSRpu7JqU7D62Alei6GspvqDZsaC7xpWBvQhG
         unjWsP1lOYQKGgL7V+InteTAoIS65CMUz6gDCAb5R+viInI3qdm9V56T9VmN8unGV66L
         ipXQ==
X-Gm-Message-State: AOAM532+OmDSmYHKylp9KYKjEXEd2gpdEX3PSdxcLfwLZ2mdtxBplbNW
        U3Vg/DY0DNGNnM6sbF/ZSFg=
X-Google-Smtp-Source: ABdhPJzWo9ycpAb0FxfucGSEx3TuQGbM2XFExqWWirujFURthZj7AfTEgawOve1rKjgioqVmyl//Ng==
X-Received: by 2002:a17:90a:ab08:b0:1b9:c59:82c3 with SMTP id m8-20020a17090aab0800b001b90c5982c3mr10802071pjq.95.1647446103800;
        Wed, 16 Mar 2022 08:55:03 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:9500:ad27:b03f:5499])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm3427852pfj.128.2022.03.16.08.55.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:55:03 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH v4 0/3] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Thu, 17 Mar 2022 00:54:52 +0900
Message-Id: <20220316155455.162362-1-ikegami.t@gmail.com>
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

As pointed out by this bug report [1], buffered writes are now broken on
S29GL064N. This issue comes from a rework which switched from using chip_good()
to chip_ready(), because DQ true data 0xFF is read on S29GL064N and an error
returned by chip_good(). One way to solve the issue is to revert the change
partially to use chip_ready for S29GL064N.

[1] https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/

Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc: stable@vger.kernel.org

Tokunori Ikegami (3):
  mtd: cfi_cmdset_0002: Move and rename
    chip_check/chip_ready/chip_good_for_write
  mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
  mtd: cfi_cmdset_0002: Add S29GL064N ID definition

 drivers/mtd/chips/cfi_cmdset_0002.c | 93 +++++++++++++++--------------
 1 file changed, 49 insertions(+), 44 deletions(-)

-- 
2.32.0

