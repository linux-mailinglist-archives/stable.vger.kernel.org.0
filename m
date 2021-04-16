Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 099DF362211
	for <lists+stable@lfdr.de>; Fri, 16 Apr 2021 16:21:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244635AbhDPOVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Apr 2021 10:21:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244572AbhDPOVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Apr 2021 10:21:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 224B9610F7;
        Fri, 16 Apr 2021 14:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618582853;
        bh=Gh03nu1A4faVx9WK16Fm5FUCgtttHSKTiGQDwRd0pFI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ebDClTzgDAXny047rDzef+hjYktXjBqrsIU2q09TqVpyK17wAxQbfrBtXXYz15Khz
         eVeebfHc4r6CNGovYMD/17o/kZCJyIy+ML1FSelX+WZTEq1I9IlB48sDTBG4NpzJMM
         c3u2D7OYaegEyY/4vJ0o09IL2fwHH1XkQsy26Qa4m7XkPwcSWQJ/jynypCglmd8G+T
         YubpHWITySRfi3zFnnpdi5YdAD6CTuQoJqmGYgMuGWAquJNSEAYkZlgkOtkN1yeOzr
         Rcrp6JEbODua6SgBTV0RuYB3kM+9hy8iv7BO3O1zLz+550nIwVzKSeB9/nY99Z6HW4
         2eZUwac88JimQ==
Date:   Fri, 16 Apr 2021 10:20:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Anastasia Kovaleva <a.kovaleva@yadro.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        kernel-team@lists.ubuntu.com, linux@yadro.com
Subject: Re: [PATCH for-5.4 0/2] scsi: qla2xxx: Fix P2P mode
Message-ID: <YHmdRKaxSoKwbzZH@sashalap>
References: <20210415195144.91903-1-a.kovaleva@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210415195144.91903-1-a.kovaleva@yadro.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 15, 2021 at 10:51:42PM +0300, Anastasia Kovaleva wrote:
>Hi Greg and Sasha,
>
>QLogic FC adapters don’t work in P2P mode on the latest stable 5.4 (at least
>QLE2692, and QLE2694, QLE2742 are affected).
>
>We’ve tested and bisected from 5.4 up to 5.4.112 and figured out the
>following: 
>
>1. From 5.4 to 5.4.5 inclusively direct mode doesn’t work at all.
>
>   Stable commit a82545b62e07 ("scsi: qla2xxx: Change discovery state before
>   PLOGI") fixes the issue in 5.4.6
>
>2. From 5.4.6 to 5.4.68 inclusively direct mode works but FC link cannot be
>   recovered after issue_lip and all presented LUNs are lost
>
>   Not working issue_lip is an outcome of a82545b62e07 applied to stable
>   without the upstream commit 65e920093805 ("scsi: qla2xxx: Fix device connect
>   issues in P2P configuration.").
>
>3. From 5.4.69 up till now (5.4.112) direct mode doesn’t work again
>
>   The issue was introduced by stable commit 74924e407bf7 ("scsi: qla2xxx:
>   Retry PLOGI on FC-NVMe PRLI failure").
>
>   Upstream commit 84ed362ac40c ("scsi: qla2xxx: Dual FCP-NVMe target port
>   support") fixes the issue.
>
>So, in order to fix both P2P issues we need to apply upstream commits
>65e920093805 and 84ed362ac40c.

That's a great analysis, thank you.

>However, stable commits 0b84591fdd5e ("scsi: qla2xxx: Fix stuck login session
>using prli_pend_timer") introduced in 5.4.19 and 74924e407bf7 ("scsi: qla2xxx:
>Retry PLOGI on FC-NVMe PRLI failure") in 5.4.69 were applied in the wrong
>order, upstream and chronological-wise with regards to required upstream fixes,
>and cherry-picking of the fixes is not possible without a merge conflict.

Right, in particular: 74924e407bf7 ("scsi: qla2xxx: Retry PLOGI on
FC-NVMe PRLI failure") was modified to work around missing 84ed362ac40c
("scsi: qla2xxx: Dual FCP-NVMe target port support"), which is where the
rest of the conflicts are coming from.

>The series provides merge conflict resolution and resolves both P2P discovery
>and issue_lip issue. It has been tested over Linux stable 5.4.112 and
>Ubuntu 20.04 kernel 5.4.0-71.79 (that's based off stable 5.4.101).
>
>Please apply at your earliest convenience to 5.4 stable.

So instead of applying even more modified patches that'll create similar
issue in the future, I backed up 0b84591fdd5e and 74924e407bf7, and
applied the 4 commits you've pointed out in the "correct" order. I also
grabbed 27258a577144 ("scsi: qla2xxx: Add a shadow variable to hold
disc_state history of fcport") for completeness.

Thanks for diagnosing this issue! Please let me know if something is
still broken.

-- 
Thanks,
Sasha
