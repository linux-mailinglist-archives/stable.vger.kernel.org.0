Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 964622AA804
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 22:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbgKGVH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 16:07:57 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:43138 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgKGVH5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 16:07:57 -0500
From:   Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1604783275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fk5ZOrseEUy+A30Zeu99trnULtaUnQJULQgT+zZZMWM=;
        b=pzo8PcXvp8nZ81cdKAWqC4Mqj5RzIBMkapXrcBj6Z4eDybWgChvT7DQKz9HQYJzIbmG5E7
        fbQo7+W8CG3YgtRoKWbKkyRD7h43TLnOsgOxgR+a9MTUaRD8UpRw/siK/xCDXgbLe1NRJs
        8E2uqUrkcx9m1LCRWqyZwEEaVdNH1k8kOI1pecNhNbjoHofElFTNC9p8TpDbg0iMA83hos
        4qX+m6wP20p6TfdMc9b40SUk6aWxz4DX1jg+A6ISAU1AHFIFi8WGi5I0I25sEQGy5+gYnH
        iSzfyfq0AevSi59xxhJ3vzjyWJahAQLC+3uhCOGtngk0iI+N2GkUCZ1EB/08cg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1604783275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fk5ZOrseEUy+A30Zeu99trnULtaUnQJULQgT+zZZMWM=;
        b=iQmPdwis43i6WfpNQfGlriGjdENjY/HuSeyflZ21H3p1PSAAnsB0ZzGst+EcXWcMOVWcoR
        bxcG152NqoKccKAA==
To:     Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org,
        linux-tip-commits@vger.kernel.org
Cc:     Gratian Crisan <gratian.crisan@ni.com>, stable@vger.kernel.org,
        x86 <x86@kernel.org>
Subject: Re: [tip: locking/urgent] futex: Handle transient "ownerless" rtmutex state correctly
In-Reply-To: <c35f88c5eb00c69fa74bbc7225316307a5eb38d8.camel@gmx.de>
References: <87a6w6x7bb.fsf@ni.com> <160469801844.397.7418241151599681987.tip-bot2@tip-bot2> <c35f88c5eb00c69fa74bbc7225316307a5eb38d8.camel@gmx.de>
Date:   Sat, 07 Nov 2020 22:07:54 +0100
Message-ID: <87v9egkh91.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 07 2020 at 18:05, Mike Galbraith wrote:
> On Fri, 2020-11-06 at 21:26 +0000, tip-bot2 for Mike Galbraith wrote:
>> +		if (unlikely(!newowner)) {
>> +			ret = -EAGAIN;
>                         ^^^
>
> My box just discovered an unnoticed typo.  That 'ret' should read 'err'
> so we goto retry, else fbomb_v2 proggy will trigger gripeage.

Bah. I noticed and wanted to fix it before committing and then
forgot. Fixed now.
