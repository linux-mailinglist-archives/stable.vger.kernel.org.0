Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 95A6466C45F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230120AbjAPPyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:54:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbjAPPyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:54:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFAB31D905
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:54:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99944B81052
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C16C433D2;
        Mon, 16 Jan 2023 15:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884450;
        bh=z0wSYaycW+TsNEC5o6aMzEGAU9pzWzENPsa1/1DLLGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFDftzoseNElioiwsnY09r+64ELFNS8prC8v0pnV2KaIRL30eMxYWcB6eMLdhmxy5
         AxXPlfzPKrnfubRDpsMFWa7aGt1/amheGfKShUkhtUzbdPKFkqOw70aBXzHhw6agCE
         P4yghuJIAFPLLsy219FVaGtFn5M+rZOHL8AfAYRg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, yang.yang29@zte.com.cn,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 003/183] ALSA: control-led: use strscpy in set_led_id()
Date:   Mon, 16 Jan 2023 16:48:46 +0100
Message-Id: <20230116154803.486813422@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jaroslav Kysela <perex@perex.cz>

commit 70051cffb31b5ee09096351c3b41fcae6f89de31 upstream.

The use of strncpy() in the set_led_id() was incorrect.
The len variable should use 'min(sizeof(buf2) - 1, count)'
expression.

Use strscpy() function to simplify things and handle the error gracefully.

Fixes: a135dfb5de15 ("ALSA: led control - add sysfs kcontrol LED marking layer")
Reported-by: yang.yang29@zte.com.cn
Link: https://lore.kernel.org/alsa-devel/202301091945513559977@zte.com.cn/
Cc: <stable@vger.kernel.org>
Signed-off-by: Jaroslav Kysela <perex@perex.cz>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/control_led.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/sound/core/control_led.c
+++ b/sound/core/control_led.c
@@ -530,12 +530,11 @@ static ssize_t set_led_id(struct snd_ctl
 			  bool attach)
 {
 	char buf2[256], *s, *os;
-	size_t len = max(sizeof(s) - 1, count);
 	struct snd_ctl_elem_id id;
 	int err;
 
-	strncpy(buf2, buf, len);
-	buf2[len] = '\0';
+	if (strscpy(buf2, buf, sizeof(buf2)) < 0)
+		return -E2BIG;
 	memset(&id, 0, sizeof(id));
 	id.iface = SNDRV_CTL_ELEM_IFACE_MIXER;
 	s = buf2;


