Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 737045216B1
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242500AbiEJNRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242501AbiEJNQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:16:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A0B49C80;
        Tue, 10 May 2022 06:12:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 80017CE1EE5;
        Tue, 10 May 2022 13:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949F1C385A6;
        Tue, 10 May 2022 13:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188352;
        bh=xcXfCRcoyhfyUlxipCdVEsXYo0JlNezMMEx8Crxqedw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vI3AnWVmVz2eyEJi80ZcdTh78S/n948CeS+XPg4463RmH6HHlmqnwDPOMhLfdt4Eo
         6FgdQoyA8Q2uqz47utQJ2bydA4SWUxjjm04JikLAEq3akBMvMD2wA4Fsa2W4Bd9SJT
         NlPE6fJtJxfsMvwAG8WdT8DEUJ+wrqL+SHMMEFRk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 4.9 45/66] ALSA: fireworks: fix wrong return count shorter than expected by 4 bytes
Date:   Tue, 10 May 2022 15:07:35 +0200
Message-Id: <20220510130731.088702139@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takashi Sakamoto <o-takashi@sakamocchi.jp>

commit eb9d84b0ffe39893cb23b0b6712bbe3637fa25fa upstream.

ALSA fireworks driver has a bug in its initial state to return count
shorter than expected by 4 bytes to userspace applications when handling
response frame for Echo Audio Fireworks transaction. It's due to missing
addition of the size for the type of event in ALSA firewire stack.

Fixes: 555e8a8f7f14 ("ALSA: fireworks: Add command/response functionality into hwdep interface")
Cc: <stable@vger.kernel.org>
Signed-off-by: Takashi Sakamoto <o-takashi@sakamocchi.jp>
Link: https://lore.kernel.org/r/20220424102428.21109-1-o-takashi@sakamocchi.jp
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/firewire/fireworks/fireworks_hwdep.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/firewire/fireworks/fireworks_hwdep.c
+++ b/sound/firewire/fireworks/fireworks_hwdep.c
@@ -35,6 +35,7 @@ hwdep_read_resp_buf(struct snd_efw *efw,
 	type = SNDRV_FIREWIRE_EVENT_EFW_RESPONSE;
 	if (copy_to_user(buf, &type, sizeof(type)))
 		return -EFAULT;
+	count += sizeof(type);
 	remained -= sizeof(type);
 	buf += sizeof(type);
 


