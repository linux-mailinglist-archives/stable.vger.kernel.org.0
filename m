Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA9694EA9D
	for <lists+stable@lfdr.de>; Fri, 21 Jun 2019 16:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfFUOaW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Jun 2019 10:30:22 -0400
Received: from outbound-smtp09.blacknight.com ([46.22.139.14]:36980 "EHLO
        outbound-smtp09.blacknight.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbfFUOaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Jun 2019 10:30:22 -0400
X-Greylist: delayed 569 seconds by postgrey-1.27 at vger.kernel.org; Fri, 21 Jun 2019 10:30:21 EDT
Received: from mail.blacknight.com (pemlinmail04.blacknight.ie [81.17.254.17])
        by outbound-smtp09.blacknight.com (Postfix) with ESMTPS id 3ADEA1C249E
        for <stable@vger.kernel.org>; Fri, 21 Jun 2019 15:20:51 +0100 (IST)
Received: (qmail 22845 invoked from network); 21 Jun 2019 14:20:51 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.21.36])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 21 Jun 2019 14:20:51 -0000
Date:   Fri, 21 Jun 2019 15:16:33 +0100
From:   Mel Gorman <mgorman@techsingularity.net>
To:     Alan Jenkins <alan.christopher.jenkins@gmail.com>
Cc:     linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix setting the high and low watermarks
Message-ID: <20190621141633.GA2978@techsingularity.net>
References: <20190621114325.711-1-alan.christopher.jenkins@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20190621114325.711-1-alan.christopher.jenkins@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 21, 2019 at 12:43:25PM +0100, Alan Jenkins wrote:
> When setting the low and high watermarks we use min_wmark_pages(zone).
> I guess this is to reduce the line length.  But we forgot that this macro
> includes zone->watermark_boost.  We need to reset zone->watermark_boost
> first.  Otherwise the watermarks will be set inconsistently.
> 
> E.g. this could cause inconsistent values if the watermarks have been
> boosted, and then you change a sysctl which triggers
> __setup_per_zone_wmarks().
> 
> I strongly suspect this explains why I have seen slightly high watermarks.
> Suspicious-looking zoneinfo below - notice high-low != low-min.
> 
> Node 0, zone   Normal
>   pages free     74597
>         min      9582
>         low      34505
>         high     36900
> 
> https://unix.stackexchange.com/questions/525674/my-low-and-high-watermarks-seem-higher-than-predicted-by-documentation-sysctl-vm/525687
> 
> Signed-off-by: Alan Jenkins <alan.christopher.jenkins@gmail.com>
> Fixes: 1c30844d2dfe ("mm: reclaim small amounts of memory when an external
>                       fragmentation event occurs")
> Cc: stable@vger.kernel.org

Either way

Acked-by: Mel Gorman <mgorman@techsingularity.net>

-- 
Mel Gorman
SUSE Labs
