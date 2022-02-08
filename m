Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAAA44AD3F5
	for <lists+stable@lfdr.de>; Tue,  8 Feb 2022 09:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349598AbiBHIvF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Feb 2022 03:51:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234703AbiBHIvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Feb 2022 03:51:05 -0500
Received: from mail.kmu-office.ch (mail.kmu-office.ch [IPv6:2a02:418:6a02::a2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7843DC0401F6
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 00:51:01 -0800 (PST)
Received: from webmail.kmu-office.ch (unknown [IPv6:2a02:418:6a02::a3])
        by mail.kmu-office.ch (Postfix) with ESMTPSA id 4642F5C1D10;
        Tue,  8 Feb 2022 09:50:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=agner.ch; s=dkim;
        t=1644310259;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jdbAvq7z9eTXY5eg8HuXoMcDIWe+qtaUrY5jz0a9as0=;
        b=ruHoVnCHu83SL64ZG8dQ0vlZHaDEy0F4DPhonRJmt+UYDYSHEZJ/P+5I0fU4TybtQxq1yf
        B8wKMcJCn6PWRRvtL/NwQoxiE10x3AYsYag4chdsAtrFa+W5BPdeWOmaV60k3lwvE9uhr3
        C9RaadyqT2rpoNI41gJE3v1nS6dpInQ=
MIME-Version: 1.0
Date:   Tue, 08 Feb 2022 09:50:59 +0100
From:   Stefan Agner <stefan@agner.ch>
To:     Jason Self <jason@bluehome.net>,
        Greg KH <gregkh@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>
Cc:     stable@vger.kernel.org, regressions@lists.linux.dev
Subject: Re: Regression/boot failure on 5.16.3
In-Reply-To: <20220203161959.3edf1d6e@valencia>
References: <20220203161959.3edf1d6e@valencia>
User-Agent: Roundcube Webmail/1.4.9
Message-ID: <00b41f5de94fca5ef995ab2c95def4aa@agner.ch>
X-Sender: stefan@agner.ch
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2022-02-04 01:19, Jason Self wrote:
> The computer (amd64) fails to boot. The init was stuck at the
> synchronization of the time through the network. This began between
> 5.16.2 (good) and 5.16.3 (bad.) This continues on 5.16.4 and 5.16.5.
> Git bisect revealed the following. In this case the nonfree firmwre is
> not present on the system. Blacklisting the iwflwifi module works as a
> workaround for now.

I have several reports of Intel NUC 10th/11th gen not booting/crashing
during boot after updating to 5.10.96 (from 5.10.91). At least one stack
trace shows iwl_dealloc_ucode in the call path. The below commit is part
of 5.10.96 So this regression seems to not only affect 5.16 series.

Link:
https://github.com/home-assistant/operating-system/issues/1739#issuecomment-1032013069

--
Stefan


> 
> 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1 is the first bad commit
> commit 6b5ad4bd0d78fef6bbe0ecdf96e09237c9c52cc1
> Author: Johannes Berg <johannes.berg@intel.com>
> Date:   Fri Dec 10 11:12:42 2021 +0200
> 
>     iwlwifi: fix leaks/bad data after failed firmware load
>     
>     [ Upstream commit ab07506b0454bea606095951e19e72c282bfbb42 ]
>     
>     If firmware load fails after having loaded some parts of the
>     firmware, e.g. the IML image, then this would leak. For the
>     host command list we'd end up running into a WARN on the next
>     attempt to load another firmware image.
>     
>     Fix this by calling iwl_dealloc_ucode() on failures, and make
>     that also clear the data so we start fresh on the next round.
>     
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
>     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>     Link:
>    
> https://lore.kernel.org/r/iwlwifi.20211210110539.1f742f0eb58a.I1315f22f6aa632d94ae2069f85e1bca5e734dce0@changeid
>     Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
>  drivers/net/wireless/intel/iwlwifi/iwl-drv.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
