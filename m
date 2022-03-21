Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACAB4E26AA
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 13:36:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244529AbiCUMh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 08:37:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347462AbiCUMh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 08:37:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DABDF48A
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 05:36:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A27061009
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 12:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A7EC340ED;
        Mon, 21 Mar 2022 12:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647866159;
        bh=7WadrJ71hYTpYrf24WUkefiDKfnJHVNIJCTFOFa918E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HhN3jgN5FLOLH3Kk5WCcFjmqQTI6RMi+KYRt+TrsQerrteVcmOiUPRQT2J3ZqYpzz
         dvuwVBnf73SlY713Q5B11W6vryry/OAciZcXyjgue1UezdX7zzaXMcAggkcr+wfznE
         fQROmedPcyoZ4wPk1IPBw6cLWQfp/2SIB/Lsh+sU=
Date:   Mon, 21 Mar 2022 13:35:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     sec@valis.email, stable@vger.kernel.org,
        steffen.klassert@secunet.com,
        syzbot+93ab2623dcb5c73eda9f@syzkaller.appspotmail.com
Subject: Re: [PATCH 5.10] esp: Fix possible buffer overflow in ESP
 transformation
Message-ID: <YjhxLN5CM+Pe1yoM@kroah.com>
References: <164724987520346@kroah.com>
 <20220317164159.1916929-1-tadeusz.struk@linaro.org>
 <YjNoIEs7+qTgq7XE@kroah.com>
 <d4041c47-73e9-a9f4-cffc-327dcf1e668c@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4041c47-73e9-a9f4-cffc-327dcf1e668c@linaro.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 10:09:52AM -0700, Tadeusz Struk wrote:
> On 3/17/22 09:56, Greg KH wrote:
> > On Thu, Mar 17, 2022 at 09:41:59AM -0700, Tadeusz Struk wrote:
> > > From: Steffen Klassert <steffen.klassert@secunet.com>
> > > 
> > > Plese apply this on 5.10.y stable as well as it fixes the following
> > > syzbot issues:
> > > 
> > > LINK: https://syzkaller.appspot.com/bug?id=517fa734b92b7db404c409b924cf5c997640e324
> > > LINK: https://syzkaller.appspot.com/bug?id=57375340ab81a369df5da5eb16cfcd4aef9dfb9d
> > > 
> > > Here is a working patch.
> > > ---8<---
> > > 
> > > The maximum message size that can be send is bigger than
> > > the  maximum site that skb_page_frag_refill can allocate.
> > > So it is possible to write beyond the allocated buffer.
> > > 
> > > Fix this by doing a fallback to COW in that case.
> > > 
> > > Fixes: cac2661c53f3 ("esp4: Avoid skb_cow_data whenever possible")
> > > Fixes: 03e2a30f6a27 ("esp6: Avoid skb_cow_data whenever possible")
> > > Reported-by: valis <sec@valis.email>
> > > Reported-by: <syzbot+93ab2623dcb5c73eda9f@syzkaller.appspotmail.com>
> > > Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
> > > Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
> > > ---
> > >   include/net/esp.h  | 2 ++
> > >   include/net/sock.h | 1 +
> > >   net/ipv4/esp4.c    | 5 +++++
> > >   net/ipv6/esp6.c    | 5 +++++
> > >   4 files changed, 13 insertions(+)
> > 
> > What is the git commit id of this commit in Linus's tree?
> > 
> 
> It's this one:
> 
> ebe48d368e97 ("esp: Fix possible buffer overflow in ESP transformation")
> 
> Sorry I forgot to include it in the backport.

Now queued up, thanks.

gre gk-h
