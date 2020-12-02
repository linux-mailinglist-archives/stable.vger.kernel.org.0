Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF73C2CC7B0
	for <lists+stable@lfdr.de>; Wed,  2 Dec 2020 21:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731097AbgLBUYP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 15:24:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729063AbgLBUYP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 15:24:15 -0500
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0164EC0613D6;
        Wed,  2 Dec 2020 12:23:35 -0800 (PST)
Received: by mail-ed1-x542.google.com with SMTP id b73so1739924edf.13;
        Wed, 02 Dec 2020 12:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=6Xn6cEGyktow5p3VgWzBUqWHQbYSFeH1C45TGfme5TQ=;
        b=PVWClXnJuO31NKJGgDWsoVCmbhBw7LnNv1pGmPNaVU2dFDIYoQU4elvMm5hlARCYhv
         19/lPlZV2T0kEOXh8AgdFxXayxAHCRGji1+9l0Q0AIz21Zw++I1FXVhff4eJu3jlKIRv
         Ovx5xNopEvTIvpIR3SMicR8GAyLhbPjriXVn9To/lGhXD0dASnUiALrH4pd8Rv1hRZOU
         S6GABk/01ulpgX/c+vopTNnlxyT9BK87J/70QTyk/B3O9tOoUpZpic0tGrooIR1dE4jt
         +W20BdfVRR1iB0zzzEtlzY0DKT8lucxxUH+WPLzofkGBvjHqjTQ8xS7Gg2dqKe9rzG3G
         W3Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=6Xn6cEGyktow5p3VgWzBUqWHQbYSFeH1C45TGfme5TQ=;
        b=IncPv1E2KyR7DZHSW/uqtmYMmMUFOuiCORhfm4yw9IhQWDIo2ff0U+All5dCkzs7Xx
         9RujDLAa3rdcoSl4dUlx9msUeaxKYnz3nk466JvDl190RBevSWuqQ6p6TbrVQ3GNCdtI
         aijPCESu/sgwugJj9XNOLRpUXCh07B/2GynwpOHR/TJQJTLHafLdgAkmfIMp2X7ePDfd
         BH7GYEOnc+KN4xsoflTUXnRPEasnr5LaP4nGjW4DVsXWWGX+Os9v/gRFA1Nk5e+7eH+1
         qradV4b46SkN/h5g3lQPbJtbgfk7UQiCmHKqVphMGybfTDIN1Ksfo1ClAUGdBZZLtq7e
         J8ww==
X-Gm-Message-State: AOAM530SinsbaEsxsLFUI5izuheYH42SwLO54U8e2m35YJ8un4r0et0r
        WnpxTJXIBkJXiaf/a+H40+E=
X-Google-Smtp-Source: ABdhPJzkv2IFysSAiRWeMnEusdw/xqfmfC562SoKT5JOpvd6DMfm0ouM48i7yA1WEfWCfRFt7B+y1w==
X-Received: by 2002:aa7:dbc3:: with SMTP id v3mr1737369edt.199.1606940613632;
        Wed, 02 Dec 2020 12:23:33 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id y15sm666474eds.56.2020.12.02.12.23.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 12:23:33 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     ulf.hansson@linaro.org, axboe@kernel.dk, baolin.wang@linaro.org,
        beanhuo@micron.com, arnd@arndb.de, vbadigan@codeaurora.org,
        richard.peng@oppo.com, chaotian.jing@mediatek.com,
        avri.altman@wdc.com, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, zliua@micron.com,
        zszubbocsev@micron.com
Cc:     stable@vger.kernel.org
Subject: [PATCH] mmc: block: Let CMD13 polling only for MMC IOCTLS with the R1B response
Date:   Wed,  2 Dec 2020 21:23:20 +0100
Message-Id: <20201202202320.22165-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

The CMD13 polling is only needed for the command with R1B Resp. For the
command with R1 Resp, such as open-ended multiple block read/write
(CMD18/25) commands, the device will just wait for its next paired command.
There is no need to poll device status through CMD13.

Meanwhile, based on the original change commit (mmc: block: Add CMD13 polling
for MMC IOCTLS with R1B response), and comment in __mmc_blk_ioctl_cmd(),
current code is not in line with its original purpose. So fix it with this patch.

Fixes: a0d4c7eb71dd ("mmc: block: Add CMD13 polling for MMC IOCTLS with R1B response")
Cc: stable@vger.kernel.org
Reported-by: Zhan Liu <zliua@micron.com>
Signed-off-by: Zhan Liu <zliua@micron.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/mmc/core/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 8d3df0be0355..42e27a298218 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -580,7 +580,7 @@ static int __mmc_blk_ioctl_cmd(struct mmc_card *card, struct mmc_blk_data *md,
 
 	memcpy(&(idata->ic.response), cmd.resp, sizeof(cmd.resp));
 
-	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B)) {
+	if (idata->rpmb || (cmd.flags & MMC_RSP_R1B) == MMC_RSP_R1B) {
 		/*
 		 * Ensure RPMB/R1B command has completed by polling CMD13
 		 * "Send Status".
-- 
2.17.1

