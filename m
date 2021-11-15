Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF303451782
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 23:30:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233930AbhKOWaC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 17:30:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:44292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349653AbhKOW2E (ORCPT <rfc822;Stable@vger.kernel.org>);
        Mon, 15 Nov 2021 17:28:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7A9661B5E;
        Mon, 15 Nov 2021 22:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637015108;
        bh=vJSsxRlroSa+Wf1PfSlk5Zcswft53H0QxDAKhSabyYs=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=BmWjiqc3dkXXeSpniJ6dzODtEuEJtDZJf1qW9i1Q5p2kyyOHXLaJn0rzSjli3lMUB
         eXGwsX2Bjd0ZfgH5ZDJhCi9ZLTWo5zlr3AVgbjrJN92qY1dwwF++LJJ//g0ugs0Tri
         WILh8gR3RXxVviHiDaTgOmbYjIpCdmtVhW34SPkG9OjdRj5t1u3OqmnV/EczLUcU1T
         BktqC0+BvkXPC56RsyKujUDfmYijhLIBaTr2j62PZCWG3aOvNVY9aU+kIn1Oe3xljW
         CcT+Pa4JMh59X4eQxVu26jrismAF1mULzxs4gPL3gFFD5LTphRR7LQ2wIHB7c1XqoR
         Pz4icykEWV/3w==
Date:   Mon, 15 Nov 2021 14:25:06 -0800 (PST)
From:   Stefano Stabellini <sstabellini@kernel.org>
X-X-Sender: sstabellini@ubuntu-linux-20-04-desktop
To:     Jan Beulich <jbeulich@suse.com>
cc:     Stefano Stabellini <sstabellini@kernel.org>,
        boris.ostrovsky@oracle.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@xilinx.com>,
        Stable@vger.kernel.org, jgross@suse.com
Subject: Re: [PATCH] xen: don't continue xenstore initialization in case of
 errors
In-Reply-To: <6be8285f-6cbe-c115-a826-585664c91022@suse.com>
Message-ID: <alpine.DEB.2.22.394.2111151424510.1412361@ubuntu-linux-20-04-desktop>
References: <20211112214709.1763928-1-sstabellini@kernel.org> <6be8285f-6cbe-c115-a826-585664c91022@suse.com>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 15 Nov 2021, Jan Beulich wrote:
> On 12.11.2021 22:47, Stefano Stabellini wrote:
> > --- a/drivers/xen/xenbus/xenbus_probe.c
> > +++ b/drivers/xen/xenbus/xenbus_probe.c
> > @@ -983,8 +983,10 @@ static int __init xenbus_init(void)
> >  	 */
> >  	proc_create_mount_point("xen");
> >  #endif
> > +	return err;
> 
> Personally I think such cases would better be "return 0". With
> that done here, err's initializer could (imo should) then also
> be dropped.

I'll make both changes in the next version


> >  out_error:
> > +	xen_store_domain_type = XS_UNKNOWN;
> >  	return err;
> >  }
> >  
> > 
> 
