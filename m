Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6975F50F440
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 10:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbiDZIfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 04:35:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345094AbiDZIeF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 04:34:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 557286D4E0;
        Tue, 26 Apr 2022 01:26:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E599B81CF5;
        Tue, 26 Apr 2022 08:26:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54E1DC385A4;
        Tue, 26 Apr 2022 08:25:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650961559;
        bh=OZh4LPinysjplNiwT4eLfT6wOyCunHQ9OYvn5K7otxY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWTt+8fiJe7yNaIvAzBpg5q87Hg4LwrxKRT9UrsXV+7ZjSuxRKwfKD/3nOBMFfRuO
         U0IH2RoXQUOQg7qvSN4tYS0kzSzQ6a2Tg4b8i8usy5hSUuGL69ep9ucyyTUJVVZlns
         w/yqQhS7jxV0EwGRcl0x90dx8eZiqZimLeF5tHtM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.14 26/43] ASoC: soc-dapm: fix two incorrect uses of list iterator
Date:   Tue, 26 Apr 2022 10:21:08 +0200
Message-Id: <20220426081735.290430235@linuxfoundation.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220426081734.509314186@linuxfoundation.org>
References: <20220426081734.509314186@linuxfoundation.org>
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
@@ -1617,8 +1617,7 @@ static void dapm_seq_run(struct snd_soc_
 		switch (w->id) {
 		case snd_soc_dapm_pre:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,
@@ -1630,8 +1629,7 @@ static void dapm_seq_run(struct snd_soc_
 
 		case snd_soc_dapm_post:
 			if (!w->event)
-				list_for_each_entry_safe_continue(w, n, list,
-								  power_list);
+				continue;
 
 			if (event == SND_SOC_DAPM_STREAM_START)
 				ret = w->event(w,


