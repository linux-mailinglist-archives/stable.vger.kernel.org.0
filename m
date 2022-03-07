Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2CC54CF84C
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235424AbiCGJwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240281AbiCGJus (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:48 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08EC974DC3;
        Mon,  7 Mar 2022 01:44:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 58C736116E;
        Mon,  7 Mar 2022 09:44:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 534BFC340E9;
        Mon,  7 Mar 2022 09:44:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646262;
        bh=7op5MFowyiInE3pMmlvDncVgyDPHUsh9zGiv/8ME6CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JjM2vfxkbuBqLE9yoOy+6FqGTCqVZzQY/C/yWi1Nzed5NcAJasWvQPC218aFCaiwz
         wq7sUD+nR5lpnpgi5koQKY33kbYli6g5gc44Vs1aBqTUZcceyum6h2ixeRSJELCntO
         HMEh97MAFP3Jd5ZpBFB8JUHk0uB4FqU8wCWXXSXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 5.15 187/262] auxdisplay: lcd2s: Use proper API to free the instance of charlcd object
Date:   Mon,  7 Mar 2022 10:18:51 +0100
Message-Id: <20220307091707.746320066@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

commit 9ed331f8a0fb674f4f06edf05a1687bf755af27b upstream.

While it might work, the current approach is fragile in a few ways:
- whenever members in the structure are shuffled, the pointer will be wrong
- the resource freeing may include more than covered by kfree()

Fix this by using charlcd_free() call instead of kfree().

Fixes: 8c9108d014c5 ("auxdisplay: add a driver for lcd2s character display")
Cc: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/lcd2s.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/auxdisplay/lcd2s.c
+++ b/drivers/auxdisplay/lcd2s.c
@@ -336,7 +336,7 @@ static int lcd2s_i2c_probe(struct i2c_cl
 	return 0;
 
 fail1:
-	kfree(lcd);
+	charlcd_free(lcd2s->charlcd);
 	return err;
 }
 
@@ -345,7 +345,7 @@ static int lcd2s_i2c_remove(struct i2c_c
 	struct lcd2s_data *lcd2s = i2c_get_clientdata(i2c);
 
 	charlcd_unregister(lcd2s->charlcd);
-	kfree(lcd2s->charlcd);
+	charlcd_free(lcd2s->charlcd);
 	return 0;
 }
 


