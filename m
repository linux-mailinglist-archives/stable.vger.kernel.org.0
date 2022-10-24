Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89F3E60A7F5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:00:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiJXNAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235144AbiJXM7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:59:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5B569AC1B;
        Mon, 24 Oct 2022 05:18:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 714AF612C3;
        Mon, 24 Oct 2022 12:17:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 843A5C433D6;
        Mon, 24 Oct 2022 12:17:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613836;
        bh=Ys3ka49cccFJzfsTCTuZ+erQPYHY5yRX3BygybRzjkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQwAPuVreDBRQzb+Q1lJi5xqGEWZueMXhWTDUFg4n97djBTGqA2tCFDo/aRf1Tkef
         SDmuZXwAkdQ1PDrwOKhl+S+JX5CgdmrZBzfsIp+OwGyCO4jVOHBAsFnhKAvD0U0Ly0
         C9SOsHEgmZ+xmrGntU23iZEPxkaZ6P6iqf6Z56V4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.10 033/390] parisc: fbdev/stifb: Align graphics memory size to 4MB
Date:   Mon, 24 Oct 2022 13:27:10 +0200
Message-Id: <20221024113024.012872639@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helge Deller <deller@gmx.de>

commit aca7c13d3bee81a968337a5515411409ae9d095d upstream.

Independend of the current graphics resolution, adjust the reported
graphics card memory size to the next 4MB boundary.
This fixes the fbtest program which expects a naturally aligned size.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/fbdev/stifb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/video/fbdev/stifb.c
+++ b/drivers/video/fbdev/stifb.c
@@ -1257,7 +1257,7 @@ static int __init stifb_init_fb(struct s
 	
 	/* limit fbsize to max visible screen size */
 	if (fix->smem_len > yres*fix->line_length)
-		fix->smem_len = yres*fix->line_length;
+		fix->smem_len = ALIGN(yres*fix->line_length, 4*1024*1024);
 	
 	fix->accel = FB_ACCEL_NONE;
 


