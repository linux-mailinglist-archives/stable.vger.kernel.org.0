Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDA9A5FDE90
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 18:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbiJMQxw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 12:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJMQxt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 12:53:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103186706E
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 09:53:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B385B81FBC
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 16:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40939C433D6;
        Thu, 13 Oct 2022 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665680003;
        bh=SbPWJthaPZ+YKDU01YRyqbROZKJG3CL5GzqsHSubwj4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cg3CnimkJjrap3CmREgur6yejtdJKhxhyjwPm/T8nF3MG2fYzzqxzbhhiwi44rWhI
         WBgpC2YjgEx2WrkqCOr2XGhYNrk/Ah1DieF4DNJYvjTdAsaK2Dno7u5V43+PaEw+Kp
         c4wjVoOkfUTGSs3N+w67a+XxM2tIGcn4WBOxpTO0=
Date:   Thu, 13 Oct 2022 18:54:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 0/3] recent failed backports for the rng
Message-ID: <Y0hCrbRTA18l3+Ei@kroah.com>
References: <20221013153654.1397691-1-Jason@zx2c4.com>
 <Y0g6bYnxyNNX5WC6@kroah.com>
 <Y0g89B5GYqYco9w2@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y0g89B5GYqYco9w2@zx2c4.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 10:29:40AM -0600, Jason A. Donenfeld wrote:
> On Thu, Oct 13, 2022 at 06:18:53PM +0200, Greg KH wrote:
> > On Thu, Oct 13, 2022 at 09:36:51AM -0600, Jason A. Donenfeld wrote:
> > > Hi Greg,
> > > 
> > > You just sent me an automated email about these failing, so here they
> > > are backported. 
> > 
> > Backported where?  Patch 1 is already in 5.10 and newer, does this one
> > work in older?
> > 
> > And 2 and 3 for all branches?
> 
> For all of them they're not yet in.
> 
> I'll have a look at the 4.9 breakage.

Oops, 748bc4dd9e66 ("random: use expired timer rather than wq for mixing
fast pool") does not work for 4.9.y or 4.14.y, it breaks the build there
too:

drivers/char/random.c:909:63: error: macro "__TIMER_INITIALIZER" requires 4 arguments, but only 2 given
  909 |         .mix = __TIMER_INITIALIZER(mix_interrupt_randomness, 0)
      |                                                               ^
In file included from ./include/linux/workqueue.h:9,
                 from ./include/linux/rhashtable.h:26,
                 from ./include/linux/ipc.h:7,
                 from ./include/uapi/linux/sem.h:5,
                 from ./include/linux/sem.h:9,
                 from ./include/linux/sched.h:15,
                 from ./include/linux/utsname.h:6,
                 from drivers/char/random.c:28:
./include/linux/timer.h:67: note: macro "__TIMER_INITIALIZER" defined here
   67 | #define __TIMER_INITIALIZER(_function, _expires, _data, _flags) { \
      |
drivers/char/random.c:909:16: error: ‘__TIMER_INITIALIZER’ undeclared here (not in a function); did you mean ‘TIMER_INITIALIZER’?
  909 |         .mix = __TIMER_INITIALIZER(mix_interrupt_randomness, 0)
      |                ^~~~~~~~~~~~~~~~~~~
      |                TIMER_INITIALIZER
drivers/char/random.c:951:13: warning: ‘mix_interrupt_randomness’ defined but not used [-Wunused-function]
  951 | static void mix_interrupt_randomness(struct timer_list *work)
      |             ^~~~~~~~~~~~~~~~~~~~~~~~


