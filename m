Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F15F5165864
	for <lists+stable@lfdr.de>; Thu, 20 Feb 2020 08:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726550AbgBTH3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Feb 2020 02:29:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:52316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726149AbgBTH3h (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Feb 2020 02:29:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DC0024654;
        Thu, 20 Feb 2020 07:29:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582183776;
        bh=TxnVf9P5GTfdh8uEk/jtWBk7wfQqSZEQk6MNCsGrQfE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wicZbk6IzHOoAhg+vtJOYEGxPaTpNGCFRUn9hqrP9CXWODywFtF4jC6fbHoF1dhIi
         Ae8VqYDJHF4u0TEZmyQ/zh941MLVXY8E0nan29sMymtJ4U8ztnJ6JwPJCFxTuAEPCJ
         qlkXyWcSlLOJq7CX1JOXX08o7QnFY8mI1UxS89qQ=
Date:   Thu, 20 Feb 2020 08:29:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Santosh Sivaraj <santosh@fossix.org>
Cc:     linuxppc-dev <linuxppc-dev@lists.ozlabs.org>,
        stable@vger.kernel.org, peterz@infradead.org,
        aneesh.kumar@linux.ibm.com, akshay.adiga@linux.ibm.com
Subject: Re: [PATCH 0/6] Memory corruption may occur due to incorrent tlb
 flush
Message-ID: <20200220072934.GA3253157@kroah.com>
References: <20200220053457.930231-1-santosh@fossix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220053457.930231-1-santosh@fossix.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 20, 2020 at 11:04:51AM +0530, Santosh Sivaraj wrote:
> The TLB flush optimisation (a46cc7a90f: powerpc/mm/radix: Improve TLB/PWC
> flushes) may result in random memory corruption. Any concurrent page-table walk
> could end up with a Use-after-Free. Even on UP this might give issues, since
> mmu_gather is preemptible these days. An interrupt or preempted task accessing
> user pages might stumble into the free page if the hardware caches page
> directories.
> 
> The series is a backport of the fix sent by Peter [1].
> 
> The first three patches are dependencies for the last patch (avoid potential
> double flush). If the performance impact due to double flush is considered
> trivial then the first three patches and last patch may be dropped.
> 
> [1] https://patchwork.kernel.org/cover/11284843/

Can you resend these with the git commit ids of the upstream patches in
them, and say what stable tree(s) you wish to have them applied to?

thanks,

greg k-h
