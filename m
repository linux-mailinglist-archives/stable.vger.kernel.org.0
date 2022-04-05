Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6F074F32F0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 15:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbiDEIxT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241111AbiDEIct (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82C011583E;
        Tue,  5 Apr 2022 01:27:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 35C84B81B13;
        Tue,  5 Apr 2022 08:27:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D97C385A2;
        Tue,  5 Apr 2022 08:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147264;
        bh=e8M3m26qr3VKHSlMi/VvMyNC/NrvzXKmemOXvTAkL4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASlefjH7DVGX3yrrHJMsotRY8ziNar54VBYwD85HUeeOoTqMx/FSicKcrj4kYaqos
         BDQKBPXjTyaZ/rsv6oQMqjxZGJtNkTqgob3wo9GsmBl6+cMsP0xbGTHYb7wC/vLJDr
         ZyHH1lqyU0N8sXNlQbvi1CN2ZSZ/eB3IiUGYZ8mE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Abhijeet V <abhijeetviswa@gmail.com>
Subject: [PATCH 5.17 1062/1126] platform/x86: asus-wmi: Fix regression when probing for fan curve control
Date:   Tue,  5 Apr 2022 09:30:09 +0200
Message-Id: <20220405070438.633178279@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Hans de Goede <hdegoede@redhat.com>

commit d717e4509af0380a94dbc28b61839df39f17e1eb upstream.

The fan curve control patches introduced a regression for at least the
TUF FX506 and possibly other TUF series laptops that do not have support
for fan curve control.

As part of the probing process, asus_wmi_evaluate_method_buf is called
to get the factory default fan curve . The WMI management function
returns 0 on certain laptops to indicate lack of fan curve control
instead of ASUS_WMI_UNSUPPORTED_METHOD. This 0 is transformed to
-ENODATA which results in failure when probing.

Fixes: 0f0ac158d28f ("platform/x86: asus-wmi: Add support for custom fan curves")
Reported-and-tested-by: Abhijeet V <abhijeetviswa@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20220205112840.33095-1-hdegoede@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/asus-wmi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -2059,7 +2059,7 @@ static int fan_boost_mode_check_present(
 	err = asus_wmi_get_devstate(asus, ASUS_WMI_DEVID_FAN_BOOST_MODE,
 				    &result);
 	if (err) {
-		if (err == -ENODEV)
+		if (err == -ENODEV || err == -ENODATA)
 			return 0;
 		else
 			return err;


