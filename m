Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6194C1BEFB0
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 07:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbgD3Fag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 01:30:36 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:60320 "EHLO fornost.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgD3Faf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 01:30:35 -0400
Received: from gwarestrin.me.apana.org.au ([192.168.0.7] helo=gwarestrin.arnor.me.apana.org.au)
        by fornost.hmeau.com with smtp (Exim 4.89 #2 (Debian))
        id 1jU1kf-0005J1-9j; Thu, 30 Apr 2020 15:28:50 +1000
Received: by gwarestrin.arnor.me.apana.org.au (sSMTP sendmail emulation); Thu, 30 Apr 2020 15:29:42 +1000
Date:   Thu, 30 Apr 2020 15:29:42 +1000
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Daniel Jordan <daniel.m.jordan@oracle.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] padata: add separate cpuhp node for CPUHP_PADATA_DEAD
Message-ID: <20200430052942.GA11738@gondor.apana.org.au>
References: <20200421163455.2177998-1-daniel.m.jordan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421163455.2177998-1-daniel.m.jordan@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 21, 2020 at 12:34:55PM -0400, Daniel Jordan wrote:
> Removing the pcrypt module triggers this:
> 
>   general protection fault, probably for non-canonical
>     address 0xdead000000000122
>   CPU: 5 PID: 264 Comm: modprobe Not tainted 5.6.0+ #2
>   Hardware name: QEMU Standard PC
>   RIP: 0010:__cpuhp_state_remove_instance+0xcc/0x120
>   Call Trace:
>    padata_sysfs_release+0x74/0xce
>    kobject_put+0x81/0xd0
>    padata_free+0x12/0x20
>    pcrypt_exit+0x43/0x8ee [pcrypt]
> 
> padata instances wrongly use the same hlist node for the online and dead
> states, so __padata_free()'s second cpuhp remove call chokes on the node
> that the first poisoned.
> 
> cpuhp multi-instance callbacks only walk forward in cpuhp_step->list and
> the same node is linked in both the online and dead lists, so the list
> corruption that results from padata_alloc() adding the node to a second
> list without removing it from the first doesn't cause problems as long
> as no instances are freed.
> 
> Avoid the issue by giving each state its own node.
> 
> Fixes: 894c9ef9780c ("padata: validate cpumask without removed CPU during offline")
> Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Steffen Klassert <steffen.klassert@secunet.com>
> Cc: linux-crypto@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@vger.kernel.org # v5.4+
> ---
>  include/linux/padata.h |  6 ++++--
>  kernel/padata.c        | 14 ++++++++------
>  2 files changed, 12 insertions(+), 8 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
