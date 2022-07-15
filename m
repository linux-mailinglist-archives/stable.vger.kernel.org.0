Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD56D5764B7
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiGOPqv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:46:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiGOPqr (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:46:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E4CA231;
        Fri, 15 Jul 2022 08:46:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DFBEB62135;
        Fri, 15 Jul 2022 15:46:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65BE5C34115;
        Fri, 15 Jul 2022 15:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657900006;
        bh=1pP6wpTZR6yxJttIfhQ8GaI8CR+vOrFTZHxcwN15uk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nTS1MBom8JQTTyxEVLiCJsH0hjcLXRd+KWRW8j3+FwNB94NtVwxVS2b96USqC+sj4
         X/y9CH5O8YMTLBPq2aLd6pHgYwMMkzcQE8XH7EE5DFEuPgy48tsQv1wK1nuHVA8sjv
         d9LxY2RmBRhHoOoqQHLHJmdKo67NuGc+5QL5hrDXhUzcvX1aesCIXJLRFKlGsLsT+U
         rvJ9XJYf3yOkXRvfjwP0iY+hRoZsNgrRJ1SbPWaq5DYVaa4NkP9SzzfADd2GOYlAmX
         BGuzgB7BqNF8zrOFWIG+/Hiit3qJ6zHtel3LuLoAF7S4p7KhMQcV/CU9YTJSlfi0if
         u/t2DHgvbMY0g==
From:   SeongJae Park <sj@kernel.org>
To:     Andrii Chepurnyi <andrii.chepurnyi82@gmail.com>
Cc:     Oleksandr <olekstysh@gmail.com>, SeongJae Park <sj@kernel.org>,
        roger.pau@citrix.com, jgross@suse.com, axboe@kernel.dk,
        boris.ostrovsky@oracle.com, mheyne@amazon.de,
        xen-devel@lists.xenproject.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] xen-blkback: fix persistent grants negotiation
Date:   Fri, 15 Jul 2022 15:46:43 +0000
Message-Id: <20220715154643.54334-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <CAJwUmVB6H3iTs-C+U=v-pwJB7-_ZRHPxHzKRJZ22xEPW7z8a=g@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,


Oleksandr, thank you for Cc-ing Andrii.  Andrii, thank you for the comment!

On Fri, 15 Jul 2022 15:00:10 +0300 Andrii Chepurnyi <andrii.chepurnyi82@gmail.com> wrote:

> [-- Attachment #1: Type: text/plain, Size: 5237 bytes --]
> 
> Hello All,
> 
> I faced the mentioned issue recently and just to bring more context here is
> our setup:
> We use pvblock backend for Android guest. It starts using u-boot with
> pvblock support(which frontend doesn't support the persistent grants
> feature), later it loads and starts the Linux kernel(which frontend
> supports the persistent grants feature). So in total, we have sequent two
> different frontends reconnection, the first of which doesn't support
> persistent grants.
> So the original patch [1] perfectly solves the original issue and provides
> the ability to use persistent grants after the reconnection when Linux
> frontend which supports persistent grants comes into play.
> At the same time [2] will disable the persistent grants feature for the
> first and second frontend.

Thank you for this great explanation of your situation.

> Is it possible to keep [1]  as is?

Yes, my concerns about Max's original patch[1] are conflicting behavior
description in the document[1] and different behavior on blkfront-side
'feature_persistent' parameter.  I will post Max's patch again with patches for
blkfront behavior change and Documents updates.

[1] https://lore.kernel.org/xen-devel/20220121102309.27802-1-sj@kernel.org/


Thanks,
SJ

> 
> [1]
> https://lore.kernel.org/xen-devel/20220106091013.126076-1-mheyne@amazon.de/
> [2] https://lore.kernel.org/xen-devel/20220714224410.51147-1-sj@kernel.org/
> 
> Best regards,
> Andrii
> 
> On Fri, Jul 15, 2022 at 1:15 PM Oleksandr <olekstysh@gmail.com> wrote:
> 
> >
> > On 15.07.22 01:44, SeongJae Park wrote:
> >
> >
> > Hello all.
> >
> > Adding Andrii Chepurnyi to CC who have played with the use-case which
> > required reconnect recently and faced some issues with
> > feature_persistent handling.
[...]
