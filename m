Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86EE765519D
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 15:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236400AbiLWOvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 09:51:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236398AbiLWOvO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 09:51:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D4B1D8;
        Fri, 23 Dec 2022 06:51:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 731BCB80315;
        Fri, 23 Dec 2022 14:51:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0616C433EF;
        Fri, 23 Dec 2022 14:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671807071;
        bh=kNH4zf3D7/4hjbqE5cHwauHXbJqf2MkEh7zrETewNzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T2OsMkeaLXZ3LoGvMPLrR3x1WKZSESD6cVCnbf/dB9Cr4Q/NXvqwtIHf2bBNtDPQo
         vpKqj8Y2m/xZuAftmJcIuKSwliu6gXgLjoZe9n7ED09GeyHIY5wxitEED0db2S/ZpJ
         EdxphWMWrVUxKWQRVRTcJywe5yerH5IMYy/BDYGg=
Date:   Fri, 23 Dec 2022 15:51:07 +0100
From:   'Greg Kroah-Hartman' <gregkh@linuxfoundation.org>
To:     Prashanth K <quic_prashk@quicinc.com>
Cc:     David Laight <David.Laight@aculab.com>,
        Dan Carpenter <error27@gmail.com>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        Shuah Khan <skhan@linuxfoundation.org>,
        John Keeping <john@metanate.com>,
        Pratham Pratap <quic_ppratap@quicinc.com>,
        Vincent Pelletier <plr.vincent@gmail.com>,
        Udipto Goswami <quic_ugoswami@quicinc.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "# 5 . 15" <stable@vger.kernel.org>
Subject: Re: usb: f_fs: Fix CFI failure in ki_complete
Message-ID: <Y6XAW8JrwjQ4DkJV@kroah.com>
References: <1670851464-8106-1-git-send-email-quic_prashk@quicinc.com>
 <Y5cuCMhFIaKraUyi@kroah.com>
 <abe47a47aa5d49878c58fc1199be18ea@AcuMS.aculab.com>
 <acdda510-945f-ff68-5c8b-a1a0290bed6d@quicinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acdda510-945f-ff68-5c8b-a1a0290bed6d@quicinc.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 22, 2022 at 06:21:03PM +0530, Prashanth K wrote:
> 
> 
> On 14-12-22 11:05 pm, David Laight wrote:
> > From: Greg Kroah-Hartman
> > > Sent: 12 December 2022 13:35
> > > 
> > > On Mon, Dec 12, 2022 at 06:54:24PM +0530, Prashanth K wrote:
> > > > Function pointer ki_complete() expects 'long' as its second
> > > > argument, but we pass integer from ffs_user_copy_worker. This
> > > > might cause a CFI failure, as ki_complete is an indirect call
> > > > with mismatched prototype. Fix this by typecasting the second
> > > > argument to long.
> > > 
> > > "might"?  Does it or not?  If it does, why hasn't this been reported
> > > before?
> > 
> > Does the cast even help at all.
> Actually I also have these same questions
> - why we haven't seen any instances other than this one?
> - why its not seen on other indirect function calls?

Great, please work on figuring these out before you resubmit this again
as obviously we can't take this change without knowing the answers here.

good luck!

greg k-h
