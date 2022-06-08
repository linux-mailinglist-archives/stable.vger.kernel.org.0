Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4B52543E93
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 23:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234350AbiFHVZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jun 2022 17:25:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233999AbiFHVZK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Jun 2022 17:25:10 -0400
X-Greylist: delayed 2349 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 08 Jun 2022 14:25:09 PDT
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8370E194BFA
        for <stable@vger.kernel.org>; Wed,  8 Jun 2022 14:25:08 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 258KjtIX006175
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 8 Jun 2022 21:45:55 +0100
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     linux-bcache@vger.kernel.org, linux-block@vger.kernel.org,
        Nikhil Kshirsagar <nkshirsagar@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 4/4] bcache: avoid journal no-space deadlock by
 reserving 1 journal bucket
References: <20220521170502.20026-1-colyli@suse.de>
        <20220521170502.20026-4-colyli@suse.de>
Emacs:  the definitive fritterware.
Date:   Wed, 08 Jun 2022 21:45:55 +0100
In-Reply-To: <20220521170502.20026-4-colyli@suse.de> (Coly Li's message of
        "Sun, 22 May 2022 01:05:02 +0800")
Message-ID: <8735geanp8.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1480; Body=5 Fuz1=5 Fuz2=5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21 May 2022, Coly Li spake thusly:

> When all journal buckets are fully filled by active jset with heavy
> write I/O load, the cache set registration (after a reboot) will load
> all active jsets and inserting them into the btree again (which is
> called journal replay). If a journaled bkey is inserted into a btree
> node and results btree node split, new journal request might be
> triggered. For example, the btree grows one more level after the node
> split, then the root node record in cache device super block will be
> upgrade by bch_journal_meta() from bch_btree_set_root(). But there is no
> space in journal buckets, the journal replay has to wait for new journal
> bucket to be reclaimed after at least one journal bucket replayed. This
> is one example that how the journal no-space deadlock happens.
> 
> The solution to avoid the deadlock is to reserve 1 journal bucket in

It seems to me that this could happen more than once in a single journal
replay (multiple nodes might be split, etc). Is one bucket actually
always enough, or is it merely enough nearly all the time?

-- 
NULL && (void)
