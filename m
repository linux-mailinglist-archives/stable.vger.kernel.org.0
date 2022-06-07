Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFF4B541E55
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:29:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356142AbiFGW3L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:29:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358975AbiFGW1X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:27:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CEC72722B8;
        Tue,  7 Jun 2022 12:23:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A873DB823CC;
        Tue,  7 Jun 2022 19:23:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F8BC385A5;
        Tue,  7 Jun 2022 19:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629805;
        bh=/dvj1yLBraTRfb7jibzxDZgOea9b9knsNdoqbo1WkrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qfQdgLrfyeBrs/hHPpT8K5SYuApW5xjR/zgzbnl+3cpxRcDotUGgrQaVXEGRnarlg
         addFCpK7cr9wZd+dMIV8YnKUiCmLUdctYStaY7THD2OV+6PhFbbuzeW8Tbtb6ZRxIi
         0vqHAl8ZCtPwQCEDWJ/lqt5DIOHI3gYCxQl3c/YY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Puyou Lu <puyou.lu@gmail.com>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.18 806/879] lib/string_helpers: fix not adding strarray to devices resource list
Date:   Tue,  7 Jun 2022 19:05:24 +0200
Message-Id: <20220607165026.253151949@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Puyou Lu <puyou.lu@gmail.com>

commit cd290a9839cee2f6641558877e707bd373c8f6f1 upstream.

Add allocated strarray to device's resource list. This is a must to
automatically release strarray when the device disappears.

Without this fix we have a memory leak in the few drivers which use
devm_kasprintf_strarray().

Link: https://lkml.kernel.org/r/20220506044409.30066-1-puyou.lu@gmail.com
Link: https://lkml.kernel.org/r/20220506073623.2679-1-puyou.lu@gmail.com
Fixes: acdb89b6c87a ("lib/string_helpers: Introduce managed variant of kasprintf_strarray()")
Signed-off-by: Puyou Lu <puyou.lu@gmail.com>
Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/string_helpers.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/lib/string_helpers.c
+++ b/lib/string_helpers.c
@@ -757,6 +757,9 @@ char **devm_kasprintf_strarray(struct de
 		return ERR_PTR(-ENOMEM);
 	}
 
+	ptr->n = n;
+	devres_add(dev, ptr);
+
 	return ptr->array;
 }
 EXPORT_SYMBOL_GPL(devm_kasprintf_strarray);


