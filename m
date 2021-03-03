Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D661832BC56
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 22:53:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1447259AbhCCNsc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 08:48:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:53904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232777AbhCCMcp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 3 Mar 2021 07:32:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDA1F64EE6;
        Wed,  3 Mar 2021 09:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614765464;
        bh=m5ZgB2uhhBpzt73LsJTxuAhJfKD5R+vFHoUx+9V28SE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R69mIedG6TCe/QyLb4VgW3wV+3ODZJzZrp11MBZDlqNhK4Iw35dsx5UJKGqa9xTBJ
         5McGaTAS/Kpp7NaG0xPizZq4iWOUbZ4RmTY+y8Yf34WuJ8rNj8UEMpoy8hBjbCfZzm
         DU2ITVOsJL2Kr3VE3DonCKaa92HMx+Z2GMgCFshQ=
Date:   Wed, 3 Mar 2021 10:57:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Marco Elver <elver@google.com>
Cc:     rafael@kernel.org, paulmck@kernel.org, dvyukov@google.com,
        glider@google.com, andreyknvl@google.com,
        kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] kcsan, debugfs: Move debugfs file creation out of early
 init
Message-ID: <YD9dld26cz0RWHg7@kroah.com>
References: <20210303093845.2743309-1-elver@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210303093845.2743309-1-elver@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 03, 2021 at 10:38:45AM +0100, Marco Elver wrote:
> Commit 56348560d495 ("debugfs: do not attempt to create a new file
> before the filesystem is initalized") forbids creating new debugfs files
> until debugfs is fully initialized. This breaks KCSAN's debugfs file
> creation, which happened at the end of __init().

How did it "break" it?  The files shouldn't have actually been created,
right?

> There is no reason to create the debugfs file during early
> initialization. Therefore, move it into a late_initcall() callback.
> 
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: "Rafael J. Wysocki" <rafael@kernel.org>
> Cc: stable <stable@vger.kernel.org>
> Fixes: 56348560d495 ("debugfs: do not attempt to create a new file before the filesystem is initalized")
> Signed-off-by: Marco Elver <elver@google.com>
> ---
> I've marked this for 'stable', since 56348560d495 is also intended for
> stable, and would subsequently break KCSAN in all stable kernels where
> KCSAN is available (since 5.8).

No objection from me, just odd that this actually fixes anything :)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
