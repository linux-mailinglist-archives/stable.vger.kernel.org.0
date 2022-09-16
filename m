Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30BA15BA665
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 07:38:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiIPFij (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 01:38:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229964AbiIPFii (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 01:38:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480D471BD5;
        Thu, 15 Sep 2022 22:38:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0E2C3B823AE;
        Fri, 16 Sep 2022 05:38:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C9DC433C1;
        Fri, 16 Sep 2022 05:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663306714;
        bh=XjhJeM8qGrTfgtllNG60b4yqc1CpmpKRtgp6g86FThs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Knu9u1kNuImMnMOkFtkAMf06CxemF3MI2nB+BhrgdHRdnKM1k0T/099pJb0DjIaYK
         L6rN8XxhSdsI/t1z+v+tRAtRHQAzgu7vQTlTzClfaAasA7JGJHS26CNjp/yzLQ6xa/
         BcnGRusk1onJFxaXf+IDV/BwKyDTdRQ23rrH8dz5K6ZucvKcjnpnfC2XGZKL7gKVXG
         djagtWO1UTYpxVPfheQg26wISqHOZ7Zl0AzxgdoocJtUZ0yD7sdpgIFfr0sfjBwFta
         hULmZErfIzZVPZTaHXCzGJRWXSetNUfGtj+xAIkMHSicrKBMLpfQgbIT6ZOhqB5tuB
         IgJ0qIdIdMcgg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        Felix Fietkau <nbd@nbd.name>, stable@vger.kernel.org
Subject: Re: [PATCH] mac80211: Ensure vif queues are operational after start
References: <20220915130946.302803-1-alexander@wetzel-home.de>
Date:   Fri, 16 Sep 2022 08:38:31 +0300
In-Reply-To: <20220915130946.302803-1-alexander@wetzel-home.de> (Alexander
        Wetzel's message of "Thu, 15 Sep 2022 15:09:46 +0200")
Message-ID: <87y1ujanfs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Alexander Wetzel <alexander@wetzel-home.de> writes:

> Make sure local->queue_stop_reasons and vif.txqs_stopped stay in sync.
>
> When a new vif is created the queues may end up in an inconsistent state
> and be inoperable:
> Communication not using iTXQ will work, allowing to e.g. complete the
> association. But the 4-way handshake will time out. The sta will not
> send out any skbs queued in iTXQs.
>
> All normal attempts to start the queues will fail when reaching this
> state.
> local->queue_stop_reasons will have marked all queues as operational but
> vif.txqs_stopped will still be set, creating an inconsistent internal
> state.
>
> In reality this seems to be race between the mac80211 function
> ieee80211_do_open() setting SDATA_STATE_RUNNING and the wake_txqs_tasklet:
> Depending on the driver and the timing the queues may end up to be
> operational or not.
>
> Cc: stable@vger.kernel.org
> Fixes: f856373e2f31 ("wifi: mac80211: do not wake queues on a vif that is being stopped")
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>  net/mac80211/util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

The title is missing "wifi:", but no need to resend because of this. I
assume Johannes will fix it during commit.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
