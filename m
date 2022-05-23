Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 661FB531BCB
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240016AbiEWRRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240211AbiEWRQK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:16:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53EA769B4E;
        Mon, 23 May 2022 10:12:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3621DB81202;
        Mon, 23 May 2022 17:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F43FC385A9;
        Mon, 23 May 2022 17:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653325950;
        bh=dJC52LsQXQSZFqjHlNkBmh1vXiFgwOEY/KbXbxy7Beg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jRodq6HwD+YMa3j3M3OCB6PH0/9WY47RkQ0YdZybOtp10iAlhExEJpeZ/6IpABX/R
         hD1yETTCuKcp8KaYzDfiGPrfTIuLLfRKUVJI1kEY1gsRea71PY/WGXpsXJmjI96Tnr
         BRXb6PeNzvEyQbgNsylfs9+Mv4Hz6Z4HTjWWjcb0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: [PATCH 5.4 20/68] mmc: block: Use generic_cmd6_time when modifying INAND_CMD38_ARG_EXT_CSD
Date:   Mon, 23 May 2022 19:04:47 +0200
Message-Id: <20220523165805.976597021@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165802.500642349@linuxfoundation.org>
References: <20220523165802.500642349@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ulf Hansson <ulf.hansson@linaro.org>

commit ad91619aa9d78ab1c6d4a969c3db68bc331ae76c upstream

The INAND_CMD38_ARG_EXT_CSD is a vendor specific EXT_CSD register, which is
used to prepare an erase/trim operation. However, it doesn't make sense to
use a timeout of 10 minutes while updating the register, which becomes the
case when the timeout_ms argument for mmc_switch() is set to zero.

Instead, let's use the generic_cmd6_time, as that seems like a reasonable
timeout to use for these cases.

Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Link: https://lore.kernel.org/r/20200122142747.5690-3-ulf.hansson@linaro.org
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -1126,7 +1126,7 @@ static void mmc_blk_issue_discard_rq(str
 					 card->erase_arg == MMC_TRIM_ARG ?
 					 INAND_CMD38_ARG_TRIM :
 					 INAND_CMD38_ARG_ERASE,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 		}
 		if (!err)
 			err = mmc_erase(card, from, nr, card->erase_arg);
@@ -1168,7 +1168,7 @@ retry:
 				 arg == MMC_SECURE_TRIM1_ARG ?
 				 INAND_CMD38_ARG_SECTRIM1 :
 				 INAND_CMD38_ARG_SECERASE,
-				 0);
+				 card->ext_csd.generic_cmd6_time);
 		if (err)
 			goto out_retry;
 	}
@@ -1186,7 +1186,7 @@ retry:
 			err = mmc_switch(card, EXT_CSD_CMD_SET_NORMAL,
 					 INAND_CMD38_ARG_EXT_CSD,
 					 INAND_CMD38_ARG_SECTRIM2,
-					 0);
+					 card->ext_csd.generic_cmd6_time);
 			if (err)
 				goto out_retry;
 		}


