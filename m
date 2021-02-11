Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3854E31890C
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 12:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbhBKLGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 06:06:10 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:58572 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230395AbhBKLB0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 06:01:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613041192;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=43q0O9aZ2uqu/EPy/MYzL5B9BqsrK/x8AuDZmtqwScc=;
        b=OxdAPEHaEFc1cpmOSKor2h4VCKAfopqpIeGrU9s6MBcdl9mDSlp8QATtVer6TpgnKV2Bgz
        VyxGN2ytRJXtbVsVmAV70QfksgP8493DkHmP945TGI5QAKI022Qm0F8Q5ZnuaDKICIMLWT
        tNrKVJUEUbR8S1MfLtO/tOCFwfhTMgI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-YA3mc8hyODClKumZ8ey7gw-1; Thu, 11 Feb 2021 05:59:48 -0500
X-MC-Unique: YA3mc8hyODClKumZ8ey7gw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0215686A060;
        Thu, 11 Feb 2021 10:59:47 +0000 (UTC)
Received: from localhost (holly.tpb.lab.eng.brq.redhat.com [10.43.134.11])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C628762953;
        Thu, 11 Feb 2021 10:59:45 +0000 (UTC)
Date:   Thu, 11 Feb 2021 11:59:44 +0100
From:   Miroslav Lichvar <mlichvar@redhat.com>
To:     Joerg Vehlow <lkml@jv-coder.de>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [4.14] Failing selftest timer/adjtick
Message-ID: <20210211105944.GG1903164@localhost>
References: <e76744b3-342a-1f75-cba6-51fd8b01c5ce@jv-coder.de>
 <YCPZA7nkGGDru3xw@kroah.com>
 <239b8a9a-d550-11e3-4650-39ad5bd85013@jv-coder.de>
 <20210210131916.GC1903164@localhost>
 <897e03f9-4062-d34f-0445-ff4f047ccd13@jv-coder.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <897e03f9-4062-d34f-0445-ff4f047ccd13@jv-coder.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 11:33:05AM +0100, Joerg Vehlow wrote:
> > My suggestion for a fix would be to increase the limit in the failing
> > test.
> Thanks, that's what I expected. But I still wonder why the test is failing
> almost 100% of time for me on qemu-arm64 (running on x86). Is this a
> regression in 4.14, that was working at some point or was it never tested on
> arm?

I don't think it is specific to arm or that it is a regression. I
think the virtual machine just happens to be too idle for the test.
There may be unrelated changes, maybe in the kernel, qemu, or
applications, that caused the rate of the clock updates to decrease so
much that the instability now triggers the failure in the test.  The
issue with the clock was there since NO_HZ was introduced, but it
becomes more severe as the activity of the kernel decreases.

-- 
Miroslav Lichvar

