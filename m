Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7C5E33D11E
	for <lists+stable@lfdr.de>; Tue, 16 Mar 2021 10:49:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233039AbhCPJtH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 05:49:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232335AbhCPJtA (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 05:49:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 990CD64F6D;
        Tue, 16 Mar 2021 09:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615888140;
        bh=2V+lNZksGULsy/lblGLLF1K+PMqySH5u+6uef63fvDU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WpYrW87pN81De28KP8oYmI+UG3Ga44pGvZbOmRXFDvjKvid9eGfidTYrSnIpNdn7a
         EhYpD34MsZ9YjfJ71kQa79ty/N7ugMD8LsYJvZT0VqxWtifjFazJJiTuzx4L/HtGjm
         TMVvtZkT0+jMj0/6XqU6u/ksIMNRZ7d/rlDhR2Ko=
Date:   Tue, 16 Mar 2021 10:48:56 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 011/120] tcp: annotate tp->copied_seq lockless reads
Message-ID: <YFB/CBeDBiolOxDD@kroah.com>
References: <20210315135720.002213995@linuxfoundation.org>
 <20210315135720.384809636@linuxfoundation.org>
 <20210316094137.GA12946@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210316094137.GA12946@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 16, 2021 at 10:41:37AM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > 
> > From: Eric Dumazet <edumazet@google.com>
> 
> Two From: fields here.

This is a side-affect of me using git-send-email to talk to the remote
smtp server directly instead of using my local email server.  This was
done to increase the speed of sending these patches out as
git-send-email can pipeline messages instead of having msmtp do a
setup/send/teardown on every individual message sent.

These are not in the patches themselves and I will work to figure out
if this can be fixed.  Gotta be a setting somewhere...

> 
> > [ Upstream commit 7db48e983930285b765743ebd665aecf9850582b ]
> > 
> > There are few places where we fetch tp->copied_seq while
> > this field can change from IRQ or other cpu.
> 
> And there are few such places even after the patch is applied; I
> quoted them below.
> 
> Doing addition to variable without locking... is kind of
> interesting. Are you sure it is okay?

Why isn't it?

thanks,

greg k-h
