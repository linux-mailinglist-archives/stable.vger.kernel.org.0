Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9281ED37F
	for <lists+stable@lfdr.de>; Wed,  3 Jun 2020 17:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726138AbgFCPfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Jun 2020 11:35:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:39102 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgFCPfh (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Jun 2020 11:35:37 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1jgVQR-0002xY-4E; Wed, 03 Jun 2020 17:35:31 +0200
Date:   Wed, 3 Jun 2020 17:35:31 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Mike Dillinger <miked@softtalker.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Don't account for expired elements on
 insertion
Message-ID: <20200603153531.GS31506@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Mike Dillinger <miked@softtalker.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
References: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Wed, Jun 03, 2020 at 01:50:11AM +0200, Stefano Brivio wrote:
> While checking the validity of insertion in __nft_rbtree_insert(),
> we currently ignore conflicting elements and intervals only if they
> are not active within the next generation.

Yes, it seems I missed insert path entirely when adding
nft_set_elem_expired() checks. Assuming that it is fine that expired
elements block insertions until gc-interval has passed, I missed the
chance for one end of an interval to be accepted while the other is not.

Thanks for clearing up my mess!

[...]

> Reported-by: Mike Dillinger <miked@softtalker.com>
> Cc: <stable@vger.kernel.org> # 5.6.x
> Fixes: 8d8540c4f5e0 ("netfilter: nft_set_rbtree: add timeout support")
> Fixes: 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps on insertion")
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>

Acked-by: Phil Sutter <phil@nwl.cc>

Cheers, Phil
