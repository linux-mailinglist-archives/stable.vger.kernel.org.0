Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED6C26EAECB
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 18:10:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbjDUQJw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 12:09:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbjDUQJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 12:09:51 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF4C14444
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 09:09:49 -0700 (PDT)
Date:   Fri, 21 Apr 2023 18:09:47 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1682093388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ViNQP6CsrTcmgIE0qeBt0ai+rJeTUoRrSX8qSVMo9Fo=;
        b=t/Km1koCRuEPSHIZ0M2kyZ0z8Op3/09aohaWj/8fNWtBMy46IFxE6OSLH3epiWwCQ+Euhr
        fwA/2uJnGCcDhTo9qoiwY0qnaKHdTS69daxBsxxQNcXmRYb3bZ3ieJP8xSYjlK9x5aKz6C
        jcqcEB8JJzd4S5geyeSG91il8Mk6U/xj7uTBC2KbkygZ68XZ1Zpm8soTrCgMpuaRiOviSB
        C2GgCCxV12C2VBLbxv5JBrDpPPgHzL8t70TDYMeiDF4tS5DQ5irXCRgYfhunWk10uEdK8Q
        6E1e12azbkwxpOQRVlALDJ4WCynfuSjgZLKSQpaqb3IPjAW7LOuvxUBLTJC9ew==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1682093388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ViNQP6CsrTcmgIE0qeBt0ai+rJeTUoRrSX8qSVMo9Fo=;
        b=/m6tIWRiUGueJJ/p4L9R01LQe2ivTsBRcq/UfU2AzfMkceIH5gcG2JkgUG5T5XWBPG04+W
        ZUm91pmSYCn8saAw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
Message-ID: <20230421160947.Sh0eyEWC@linutronix.de>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
 <20230419072546.gD_YO2-K@linutronix.de>
 <87pm7x3d8b.ffs@tglx>
 <ZEKFWx_68PX3pk3g@kroah.com>
 <87ildp2qy7.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <87ildp2qy7.ffs@tglx>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2023-04-21 17:30:24 [+0200], Thomas Gleixner wrote:
> >> > The out-of-tree RT patches make extensive use of the code. Since it is
> >> > upstream code, I assumed it should go via the official stable trees.
> >> > Without RT, the code is limited the rt_mutex_lock() used by I2C and the
> >> > RCU booster-mutex.
> >> 
> >> Which is a reason to route it through the upstream stable trees, no?
> >
> > I do not understand.  Why would we take a patch in the stable tree
> > because an out-of-tree change requires it?
> 
> The change is to the rtmutex core which _IS_ used in tree by futex, RCU
> and some drivers.

not back stab but to clarify: futex does not use the annotation (it does
not use the fastpath) but RCU-boosting _and_ I2C-bus code does use it.

So both mainline users users of the rtmutex code are affected.

> Just because the problem was observed on RT it does not make the
> mainline usage of RTMUTEXes magically unaffected. The missing acquire
> semantics are required there too.
> 
> Thanks,
> 
>         tglx

Sebastian
