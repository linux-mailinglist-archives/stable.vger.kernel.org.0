Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAB653CEE1
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:48:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345179AbiFCRsZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:48:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345258AbiFCRsD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:48:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9400957994;
        Fri,  3 Jun 2022 10:44:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8E5AC61B38;
        Fri,  3 Jun 2022 17:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD11C341C0;
        Fri,  3 Jun 2022 17:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278271;
        bh=atzWDr3Jf2Jp/XXbxcAVp3pEhbI+lZ1uviGA5cgwK2I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ojoOvXXQOGMPpUtr9h7PR/gXZTbEWNZA/XQ8t5ejMu62jMPCZl+81QL73i/B8gypy
         E4zAkUMuxP1cnGKEgdYnVw+zIYziWlCkTBoAjwhqDHWI4H7X09uUR+R6I0hAsg9zJq
         Bu/yuxo1cQ0tCYg9MP9A3uHG1HUR4L1bekzJfXT4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dmitry Mastykin <dmastykin@astralinux.ru>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Fabio Estevam <festevam@gmail.com>
Subject: [PATCH 5.4 04/34] Input: goodix - fix spurious key release events
Date:   Fri,  3 Jun 2022 19:43:00 +0200
Message-Id: <20220603173816.122230068@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173815.990072516@linuxfoundation.org>
References: <20220603173815.990072516@linuxfoundation.org>
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

From: Dmitry Mastykin <dmastykin@astralinux.ru>

commit 24ef83f6e31d20fc121a7cd732b04b498475fca3 upstream.

The goodix panel sends spurious interrupts after a 'finger up' event,
which always cause a timeout.
We were exiting the interrupt handler by reporting touch_num == 0, but
this was still processed as valid and caused the code to use the
uninitialised point_data, creating spurious key release events.

Report an error from the interrupt handler so as to avoid processing
invalid point_data further.

Signed-off-by: Dmitry Mastykin <dmastykin@astralinux.ru>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20200316075302.3759-2-dmastykin@astralinux.ru
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/goodix.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -335,7 +335,7 @@ static int goodix_ts_read_input_report(s
 	 * The Goodix panel will send spurious interrupts after a
 	 * 'finger up' event, which will always cause a timeout.
 	 */
-	return 0;
+	return -ENOMSG;
 }
 
 static void goodix_ts_report_touch_8b(struct goodix_ts_data *ts, u8 *coor_data)


