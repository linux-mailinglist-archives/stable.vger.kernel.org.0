Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7A9366C545
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:04:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232249AbjAPQES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjAPQDi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:03:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9FC523C78
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:02:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56CD061042
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:02:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6FBC433EF;
        Mon, 16 Jan 2023 16:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884955;
        bh=z0wSYaycW+TsNEC5o6aMzEGAU9pzWzENPsa1/1DLLGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D98Lcz2m2c1fH4TslMQjpUS7C+XvnUXA/VjF8kzlFB8OzC/mnV4k5cFrjlhhzo1xJ
         rYInB3m078PzNLTetJAoW0RC7yMCYVwCXQniJWRaJEzCOhULECfaYpNqHsaFktWfRO
         SGKUltnnbG7o3SnC3tz6dv/zjdg+dyHbq9i2MF4Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, yang.yang29@zte.com.cn,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 02/86] ALSA: control-led: use strscpy in set_led_id()
Date:   Mon, 16 Jan 2023 16:50:36 +0100
Message-Id: <20230116154747.162412721@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
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


