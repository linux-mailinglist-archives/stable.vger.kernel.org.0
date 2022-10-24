Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0CE60B251
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234464AbiJXQpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:45:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234990AbiJXQoK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:44:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB8199E2C2;
        Mon, 24 Oct 2022 08:30:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2F947B811A5;
        Mon, 24 Oct 2022 12:07:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 838A2C433C1;
        Mon, 24 Oct 2022 12:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613229;
        bh=Ys3ka49cccFJzfsTCTuZ+erQPYHY5yRX3BygybRzjkA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2Ry+33JZoizGkywHI81h3wacURBrdYsrHmHBSB8m/mp5kQFGn7Q00A9gsIrlzfg0
         qz6AVX1BzDtKJ7WrCzn0xJw+bSAAZX+u/N9PCAiCpwWgTzKmz1xQXuqhSagpfsK5Vp
         Y3sgESGOfOaawnp/xv4enJ82ladi/Y/ISfsSiIAY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helge Deller <deller@gmx.de>
Subject: [PATCH 5.4 028/255] parisc: fbdev/stifb: Align graphics memory size to 4MB
Date:   Mon, 24 Oct 2022 13:28:58 +0200
Message-Id: <20221024113003.381799170@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
 


