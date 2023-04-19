Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 887886E7C88
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 16:25:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232333AbjDSOZ5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 10:25:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232634AbjDSOZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 10:25:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3C487DAD;
        Wed, 19 Apr 2023 07:25:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC498612F2;
        Wed, 19 Apr 2023 14:24:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11E12C433EF;
        Wed, 19 Apr 2023 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681914296;
        bh=ECQupXum7C5csYm6oCBpT9WEdJx57UL7F89LUbZpf/M=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=pOXXGT1V+govUKL15SCaz62C2cqZS+y3ZMw4s8AMqTGDYirqkPAxqIsig4OmQIdrn
         OwUFQ6Pvn+sw2nN51JebIMaFqfsuKqM0LGx9DZ4pj1knSDZtcnEyqrfcQd3p9uSBkG
         po4MVYPuX95g8/HA5F0l4TXJ5wdXZ6nA8S3eWt4cCaEH/KyLDhW6VxDiS1mDDzxk+7
         vcsRUf4EcocYYXuSxe9yK+YLsxGRuymFELud/gnxVkizROkB8aUI8u5obUIl6bzm1d
         x/TNdaQBHZXEicJahYskC3nVXoTAqXsdjpaiZJmAZqjEpju5ee5tki6BVdfB9wD1Xb
         VseyQkuQ4hZwQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] wifi: ath9k: Don't mark channelmap stack variable
 read-only
 in ath9k_mci_update_wlan_channels()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230413214118.153781-1-toke@toke.dk>
References: <20230413214118.153781-1-toke@toke.dk>
To:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        Kalle Valo <quic_kvalo@quicinc.com>,
        Colin Ian King <colin.i.king@gmail.com>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168191429286.18451.14816485203241143280.kvalo@kernel.org>
Date:   Wed, 19 Apr 2023 14:24:54 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Toke Høiland-Jørgensen <toke@toke.dk> wrote:

> This partially reverts commit e161d4b60ae3a5356e07202e0bfedb5fad82c6aa.
> 
> Turns out the channelmap variable is not actually read-only, it's modified
> through the MCI_GPM_CLR_CHANNEL_BIT() macro further down in the function,
> so making it read-only causes page faults when that code is hit.
> 
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=217183
> Fixes: e161d4b60ae3 ("wifi: ath9k: Make arrays prof_prio and channelmap static const")
> Cc: stable@vger.kernel.org
> Signed-off-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

b956e3110a79 wifi: ath9k: Don't mark channelmap stack variable read-only in ath9k_mci_update_wlan_channels()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230413214118.153781-1-toke@toke.dk/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

