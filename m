Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 322B1535F8E
	for <lists+stable@lfdr.de>; Fri, 27 May 2022 13:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351593AbiE0Lks (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 May 2022 07:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351737AbiE0LkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 May 2022 07:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD9913128C;
        Fri, 27 May 2022 04:39:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4E9961CD8;
        Fri, 27 May 2022 11:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F254FC385A9;
        Fri, 27 May 2022 11:39:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653651551;
        bh=aARjXd9mcvbcdHWE51vJ2pbllbwuZ37CccrqNv/hH70=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FthS+chxGEIVbSDtksvaPGklXL0sav/c5HtkB4epvvJ2fO1vZcr/+zJe4G6G4hYUE
         s8n/lnf7ETUpHy/O0+skXij2R/fzXzVrCMxIvISe2CVTiEFFuPIG+HWRSrOqzIDM6c
         qefLKpIEKvOMqgxYyTWRNtqK28lBg74+3sFkZetM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH 5.10 032/163] random: do not sign extend bytes for rotation when mixing
Date:   Fri, 27 May 2022 10:48:32 +0200
Message-Id: <20220527084832.607944244@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220527084828.156494029@linuxfoundation.org>
References: <20220527084828.156494029@linuxfoundation.org>
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

From: "Jason A. Donenfeld" <Jason@zx2c4.com>

commit 0d9488ffbf2faddebc6bac055bfa6c93b94056a3 upstream.

By using `char` instead of `unsigned char`, certain platforms will sign
extend the byte when `w = rol32(*bytes++, input_rotate)` is called,
meaning that bit 7 is overrepresented when mixing. This isn't a real
problem (unless the mixer itself is already broken) since it's still
invertible, but it's not quite correct either. Fix this by using an
explicit unsigned type.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/random.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/char/random.c
+++ b/drivers/char/random.c
@@ -547,7 +547,7 @@ static void _mix_pool_bytes(struct entro
 	unsigned long i, tap1, tap2, tap3, tap4, tap5;
 	int input_rotate;
 	int wordmask = r->poolinfo->poolwords - 1;
-	const char *bytes = in;
+	const unsigned char *bytes = in;
 	__u32 w;
 
 	tap1 = r->poolinfo->tap1;


