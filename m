Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A0A576488
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 17:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbiGOPhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 11:37:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiGOPhS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 11:37:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CDC2558E4;
        Fri, 15 Jul 2022 08:37:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8F5620C4;
        Fri, 15 Jul 2022 15:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3225C34115;
        Fri, 15 Jul 2022 15:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657899436;
        bh=+TdpH4LmJ65RSDe8U7gFREpB+3xhVtMCKYTl6PjP6AQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZDVxByyE06Yf/5CCHEZTotbv5fbyiY/Qsc/fUy21vl9mi0YZsXBvHSSaPscGE4B3J
         xDN/mU+5+sxfbv/nTtpG0vr6QaftZJbfq5HGOY5XDk0FXlAK/h6ctZGZAAH4dCYf3b
         kJAecfM0aRxl9xOh72MsfM1chbID98RZ0jPk0GQs=
Date:   Fri, 15 Jul 2022 17:37:13 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Phil Auld <pauld@redhat.com>
Cc:     linux-kernel@vger.kernel.org,
        "Rafael J . Wysocki" <rafael@kernel.org>,
        Barry Song <21cnbao@gmail.com>,
        Tian Tao <tiantao6@hisilicon.com>,
        Yury Norov <yury.norov@gmail.com>, stable@vger.kernel.org
Subject: Re: [PATCH v5] drivers/base: fix userspace break from using
 bin_attributes for cpumap and cpulist
Message-ID: <YtGJqYrbSPq9q19U@kroah.com>
References: <20220715134924.3466194-1-pauld@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715134924.3466194-1-pauld@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 09:49:24AM -0400, Phil Auld wrote:
> Using bin_attributes with a 0 size causes fstat and friends to return that
> 0 size. This breaks userspace code that retrieves the size before reading
> the file. Rather than reverting 75bd50fa841 ("drivers/base/node.c: use
> bin_attribute to break the size limitation of cpumap ABI") let's put in a
> size value at compile time.
> 
> For cpulist the maximum size is on the order of
> 	NR_CPUS * (ceil(log10(NR_CPUS)) + 1)/2
> 
> which for 8192 is 20480 (8192 * 5)/2. In order to get near that you'd need
> a system with every other CPU on one node. For example: (0,2,4,8, ... ).
> To simplify the math and support larger NR_CPUS in the future we are using
> (NR_CPUS * 7)/2. We also set it to a min of PAGE_SIZE to retain the older
> behavior for smaller NR_CPUS.
> 
> The cpumap file the size works out to be NR_CPUS/4 + NR_CPUS/32 - 1
> (or NR_CPUS * 9/32 - 1) including the ","s.
> 
> Add a set of macros for these values to cpumask.h so they can be used in
> multiple places. Apply these to the handful of such files in
> drivers/base/topology.c as well as node.c.
> 
> As an example, on an 80 cpu 4-node system (NR_CPUS == 8192):
> 
> before:
> 
> -r--r--r--. 1 root root 0 Jul 12 14:08 system/node/node0/cpulist
> -r--r--r--. 1 root root 0 Jul 11 17:25 system/node/node0/cpumap
> 
> after:
> 
> -r--r--r--. 1 root root 28672 Jul 13 11:32 system/node/node0/cpulist
> -r--r--r--. 1 root root  4096 Jul 13 11:31 system/node/node0/cpumap
> 
> CONFIG_NR_CPUS = 16384
> -r--r--r--. 1 root root 57344 Jul 13 14:03 system/node/node0/cpulist
> -r--r--r--. 1 root root  4607 Jul 13 14:02 system/node/node0/cpumap
> 
> The actual number of cpus doesn't matter for the reported size since they
> are based on NR_CPUS.
> 
> Fixes: 75bd50fa841 ("drivers/base/node.c: use bin_attribute to break the size limitation of cpumap ABI")
> Fixes: bb9ec13d156 ("topology: use bin_attribute to break the size limitation of cpumap ABI")

Nit, use the full 12 characters otherwise our tools will complain.  I'll
go fix it up by hand...

thanks for sticking with this.

greg k-h
