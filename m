Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F37414340
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 10:09:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233383AbhIVILI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 04:11:08 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:38932 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233349AbhIVILI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 04:11:08 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id E70F422156;
        Wed, 22 Sep 2021 08:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1632298177; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1NPG4O+Jngi0bELwMcPJpHyS/p8bC72T2cOWGd3btpQ=;
        b=OxBaCGcDkobLlCSjXiT4d+DQHNDsxDAW9k/FQXYjAv+rr/+v/70PgCEjQUCWNrVvXqVn4f
        yYUQG3OCMI0MP+zzyhjdsPe0KyXOnfFHoa8j9RU2bAmQ33K9DWad10aOqHCf3AvuBp727J
        IocZeQsX1HEUCBQGnOXD9ODJXMiPbwE=
Received: from suse.cz (unknown [10.100.201.86])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 9F1CFA3B8D;
        Wed, 22 Sep 2021 08:09:37 +0000 (UTC)
Date:   Wed, 22 Sep 2021 10:09:37 +0200
From:   Michal Hocko <mhocko@suse.com>
To:     Vishnu Rangayyan <vishnu.rangayyan@apple.com>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fs: fix for core dumping of a process getting oom-killed
Message-ID: <YUrkwbQ9d6vvh0Ta@dhcp22.suse.cz>
References: <9aec4002-754c-ca6d-7caf-9de6e8c31dd7@apple.com>
 <YUm7LLqwrXygzKll@dhcp22.suse.cz>
 <216745b1-2d4c-8707-2403-07117e6b3bca@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <216745b1-2d4c-8707-2403-07117e6b3bca@apple.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue 21-09-21 20:12:08, Vishnu Rangayyan wrote:
> 
> 
> On 9/21/21 5:59 AM, Michal Hocko wrote:
[...]
> > Why
> > is fsync helping at all? Why do we need a new sysctl to address the
> > problem and how does it help to prevent the memcg OOM. Also why is this
> > a problem in the first place.
> The simple intent is to allow the core dumping to succeed in low memory
> situations where the dump_emit doesn't tip over the thing and trigger the
> oom-killer. This change avoids only that particular issue.

How does it avoid that?

> Agree, its not the actual problem at all. If the core dumping fails, that
> sometimes prevents or delays looking into the actual issue.
> The sysctl was to allow disabling this behavior or to fine tune for special
> cases such as limited memory environments.

Please note that any sysctl is an userspace API that has to be
maintained effectivelly for ever so there should be a very good reason
and a strong justification to add one. I do not see that to be case
here.

-- 
Michal Hocko
SUSE Labs
