Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D823A4BE8C
	for <lists+stable@lfdr.de>; Wed, 19 Jun 2019 18:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbfFSQqc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jun 2019 12:46:32 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:44370 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfFSQqc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jun 2019 12:46:32 -0400
Received: by mail-io1-f68.google.com with SMTP id s7so359924iob.11
        for <stable@vger.kernel.org>; Wed, 19 Jun 2019 09:46:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=18Kg5MWKnGyDk/Hk0hs3jQay0Br3d6t8dYYP1QSodXI=;
        b=hDEpW6pckZdP1MNsA9CrUrIBOZzka71e4VguuhxpKqYleqlCQabNYvvSjurTLKN2hG
         socR7N/sahSiKwTowWg2gM1tOUfpj+vtK1UdqIaOOr8LfWDRelj7AGPbx2Y/hrwSTTlR
         XgV3vpyu0JL8NcdIEPe/d0dnDFl1YRGp04khdB/WBHaxdHnH4iPcweYZZmzhRCgmNZbR
         gmH5mDAqHKBRIuxo027EWBxgUXRDHdBos/jreSYtg1kZpbQdorXQb1e5jYwxw7E261Iv
         yj0Pd7URP9le2yebOvZJ5O0NudYIgZRSSMEf6F1a/md6fEYTGNXT4gaRtJxlbZSNZonz
         FGNg==
X-Gm-Message-State: APjAAAWq6wgzAWAZCpnAOJD6rJ4Yay73OlXeDHLuXPOz2+6dr3joMe6P
        SnnXd0ZHUtvxNvPyEGlYWaVaHQ==
X-Google-Smtp-Source: APXvYqwlrenhz7SGY4ppdH5b4KqvGgeKH2qtdHOslNv0XodC4c1mNe523GdL5Na20VfbkbwdPmjrRA==
X-Received: by 2002:a5d:8195:: with SMTP id u21mr15862298ion.260.1560962791001;
        Wed, 19 Jun 2019 09:46:31 -0700 (PDT)
Received: from google.com ([2620:15c:183:0:20b8:dee7:5447:d05])
        by smtp.gmail.com with ESMTPSA id t19sm13739147iog.41.2019.06.19.09.46.28
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 19 Jun 2019 09:46:29 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:46:25 -0600
From:   Raul Rangel <rrangel@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-mmc@vger.kernel.org,
        djkurtz@google.com, adrian.hunter@intel.com, zwisler@chromium.org,
        Linus Walleij <linus.walleij@linaro.org>,
        linux-kernel@vger.kernel.org, Chris Boot <bootc@bootc.net>,
        =?iso-8859-1?Q?Cl=E9ment_P=E9ron?= <peron.clem@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [stable/4.14.y PATCH 0/3] mmc: Fix a potential resource leak
 when shutting down request queue.
Message-ID: <20190619164625.GA85539@google.com>
References: <20190513175521.84955-1-rrangel@chromium.org>
 <20190514091933.GA27269@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190514091933.GA27269@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 14, 2019 at 11:19:34AM +0200, Greg Kroah-Hartman wrote:
> On Mon, May 13, 2019 at 11:55:18AM -0600, Raul E Rangel wrote:
> > I think we should cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
> > https://lore.kernel.org/patchwork/patch/856512/ into 4.14. It fixes a
> > potential resource leak when shutting down the request queue.
> 
> Potential meaning "it does happen", or "it can happen if we do this", or
> just "maybe it might happen, we really do not know?"
It does happen if the AMD SDHCI patches are cherry-picked into 4.14.
https://lkml.org/lkml/2019/5/1/398
It can be mitigated by changing the line in the patch with
`mmc_detect_change(host, 0)` to mmc_detect_change(host, 200)`, but
that's just a workaround to play with the timing so the race condition
doesn't happen.
> 
> > Once this patch is applied, there is a potential for a null pointer dereference.
> > That's what the second patch fixes.
> 
> What is the git id of that upstream fix?
So there is no specific upstream fix. There was a large patch set that
migrated mmc to using blk-mq, so the bug just kind of went away.
https://lwn.net/Articles/739774/ or 0fbfd12518303e9b32ac9fd231439459eac848f9

> 
> > The third patch is just an optimization to stop processing earlier.
> 
> That's not how stable kernels work :(
Oops, I guess we can ignore that patch. It just prevents mmc_init_request
from being called, but it doesn't matter since the 2nd patch actually
checks for NULL now.
> 
> > See https://patchwork.kernel.org/patch/10925469/ for the initial motivation.
> 
> I don't understand the motivation from that link at all :(
> 
> > This commit applies to v4.14.116. It is already included in 4.19. 4.19 doesn't
> > suffer from the null pointer dereference because later commits migrate the mmc
> > stack to blk-mq.
> 
> What are those later commits?
Commit 0fbfd12518303e9b32ac9fd231439459eac848f9 specifically deletes the
code for the 2nd patch. As I said above, the NULL pointer dereference
just kind of went away as part of the blk-mq migration, so there is no
upstream fix :(

> 
> > I tested this patch set by randomly connecting/disconnecting the SD
> > card. I got over 189650 itarations without a problem.
> 
> And if you do not have these patches, on 4.14.y, how many iterations
> cause a problem?  If you just apply the first patch, does that work?
If I apply the AMD SDHCI patches and nothing else, then I can cause a
resource leak within 10 iterations. If I apply just the first patch then
I can cause a NULL pointer error within 10 iterations. If I apply both 1
and 2, then everything works as expected and I can't cause a problem.
> 
> _EVERY_ time we take a patch that is not upstream, something usually is
> broken and needs to be fixed.  We have a long long long history of this,
> so if you want to have a patch that is not upstream applied to a stable
> kernel release, you need a whole lot of justification and explanation
> and begging.  And you need to be around to fix the fallout for when it
> breaks :)

It also looks like 2361bfb055f948eac6583fa3c75a014da84fe554 includes a
fix for 41e3efd07d5a02c80f503e29d755aa1bbb4245de, so that would need to
be cherry picked in.

I guess I should have included a fixes: line in my second patch.

So to summarize:
- cherry-pick 41e3efd07d5a02c80f503e29d755aa1bbb4245de
- cherry-pick 2361bfb055f948eac6583fa3c75a014da84fe554
- apply 2nd patch but add to commit message:
  Fixes: 41e3efd07d5a ("mmc: block: Simplify cleaning up the queue")
- Ignore patch 3 since it's an optimization.
> 
> thanks,
> 
> greg k-h
Thanks again for your time, and sorry for the really late response!

Raul
