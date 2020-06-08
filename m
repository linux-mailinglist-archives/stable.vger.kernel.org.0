Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C911F1F27
	for <lists+stable@lfdr.de>; Mon,  8 Jun 2020 20:42:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgFHSmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 14:42:01 -0400
Received: from correo.us.es ([193.147.175.20]:45114 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725280AbgFHSl7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 14:41:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 82EE9DBC06
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 20:41:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75777DA789
        for <stable@vger.kernel.org>; Mon,  8 Jun 2020 20:41:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6A5D2DA791; Mon,  8 Jun 2020 20:41:56 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B288DA78B;
        Mon,  8 Jun 2020 20:41:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 08 Jun 2020 20:41:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 09FF942EF4E0;
        Mon,  8 Jun 2020 20:41:53 +0200 (CEST)
Date:   Mon, 8 Jun 2020 20:41:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Stefano Brivio <sbrivio@redhat.com>
Cc:     Mike Dillinger <miked@softtalker.com>, stable@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] nft_set_rbtree: Don't account for expired elements on
 insertion
Message-ID: <20200608184153.GA7865@salvia>
References: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <924e80c7b563cc6522a241b123c955c18983edb1.1591141588.git.sbrivio@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 03, 2020 at 01:50:11AM +0200, Stefano Brivio wrote:
> While checking the validity of insertion in __nft_rbtree_insert(),
> we currently ignore conflicting elements and intervals only if they
> are not active within the next generation.
> 
> However, if we consider expired elements and intervals as
> potentially conflicting and overlapping, we'll return error for
> entries that should be added instead. This is particularly visible
> with garbage collection intervals that are comparable with the
> element timeout itself, as reported by Mike Dillinger.
> 
> Other than the simple issue of denying insertion of valid entries,
> this might also result in insertion of a single element (opening or
> closing) out of a given interval. With single entries (that are
> inserted as intervals of size 1), this leads in turn to the creation
> of new intervals. For example:
> 
>   # nft add element t s { 192.0.2.1 }
>   # nft list ruleset
>   [...]
>      elements = { 192.0.2.1-255.255.255.255 }
> 
> Always ignore expired elements active in the next generation, while
> checking for conflicts.
> 
> It might be more convenient to introduce a new macro that covers
> both inactive and expired items, as this type of check also appears
> quite frequently in other set back-ends. This is however beyond the
> scope of this fix and can be deferred to a separate patch.
> 
> Other than the overlap detection cases introduced by commit
> 7c84d41416d8 ("netfilter: nft_set_rbtree: Detect partial overlaps
> on insertion"), we also have to cover the original conflict check
> dealing with conflicts between two intervals of size 1, which was
> introduced before support for timeout was introduced. This won't
> return an error to the user as -EEXIST is masked by nft if
> NLM_F_EXCL is not given, but would result in a silent failure
> adding the entry.

Applied, thanks.
