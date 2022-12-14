Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E483364CCBC
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 15:56:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiLNO4d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 09:56:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238744AbiLNO4b (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 09:56:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DAC27B26;
        Wed, 14 Dec 2022 06:56:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 16B4261807;
        Wed, 14 Dec 2022 14:56:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB9B4C433D2;
        Wed, 14 Dec 2022 14:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671029788;
        bh=maUEsgzJ2DJN1ffH0fFG9b002yrOqNh2td9Dk+SSa6U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DnVPosIOGOUiUQ7xNBq2QwKrLOcB2ifUac18WOMx7X+g68JJIMYsk5AaVrPZttqLK
         N6YVs4hSBp7IpU/MvgiwhAYhMMTRnorqQPOLFheYY0nwJwnC0wERlYUd+iFbnNeDgS
         EsGxxwRqqmYnRL+C4RN78eC3jUcBPlWE6H67BOK4=
Date:   Wed, 14 Dec 2022 15:56:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Prashanth K <quic_prashk@quicinc.com>
Cc:     "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Linyu Yuan <quic_linyyuan@quicinc.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Dan Carpenter <error27@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Message-ID: <Y5nkGdJOpmn1hXZo@kroah.com>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
 <Y5cuCMhFIaKraUyi@kroah.com>
 <214c4b8f-b86b-3e1f-d34b-ccfa756f3136@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <214c4b8f-b86b-3e1f-d34b-ccfa756f3136@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 14, 2022 at 06:38:17PM +0530, Prashanth K wrote:
> 
> 
> On 12-12-22 07:05 pm, Greg Kroah-Hartman wrote:
> > On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> > > Function pointer ki_complete() expects 'long' as its second
> > > argument, but we pass integer from ffs_user_copy_worker. This
> > > might cause a CFI failure, as ki_complete is an indirect call
> > > with mismatched prototype. Fix this by typecasting the second
> > > argument to long.
> > 
> > "might"?  Does it or not?  If it does, why hasn't this been reported
> > before?
> Sorry for the confusion in commit text, We caught a CFI (Control Flow
> Integrity) failure internally on 5.15, hence pushed this patch. But later I
> came to know that CFI was implemented on 5.4 kernel for Android. Will push
> the same on ACK and share the related details there.

I will have the same questions there, namely, "why just this one
instance and why is it trigging anything"?

So please, work this out here, in public, don't bury stuff in random
vendor kernel trees.  That's not the way to solve anything properly, you
know this :)

thanks,

greg k-h
