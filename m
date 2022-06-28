Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1BBB55E4C4
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:39:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346503AbiF1Ndk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:33:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346558AbiF1NdD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:33:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C73517597;
        Tue, 28 Jun 2022 06:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCF3A61840;
        Tue, 28 Jun 2022 13:33:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20892C3411D;
        Tue, 28 Jun 2022 13:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656423181;
        bh=vy3vuOmznWhEncPhENdIaQ8B4RXL0dQ2DU1vhKaw1wI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y4XsWQD1zmi+SuFbeJ2RykJ9dWBaMzWEmTVs23IF4PWHmoayVxci28MQxiDiVXFaI
         YTTzC1R0uZOzpCBgoo3Uk/vTErquLXkYaLmDMQgKioT6+LoYc6BI+b4wqasI8uqE86
         UuXLS3orUpGW3WONEmJ1G+xN6tfpZ6bQIeQzReDDOcLH+69V4PHRZn7OCFdELqo+H1
         coitz3iAazmVnU7Uu7ljQJVBsVr9NVJrh7dPTObH1IQRvPM6ZsY0P3MpGPwop9F2E4
         9fnRy0YTKILmijwGUj4qCXVQwha+5A2yDwHmtkVYnTIxTiBGnxrivSc4h03EWdWl2p
         9ZX7rwA0BnKtw==
Date:   Tue, 28 Jun 2022 09:32:59 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        John Fastabend <john.fastabend@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH 5.18 097/181] Revert "net/tls: fix tls_sk_proto_close
 executed repeatedly"
Message-ID: <YrsDCwxiIqm1N9K+@sashalap>
References: <20220627111944.553492442@linuxfoundation.org>
 <20220627111947.372126973@linuxfoundation.org>
 <20220627083313.285787a5@kernel.org>
 <YrnRxxAUbk8fdjac@kroah.com>
 <20220627085728.643737fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220627085728.643737fb@kernel.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 27, 2022 at 08:57:28AM -0700, Jakub Kicinski wrote:
>On Mon, 27 Jun 2022 17:50:31 +0200 Greg Kroah-Hartman wrote:
>> On Mon, Jun 27, 2022 at 08:33:13AM -0700, Jakub Kicinski wrote:
>> > On Mon, 27 Jun 2022 13:21:10 +0200 Greg Kroah-Hartman wrote:
>> > > From: Jakub Kicinski <kuba@kernel.org>
>> > >
>> > > [ Upstream commit 1b205d948fbb06a7613d87dcea0ff5fd8a08ed91 ]
>> > >
>> > > This reverts commit 69135c572d1f84261a6de2a1268513a7e71753e2.
>> > >
>> > > This commit was just papering over the issue, ULP should not
>> > > get ->update() called with its own sk_prot. Each ULP would
>> > > need to add this check.
>> > >
>> > > Fixes: 69135c572d1f ("net/tls: fix tls_sk_proto_close executed repeatedly")
>> > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
>> >
>> > Mm? How did 69135c572d1f get into stableh?
>> > I reverted it before it hit Linus's tree.
>> > Don't see the notification about it either.
>>
>> It is commit 075/181 in this series as you can see here:
>> 	https://lore.kernel.org/r/20220627111946.738369250@linuxfoundation.org
>
>Argh, I forgot I'm not gonna get CCed if my tags aren't on the
>commit in question, sorry for the confusion.
>
>So I expected patches 075 and 097 would just get dropped since
>they are in the same series and are canceling each other out.
>But I guess people may edit reverts so you prefer not to
>automatically do that?

It's also the case that it's useful for historical purposes to keep
track of why a certain commit made it in or not.

-- 
Thanks,
Sasha
