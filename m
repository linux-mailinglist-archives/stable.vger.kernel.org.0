Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E9774FD064
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 08:45:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbiDLGqP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 02:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351180AbiDLGoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 02:44:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D66B39830;
        Mon, 11 Apr 2022 23:37:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E49E961902;
        Tue, 12 Apr 2022 06:37:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED668C385A1;
        Tue, 12 Apr 2022 06:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649745459;
        bh=Ur7rnRKD7I0yAumOWBGWGZkPPf4CPiK8FlaCdTnTWQw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kofISyJlfKaddVDd1GKP2sPnWzoI/7VF2c4xhhLY0zFkrpRvoEUwCTDD5LB3sH3rM
         qI8zSuXzmefpFstbZibeePGBgDYlYIFAQ/aVcZK/vMqLKI2FLJyJhy/xTt8alXXHve
         UYq2m+P/LDFd+Sa866BAPurQlhtHAPqfNlEh/q2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 102/171] scsi: zorro7xx: Fix a resource leak in zorro7xx_remove_one()
Date:   Tue, 12 Apr 2022 08:29:53 +0200
Message-Id: <20220412062930.835918660@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062927.870347203@linuxfoundation.org>
References: <20220412062927.870347203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 16ed828b872d12ccba8f07bcc446ae89ba662f9c ]

The error handling path of the probe releases a resource that is not freed
in the remove function. In some cases, a ioremap() must be undone.

Add the missing iounmap() call in the remove function.

Link: https://lore.kernel.org/r/247066a3104d25f9a05de8b3270fc3c848763bcc.1647673264.git.christophe.jaillet@wanadoo.fr
Fixes: 45804fbb00ee ("[SCSI] 53c700: Amiga Zorro NCR53c710 SCSI")
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/zorro7xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/zorro7xx.c b/drivers/scsi/zorro7xx.c
index 27b9e2baab1a..7acf9193a9e8 100644
--- a/drivers/scsi/zorro7xx.c
+++ b/drivers/scsi/zorro7xx.c
@@ -159,6 +159,8 @@ static void zorro7xx_remove_one(struct zorro_dev *z)
 	scsi_remove_host(host);
 
 	NCR_700_release(host);
+	if (host->base > 0x01000000)
+		iounmap(hostdata->base);
 	kfree(hostdata);
 	free_irq(host->irq, host);
 	zorro_release_device(z);
-- 
2.35.1



