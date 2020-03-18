Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF81718A024
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 17:03:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726994AbgCRQDX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 12:03:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:57966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726961AbgCRQDW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 12:03:22 -0400
Received: from linux-8ccs (p5B2812F9.dip0.t-ipconnect.de [91.40.18.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 383192076C;
        Wed, 18 Mar 2020 16:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584547401;
        bh=8+bhNeSa7Nigx9lS/u8FMlPTHye2zcWuNkajfPvjVP0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Izl6b0ua1+tYjXnLnem1GifC/wnoWuzCPXbuSvOV+fm4FovYEdx2fZwZeuoazXHf4
         KKqkDz2I/toW12IdmVG+tsC/k++kMxwuB22RWbqkIb8l6JogE9XAeBR84cnYgojkIz
         NXSxU3AXxtELDbwGdexG+SICwJ2InYehXnsNies4=
Date:   Wed, 18 Mar 2020 17:03:16 +0100
From:   Jessica Yu <jeyu@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Kees Cook <keescook@chromium.org>,
        Luis Chamberlain <mcgrof@kernel.org>,
        NeilBrown <neilb@suse.com>, stable@vger.kernel.org
Subject: Re: [PATCH v3 1/5] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200318160316.GC4144@linux-8ccs>
References: <20200314213426.134866-1-ebiggers@kernel.org>
 <20200314213426.134866-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200314213426.134866-2-ebiggers@kernel.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ Eric Biggers [14/03/20 14:34 -0700]:
>From: Eric Biggers <ebiggers@google.com>
>
>It's long been possible to disable kernel module autoloading completely
>(while still allowing manual module insertion) by setting
>/proc/sys/kernel/modprobe to the empty string.  This can be preferable
>to setting it to a nonexistent file since it avoids the overhead of an
>attempted execve(), avoids potential deadlocks, and avoids the call to
>security_kernel_module_request() and thus on SELinux-based systems
>eliminates the need to write SELinux rules to dontaudit module_request.
>
>However, when module autoloading is disabled in this way,
>request_module() returns 0.  This is broken because callers expect 0 to
>mean that the module was successfully loaded.
>
>Apparently this was never noticed because this method of disabling
>module autoloading isn't used much, and also most callers don't use the
>return value of request_module() since it's always necessary to check
>whether the module registered its functionality or not anyway.  But
>improperly returning 0 can indeed confuse a few callers, for example
>get_fs_type() in fs/filesystems.c where it causes a WARNING to be hit:
>
>	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
>		fs = __get_fs_type(name, len);
>		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
>	}
>
>This is easily reproduced with:
>
>	echo > /proc/sys/kernel/modprobe
>	mount -t NONEXISTENT none /
>
>It causes:
>
>	request_module fs-NONEXISTENT succeeded, but still no fs?
>	WARNING: CPU: 1 PID: 1106 at fs/filesystems.c:275 get_fs_type+0xd6/0xf0
>	[...]
>
>This should actually use pr_warn_once() rather than WARN_ONCE(), since
>it's also user-reachable if userspace immediately unloads the module.
>Regardless, request_module() should correctly return an error when it
>fails.  So let's make it return -ENOENT, which matches the error when
>the modprobe binary doesn't exist.
>
>I've also sent patches to document and test this case.
>
>Acked-by: Luis Chamberlain <mcgrof@kernel.org>
>Cc: stable@vger.kernel.org
>Cc: Alexei Starovoitov <ast@kernel.org>
>Cc: Andrew Morton <akpm@linux-foundation.org>
>Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>Cc: Jeff Vander Stoep <jeffv@google.com>
>Cc: Jessica Yu <jeyu@kernel.org>
>Cc: Kees Cook <keescook@chromium.org>
>Cc: NeilBrown <neilb@suse.com>
>Signed-off-by: Eric Biggers <ebiggers@google.com>

Reviewed-by: Jessica Yu <jeyu@kernel.org>

