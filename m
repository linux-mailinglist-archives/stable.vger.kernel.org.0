Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D511183E08
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 01:58:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726895AbgCMA6f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 20:58:35 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37635 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbgCMA6e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Mar 2020 20:58:34 -0400
Received: by mail-pg1-f196.google.com with SMTP id a32so3098164pga.4;
        Thu, 12 Mar 2020 17:58:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w2dJvjqoKaCtDbJSbP6GfunKVqsuAQLMGA6TusRI3Wg=;
        b=c/xE1nEGVu2X1lDgqT8UkwcPolQfeZcjJ0bAB4B19OOzOqxC3cFdJv2hGERPprzl3y
         14TJs4reJsVoTInnGFG24YSfMD7qaDpCZAejmgG9pyAldag1QGfzMI6BSWh0TON7uKAD
         sOa0EH59+ySAoDM+TPovVHFMBCB2trUfdMTm5we7H9xzYtFvjjs3xGtn0eoVowMOW9ny
         fw4o07fSHvRpTpFZo5uWYBEDN0Pmdchrequkn1gH3tGNUE4KOvy5qXOFk9rfV4U5e5ln
         /JFUI2si040GswDyxSlmuFowszh8SPqrpfW8AVX1keNfr2TC57rR+aHCUiQZsqwMssRu
         AVxA==
X-Gm-Message-State: ANhLgQ0ZGz8fQGVZ3u/OA3x6W0K5zx308/bN6neR34Ue03QVome9Fhkd
        1VXH+cNFSWwv1cLO8QfpwXyNuM7b3Mk=
X-Google-Smtp-Source: ADFU+vtWUix6nYJK2rz2o2/xQxYRepdItn+tkMt206rx3HLLDhOKIdDLRVknWVyQQDA/duk96z7vFw==
X-Received: by 2002:a63:a807:: with SMTP id o7mr10087694pgf.407.1584061113397;
        Thu, 12 Mar 2020 17:58:33 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id x12sm45523818pfi.122.2020.03.12.17.58.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 17:58:31 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 2B1244028E; Fri, 13 Mar 2020 00:58:31 +0000 (UTC)
Date:   Fri, 13 Mar 2020 00:58:31 +0000
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>, NeilBrown <neilb@suse.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH v2 2/4] fs/filesystems.c: downgrade user-reachable
 WARN_ONCE() to pr_warn_once()
Message-ID: <20200313005831.GR11244@42.do-not-panic.com>
References: <20200312202552.241885-1-ebiggers@kernel.org>
 <20200312202552.241885-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312202552.241885-3-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 01:25:50PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> After request_module(), nothing is stopping the module from being
> unloaded until someone takes a reference to it via try_get_module().
> 
> The WARN_ONCE() in get_fs_type() is thus user-reachable, via userspace
> running 'rmmod' concurrently.
> 
> Since WARN_ONCE() is for kernel bugs only, not for user-reachable
> situations, downgrade this warning to pr_warn_once().
> 
> Cc: stable@vger.kernel.org
> Cc: Alexei Starovoitov <ast@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Jeff Vander Stoep <jeffv@google.com>
> Cc: Jessica Yu <jeyu@kernel.org>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Luis Chamberlain <mcgrof@kernel.org>
> Cc: NeilBrown <neilb@suse.com>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Acked-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
