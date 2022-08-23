Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4FBD59DA51
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:08:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242703AbiHWKHL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 06:07:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352161AbiHWKEh (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 06:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4119671724;
        Tue, 23 Aug 2022 01:51:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A0A086150F;
        Tue, 23 Aug 2022 08:51:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8494C433D6;
        Tue, 23 Aug 2022 08:51:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244691;
        bh=IKMkzTsYh/OjMKBcBRBsOD5re4x3laIipvrW/22RXUE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rivc/sPXU4ei2BrY2oMC7jqOgq8fvjvCR23NaPQPnie+yy5nP5Ogx8E/U8TNLV1b8
         xBUOa4tUe+B2SqBlB8J0B/9PKlPCbqjPls0DRYskrQLusJdHpZS9FTRm8kJ7b4S+GT
         mKQALecrGHSQ7zn5Lx6AM9Q0LZiVANdtmY1tC9AQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= 
        <amadeuszx.slawinski@linux.intel.com>, Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.14 176/229] ALSA: info: Fix llseek return value when using callback
Date:   Tue, 23 Aug 2022 10:25:37 +0200
Message-Id: <20220823080059.901302464@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
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

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit 9be080edcca330be4af06b19916c35227891e8bc upstream.

When using callback there was a flow of

	ret = -EINVAL
	if (callback) {
		offset = callback();
		goto out;
	}
	...
	offset = some other value in case of no callback;
	ret = offset;
out:
	return ret;

which causes the snd_info_entry_llseek() to return -EINVAL when there is
callback handler. Fix this by setting "ret" directly to callback return
value before jumping to "out".

Fixes: 73029e0ff18d ("ALSA: info - Implement common llseek for binary mode")
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20220817124924.3974577-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/core/info.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/core/info.c
+++ b/sound/core/info.c
@@ -127,9 +127,9 @@ static loff_t snd_info_entry_llseek(stru
 	entry = data->entry;
 	mutex_lock(&entry->access);
 	if (entry->c.ops->llseek) {
-		offset = entry->c.ops->llseek(entry,
-					      data->file_private_data,
-					      file, offset, orig);
+		ret = entry->c.ops->llseek(entry,
+					   data->file_private_data,
+					   file, offset, orig);
 		goto out;
 	}
 


