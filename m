Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E665A13C129
	for <lists+stable@lfdr.de>; Wed, 15 Jan 2020 13:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgAOMjf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jan 2020 07:39:35 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:52942 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgAOMje (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jan 2020 07:39:34 -0500
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 00FCdTPb010825;
        Wed, 15 Jan 2020 12:39:29 GMT
From:   Nix <nix@esperi.org.uk>
To:     Coly Li <colyli@suse.de>
Cc:     Eric Wheeler <bcache@lists.ewheeler.net>,
        linux-bcache@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] bcache: back to cache all readahead I/Os
References: <20200104065802.113137-1-colyli@suse.de>
        <alpine.LRH.2.11.2001062256450.2074@mx.ewheeler.net>
        <87lfqa2p4s.fsf@esperi.org.uk>
        <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de>
Emacs:  because extension languages should come with the editor built in.
Date:   Wed, 15 Jan 2020 12:39:29 +0000
In-Reply-To: <5af6593d-b6aa-74a7-0aae-e3c689cebc67@suse.de> (Coly Li's message
        of "Wed, 15 Jan 2020 14:21:05 +0800")
Message-ID: <875zhc3ncu.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: loom 1290; Body=4 Fuz1=4 Fuz2=4
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 15 Jan 2020, Coly Li stated:

> I have two reports offline and directly to me, one is from an email
> address of github and forwarded to me by Jens, one is from a China local
> storage startup.
>
> The first report complains the desktop-pc benchmark is about 50% down
> and the root cause is located on commit b41c9b0 ("bcache: update
> bio->bi_opf bypass/writeback REQ_ flag hints").
>
> The second report complains their small file workload (mixed read and
> write) has around 20%+ performance drop and the suspicious change is
> also focused on the readahead restriction.
>
> The second reporter verifies this patch and confirms the performance
> issue has gone. I don't know who is the first report so no response so far.

Hah! OK, looks like readahead is frequently-enough useful that caching
it is better than not caching it :) I guess the problem is that if you
don't cache it, it never gets cached at all even if it was useful, so
the next time round you'll end up having to readahead it again :/

One wonders what effect this will have on a bcache-atop-RAID: will we
end up caching whole stripes most of the time?
