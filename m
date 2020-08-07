Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CD923E76F
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 08:47:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726038AbgHGGre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 02:47:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:46824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgHGGre (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 7 Aug 2020 02:47:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 002BE20866;
        Fri,  7 Aug 2020 06:47:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596782852;
        bh=SqxXmUiK7bEJla9DM38sBEbKa6Nq9LJxsuptDBfN6kE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NtjyCGcIEP9AXhfIM3EG4BPCtXhgO8DRQUKxnQDB9dOVTSYff71OVVO9yoqHpuJc7
         oznteTT5V+qeKzOd6GrgoxH9iaXxDzUl3zGm0bWeyZBs0Y0TBPleciknAqoYPjm+Hq
         gNFpNdoG03LTULJs9HowQlVUi2i0eQTMWzD9Mclo=
Date:   Fri, 7 Aug 2020 08:47:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        stable@vger.kernel.org, Jessica Yu <jeyu@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 1/2] module: Correctly truncate sysfs sections output
Message-ID: <20200807064729.GA981993@kroah.com>
References: <20200807063539.2620154-1-keescook@chromium.org>
 <20200807063539.2620154-2-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200807063539.2620154-2-keescook@chromium.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 06, 2020 at 11:35:38PM -0700, Kees Cook wrote:
> The only-root-readable /sys/module/$module/sections/$section files
> did not truncate their output to the available buffer size. While most
> paths into the kernfs read handlers end up using PAGE_SIZE buffers,
> it's possible to get there through other paths (e.g. splice, sendfile).
> Actually limit the output to the "count" passed into the read function,
> and report it back correctly. *sigh*

Ugh, never thought about that...

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
