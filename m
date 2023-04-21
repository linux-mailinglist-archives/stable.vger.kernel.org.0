Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41E606EAF33
	for <lists+stable@lfdr.de>; Fri, 21 Apr 2023 18:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233104AbjDUQdi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 12:33:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232577AbjDUQdh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 12:33:37 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95D3B15447
        for <stable@vger.kernel.org>; Fri, 21 Apr 2023 09:33:33 -0700 (PDT)
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1682094810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhULTCPy9bP1DfMbNb4Afvjzum0mCNJToft6ND93qOs=;
        b=LQDj8lcKm20urpV2kRsx6AQDREHrGGbf7BlnVTJmkPa/gO6Mm/Z/YXGMk1NIbiW+aK7nR2
        it9ZwcFX7a8grKs/s12KBM7InwQQYfe4mLwVbvYcBS+akJFub6StSmNiEy9238QqSzljNe
        Puuy291nl4LAX6gi6KjGXLKCGIvdW97cHSuKzd7/xSDz1GaMTkbmSZ5b2+cslC4afpe0qV
        qFp+ZSpcTmyzrV5enYADFBQeyjNlf1L0Lsm8zvw7fTPntZk4g6ve5Uh1Dk4CJDLUxUpPZR
        IBBCa1cX33z3CdzntxiW+aVr8Nvo/OcXWDACSuLR5Rx7B8sviTme5hmDc8PB0A==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1682094810;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dhULTCPy9bP1DfMbNb4Afvjzum0mCNJToft6ND93qOs=;
        b=0BEGnC9d/IY/djuIpJUsN2oC2ZtRASP2tahCEb9lOPRqLPgI1sobZXDW5spmL4KFLWC6s4
        2Qt/7OxWZz8iEhDA==
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH] rtmutex: Add acquire semantics for rtmutex lock
 acquisition slow path
In-Reply-To: <20230421160947.Sh0eyEWC@linutronix.de>
References: <20230418154315.9PD52J2N@linutronix.de>
 <2023041854-cranium-prone-b9fa@gregkh>
 <20230419072546.gD_YO2-K@linutronix.de> <87pm7x3d8b.ffs@tglx>
 <ZEKFWx_68PX3pk3g@kroah.com> <87ildp2qy7.ffs@tglx>
 <20230421160947.Sh0eyEWC@linutronix.de>
Date:   Fri, 21 Apr 2023 18:33:30 +0200
Message-ID: <87edod2o11.ffs@tglx>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 21 2023 at 18:09, Sebastian Andrzej Siewior wrote:
> On 2023-04-21 17:30:24 [+0200], Thomas Gleixner wrote:
>> >> > The out-of-tree RT patches make extensive use of the code. Since it is
>> >> > upstream code, I assumed it should go via the official stable trees.
>> >> > Without RT, the code is limited the rt_mutex_lock() used by I2C and the
>> >> > RCU booster-mutex.
>> >> 
>> >> Which is a reason to route it through the upstream stable trees, no?
>> >
>> > I do not understand.  Why would we take a patch in the stable tree
>> > because an out-of-tree change requires it?
>> 
>> The change is to the rtmutex core which _IS_ used in tree by futex, RCU
>> and some drivers.
>
> not back stab but to clarify: futex does not use the annotation (it does
> not use the fastpath) but RCU-boosting _and_ I2C-bus code does use it.

Futex requires it too, really. The patch is about the slowpath, no?


