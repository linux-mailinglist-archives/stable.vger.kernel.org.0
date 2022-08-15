Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03E65593AF8
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233271AbiHOUG5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346058AbiHOUGA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9843481B02;
        Mon, 15 Aug 2022 11:55:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45FC8B8105C;
        Mon, 15 Aug 2022 18:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0CA0C433D7;
        Mon, 15 Aug 2022 18:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589699;
        bh=4WBlhzPsjfVj1rRFmuAP5awjPtNhQi4gcsTz5aOQEgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aWYApASO/dsnHAGhXRDvtJqaIwS5Lt5xu7YLNjsRz/eL2uk3Yt2gnBYNQ9lDmwjNk
         zprJ43RM9OPS6vTor4MTGrDNJpRSE8Yrx0i/IiCA3teCve+BP+gOfKi+ST8vI7ZmTp
         HcsmEu6eufxyFDSb3bU5Gm28lqbg95/JCjClx8fs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Daniel J. Ogorchock" <djogorchock@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.18 0020/1095] HID: nintendo: Add missing array termination
Date:   Mon, 15 Aug 2022 19:50:19 +0200
Message-Id: <20220815180430.187702863@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

commit ab5f3404b7762b88403fbddbdda6b1b464bd6cbc upstream.

joycon_dpad_inputs_jc[] is unterminated. This may result in odd warnings
such as

input: input_set_capability: invalid code 3077588140 for type 1

or in kernel crashes in nintendo_hid_probe(). Terminate the array to fix
the problem.

Fixes: 2af16c1f846bd ("HID: nintendo: add nintendo switch controller driver")
Cc: Daniel J. Ogorchock <djogorchock@gmail.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Reviewed-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-nintendo.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hid/hid-nintendo.c
+++ b/drivers/hid/hid-nintendo.c
@@ -1586,6 +1586,7 @@ static const unsigned int joycon_button_
 /* We report joy-con d-pad inputs as buttons and pro controller as a hat. */
 static const unsigned int joycon_dpad_inputs_jc[] = {
 	BTN_DPAD_UP, BTN_DPAD_DOWN, BTN_DPAD_LEFT, BTN_DPAD_RIGHT,
+	0 /* 0 signals end of array */
 };
 
 static int joycon_input_create(struct joycon_ctlr *ctlr)


