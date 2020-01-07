Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD1A13263C
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 13:34:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727722AbgAGMee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 07:34:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51838 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727177AbgAGMee (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 07:34:34 -0500
Received: from ip-109-41-1-227.web.vodafone.de ([109.41.1.227] helo=wittgenstein)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <christian.brauner@ubuntu.com>)
        id 1ioo48-0001ih-2L; Tue, 07 Jan 2020 12:34:32 +0000
Date:   Tue, 7 Jan 2020 13:34:35 +0100
From:   Christian Brauner <christian.brauner@ubuntu.com>
To:     Amanieu d'Antras <amanieu@gmail.com>
Cc:     linux-kernel@vger.kernel.org,
        Christian Brauner <christian@brauner.io>,
        stable@vger.kernel.org
Subject: Re: [PATCH 0/7] Fix CLONE_SETTLS with clone3
Message-ID: <20200107123434.vxfq57oah34plvjx@wittgenstein>
References: <20200102172413.654385-1-amanieu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200102172413.654385-1-amanieu@gmail.com>
User-Agent: NeoMutt/20180716
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 06:24:06PM +0100, Amanieu d'Antras wrote:
> The clone3 syscall is currently broken when used with CLONE_SETTLS on all
> architectures that don't have an implementation of copy_thread_tls. The old
> copy_thread function handles CLONE_SETTLS by reading the new TLS value from
> pt_regs containing the clone syscall parameters. Since clone3 passes the TLS
> value in clone_args, this results in the TLS register being initialized to a
> garbage value.
> 
> This patch series implements copy_thread_tls on all architectures that currently
> define __ARCH_WANT_SYS_CLONE3 and adds a compile-time check to ensure that any
> architecture that enables clone3 in the future also implements copy_thread_tls.
> 
> I have also included a minor fix for the arm64 uapi headers which caused
> __NR_clone3 to be missing from the exported user headers.
> 
> I have only tested this on arm64, but the copy_thread_tls implementations for
> the various architectures are fairly straightforward.

I've picked up this series and moved it into
https://git.kernel.org/pub/scm/linux/kernel/git/brauner/linux.git/log/?h=clone3_tls

If I hear no objections I'll merge into into my fixes tree today or
tomorrow.

Thanks!
Christian
