Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8B053167DB
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 14:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231874AbhBJNVH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 08:21:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39162 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231438AbhBJNUt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 08:20:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612963162;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CutjPVhTtQ55NEbupLt796Nt3X7TBlQOKuwFgAzRlVE=;
        b=HvgkkDAbJ+o7eCQKhAHCqQiEEMl3C/5NSjdKYZFDQxKk0bUnxilc9/ptwf0i79M24rZpIO
        vwULmV6FmROepJpj1yrEu0CRThrDU4EC7n8iWr+OJ5GFHvdW2C9D3dlakza5GP0y012CiM
        Wfyl4HdYrfbe/UHi/4pl6a3It/Sa7qA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-usIAKUTJMxeFbH_IFGDv5A-1; Wed, 10 Feb 2021 08:19:20 -0500
X-MC-Unique: usIAKUTJMxeFbH_IFGDv5A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 9243E79EC0;
        Wed, 10 Feb 2021 13:19:19 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6AE265D71B;
        Wed, 10 Feb 2021 13:19:17 +0000 (UTC)
Date:   Wed, 10 Feb 2021 14:19:16 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [4.14] Failing selftest timer/adjtick
Message-ID: <20210210131916.GC1903164@localhost>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
 <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 10, 2021 at 02:07:21PM +0100, Joerg Vehlow wrote:
> On 2/10/2021 2:00 PM, Greg KH wrote:
> > Have you tried applying it to that tree to see if it solves your problem
> > and works properly?  If so, please feel free to provide a working
> > backported copy, with your signed-off-by and we can consider it.
> It can be applied without any changes and fixes the problem, but since I
> have not a lot of knowledge about this subsystem, I don't know if this
> breaks anything or if it requires other patches to be applied first, to not
> break anything..
> Maybe the authors of the patch can check this easily or maybe know it.
> That's why I added them to the initial mail.

That patch cannot be applied alone. It would break the timekeeping in
not so obvious ways as there will be unexpected sources of the NTP
tracking error. IIRC, at least the following changes would need to be
included with it. There may be others.

c2cda2a5bda9 ("timekeeping/ntp: Don't align NTP frequency adjustments to ticks")
aea3706cfc4d ("timekeeping: Remove CONFIG_GENERIC_TIME_VSYSCALL_OLD")
d4d1fc61eb38 ("ia64: Update fsyscall gettime to use modern vsyscall_update")

My suggestion for a fix would be to increase the limit in the failing
test.

-- 
Miroslav Lichvar

