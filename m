Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA1349440C
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 01:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230295AbiATAPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 19:15:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357655AbiATAPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 19:15:45 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75950C061574
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 16:15:45 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id r65so9077070ybc.11
        for <stable@vger.kernel.org>; Wed, 19 Jan 2022 16:15:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=vqB9iAU9Xq8VapOGNAY+XjZSz4Vf+X9jFOMw2lhUkLY=;
        b=QmmAQIRC3yjjpgn0zlODllGsc9bsnAah2PJ+2PQwD+mCtbXR5pW6NqmpqKaCbuRb55
         7rU9nirnNxVnTtRvxaijfO0R5t8glKIe7wI0EVxh8kiXIndAe3x1LWCKlnSx9Prd+ti1
         wy9o2bjZTUD1jcnQELsHbAit+Y3rFEKPcpbfg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=vqB9iAU9Xq8VapOGNAY+XjZSz4Vf+X9jFOMw2lhUkLY=;
        b=b7wSZY2jCDJv3cBNIDpZvvYpZE8TuR3LttLCb7tWpJ+4F0FgB0Ivs1UZOzvce7xpPv
         lDT8O9tlVWdSHd24Q7kiv8javQPVToZN0rBDyKSeWpHNXCBvpVhaMFtPEZSE/60+Yb2m
         HNj4MgwquBh0RZh8KlWRsHDEVYZGurX02BdiTaZce4IoanTskeHY0hQb0nWBB6PLNcl/
         WO5jA1l1wLlp66j//EVQpgObarHnXwO7vziNFgdzFhaLu0K9anuG29zEvbHfpVV5GisS
         6biDNZWS62arjsCGLb1LDNfMhiTPYcF1WrFHJb6BW1imjCQUr8qW4fP97bMhtpadyIIg
         DJbQ==
X-Gm-Message-State: AOAM530x2j+gZD/vRgQEuiRH8VAYgXiVkfFVaU9xzOpEHOAgaUv9KVGt
        3D2UcFAvJHLJBLRDpgIUSFU7mgLG6Kg25xYjYMzACNejbMPuOQ==
X-Google-Smtp-Source: ABdhPJywvv5oYywzYzmG4Eo7tReEkmwlZFlc81LCRSGw7rA0bDYB2gH40+2TimPqIE9xCxjRrfGQwYK+PVBzR0Ii0Mg=
X-Received: by 2002:a25:880e:: with SMTP id c14mr12305836ybl.158.1642637744580;
 Wed, 19 Jan 2022 16:15:44 -0800 (PST)
MIME-Version: 1.0
From:   Ivan Babrou <ivan@cloudflare.com>
Date:   Wed, 19 Jan 2022 16:15:34 -0800
Message-ID: <CABWYdi28yMU2YbJGKvPb91HR7yYAEyq3Zg6QeeBUk3KwjiyTMg@mail.gmail.com>
Subject: Backport memcg flush improvements into 5.15
To:     stable@vger.kernel.org
Cc:     Shakeel Butt <shakeelb@google.com>,
        kernel-team <kernel-team@cloudflare.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

We've seen a significant perf degradation when reading a tmpfs file
swapped into zram between 5.10 and 5.15. The source of the issue is:

* aa48e47e3906: memcg: infrastructure to flush memcg stats

There's a couple of commits that helps to bridge the gap in 5.16:

* 11192d9c124d: memcg: flush stats only if updated
* fd25a9e0e23b: memcg: unify memcg stat flushing

Both of these apply cleanly and Shakeel (the author) has okayed the
backport from his end. He also suggested backporting the following:

* 5b3be698a872: memcg: better bounds on the memcg stats updates

I personally did not test this one, but it applies cleanly, so there's
probably no harm. I cc'd Shakeel in case you want confirmation on
that. It's not a part of any tag yet.

Please backport all three (or at least the first two) to 5.15 LTS.

Thanks!
