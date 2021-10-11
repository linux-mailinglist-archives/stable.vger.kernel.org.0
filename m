Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4D429050
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241002AbhJKOHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:07:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:57814 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238667AbhJKOFJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:05:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7CA3861206;
        Mon, 11 Oct 2021 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633960773;
        bh=iJ19XUu6miTNkPhxzTcAIecPW6SYgVEeC8WUUhrwnHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lDG0thgJ3WPAFSP8F8+ajl74djwB5b5DUDzpp75W/i8gqAoH4w47Z3jF16y6wFbPy
         cz/CYznQkD9cm83rjB+Oa0Y6vb7Uao51tYOKgsakjXkGxLkFr0eIGsCErW/Mh0aenU
         hgYV4cEhoJmjEfKojif+FlWVcfkp0GrTZhF8z5zuCfe095XT8XKov42IT7kfgOlmE2
         NIvzpB9nBuJ7LihkENWwxPttT80NCfj2Ep9lyP3gDsalYZr6+f/upn9LDeKo2Xo1XW
         iJchAVhoCBgJqfNhrgTvdIKwTcgpUedemKJOKr3sFFRrnF1VsX+iFDzE3qQgGA3QuY
         ocb9D3Qmkk6Sw==
Date:   Mon, 11 Oct 2021 06:59:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH 5.4 51/52] x86/hpet: Use another crystalball to evaluate
 HPET usability
Message-ID: <20211011065931.78965dff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211011134505.483011431@linuxfoundation.org>
References: <20211011134503.715740503@linuxfoundation.org>
        <20211011134505.483011431@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 11 Oct 2021 15:46:20 +0200 Greg Kroah-Hartman wrote:
> From: Thomas Gleixner <tglx@linutronix.de>
> 
> commit 6e3cd95234dc1eda488f4f487c281bac8fef4d9b upstream.
> 
> On recent Intel systems the HPET stops working when the system reaches PC10
> idle state.
> 
> The approach of adding PCI ids to the early quirks to disable HPET on
> these systems is a whack a mole game which makes no sense.
> 
> Check for PC10 instead and force disable HPET if supported. The check is
> overbroad as it does not take ACPI, intel_idle enablement and command
> line parameters into account. That's fine as long as there is at least
> PMTIMER available to calibrate the TSC frequency. The decision can be
> overruled by adding "hpet=force" on the kernel command line.
> 
> Remove the related early PCI quirks for affected Ice Cake and Coffin Lake
> systems as they are not longer required. That should also cover all
> other systems, i.e. Tiger Rag and newer generations, which are most
> likely affected by this as well.
> 
> Fixes: Yet another hardware trainwreck
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Tested-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>
> Cc: stable@vger.kernel.org
> Cc: Kai-Heng Feng <kai.heng.feng@canonical.com>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

FWIW I've never seen any problems prior to Paul's rework of bad clock
detection in 5.13. Backports to 5.4 and 5.10 are not necessary.
