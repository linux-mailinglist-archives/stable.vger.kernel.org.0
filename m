Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E47B5AB0A4
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiIBMyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:54:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238021AbiIBMxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:53:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 440AEE58B1;
        Fri,  2 Sep 2022 05:38:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 979AAB82A8B;
        Fri,  2 Sep 2022 12:37:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A69C433C1;
        Fri,  2 Sep 2022 12:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662122239;
        bh=lV7mb2d2P7zCPfmJmyz0dYwCOsfkfJLOefpZXPPvb/4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v575zYHYD0O6KL2SP9qdf9VRff1zVb7D7ghqntoQ0EuOaTsUXD9QfTczk7SEEPMDF
         XwGbFKl8Ib9mf5CSMGDL6aLIUHFbTHbKSMI/gwhUNkWSqtgRh9PbnOXLleHjxWey1m
         D0RqqlYvjfSyg38LD/JBKXkrWxwAUgqnqXYQgzVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Michael=20H=C3=BCbner?= <michaelh.95@t-online.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.19 26/72] HID: thrustmaster: Add sparco wheel and fix array length
Date:   Fri,  2 Sep 2022 14:19:02 +0200
Message-Id: <20220902121405.660611157@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.772492078@linuxfoundation.org>
References: <20220902121404.772492078@linuxfoundation.org>
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

From: Michael Hübner <michaelh.95@t-online.de>

commit d9a17651f3749e69890db57ca66e677dfee70829 upstream.

Add device id for the Sparco R383 Mod wheel.

Fix wheel info array length to match actual wheel count present in the array.

Signed-off-by: Michael Hübner <michaelh.95@t-online.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-thrustmaster.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hid/hid-thrustmaster.c
+++ b/drivers/hid/hid-thrustmaster.c
@@ -67,12 +67,13 @@ static const struct tm_wheel_info tm_whe
 	{0x0200, 0x0005, "Thrustmaster T300RS (Missing Attachment)"},
 	{0x0206, 0x0005, "Thrustmaster T300RS"},
 	{0x0209, 0x0005, "Thrustmaster T300RS (Open Wheel Attachment)"},
+	{0x020a, 0x0005, "Thrustmaster T300RS (Sparco R383 Mod)"},
 	{0x0204, 0x0005, "Thrustmaster T300 Ferrari Alcantara Edition"},
 	{0x0002, 0x0002, "Thrustmaster T500RS"}
 	//{0x0407, 0x0001, "Thrustmaster TMX"}
 };
 
-static const uint8_t tm_wheels_infos_length = 4;
+static const uint8_t tm_wheels_infos_length = 7;
 
 /*
  * This structs contains (in little endian) the response data


