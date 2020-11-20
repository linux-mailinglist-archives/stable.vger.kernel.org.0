Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5808B2BA338
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 08:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725858AbgKTHbV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 02:31:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:38720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726544AbgKTHbV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 02:31:21 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 897332158C;
        Fri, 20 Nov 2020 07:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605857479;
        bh=radc542TN6um7EFPCh8nJ/Ba0D/UvKiUwI3mWZuMOdY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tbNFkWKzEQPKzlhL/I3Fcce3vtLEVSTloVGvMIvC+ppoHWhXW2oo0eW7ec0r7VjEJ
         8iUHTuavBE0OVTkkHKFV95WRVAaxkKAAjSznnBsfxwEFxGTNl4JZlF2PhizO5Oumgk
         i9RKpYWtrEihDXBejm7+M6cxx0+iXEjbGWhxPmyI=
Date:   Fri, 20 Nov 2020 08:32:01 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Daniel Axtens <dja@axtens.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.9 0/5] CVE-2020-4788: Speculation on incompletely
 validated data on IBM Power9
Message-ID: <X7dw8U60gIVwY1b6@kroah.com>
References: <20201119232250.365304-1-dja@axtens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201119232250.365304-1-dja@axtens.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Nov 20, 2020 at 10:22:45AM +1100, Daniel Axtens wrote:
> IBM Power9 processors can speculatively operate on data in the L1
> cache before it has been completely validated, via a way-prediction
> mechanism. It is not possible for an attacker to determine the
> contents of impermissible memory using this method, since these
> systems implement a combination of hardware and software security
> measures to prevent scenarios where protected data could be leaked.
> 
> However these measures don't address the scenario where an attacker
> induces the operating system to speculatively execute instructions
> using data that the attacker controls. This can be used for example to
> speculatively bypass "kernel user access prevention" techniques, as
> discovered by Anthony Steinhauser of Google's Safeside Project. This
> is not an attack by itself, but there is a possibility it could be
> used in conjunction with side-channels or other weaknesses in the
> privileged code to construct an attack.
> 
> This issue can be mitigated by flushing the L1 cache between privilege
> boundaries of concern. This series flushes the cache on kernel entry and
> after kernel user accesses.
> 
> Thanks to Nick Piggin, Russell Currey, Christopher M. Riedl, Michael
> Ellerman and Spoorthy S for their work in developing, optimising,
> testing and backporting these fixes, and to the many others who helped
> behind the scenes.

All of these for all branches are now queued up, thanks for making them
so easy to apply!

greg k-h
