Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A9C3141A49
	for <lists+stable@lfdr.de>; Sat, 18 Jan 2020 23:54:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgARWyX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 18 Jan 2020 17:54:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:41320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727008AbgARWyW (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 18 Jan 2020 17:54:22 -0500
Received: from X1 (nat-ab2241.sltdut.senawave.net [162.218.216.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBAF1246A5;
        Sat, 18 Jan 2020 22:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579388062;
        bh=Sev9wYvUYEKc/zi96JR7EJPQmQ+w++cAUQuho0Lvcrw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bx8VFTpKrukNtyrKYNpWQTv9MPPdUb67f7YOlBo4dKRK+/i/MOj7Eaf0YavBqSzEe
         /mdWpMo8vERRzmRc3gO8wNVjeuTCRnI5FxQ2nWx6Sot5YFhcS6n69JBLu0rE7IKoF0
         p+s5lIVAktqhjyYPmz4/WQHgBENTGQrwmRzX093g=
Date:   Sat, 18 Jan 2020 14:54:21 -0800
From:   Andrew Morton <akpm@linux-foundation.org>
To:     Wei Yang <richardw.yang@linux.intel.com>
Cc:     hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com,
        ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com,
        yang.shi@linux.alibaba.com, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        alexander.duyck@gmail.com, rientjes@google.com,
        stable@vger.kernel.org
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Message-Id: <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org>
In-Reply-To: <20200117233836.3434-1-richardw.yang@linux.intel.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 18 Jan 2020 07:38:36 +0800 Wei Yang <richardw.yang@linux.intel.com> wrote:

> If compound is true, this means it is a PMD mapped THP. Which implies
> the page is not linked to any defer list. So the first code chunk will
> not be executed.
> 
> Also with this reason, it would not be proper to add this page to a
> defer list. So the second code chunk is not correct.
> 
> Based on this, we should remove the defer list related code.
> 
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> 
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> Suggested-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> Cc: <stable@vger.kernel.org>    [5.4+]

This patch is identical to "mm: thp: grab the lock before manipulating
defer list", which is rather confusing.  Please let people know when
this sort of thing is done.

The earlier changelog mentioned a possible race condition.  This
changelog does not.  In fact this changelog fails to provide any
description of any userspace-visible runtime effects of the bug. 
Please send along such a description for inclusion, as always.

