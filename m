Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5263199697
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 14:32:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730437AbgCaMcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 08:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:58144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730760AbgCaMcT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 08:32:19 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F82220675;
        Tue, 31 Mar 2020 12:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585657938;
        bh=7loumAm3kmhSpsdOIcJBHUWzkc8jtfOGOr7n6sGyhfw=;
        h=Date:From:To:Subject:From;
        b=p0kJ8dUHna7p4arS36bbC4dZRVC3koticP/sQYimTUavrXZ7Bwk+t4s/AHLVTAcMt
         hHJOLzgWda5DP8XN2/0mcvrEUav9Sh6HK3vgFlLLfNzIIUcsHz2JANkQRAIBuz5dSz
         KdlGe70odviMflB5TrwR0fgcLLtcxwkgrOXYC2HA=
Date:   Tue, 31 Mar 2020 08:32:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Backport dependencies helper
Message-ID: <20200331123217.GM4189@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

I wanted to share a resource I've been using to help me with doing
backports to various stable kernels.

In the Stable Kernel world, when we need to backport a patch, we'd
rather take any relevant dependencies to make the patch work cleanly on
an older kernel, rather than modifying the patch and diverging from
upstream.

This raises an interesting problem: how do we figure out which other
patches might be "interesting" to look at? git-blame is a great tool,
but it takes a while to go through the history of a patch, and given the
volume of patches we need to look at, it just isn't enough.

So here's a tool in the form of a git repo that can help point out these
interesting patches:

        https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/

How does it work, you might ask? It's actually quite simple: Each
directory represents a kernel version which we'll call K, and each file
inside that directory is named after an upstream commit we'll call C,
and it's content are the list of commits one would need to apply on top
of kernel K to "reach" commit C.

For example, let's say we want to apply:

        f8788d86ab28 ("Linux 5.6-rc3")

On top of the v5.5 kernel tree. All we need to do is:

        $ cat v5.5/f8788d86ab28f61f7b46eb6be375f8a726783636
        f8788d86ab28 ("Linux 5.6-rc3")
        11a48a5a18c6 ("Linux 5.6-rc2")
        bb6d3fb354c5 ("Linux 5.6-rc1")

If you don't feel like cloning the repo (which contains quite a few
files), you can also use kernel.org's web interface in a script that
might look something like this:

        #!/bin/bash
        curl https://git.kernel.org/pub/scm/linux/kernel/git/sashal/deps.git/plain/$1/$2

And then simply:

        $ ./deps.sh v5.5 f8788d86ab28f61f7b46eb6be375f8a726783636
        f8788d86ab28 ("Linux 5.6-rc3")
        11a48a5a18c6 ("Linux 5.6-rc2")
        bb6d3fb354c5 ("Linux 5.6-rc1")

Caveats:

 - Each file is limited to 50 entries. I feel that at that point it
   stops being useful.
 - Each file stops if a merge commit is hit.
 - I might have bugs in my scripts and some entries are broken, please
   report those if you see them.

-- 
Thanks,
Sasha
