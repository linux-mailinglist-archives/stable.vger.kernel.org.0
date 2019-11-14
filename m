Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7C2DFCECE
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 20:37:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726444AbfKNThk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 14:37:40 -0500
Received: from mail-qt1-f195.google.com ([209.85.160.195]:34682 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbfKNThk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 14:37:40 -0500
Received: by mail-qt1-f195.google.com with SMTP id i17so8123506qtq.1;
        Thu, 14 Nov 2019 11:37:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NaPLGFJxVcxgMv19Az2//JUge4Ox1fZnZEYyYhMIrvQ=;
        b=ENcQLJlD7NyKjL4MhLTtu6qmWQBoZX2ZbVzbI6gs1a5r58sbqecrjnHvXwJxl0rNDG
         s279UAsU35aOF6fL5X0plcg17peUXu2eWl3fEr7AnIPzNuD6vhy6+JASUlFyIDl1A75x
         hYafS7hrCW2I9Tfv65/P2zBW+iAP7E+8qBq2wyWoFs5l6XYU1oAbdfGjK9HLpc4nxahY
         qkY1XrfbEhOf5v1ODQD9vzo4h0vrZqPHM/zzo9pKbAgukQUQniSiJdPU6+ArsE65PAvy
         UAzb9sB5hT3dOXQcuuyKKJkV3QEn8690LrMp6yeDSRycq07Puyhu3s7v29FMc+2VEUE5
         6GDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=NaPLGFJxVcxgMv19Az2//JUge4Ox1fZnZEYyYhMIrvQ=;
        b=R76EOmXfrqKTCXYkQk1fQGyvDhPiTsARsUv2rdPv4VOTO+GOXIWxIa/tgvRR+xfu3D
         MjlPTqVpBg9poT7V41fzuHK/izIZzf0cXmQ4k0B2+GWkewg1wvDu4oMiesY0N26v4ocl
         RRPEfGAAQrkYW3gUxItMHII6VfawfA71yM+4Tkxwj6lNoOC7ZldMrcNa6ST3fdwvpTZs
         AxC7Elvlt9Lg6RWGjvc+gatPNzhkRsaQ+sVA+u5WNdPs4f4Tb/xdfvW5C1NvyV0LpmXk
         24VLKnvOXDA4ZnlxUVTBEPAgVvERQ+CFEfrU64pc7tBzFofIOC0f8Vdq8TLBrqnXGvkw
         oV2Q==
X-Gm-Message-State: APjAAAVs7k4xIYHT8tfThu9rEUyp/Gvna48gaunmafdHUrno6b4VeW4H
        dWUzqoliWiw54DJiisCXt1w=
X-Google-Smtp-Source: APXvYqxT7G8AToZXHz14LxnBAYjHU/Qt6IRoHOBggDxGPJxNQ/IOqepe9ojGzA8OxASeKgRE8f6g7g==
X-Received: by 2002:ac8:89c:: with SMTP id v28mr10058337qth.156.1573760258727;
        Thu, 14 Nov 2019 11:37:38 -0800 (PST)
Received: from localhost ([2620:10d:c091:500::2:69f2])
        by smtp.gmail.com with ESMTPSA id n62sm3002863qkn.47.2019.11.14.11.37.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Nov 2019 11:37:38 -0800 (PST)
Date:   Thu, 14 Nov 2019 11:37:36 -0800
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
Message-ID: <20191114193736.GL4163745@devbig004.ftw2.facebook.com>
References: <20191106225131.3543616-1-guro@fb.com>
 <20191113162934.GF19372@blackbody.suse.cz>
 <20191113170823.GA12464@castle.DHCP.thefacebook.com>
 <20191114191657.GN20866@dhcp22.suse.cz>
 <20191114192018.GJ4163745@devbig004.ftw2.facebook.com>
 <20191114193340.GA24848@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191114193340.GA24848@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

On Thu, Nov 14, 2019 at 08:33:40PM +0100, Michal Hocko wrote:
> > It is useful for controlling admissions of new userspace visible uses
> > - e.g. a tracepoint shouldn't be allowed to be attached to a cgroup
> > which has already been deleted.
> 
> I am not sure I understand. Roman says that the cgroup can get offline
> right after the function returns. How is "already deleted" different
> from "just deleted"? I thought that the state is preserved at least
> while the rcu lock is held but my memory is dim here.

It's the same difference as between "opening a file and deleting it"
and "deleting a file and opening it".  We shoud allow the former while
not allowing the latter.

> > We're just using it too liberally.
> 
> Can we get a doc update to be explicit about sensible usecases so that
> others can be dropped accordingly? 

Yeah, we should audit and convert the uses and update the doc.

Thanks.

-- 
tejun
