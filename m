Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9099E69CC32
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 14:38:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbjBTNiF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 08:38:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231708AbjBTNiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 08:38:04 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029DCB745
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:38:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 45C1CCE0FCF
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 13:38:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26DB8C433D2;
        Mon, 20 Feb 2023 13:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676900280;
        bh=V0SzFyq0MH3ytVl5/P65voB+LvKwGIsuXktgN4BiHjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ppihxhBbc8VCKBRhK1OCzdkHNJKkhoXqefa3JMllTCvHDe/Mcl+mR9konTYT8c3Ln
         k1+HNO2iPdDdLUfEBrXM2/AFpn3j0PXOGALICB+xXKGDc9mBsLUgCQKn8Gb4mJMVgY
         MuUaUm6EWyaR52fy4n1v2dUzi/4BYX3mGAwfsGUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 4.14 19/53] parisc: Fix return code of pdc_iodc_print()
Date:   Mon, 20 Feb 2023 14:35:45 +0100
Message-Id: <20230220133548.852227673@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133548.158615609@linuxfoundation.org>
References: <20230220133548.158615609@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit 5d1335dabb3c493a3d6d5b233953b6ac7b6c1ff2 upstream.

There is an off-by-one if the printed string includes a new-line
char.

Cc: stable@vger.kernel.org
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/firmware.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1197,7 +1197,7 @@ static char __attribute__((aligned(64)))
  */
 int pdc_iodc_print(const unsigned char *str, unsigned count)
 {
-	unsigned int i;
+	unsigned int i, found = 0;
 	unsigned long flags;
 
 	for (i = 0; i < count;) {
@@ -1206,6 +1206,7 @@ int pdc_iodc_print(const unsigned char *
 			iodc_dbuf[i+0] = '\r';
 			iodc_dbuf[i+1] = '\n';
 			i += 2;
+			found = 1;
 			goto print;
 		default:
 			iodc_dbuf[i] = str[i];
@@ -1222,7 +1223,7 @@ print:
                     __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
         spin_unlock_irqrestore(&pdc_lock, flags);
 
-	return i;
+	return i - found;
 }
 
 #if !defined(BOOTLOADER)


