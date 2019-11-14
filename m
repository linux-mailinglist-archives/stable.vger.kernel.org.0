Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81CB6FC29C
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 10:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726024AbfKNJbm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 04:31:42 -0500
Received: from mx2.suse.de ([195.135.220.15]:56578 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725977AbfKNJbl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 14 Nov 2019 04:31:41 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 012FDAD2B;
        Thu, 14 Nov 2019 09:31:39 +0000 (UTC)
Date:   Thu, 14 Nov 2019 10:31:38 +0100
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Michael Ellerman <patch-notifications@ellerman.id.au>
Cc:     Gustavo Walbon <gwalbon@linux.ibm.com>,
        linuxppc-dev@lists.ozlabs.org, mikey@neuling.org,
        maurosr@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        npiggin@gmail.com, diana.craciun@nxp.com, paulus@samba.org,
        leitao@debian.org, gwalbon@linux.vnet.ibm.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] Fix wrong message when RFI Flush is disable
Message-ID: <20191114093138.GF11661@kitsune.suse.cz>
References: <20190502210907.42375-1-gwalbon@linux.ibm.com>
 <47DFxM5mVHz9sNT@ozlabs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47DFxM5mVHz9sNT@ozlabs.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 14, 2019 at 08:07:35PM +1100, Michael Ellerman wrote:
> On Thu, 2019-05-02 at 21:09:07 UTC, Gustavo Walbon wrote:
> > From: "Gustavo L. F. Walbon" <gwalbon@linux.ibm.com>
> > 
> > The issue was showing "Mitigation" message via sysfs whatever the state of
> > "RFI Flush", but it should show "Vulnerable" when it is disabled.
> > 
> > If you have "L1D private" feature enabled and not "RFI Flush" you are
> > vulnerable to meltdown attacks.
> > 
> > "RFI Flush" is the key feature to mitigate the meltdown whatever the
> > "L1D private" state.
> > 
> > SEC_FTR_L1D_THREAD_PRIV is a feature for Power9 only.
> > 
> > So the message should be as the truth table shows.
> > CPU | L1D private | RFI Flush |                   sysfs               |
> > ----| ----------- | --------- | ------------------------------------- |
> >  P9 |    False    |   False   | Vulnerable
> >  P9 |    False    |   True    | Mitigation: RFI Flush
> >  P9 |    True     |   False   | Vulnerable: L1D private per thread
> >  P9 |    True     |   True    | Mitigation: RFI Flush, L1D private per
> >     |             |           | thread
> >  P8 |    False    |   False   | Vulnerable
> >  P8 |    False    |   True    | Mitigation: RFI Flush
> > 
> > Output before this fix:
> >  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
> >  Mitigation: RFI Flush, L1D private per thread
> >  # echo 0 > /sys/kernel/debug/powerpc/rfi_flush
> >  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
> >  Mitigation: L1D private per thread
> > 
> > Output after fix:
> >  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
> >  Mitigation: RFI Flush, L1D private per thread
> >  # echo 0 > /sys/kernel/debug/powerpc/rfi_flush
> >  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
> >  Vulnerable: L1D private per thread
> > 
> > Link: https://github.com/linuxppc/issues/issues/243
> > 
> > Signed-off-by: Gustavo L. F. Walbon <gwalbon@linux.ibm.com>
> > Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
> 
> Applied to powerpc next, thanks.
> 
> https://git.kernel.org/powerpc/c/4e706af3cd8e1d0503c25332b30cad33c97ed442
> 
> cheers

Fixes: ff348355e9c7 ("powerpc/64s: Enhance the information in
cpu_show_meltdown()")

Thanks

Michal
