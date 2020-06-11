Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14701F6041
	for <lists+stable@lfdr.de>; Thu, 11 Jun 2020 05:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726279AbgFKDCy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Jun 2020 23:02:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbgFKDCr (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Jun 2020 23:02:47 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBCFFC08C5C4
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 20:02:45 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id h185so2031637pfg.2
        for <stable@vger.kernel.org>; Wed, 10 Jun 2020 20:02:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j3OsXPGIwi3xsUIwRgQitia7+o3C2dniHB1RcDZH3GE=;
        b=fcp7RrfiW9uA4z+tTFPju9m2g0v7xg/w/6Yv3TKyJpkvVw3AHi9F9bI1FqyDu6Hl9w
         GyfBNHCOgQCZw4f0JowTFQTL7UPNRXy+GlzrF7F/cvWtwqH6sFM7IejbWJFtmM65xNQl
         wwbn9ttjXIWQ8BBcanAOUT3ilxezqyytZ8NSI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=j3OsXPGIwi3xsUIwRgQitia7+o3C2dniHB1RcDZH3GE=;
        b=pL1CBOmuJR5iHBU4/lzUF94xZHvKSgpNF7QCvXRgR4ADVdNEwkjRXzctpF4CUUeEpH
         9I5lJFBETtTDwdQnohQCuF5lr+9EeIVNJtPj6Ah0rhI5oCyaalmC6Utlle+QRxTAdnb3
         hd0c6QH+oQelp/X7qEYeQ5vq7sNVxVnqQEnFrjntrCOYPOVE6h3eeaWzztnVypn0mk7z
         NAs0nxgHrsULIw29DJhaC4Mt4ZKEP83Qox2U8UYd9lRhwG5ncAFyDf3f+84IGgS+pvdh
         xOeZT9MPBEhlkNxfzpd+EijXMgCB3/XEFBbn83S4z40Xtzxdhb6s0jmfCvyAdxv9ivno
         ejxg==
X-Gm-Message-State: AOAM531FKnfTaN7A3qNUs5ZnAqE9iel9bujY9RCk+kwF2kQqMUxDBcA8
        amEdmLrsACRQ1XkhH9CfuI15hQ==
X-Google-Smtp-Source: ABdhPJzDdTSTxOnzWK9kQC66Yl7w/5oeeYdWeKvh7Jap0JIbbKbOBkew4C9KEtAnUyMtc31xZqAPJg==
X-Received: by 2002:a65:484c:: with SMTP id i12mr5034279pgs.267.1591844565164;
        Wed, 10 Jun 2020 20:02:45 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id nl8sm1059871pjb.13.2020.06.10.20.02.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2020 20:02:43 -0700 (PDT)
Date:   Wed, 10 Jun 2020 20:02:42 -0700
From:   Kees Cook <keescook@chromium.org>
To:     David Laight <David.Laight@ACULAB.COM>
Cc:     'Sargun Dhillon' <sargun@sargun.me>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        "containers@lists.linux-foundation.org" 
        <containers@lists.linux-foundation.org>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Robert Sesek <rsesek@google.com>,
        Chris Palmer <palmer@google.com>, Jann Horn <jannh@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Denton <mpdenton@google.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/4] fs, net: Standardize on file_receive helper to
 move fds across processes
Message-ID: <202006102001.E9779DFA5B@keescook>
References: <202006031845.F587F85A@keescook>
 <20200604125226.eztfrpvvuji7cbb2@wittgenstein>
 <20200605075435.GA3345@ircssh-2.c.rugged-nimbus-611.internal>
 <202006091235.930519F5B@keescook>
 <20200609200346.3fthqgfyw3bxat6l@wittgenstein>
 <202006091346.66B79E07@keescook>
 <037A305F-B3F8-4CFA-B9F8-CD4C9EF9090B@ubuntu.com>
 <202006092227.D2D0E1F8F@keescook>
 <20200610081237.GA23425@ircssh-2.c.rugged-nimbus-611.internal>
 <40d76a9a4525414a8c9809cd29a7ba8e@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40d76a9a4525414a8c9809cd29a7ba8e@AcuMS.aculab.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 10, 2020 at 08:48:45AM +0000, David Laight wrote:
> From: Sargun Dhillon
> > Sent: 10 June 2020 09:13
> In essence the 'copy_to_user' is done by the wrapper code.
> The code filling in the CMSG buffer can be considered to be
> writing a kernel buffer.
> 
> IIRC other kernels (eg NetBSD) do the copies for ioctl() requests
> in the ioctl syscall wrapper.
> The IOW/IOR/IOWR flags have to be right.

Yeah, this seems like it'd make a lot more sense (and would have easily
caught the IOR/IOW issue pointed out later in the thread). I wonder how
insane it would be to try to fix that globally in the kernel...

-- 
Kees Cook
