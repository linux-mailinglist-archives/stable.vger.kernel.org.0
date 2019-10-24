Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451DDE3BCB
	for <lists+stable@lfdr.de>; Thu, 24 Oct 2019 21:08:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392857AbfJXTIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Oct 2019 15:08:19 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46737 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390450AbfJXTIT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Oct 2019 15:08:19 -0400
Received: by mail-qk1-f193.google.com with SMTP id e66so24446690qkf.13;
        Thu, 24 Oct 2019 12:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=cygSBSpbxOoz5DLta9pK9Fq8puzT/3arKPoGzp7XpzU=;
        b=uE+qV49XGr9hRYWnRoYqjv9vLqOEO1EcgYE+0tCeTsALBbePUu/hwpaNU4ffUZ1NWA
         LTbQ4vzlv66zSjjBMKaJ22ZpO41SzamYUkbAF1UiGVQXGodtZ8gRY00PAoOZ7T+kjEDm
         MNuWp+B01XnRIt2dTdeAK5ItWsPfeeaKands4plWQeR4KAH2ocQDPnyZbOTI/gPUEzDG
         9StD8w+esdZ8V5yFJXKy0JOZHNucUcWOB82VPa/e3kGsA6HhDh5hW4/hGxppi6z4t3tA
         Aw953Z+iso0hlCo9AlAkPMOP6zR+BtWewsRS2irIZONjwFIxBeDsV+ZkYZbuei8Whmzz
         F+Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=cygSBSpbxOoz5DLta9pK9Fq8puzT/3arKPoGzp7XpzU=;
        b=EWtHkWs7s1m98RKsUxcG3iVn/2stasPcDyAv5d2xUKfbZX4lY2IN63TX3gHUr0XXao
         0/LzeKCzJjNEIN14tc0nZf/ZjrDTZg4+bqgE3gD9fE1Y2s8oz6zFr16xFhQROdcQKNS8
         3qyKOwiI37vXXIcrV+Q4C4sHHQ8VHmxY/xjbsR8taznzokMsKu1RfphvkHVIg7FahDoJ
         G+ae30KSxYwaML660PqypZzGRWzPXP9GZqPxuH7lR5dXCti4gCgklUvBUwCz/hLEmor6
         xdrbYifFBZCGhvDW/O1RbJ6HaG9wBBZylNjSIGTASD4ZIBhOgBE96nfQWKGLYaFUf0qZ
         aDCg==
X-Gm-Message-State: APjAAAWHUvTuYhnG96Rgq4gLoIh0VSuxcba4BobGpdb3beO8wAoN8GU0
        wK5CR8UATbPBm7oSfnS27d8=
X-Google-Smtp-Source: APXvYqyUYYXXkr0LH1H3OtchLwpaqY+XCadnSUP+BdTePoYf4EQhtXfgOCR2J+7JMMs9bXVaQIg1rQ==
X-Received: by 2002:ae9:e513:: with SMTP id w19mr8115731qkf.308.1571944097904;
        Thu, 24 Oct 2019 12:08:17 -0700 (PDT)
Received: from localhost ([2620:10d:c091:500::3:b2e])
        by smtp.gmail.com with ESMTPSA id z5sm2247670qkc.136.2019.10.24.12.08.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 12:08:17 -0700 (PDT)
Date:   Thu, 24 Oct 2019 12:08:15 -0700
From:   Tejun Heo <tj@kernel.org>
To:     Aleksa Sarai <cyphar@cyphar.com>
Cc:     Li Zefan <lizefan@huawei.com>,
        Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] cgroup: pids: use atomic64_t for pids->limit
Message-ID: <20191024190815.GE3622521@devbig004.ftw2.facebook.com>
References: <20191016155001.13651-1-cyphar@cyphar.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016155001.13651-1-cyphar@cyphar.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 17, 2019 at 02:50:01AM +1100, Aleksa Sarai wrote:
> Because pids->limit can be changed concurrently (but we don't want to
> take a lock because it would be needlessly expensive), use atomic64_ts
> instead.
> 
> Fixes: commit 49b786ea146f ("cgroup: implement the PIDs subsystem")
> Cc: stable@vger.kernel.org # v4.3+
> Signed-off-by: Aleksa Sarai <cyphar@cyphar.com>

Applied to cgroup/for-5.5.

Thanks.

-- 
tejun
