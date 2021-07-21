Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A2233D1077
	for <lists+stable@lfdr.de>; Wed, 21 Jul 2021 16:04:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236733AbhGUNXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Jul 2021 09:23:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:55744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236464AbhGUNXo (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Jul 2021 09:23:44 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1813761245;
        Wed, 21 Jul 2021 14:04:20 +0000 (UTC)
Date:   Wed, 21 Jul 2021 10:04:13 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        David Wysochanski <dwysocha@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 147/243] NFSD: Fix TP_printk() format specifier in
 nfsd_clid_class
Message-ID: <20210721100413.227fd0cb@oasis.local.home>
In-Reply-To: <20210720214847.GB704@amd>
References: <20210719144940.904087935@linuxfoundation.org>
        <20210719144945.657682587@linuxfoundation.org>
        <20210720214847.GB704@amd>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 20 Jul 2021 23:48:47 +0200
Pavel Machek <pavel@denx.de> wrote:

> Hi!
> 
> > [ Upstream commit a948b1142cae66785521a389cab2cce74069b547 ]
> > 
> > Since commit 9a6944fee68e ("tracing: Add a verifier to check string
> > pointers for trace events"), which was merged in v5.13-rc1,
> > TP_printk() no longer tacitly supports the "%.*s" format specifier.
> > 
> > These are low value tracepoints, so just remove them.  
> 
> So I understand we want this for mainline, but AFAICT 5.10 does not
> have 9a6944fee68e ("tracing: Add a verifier to check string pointers
> for trace events") commit, so this does not fix any bug and removal of
> tracepoints can be surprising.
>

Thanks for pointing this out. I get so many stable patches, I don't
have time to look at all of them.

Greg, I don't think this should be backported. The verifier code had a
bug in it that broke the '%.*s' formats. This patch removed the good
code because of the broken code.

See eb01f5353bdaa ("tracing: Handle %.*s in trace_check_vprintf()")

-- Steve
