Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E9059D396
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 10:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241756AbiHWIIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241760AbiHWIIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:08:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4F86C762;
        Tue, 23 Aug 2022 01:05:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6BAD56120C;
        Tue, 23 Aug 2022 08:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 725EFC433C1;
        Tue, 23 Aug 2022 08:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661241904;
        bh=gAdVwi5b46D9uvxjWOaMgLJiK7BOtIW4GyeExVWcIaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cdFIPSW1gimQ5NgG+fqURfYN6hTs0B76dQQesmqxPZBn5H6QMK1OXxm/AeUSsqdJa
         l50NuKEIcdGzKPiOJsBhovCmSjmtgoQl/vA4MxT/B0oB/TqoPaMFuyV4HcbiliuMrr
         Em+8V9W5bNnfrC9BzmmKYIVNjrHbUwLZoyAIoORo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.19 015/365] mmc: pxamci: Fix another error handling path in pxamci_probe()
Date:   Tue, 23 Aug 2022 09:58:36 +0200
Message-Id: <20220823080118.811898619@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
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

commit b886f54c300d31c109d2e4336b22922b64e7ba7d upstream.

The commit in Fixes: has introduced an new error handling without branching
to the existing error handling path.

Update it now and release some resources if pxamci_init_ocr() fails.

Fixes: 61951fd6cb49 ("mmc: pxamci: let mmc core handle regulators")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/07a2dcebf8ede69b484103de8f9df043f158cffd.1658862932.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/pxamci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mmc/host/pxamci.c
+++ b/drivers/mmc/host/pxamci.c
@@ -672,7 +672,7 @@ static int pxamci_probe(struct platform_
 
 	ret = pxamci_init_ocr(host);
 	if (ret < 0)
-		return ret;
+		goto out;
 
 	mmc->caps = 0;
 	host->cmdat = 0;


