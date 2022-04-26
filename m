Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C6850F5D9
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233591AbiDZIzH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345813AbiDZIw3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:52:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 599B4D64DD;
        Tue, 26 Apr 2022 01:41:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 8907CCE1BBB;
        Tue, 26 Apr 2022 08:40:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745ECC385A0;
        Tue, 26 Apr 2022 08:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650962456;
        bh=BYqfI8ZIYsspdxUeiglQ4TrkrQOzO7vjnIDW9rFWqmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kN5AeDPQCeOVxdHVFnnpmHMleyEyUQxeXcXhkDUXs+LKAmNLBxDK7iY2HMj3S2Awu
         ei85DmzghTMvmz9QAF0VQrR7SGfr6dlev1gDtgJzMVbrFSk9Jx1m7Yo8fPOuNiSPZi
         xXRKbLhzRNMbnwMNch+IHPfRAB76TqI8iDtlByq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 103/124] ASoC: soc-dapm: fix two incorrect uses of list iterator
Date:   Tue, 26 Apr 2022 10:21:44 +0200
Message-Id: <20220426081750.225761259@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaomeng Tong <xiam0nd.tong@gmail.com>

commit f730a46b931d894816af34a0ff8e4ad51565b39f upstream.

These two bug are here:
	list_for_each_entry_safe_continue(w, n, list,
					power_list);
	list_for_each_entry_safe_continue(w, n, list,
					power_list);

After the list_for_each_entry_safe_continue() exits, the list iterator
will always be a bogus pointer which point to an invalid struct objdect
containing HEAD member. The funciton poniter 'w->event' will be a
invalid value which can lead to a control-flow hijack if the 'w' can be
controlled.

The original intention was to continue the outer list_for_each_entry_safe()
loop with the same entry if w->event is NULL, but misunderstanding the
meaning of list_for_each_entry_safe_continue().

So just add a 'continue;' to fix the bug.

Cc: stable@vger.kernel.org
Fixes: 163cac061c973 ("ASoC: Factor out DAPM sequence execution")
Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
Link: https://lore.kernel.org/r/20220329012134.9375-1-xiam0nd.tong@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/soc-dapm.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/sound/soc/soc-dapm.c
+++ b/sound/soc/soc-dapm.c
@@ -1685,8 +1685,7 @@ static void dapm_seq_run(struct snd_soc_
 		switch (w->id) {
 		case snd_soc_dapm_pre:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
@@ -1698,8 +1697,7 @@ static void dapm_seq_run(struct snd_soc_
 
 		case snd_soc_dapm_post:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,


