Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDA084260A0
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 01:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbhJGXlM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Oct 2021 19:41:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhJGXlM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Oct 2021 19:41:12 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88CEC061755
        for <stable@vger.kernel.org>; Thu,  7 Oct 2021 16:39:17 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id x8so4937625plv.8
        for <stable@vger.kernel.org>; Thu, 07 Oct 2021 16:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=o7iYhngT6EUsnwzPgIE8puO2TS5bbFhNWdFl5HK0XII=;
        b=oCoaGS3AENT/TTmmuN9mwzD7VkM3Y/M8t5iR204KBfixaZDKNCOiTkF9sd5tMSyvSJ
         Bigp3+ki9agmFoUS+DdcPG3046a0Yc2EqZLSQFdb+/KG/wfq+Jb/7IpAHahgkTNk+2FO
         3TNy49BwZk87Z96vj0I6aUuAXyDBRNV24Vv1s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o7iYhngT6EUsnwzPgIE8puO2TS5bbFhNWdFl5HK0XII=;
        b=mBa7cTYS3ZvVOtsRO0RjvUKSh9V60BaM46bOJ1w+udp0N//iaPIeN9zCKbeU+NtoH+
         BIS5IlxUMT0sZ0XPsajZpSyOWNLMRZx61Zp5tZrl5KyBybwU7CrXXUEsSzGzEMqABLRM
         7gnt5PXJ3umL3rfAIRyqn8eRQOgUErl/Ci6thMTY6/XTfwpU32CLCUtaFuVKVbiIIfhN
         xfkHjq9hNECl6hqnOzzSlCGo8J8gniH0uJV3u78TwYhC1GAWtJsUsNjV0Tor7Ou/GhFh
         UdxIXLcyj9mziSKbfBly2E54ML1HBma025FHH1RBnZGh1qz9gOAPs7pIzlFxL9gOLVVP
         pmpA==
X-Gm-Message-State: AOAM5324fLIPtrD79FahY2a1I7w02/8SGt5jsQCMsiESCXkt8Nr0UU6W
        B+ApVmCfepV3DhVH0pdWOixEz2hxlBm4HA==
X-Google-Smtp-Source: ABdhPJzLWAN6yfiSKbwvI1guk4jWD39pWKOVImh67Z12NbMjIPFCqISJly4lLMCy85uWD3S83hq5tA==
X-Received: by 2002:a17:90b:3684:: with SMTP id mj4mr29734pjb.3.1633649957294;
        Thu, 07 Oct 2021 16:39:17 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h74sm447167pfe.196.2021.10.07.16.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Oct 2021 16:39:16 -0700 (PDT)
Date:   Thu, 7 Oct 2021 16:39:16 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Matthew Wilcox (Oracle)" <willy@infradead.org>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, Hao Sun <sunhao.th@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] vfs: Check fd has read access in
 kernel_read_file_from_fd()
Message-ID: <202110071639.1CBFCF1@keescook>
References: <20211007220110.600005-1-willy@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007220110.600005-1-willy@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 07, 2021 at 11:01:10PM +0100, Matthew Wilcox (Oracle) wrote:
> If we open a file without read access and then pass the fd to a syscall
> whose implementation calls kernel_read_file_from_fd(), we get a warning
> from __kernel_read():
> 
>         if (WARN_ON_ONCE(!(file->f_mode & FMODE_READ)))
> 
> This currently affects both finit_module() and kexec_file_load(), but
> it could affect other syscalls in the future.
> 
> Reported-by: Hao Sun <sunhao.th@gmail.com>
> Fixes: b844f0ecbc56 ("vfs: define kernel_copy_file_from_fd()")
> Cc: stable@vger.kernel.org
> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>

Reviewed-by: Kees Cook <keescook@chromium.org>

Thanks for chasing this down!

-- 
Kees Cook
