Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 147E64CF813
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238004AbiCGJve (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240227AbiCGJuq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:50:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7871F4E3BE;
        Mon,  7 Mar 2022 01:44:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F095BB80F9F;
        Mon,  7 Mar 2022 09:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1BBC340E9;
        Mon,  7 Mar 2022 09:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646249;
        bh=0tQu0CpwRLss3+hMQbOV2USPB0Dgy+d/d/xMQFVe7w8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XPgu/peia4vZzCumLLgXLL0q+bodBVsUBUuDxaRVs2JbyAJQI9ROrS82ijTOkoBSu
         Et4HgINXO5k7ejY4h6HyaUaG8TNyTozEGOBV1hODdZf4dJw46HG2vO4CKNhzH3VYMU
         FE4r0nOpPe6DuRnq35t6d5F+yzWRsOpOuBtQxBbo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lars Poeschel <poeschel@lemonage.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 5.15 183/262] auxdisplay: lcd2s: Fix lcd2s_redefine_char() feature
Date:   Mon,  7 Mar 2022 10:18:47 +0100
Message-Id: <20220307091707.578968902@linuxfoundation.org>
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

commit 4424c35ead667ba2e8de7ab8206da66453e6f728 upstream.

It seems that the lcd2s_redefine_char() has never been properly
tested. The buffer is filled by DEF_CUSTOM_CHAR command followed
by the character number (from 0 to 7), but immediately after that
these bytes are rewritten by the decoded hex stream.

Fix the index to fill the buffer after the command and number.

Fixes: 8c9108d014c5 ("auxdisplay: add a driver for lcd2s character display")
Cc: Lars Poeschel <poeschel@lemonage.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-by: Geert Uytterhoeven <geert@linux-m68k.org>
[fixed typo in commit message]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/auxdisplay/lcd2s.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/auxdisplay/lcd2s.c
+++ b/drivers/auxdisplay/lcd2s.c
@@ -238,7 +238,7 @@ static int lcd2s_redefine_char(struct ch
 	if (buf[1] > 7)
 		return 1;
 
-	i = 0;
+	i = 2;
 	shift = 0;
 	value = 0;
 	while (*esc && i < LCD2S_CHARACTER_SIZE + 2) {


