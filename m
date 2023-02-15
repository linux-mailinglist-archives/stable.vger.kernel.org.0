Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8061697D13
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 14:23:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233001AbjBONXf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 08:23:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjBONXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 08:23:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D19427D63
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 05:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9B6B61A6A
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 13:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B18AC433D2;
        Wed, 15 Feb 2023 13:23:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676467403;
        bh=OAAZKddIFH7xn2FQQsz1erqtSCtQoj5XSuUjdZ2u6vM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VvhxtT00kv4G7ABSvn7z4p6qeMBhcwrE/aR4rLmW3leB8fLUKEjcoSS7YlAFmJk95
         Yzkx+S13kETaDATX+VowIg8txJuf8FrwpTr30ksZ78CmNwLmMFQWP0eon7Jv2J5GWp
         qDklgaTSYjtDlFQEm+q3hzAjtG+w8xusCOPJrz1Q=
Date:   Wed, 15 Feb 2023 14:23:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc:     stable@vger.kernel.org, debian-s390@lists.debian.org,
        debian-kernel@lists.debian.org, svens@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: Re: [PATCH 0/1] s390: fix endless loop in do_signal
Message-ID: <Y+zcyBGnQ9BuLwFv@kroah.com>
References: <20230215120413.949348-1-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215120413.949348-1-sumanthk@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 01:04:12PM +0100, Sumanth Korikkar wrote:
> Hi,
> 
> This patch fixes the issue for s390  stable kernel starting  5.10.162.
> The issue was specifically seen after stable version 5.10.162:
> Following commits can trigger it:
> 1. stable commit id - 788d0824269b ("io_uring: import 5.15-stable
> io_uring") can trigger this problem.
> 2. upstream commit id - 75309018a24d ("s390: add support for
> TIF_NOTIFY_SIGNAL")
> 
> Problem:
> qemu and user processes could stall when TIF_NOTIFY_SIGNAL is set from
> io_uring work.
> 
> Affected users:
> The issue was first raised by the debian team, where the s390
> bullseye build systems are affected.
> 
> Upstream commit Id:
> * The attached patch has no upstream commit. However, the stable kernel
> 5.10.162+ uses upstream commit id - 75309018a24d ("s390: add support for
> TIF_NOTIFY_SIGNAL"), which would need this fix
> * Starting from v5.12, there are s390 generic entry commits 
> 56e62a737028 ("s390: convert to generic entry")  and its relevant fixes,
> which are recommended and should address these problems.

I'm sorry, but I do not understand.  What exact commits should be added
to the 5.10.y tree to resolve this?

thanks,

greg k-h
