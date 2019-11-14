Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E5D0FCEA4
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 20:20:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfKNTUW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 14:20:22 -0500
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33216 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbfKNTUW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 14:20:22 -0500
Received: by mail-qk1-f196.google.com with SMTP id 71so6035049qkl.0;
        Thu, 14 Nov 2019 11:20:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Ad+hImqgLDxypIEINMZpS4Tr/4Mgv7yIFC4Nbt2V9kg=;
        b=byTtSXKQQYePQfHDLVfvtbTfxb+feN2Rw10WG0dnLqlQHjnp6ZqhpFGPYiTJtn9lDD
         6SrXLdyjN+S+8zKLupJ0J6AOFKhKFCdKMEB0XC3KSHz3eaXrxnWfHgS8f5fTJbaHzaBw
         nICTABqMxTHdOrmtN6iofLY9mxUzOMb2zmHAp8FT4UsTjOojgCJymb3q1NuHBdnFW9Li
         Uiq6x+NEu+2qVNn+pQXfevOoGLxsvDTu+ti1pPhty9u+5ujN/s/K1Sb/phspRfgXDRWZ
         9oZChaZKJI2FU49/FO/+OCDXzbOaw5PJmWhv/qzB+P/UWgcL+2sDK8CpqPNYJ0QyXAJ6
         Y2bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=Ad+hImqgLDxypIEINMZpS4Tr/4Mgv7yIFC4Nbt2V9kg=;
        b=OpZ4/sLy29V0A8WrBiqJX2o7GbQRG/vn6JNLB0Eg8jbnbTUYW2Dma7M3JZT9gL9Ud8
         eI6TD3238UW2bgmz7WdOnV/+f0jowrZUL1kiXaK1NQqJPdzUkhjV2D5yGLvRCqbnBkIx
         61wcs7DHF3BRUKpxtEgDBBavp56kKIr7e7gk1LNl9jpbbCg8CTHm7HN5x3lgD+U776gg
         Ri2LeTdNjvxUW74TPh8wCcKnkyDZWDMFyn4RZvEmG9FwTEZKwW4nkt9G4Uz/ESeYymTH
         5spH9spU1Cr8eHF3cgMR+MYT6oPOpl96SvvXR9Ztq723E4aIn+pAYHCsbRVDpoqWtJx6
         jdeQ==
X-Gm-Message-State: APjAAAWVtNd/wqUIZu8b2AI+6/MIVh8ULzFe/zO75IV7uGvB0s8rkrYt
        tGSO1y6kym7k/Q5vRmFrtT8=
X-Google-Smtp-Source: APXvYqxOQ9m72MaS9qncxYQiHkIHq6EHGB9gkSaUGXeDTWotePoS+TGDokUWUtCHpKn4SSzGsUSXEg==
X-Received: by 2002:ae9:eb94:: with SMTP id b142mr9178344qkg.450.1573759221143;
        Thu, 14 Nov 2019 11:20:21 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:69f2])
        by smtp.gmail.com with ESMTPSA id h25sm2893772qka.117.2019.11.14.11.20.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 11:20:20 -0800 (PST)
Date:   Thu, 14 Nov 2019 11:20:18 -0800
From:   Tejun Heo <tj@kernel.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Roman Gushchin <guro@fb.com>,
        Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH 1/2] mm: memcg: switch to css_tryget() in
 get_mem_cgroup_from_mm()
Message-ID: <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114191657.GN20866@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Thu, Nov 14, 2019 at 08:16:57PM +0100, Michal Hocko wrote:
> Then what is the point of this function and what about all other users?

It is useful for controlling admissions of new userspace visible uses
- e.g. a tracepoint shouldn't be allowed to be attached to a cgroup
which has already been deleted.  We're just using it too liberally.

Thanks.

-- 
tejun
