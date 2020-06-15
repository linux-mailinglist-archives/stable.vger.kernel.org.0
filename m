Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6701F1FA0E6
	for <lists+stable@lfdr.de>; Mon, 15 Jun 2020 22:04:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729836AbgFOUE2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jun 2020 16:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728773AbgFOUE2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jun 2020 16:04:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B072071A;
        Mon, 15 Jun 2020 20:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592251467;
        bh=HpSZ+6XhbkSlkxONu9hFhrcjACPI8H0WHNJT01UGSnM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=07mSqnzCcPF/Z4fkqrmDv/psU2Xh/EzRPRe7JWL1rPiTclrgNPMz6Ll2G92DJH1hS
         mx7tZDSgJ9546Wa122WpGpdkf6U82ejgmVnKnGNe6uX74zvIskjhKVjg/FMeLsFLSl
         jQfhL6AaTgtcMqPI+Ya3zvOHhkoMqijmXVJzvs7Y=
Date:   Mon, 15 Jun 2020 22:04:22 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Please add 17839856fd58 to the stable queue
Message-ID: <20200615200422.GA206959@kroah.com>
References: <CAHk-=wj-RATn3dNoBWgYaCSJGWotz3cRHFqWJwK-6GOLJK8o-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wj-RATn3dNoBWgYaCSJGWotz3cRHFqWJwK-6GOLJK8o-w@mail.gmail.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 15, 2020 at 12:18:48PM -0700, Linus Torvalds wrote:
> Commit 17839856fd58 ("gup: document and work around "COW can break
> either way" issue") is a real fix, but wasn't marked for stable
> because I wanted it to get more coverage testing in mainline first.
> Not because the patch is all that complex or scary, but because I was
> worried we'd find some odd case where it would make things slower by
> triggering the GUP slowpath much more often due to people doing odd
> things.
> 
> It turns out my worry seems to have been misplaced. The kernel test
> robot did indeed trigger a case where this made a big difference, but
> rather than being bad, it improved the odd corner-case test-case
> performance by a factor of 20x by breaking the COW and triggering the
> fast-case code that way, rather than the other way around.
> 
> See
> 
>   https://lore.kernel.org/lkml/20200611040453.GK12456@shao2-debian/
> 
> for details.
> 
> So that commit fixes a bug, isn't expected to really make any
> difference on any sane workload, and can apparently help the crazy
> cases by a huge amount. Let's just push it to stable..

Will go do that now, was waiting to see if this caused any problems,
glad to see it hasn't.

greg k-h
