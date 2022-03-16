Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 123674DB568
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 16:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346085AbiCPP43 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 11:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357364AbiCPP43 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 11:56:29 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1625F4FC
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:55:15 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so548238pjb.4
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 08:55:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TguvRSq9Uu2G86yRoz63evaiO4HI8reTSU45QiNijTg=;
        b=BE1xikM69iSlUQAxTnK4SKfT6oPG2KW744Z9Kjk/z3FrO8y/vl19/AgNqSPBtP7LUd
         X/6c7dOVdQxr1W5sCJt/qLV5kLi32ECgWXpVrmLsF8s4V1pgpKKCVpNWfJcutnyBVLen
         5j7XmhFzmi+uI1Hv8qeJyg361Da1hGmwS8yFJWApElmK00eWlOEdmd/a/bNbQejb+Qfn
         OJF6dj9bUqeML3LNaFcVwk0pinJEXU2c68lC3pHpzjuUa4i6YEBtgVNkCh40euv0nm5q
         t/rfgQIS1wy9Wv4HEAKQMBhedLrIMSd34MZtsaRXB072GHFires2rmjoCvmz+n0+ZkH1
         rrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TguvRSq9Uu2G86yRoz63evaiO4HI8reTSU45QiNijTg=;
        b=MNhji09nK8Zr64ziss+OZqH4EzfoWZiyzDnseW07Vu7pRHhSrvqXV9sBO+InqBUO5r
         ql7lDkOLIZh2OvDM6hSxjunW+tJb0tO89CH4jIsPgjUHZR/BLosPjVn/Avod8IFNu8cW
         J3/4MniamhogvokTNZPjOgvgiMtAxzC40X4fkT75jk6XAaEwei6wPOB1ecKMT9PngGAj
         Qhmy8E2QdjNkMmFffu03CgDk0tFex754D2B9SlD9tO+ci5P+W8lrevuv8knmpupi4aQm
         y3+UIP6KXJZy//l9NuszE3LpbJT52fvcvvHJCplaADkihkBkjef6FcBfMfJjxE68K9i6
         Rcpg==
X-Gm-Message-State: AOAM5316KeoN1uW4Z8EgrKrRC9qsBQfr0Je2fPMvEm7pthvLbmY19vg3
        VN+O0CahVbQEElrVST5WPJ8=
X-Google-Smtp-Source: ABdhPJwM0XPnsJi93p00218/PX+tQi5MvazW74YLvkHSFqCOaS6K2/6JQDSeh8sfYidGRBF+E7Yhfw==
X-Received: by 2002:a17:90b:17c2:b0:1c1:66a5:4f9e with SMTP id me2-20020a17090b17c200b001c166a54f9emr10900409pjb.188.1647446114604;
        Wed, 16 Mar 2022 08:55:14 -0700 (PDT)
Received: from tokunori-desktop.flets-east.jp ([240b:10:2720:5500:9500:ad27:b03f:5499])
        by smtp.gmail.com with ESMTPSA id x29-20020aa79a5d000000b004f0ef1822d3sm3427852pfj.128.2022.03.16.08.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 08:55:14 -0700 (PDT)
From:   Tokunori Ikegami <ikegami.t@gmail.com>
To:     miquel.raynal@bootlin.com
Cc:     linux-mtd@lists.infradead.org,
        Tokunori Ikegami <ikegami.t@gmail.com>,
        Ahmad Fatoum <a.fatoum@pengutronix.de>, stable@vger.kernel.org
Subject: [PATCH v4 2/3] mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
Date:   Thu, 17 Mar 2022 00:54:54 +0900
Message-Id: <20220316155455.162362-3-ikegami.t@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220316155455.162362-1-ikegami.t@gmail.com>
References: <20220316155455.162362-1-ikegami.t@gmail.com>
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
---
 drivers/mtd/chips/cfi_cmdset_0002.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/chips/cfi_cmdset_0002.c b/drivers/mtd/chips/cfi_cmdset_0002.c
index e68ddf0f7fc0..6c57f85e1b8e 100644
--- a/drivers/mtd/chips/cfi_cmdset_0002.c
+++ b/drivers/mtd/chips/cfi_cmdset_0002.c
@@ -866,6 +866,23 @@ static int __xipram chip_check(struct map_info *map, struct flchip *chip,
 		chip_check(map, chip, addr, &datum); \
 	})
 
+static bool __xipram cfi_use_chip_ready_for_write(struct map_info *map)
+{
+	struct cfi_private *cfi = map->fldrv_priv;
+
+	return cfi->mfr == CFI_MFR_AMD && cfi->id == 0x0c01;
+}
+
+static int __xipram chip_good_for_write(struct map_info *map,
+					struct flchip *chip, unsigned long addr,
+					map_word expected)
+{
+	if (cfi_use_chip_ready_for_write(map))
+		return chip_ready(map, chip, addr);
+
+	return chip_good(map, chip, addr, expected);
+}
+
 static int get_chip(struct map_info *map, struct flchip *chip, unsigned long adr, int mode)
 {
 	DECLARE_WAITQUEUE(wait, current);
@@ -1686,7 +1703,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_good(map, chip, adr, datum)) {
+		    !chip_good_for_write(map, chip, adr, datum)) {
 			xip_enable(map, chip, adr);
 			printk(KERN_WARNING "MTD %s(): software timeout\n", __func__);
 			xip_disable(map, chip, adr);
@@ -1694,7 +1711,7 @@ static int __xipram do_write_oneword_once(struct map_info *map,
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_good_for_write(map, chip, adr, datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
@@ -1966,14 +1983,14 @@ static int __xipram do_write_buffer_wait(struct map_info *map,
 		 * "chip_good" to avoid the failure due to scheduling.
 		 */
 		if (time_after(jiffies, timeo) &&
-		    !chip_good(map, chip, adr, datum)) {
+		    !chip_good_for_write(map, chip, adr, datum)) {
 			pr_err("MTD %s(): software timeout, address:0x%.8lx.\n",
 			       __func__, adr);
 			ret = -EIO;
 			break;
 		}
 
-		if (chip_good(map, chip, adr, datum)) {
+		if (chip_good_for_write(map, chip, adr, datum)) {
 			if (cfi_check_err_status(map, chip, adr))
 				ret = -EIO;
 			break;
-- 
2.32.0

