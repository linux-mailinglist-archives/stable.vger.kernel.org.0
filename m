Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6ED189FE2
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 16:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726671AbgCRPnV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 11:43:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:52132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726619AbgCRPnV (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 11:43:21 -0400
Received: from linux-8ccs (p5B2812F9.dip0.t-ipconnect.de [91.40.18.249])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6E68020767;
        Wed, 18 Mar 2020 15:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584546200;
        bh=iwK9ZIuWxFVtXKqXUS7isMl/puS748Mh/G1D0GM208U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ATXEubSqnLJ5zf8IFuO1isXZFmKsEpiFUZfSxQ5nQoKKboxQYN7cIcfVdhvfgIw6P
         +MJE06SKNCMx/NQle3Vfy7CgPW7giKLPCClA5P+/St5G8r4OiLVdJHxMoGijU7GMH9
         VtxYe0MeSI37shj0sqFXTGe9c+HA2NbWkeHWet5Y=
Date:   Wed, 18 Mar 2020 16:43:15 +0100
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
Subject: Re: [PATCH v3 2/5] fs/filesystems.c: downgrade user-reachable
 WARN_ONCE() to pr_warn_once()
Message-ID: <20200318154315.GB4144@linux-8ccs>
References: <20200314213426.134866-1-ebiggers@kernel.org>
 <20200314213426.134866-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200314213426.134866-3-ebiggers@kernel.org>
X-OS:   Linux linux-8ccs 4.12.14-lp150.12.61-default x86_64
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

+++ Eric Biggers [14/03/20 14:34 -0700]:
>From: Eric Biggers <ebiggers@google.com>
>
>After request_module(), nothing is stopping the module from being
>unloaded until someone takes a reference to it via try_get_module().
>
>The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
>running 'rmmod' concurrently.
>
>Since WARN_ONCE() is for kernel bugs only, not for user-reachable
>situations, downgrade this warning to pr_warn_once().
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
>---
> fs/filesystems.c | 4 +++-
> 1 file changed, 3 insertions(+), 1 deletion(-)
>
>diff --git a/fs/filesystems.c b/fs/filesystems.c
>index 77bf5f95362da..90b8d879fbaf3 100644
>--- a/fs/filesystems.c
>+++ b/fs/filesystems.c
>@@ -272,7 +272,9 @@ struct file_system_type *get_fs_type(const char *name)
> 	fs = __get_fs_type(name, len);
> 	if (!fs && (request_module("fs-%.*s", len, name) == 0)) {
> 		fs = __get_fs_type(name, len);
>-		WARN_ONCE(!fs, "request_module fs-%.*s succeeded, but still no fs?\n", len, name);
>+		if (!fs)
>+			pr_warn_once("request_module fs-%.*s succeeded, but still no fs?\n",
>+				     len, name);

Hm, what was the rationale for warning only once again? It might be useful
for debugging issues to see each instance of request_module() failure
(and with which fs). However, I don't have a concrete use case to
support this argument, so:

Reviewed-by: Jessica Yu <jeyu@kernel.org>
