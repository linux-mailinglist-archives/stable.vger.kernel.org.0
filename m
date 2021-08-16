Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ACE13ECF37
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 09:17:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233919AbhHPHSH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 03:18:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:45110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233906AbhHPHSH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 03:18:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71D1161A86;
        Mon, 16 Aug 2021 07:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629098256;
        bh=V3I7Bd7jxAfVHg8y2QMOjUbjW5mcFbPEbMgjJfYkyiA=;
        h=Date:From:To:cc:Subject:In-Reply-To:References:From;
        b=hQ2iOmkT6EgOJa7XEQDWU1z3CDkY1B9U8B0uXz8tujK1SVEIJFbXqZ9NM3JYBR9aZ
         nFVo4bHuMSuJE2I7ipU2GZnMheGRMmD6bI7hIg9AY4vgPxlmaAs1skjbBWjG4nKST5
         kfA1DejFZGFn4TbntzkkxdMdtBCMBD4q6x/bB/FYtZS7CT2sCqbiH3UXvNTq3VTSDT
         YikHySeMMxJt7lUUG/+AvxKAJQrrwyndEpF4P8YAtSvIFC9mAz+GLYBXArF30STrA6
         NL2Qv/BvveL/9shn2FTTc7q7aY7drkOhcHXKSLaRSl1FjothGoVrz5P2xWoUh0qRnh
         +smZIO+VNYMXg==
Date:   Mon, 16 Aug 2021 09:17:30 +0200 (CEST)
From:   Jiri Kosina <jikos@kernel.org>
To:     Denis Efremov <efremov@linux.com>
cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        regressions@lists.linux.dev, Mark Hounschell <markh@compro.net>,
        Wim Osterholt <wim@djo.tudelft.nl>,
        Kurt Garloff <kurt@garloff.de>, stable@vger.kernel.org
Subject: Re: [PATCH] Revert "floppy: reintroduce O_NDELAY fix"
In-Reply-To: <20210808074246.33449-1-efremov@linux.com>
Message-ID: <nycvar.YFH.7.76.2108160914070.8253@cbobk.fhfr.pm>
References: <de10cb47-34d1-5a88-7751-225ca380f735@compro.net> <20210808074246.33449-1-efremov@linux.com>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 8 Aug 2021, Denis Efremov wrote:

> The patch breaks userspace implementations (e.g. fdutils) and introduces
> regressions in behaviour. Previously, it was possible to O_NDELAY open a
> floppy device with no media inserted or with write protected media without
> an error. Some userspace tools use this particular behavior for probing.
> 
> It's not the first time when we revert this patch. Previous revert is in
> commit f2791e7eadf4 (Revert "floppy: refactor open() flags handling").
> 
> This reverts commit 8a0c014cd20516ade9654fc13b51345ec58e7be8.

By reverting it you bring back the bugs that were fixed by it -- e.g. the 
possibility to livelock mmap() on the returned fd to keep waiting on the 
page unlock bit forever, or the functionality bug reported at [1], and 
likely others.

[1] https://bugzilla.suse.com/show_bug.cgi?id=1181018

-- 
Jiri Kosina
SUSE Labs

