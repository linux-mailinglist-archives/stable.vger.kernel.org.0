Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A423F192ABF
	for <lists+stable@lfdr.de>; Wed, 25 Mar 2020 15:07:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbgCYOHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Mar 2020 10:07:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39538 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726102AbgCYOHN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 25 Mar 2020 10:07:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0172E20722;
        Wed, 25 Mar 2020 14:07:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585145232;
        bh=diBwSLo8wU9yZnIJ95vKRVAR15DopN3BP6vf9PO3T88=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uH2zC4S/RgnKGxWtghNl1SamqWsawwpHaEt9TT+1Sp0zx7h2V5l3Dmsrmm05Q8AHn
         4iHmfEy63KjKNqG8Ibw8RrUdw5xdFJ5VhsXjnynR8ZG6/R1LTyjpApPHlMgqpWiB53
         kiJRAonoSyD1eo0WYaOooK4A/sdty/eA/j9mwnuM=
Date:   Wed, 25 Mar 2020 15:07:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Jiri Slaby <jslaby@suse.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Saravana Kannan <saravanak@google.com>,
        Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 5.5 066/189] driver core: Call sync_state() even if
 supplier has no consumers
Message-ID: <20200325140708.GA3533248@kroah.com>
References: <20200310123639.608886314@linuxfoundation.org>
 <20200310123646.283600281@linuxfoundation.org>
 <93643339-612c-3438-fff8-4eac728118a0@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93643339-612c-3438-fff8-4eac728118a0@suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 25, 2020 at 02:42:27PM +0100, Jiri Slaby wrote:
> On 10. 03. 20, 13:38, Greg Kroah-Hartman wrote:
> > From: Saravana Kannan <saravanak@google.com>
> > 
> > commit 21eb93f432b1a785df193df1a56a59e9eb3a985f upstream.
> > 
> > The initial patch that added sync_state() support didn't handle the case
> > where a supplier has no consumers. This was because when a device is
> > successfully bound with a driver, only its suppliers were checked to see
> > if they are eligible to get a sync_state(). This is not sufficient for
> > devices that have no consumers but still need to do device state clean
> > up. So fix this.
> > 
> > Fixes: fc5a251d0fd7ca90 (driver core: Add sync_state driver/bus callback)
> 
> This causes NULL ptr dereferences (in 5.5 only). It is enough to load
> the mac80211_hwsim module.
> 
> The backport to 5.5 needs at least these two commits:
> commit ac338acf514e7b578fa9e3742ec2c292323b4c1a
> Author: Saravana Kannan <saravanak@google.com>
> Date:   Fri Feb 21 00:05:09 2020 -0800
> 
>     driver core: Add dev_has_sync_state()
> 
> commit 77036165d8bcf7c7b2a2df28a601ec2c52bb172d
> Author: Saravana Kannan <saravanak@google.com>
> Date:   Fri Feb 21 00:05:10 2020 -0800
> 
>     driver core: Skip unnecessary work when device doesn't have sync_state()
> 
> 
> and playing with includes.
> 
> I am not sure if a revert wouldn't be better -- leaving up to maintainers.
> 
> https://bugzilla.suse.com/show_bug.cgi?id=1167245

These are already queued up, I think I'll push out an update in a bit
with them in a release...

thanks,

greg k-h
