Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3308B2F8698
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 21:23:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbhAOUXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 15:23:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731529AbhAOUXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jan 2021 15:23:05 -0500
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAC7BC061757;
        Fri, 15 Jan 2021 12:22:24 -0800 (PST)
Received: by mail-qt1-x82e.google.com with SMTP id v5so6968580qtv.7;
        Fri, 15 Jan 2021 12:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMf/40ZOBursAcunQbNmwliT9GLzVostWCpfGDtK61s=;
        b=r4HR8iICuMdp2jfdiVmjAzp+pkoLhnv4i1xsKfoO51eTUIkYMhUWDw/gNZvJsf4aB5
         7WyWXScXOaX8gPCAYN4gvzwgC2ojlgiHflOW6Grlik3KPtnJt9FjFcOhLb3Iv89h+WMK
         Cgoc+OWYzjBnAt6odVF+IJw8vgNjJG7qv1TieWSsySuke2x/lw0XKLyyKAE7W7xJMUOo
         CZ7BT8hzl5K6PdVNLT3+QvdeNJI1dqx1YV1NzQOEKzOBUl+nP7gIXGVq8wpKU+G5oKS0
         O0nagHnNw883bdfHDtMPqFysbfkq9ftGZ9tllPnRnLsFixKJ5EduwujhU8/SPkvmWEK+
         xwwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMf/40ZOBursAcunQbNmwliT9GLzVostWCpfGDtK61s=;
        b=l6AWWk7CFDR9e+Jf9WA3Yt2Ieu6raNtDUWAWkYGi0i8O+Jud9mq7Qn95ZzpamW4Az3
         A8yYuPnNG7H1dkeU3y1erjcKTjq9X35aSKZTJogiDMrezBWdcCtJRhpc0zc8aKztNyC8
         vITO2UramwqB9xzyAmAv+WuU+rnu8/czA9IQIxv2+Doq2useaIQCA7xBRXdjRo0atyod
         FNla4HcIvPFWjQZ17u/XpixIJwQVOxgr+rrp0mH8V5jZS8fqv2d57Toq6hdfZ5vOx+an
         x1MJySakOkDEq0guNH07hTLyP7G6BiN9J9isymEvYhVIaqy72iIJ6Umh7+wVSFdy9Ipt
         +zXw==
X-Gm-Message-State: AOAM530JpaY3oMDYoCMvKIAvYwO5tE0cCU28voGDk8T5Ksro4dlVcQfp
        nVdOI8W7ePIwgrK2Sd7MzhY7ul56yR8=
X-Google-Smtp-Source: ABdhPJwiK/LKljooy9WTXnSxp/hPmhNuv86f9XMBQNXb+ZcubA6dmSWaoZ41flxNmq+81cYavt62SA==
X-Received: by 2002:aed:23d6:: with SMTP id k22mr13752718qtc.226.1610742143863;
        Fri, 15 Jan 2021 12:22:23 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id 38sm3268337qtb.67.2021.01.15.12.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jan 2021 12:22:23 -0800 (PST)
Date:   Fri, 15 Jan 2021 13:22:21 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaolei Wang <xiaolei.wang@windriver.com>,
        Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.10 086/103] regmap: debugfs: Fix a memory leak when
 calling regmap_attach_dev
Message-ID: <20210115202221.GA209258@ubuntu-m3-large-x86>
References: <20210115122006.047132306@linuxfoundation.org>
 <20210115122010.175920983@linuxfoundation.org>
 <20210115201819.GA8375@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210115201819.GA8375@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 15, 2021 at 09:18:19PM +0100, Pavel Machek wrote:
> Hi!
> 
> > From: Xiaolei Wang <xiaolei.wang@windriver.com>
> > 
> > commit cffa4b2122f5f3e53cf3d529bbc74651f95856d5 upstream.
> > 
> > After initializing the regmap through
> > syscon_regmap_lookup_by_compatible, then regmap_attach_dev to the
> > device, because the debugfs_name has been allocated, there is no
> > need to redistribute it again
> 
> ? redistribute?
> 
> Anyway, this patch is clearly buggy:
> 
> >  
> >  	if (!strcmp(name, "dummy")) {
> > -		kfree(map->debugfs_name);
> > +		if (!map->debugfs_name)
> > +			kfree(map->debugfs_name);
> >  
> 
> It runs kfree only if the variable is NULL. That's clearly useless,
> kfree(NULL) is NOP, and this causes memory leak.

Fixed by commit f6bcb4c7f366 ("regmap: debugfs: Fix a reversed if
statement in regmap_debugfs_init()") in mainline.

Cheers,
Nathan
