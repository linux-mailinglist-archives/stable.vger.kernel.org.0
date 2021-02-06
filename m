Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13D21311D59
	for <lists+stable@lfdr.de>; Sat,  6 Feb 2021 14:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhBFNMc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Feb 2021 08:12:32 -0500
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:49651 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229522AbhBFNMb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Feb 2021 08:12:31 -0500
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 116DBD6h007392;
        Sat, 6 Feb 2021 14:11:13 +0100
Date:   Sat, 6 Feb 2021 14:11:13 +0100
From:   Willy Tarreau <w@1wt.eu>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com
Subject: Re: Linux 4.4.256
Message-ID: <20210206131113.GB7312@1wt.eu>
References: <1612534196241236@kroah.com>
 <20210205205658.GA136925@roeck-us.net>
 <YB6S612pwLbQJf4u@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YB6S612pwLbQJf4u@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Feb 06, 2021 at 02:00:27PM +0100, Greg Kroah-Hartman wrote:
> I think Sasha's patch here:
> 	https://lore.kernel.org/r/20210205174702.1904681-1-sashal@kernel.org
> is looking like the solution.

It might cause trouble to those forcing SUBLEVEL to a given version such
as .0 to avoid exposing the exact stable version. I guess we should
instead try to integrate a test on the value itself and cap it at 255.

Something like this looks more robust to me, it will use SUBLEVEL for
values 0 to 255 and 255 for any larger value:

-	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 0$(SUBLEVEL)); \
+	expr $(VERSION) \* 65536 + 0$(PATCHLEVEL) \* 256 + 255 \* (0$(SUBLEVEL) > 255) + 0$(SUBLEVEL) * (0$(SUBLEVEL \<= 255)); \

Willy
