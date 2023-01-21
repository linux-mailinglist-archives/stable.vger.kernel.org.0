Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50EA26769D3
	for <lists+stable@lfdr.de>; Sat, 21 Jan 2023 23:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229825AbjAUWke (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Jan 2023 17:40:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjAUWkd (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 21 Jan 2023 17:40:33 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7963623672;
        Sat, 21 Jan 2023 14:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=f1sXpB/ldHPBQkMrWpc9cKM6bbQ1+cEzMMxY2SoT348=; b=trVG+VphLGnzZD2GeyrkAXKlN+
        l+bjro69F9+NpltjaOM1iA4mDQxjUqF62/ZMIk2FKh1e6Gv8jiXgT+2glgfP2iujDwozmUiEhkCRl
        3vBBNpPvjKhPYTTLkoUOEJ/Lp9JLfXfgmhKYVxOHfaZXREb37bdXSI7+tMI1NFzluzwWxq8/QH4KG
        2rttHa1Sz4haee+hwLf3W9lNg6PDxvsUo8bFfzgDU9FxKRt5E0AxpvziZ1IS+yAfVgkVxCiYL4vUe
        soyiawRq09F0C939BXFdQeMmmcMkPpaPkZYQSZFunynYbIysaVtOvZqm3hi/5JL8ZvsL5MYlhBEIc
        4v8NUDCA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pJMX6-00EcXk-4M; Sat, 21 Jan 2023 22:40:20 +0000
Date:   Sat, 21 Jan 2023 14:40:20 -0800
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Petr Mladek <pmladek@suse.com>
Cc:     Petr Pavlu <petr.pavlu@suse.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Borislav Petkov <bp@alien8.de>, NeilBrown <neilb@suse.de>,
        Goldwyn Rodrigues <rgoldwyn@suse.com>, david@redhat.com,
        mwilck@suse.com, linux-modules@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Ben Hutchings <benh@debian.org>,
        Adam Manzanares <a.manzanares@samsung.com>
Subject: Re: [PATCH v2] module: Don't wait for GOING modules
Message-ID: <Y8xp1HReo+ayHU8G@bombadil.infradead.org>
References: <20221205103557.18363-1-petr.pavlu@suse.com>
 <Y5gI/3crANzRv22J@bombadil.infradead.org>
 <Y5hRRnBGYaPby/RS@alley>
 <Y8c3hgVwKiVrKJM1@bombadil.infradead.org>
 <79aad139-5305-1081-8a84-42ef3763d4f4@suse.com>
 <Y8ll+eP+fb0TzFUh@alley>
 <Y8nljyOJ5/y9Pp72@bombadil.infradead.org>
 <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y8nnTXi1Jqy1YARi@bombadil.infradead.org>
Sender: Luis Chamberlain <mcgrof@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 19, 2023 at 04:58:53PM -0800, Luis Chamberlain wrote:
> On Thu, Jan 19, 2023 at 04:51:27PM -0800, Luis Chamberlain wrote:
> > On Thu, Jan 19, 2023 at 04:47:05PM +0100, Petr Mladek wrote:
> > > Yes, the -EINVAL error is strange. It is returned also in
> > > kernel/module/main.c on few locations. But neither of them
> > > looks like a good candidate.
> > 
> > OK I updated to next-20230119 and I don't see the issue now.
> > Odd. It could have been an issue with next-20221207 which I was
> > on before.
> > 
> > I'll run some more test and if nothing fails I'll send the fix
> > to Linux for rc5.
> 
> Jeesh it just occured to me the difference, which I'll have to
> test next, for next-20221207 I had enabled module compression
> on kdevops with zstd.
> 
> You can see the issues on kdevops git log with that... and I finally
> disabled it and the kmod test issue is gone. So it could be that
> but I just am ending my day so will check tomorrow if that was it.
> But if someone else beats me then great.
> 
> With kdevops it should be a matter of just enabling zstd as I
> just bumped support for next-20230119 and that has module decompression
> disabled.

So indeed, my suspcions were correct. There is one bug with
compression on debian:

 - gzip compressed modules don't end up in the initramfs

There is a generic upstream kmod bug:

  - modprobe --show-depends won't grok compressed modules so initramfs
    tools that use this as Debian likely are not getting module dependencies
    installed in their initramfs

But using xz compression reveals 4 GiB memory is not enough for kmod.sh
test 0004, the -EINVAL is due to an OOM hit on modprobe so the request
fails. That's a test bug.

But increasing memory (8 GiB seems to do it) still reveals kmod.sh test 0009
does fail, not all the times, and it is why the test runs 150 times if
you run the test once. The failure is not deterministic but surely fails
for me every time at least once out of the 150 runs. Test 0009 tries to
trigger running kmod_concurrent over max_modprobes for get_fs_type(). 

I'm trying to test to see if I this failure can trigger without module
compression but I don't see the failure yet.

Reverting the patch on this thread on linux-next does not fix that issue
and so this has perhaps been broken for a much longer time. And so this
patch still remains a candidate fix.

 Luis
