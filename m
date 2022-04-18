Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D1D4C5057B1
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244014AbiDRNzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245244AbiDRNxJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:53:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B640457AC;
        Mon, 18 Apr 2022 06:02:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AF401B80EBA;
        Mon, 18 Apr 2022 13:02:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13455C385A1;
        Mon, 18 Apr 2022 13:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286952;
        bh=Hi+qGAM0+K6aRhN2ffkWQJ1vVgUzo9g09tmdPd5/DCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOsuXgiUj41zg/jb7FsqneN2hgTUMQBrTDLyQkshNcy/JOfN3I0h6lXaQ09t27MXD
         Rj9DtnoNbc7XHX5/O8k8QS3FHhu+DVG3JYDLw5pMoa6S7GQqOJUTWhYeiqabjLq2k/
         +CWQ2FSvRP9HuV8PS5PawsKG7LPG5UsqVem4+eFU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kunihiko Hayashi <hayashi.kunihiko@socionext.com>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 4.9 013/218] clk: uniphier: Fix fixed-rate initialization
Date:   Mon, 18 Apr 2022 14:11:19 +0200
Message-Id: <20220418121159.373216134@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121158.636999985@linuxfoundation.org>
References: <20220418121158.636999985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>

commit ca85a66710a8a1f6b0719397225c3e9ee0abb692 upstream.

Fixed-rate clocks in UniPhier don't have any parent clocks, however,
initial data "init.flags" isn't initialized, so it might be determined
that there is a parent clock for fixed-rate clock.

This sets init.flags to zero as initialization.

Cc: <stable@vger.kernel.org>
Fixes: 734d82f4a678 ("clk: uniphier: add core support code for UniPhier clock driver")
Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Link: https://lore.kernel.org/r/1646808918-30899-1-git-send-email-hayashi.kunihiko@socionext.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/uniphier/clk-uniphier-fixed-rate.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/uniphier/clk-uniphier-fixed-rate.c
+++ b/drivers/clk/uniphier/clk-uniphier-fixed-rate.c
@@ -33,6 +33,7 @@ struct clk_hw *uniphier_clk_register_fix
 
 	init.name = name;
 	init.ops = &clk_fixed_rate_ops;
+	init.flags = 0;
 	init.parent_names = NULL;
 	init.num_parents = 0;
 


