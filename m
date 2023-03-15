Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0CBD6BBA24
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 17:47:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbjCOQr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 12:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232011AbjCOQrv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 12:47:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28F737F28;
        Wed, 15 Mar 2023 09:47:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2F68B81E38;
        Wed, 15 Mar 2023 16:47:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20226C433EF;
        Wed, 15 Mar 2023 16:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678898840;
        bh=Ar5hmSEYmhxrLosdQWXGP9BQyDb9mRGH/lEBZOlc9gM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=abqkue1D7BhzlKzKB4tRRrpdzta3fzCNxp2lV+hhobmsZrWaBAb1mKy70EE9bgR+d
         Rkdubyw1LyUYn9KQ5NAJzQOJFyYPhmoSdHrAo1hize7iQWjTvl1MQipkAVv+4ylkYd
         P+TlyqhZ1vruiQjG8Rlg08ywNvT9yY33Z3blTBzZKE138aU1dnH4Fb0vBkefXbb2HD
         /csBRupoU0ipP+zHC93VOit3L0vfkLE9Gn3KNr3c0p1zNus4isRb6kpy9gY34XC6mV
         kLNpJSQ2J5UtNGrJm0cfgVM1+0KOw0ImZsv0LpGq4aFddqvnnM1kfihpRKLBYL2yIP
         5m8No7WXoB0bw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     johannes@sipsolutions.net, nbd@nbd.name,
        linux-wireless@vger.kernel.org, Thomas Mann <rauchwolke@gmx.net>,
        stable@vger.kernel.org
Subject: Re: [PATCH] wifi: mac80211: Serialize ieee80211_handle_wake_tx_queue()
References: <20230314211122.111688-1-alexander@wetzel-home.de>
Date:   Wed, 15 Mar 2023 18:47:15 +0200
In-Reply-To: <20230314211122.111688-1-alexander@wetzel-home.de> (Alexander
        Wetzel's message of "Tue, 14 Mar 2023 22:11:22 +0100")
Message-ID: <87fsa6vu5o.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alexander Wetzel <alexander@wetzel-home.de> writes:

> ieee80211_handle_wake_tx_queue must not run concurrent multiple times.
> It calls ieee80211_txq_schedule_start() and the drivers migrated to iTXQ
> do not expect overlapping drv_tx() calls.
>
> This fixes 'c850e31f79f0 ("wifi: mac80211: add internal handler for
> wake_tx_queue")', which introduced ieee80211_handle_wake_tx_queue.
> Drivers started to use it with 'a790cc3a4fad ("wifi: mac80211: add
> wake_tx_queue callback to drivers")'.
> But only after fixing an independent bug with
> '4444bc2116ae ("wifi: mac80211: Proper mark iTXQs for resumption")'
> problematic concurrent calls really happened and exposed the initial
> issue.

This is cosmetics but the recommended way to refer to commits is:

  This fixes commit c850e31f79f0 ("wifi: mac80211: add internal handler
  for wake_tx_queue"), which introduced ieee80211_handle_wake_tx_queue....

More info:

https://www.kernel.org/doc/html/latest/process/submitting-patches.html#describe-your-changes

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
