Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E932759E27C
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 14:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358207AbiHWLrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 07:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358483AbiHWLqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 07:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4915BD21FA;
        Tue, 23 Aug 2022 02:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 27B2DB81C85;
        Tue, 23 Aug 2022 09:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F20CC433D6;
        Tue, 23 Aug 2022 09:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661247008;
        bh=gAdVwi5b46D9uvxjWOaMgLJiK7BOtIW4GyeExVWcIaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=idYZ/f8kyhp9lNtZD/jq9JKx7vR1jjbf2Tr8yuIxU0NDe4fIXjkXIBytNKd+5Dl+g
         bgM91kqDhSZGmSFxBxJlxdCNkUrelAqVqN/6F1DJ6AopydMMU3BNc6g7jP82keH0Ek
         z6rosMrgVYEbTnl1hY25fGVmSjgFhJLaMT52lFTY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.4 289/389] mmc: pxamci: Fix another error handling path in pxamci_probe()
Date:   Tue, 23 Aug 2022 10:26:07 +0200
Message-Id: <20220823080127.624558985@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080115.331990024@linuxfoundation.org>
References: <20220823080115.331990024@linuxfoundation.org>
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


