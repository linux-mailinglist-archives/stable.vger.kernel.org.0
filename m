Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D3171D544A
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 17:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgEOPWd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 11:22:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:55122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726228AbgEOPWd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 May 2020 11:22:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67F7620671;
        Fri, 15 May 2020 15:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589556152;
        bh=wsv23970vKHia1f7NewHkg9xFeiEC6PuURPqk9OMT3A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3UmKDv/RSN1r5kG8xHL+W+609JjO/AUnBdiRSacbhrZHAOe0wJraIe4GdbBxxHSj
         85cI1M7/VlNoM/uiRlsiQOKoTWpZteX+G3Ad8vt97Ztq0Z/+pulXZccu09P/mzfNU4
         BN/MrEjVLih2nEZy/0fJN7fA9tyGv2LH7Aanv/aM=
Date:   Fri, 15 May 2020 17:22:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Siddharth Chandrasekaran <csiddharth@vmware.com>
Cc:     srostedt@vmware.com, stable@vger.kernel.org, srivatsab@vmware.com,
        siddharth@embedjournal.com, dchinner@redhat.com,
        darrick.wong@oracle.com, srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] Backport xfs security fix to 4.9 and 4.4 stable trees
Message-ID: <20200515152230.GA2599290@kroah.com>
References: <cover.1589544531.git.csiddharth@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1589544531.git.csiddharth@vmware.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 08:41:07PM +0530, Siddharth Chandrasekaran wrote:
> Hello,
> 
> Lack of proper validation that cached inodes are free during allocation can,
> cause a crash in fs/xfs/xfs_icache.c (refer: CVE-2018-13093). To address this
> issue, I'm backporting upstream commit [1] to 4.4 and 4.9 stable trees
> (a backport of [1] to 4.14 already exists).
> 
> Also, commit [1] references another commit [2] which added checks only to
> xfs_iget_cache_miss(). In this patch, those checks have been moved into a
> dedicated checker method and both xfs_iget_cache_miss() and
> xfs_iget_cache_hit() are made to call that method. This code reorg in commit
> [1], makes commit [2] redundant in the history of the 4.9 and 4.4 stable
> trees. So commit [2] is not being backported.
> 
> -- Sid
> 
> [1]: afca6c5b2595 ("xfs: validate cached inodes are free when allocated")
> [2]: ee457001ed6c ("xfs: catch inode allocation state mismatch corruption")
> 
> change log:
> v2:
>  - Reword cover letter.
>  - Fix accidental worong patch that got mailed.

As the XFS maintainers want to see xfstests pass with any changes made,
have you done so for the 4.9 and 4.4 trees with this patch applied?

thanks,

greg k-h
