Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E86E01D555B
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 17:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgEOP7J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 May 2020 11:59:09 -0400
Received: from sender4-of-o53.zoho.com ([136.143.188.53]:21353 "EHLO
        sender4-of-o53.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbgEOP7J (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 May 2020 11:59:09 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1589558327; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=js7nHHp4RDiX2u7KG5XdzhlJJL9Syu4mTvwcqylefC4Yvi+ZSR/TyBkq57Dru5ekbWRDXVkwCN4zNmKfUyVQ3Ve61BlaISFzwVGBTmJzsg4qQG3YkTwPlpeJ0Ie5Xi3DgMRCuYkRGBWyv/inZNBnpMC4T3nMfO0POEyoLsNeoZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1589558327; h=Content-Type:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=i3Mm6W/KrRulKC5mcoHwCQYRpmn7OT2z0qAo4Y0yXKs=; 
        b=cX4pGE8hu/khb/2msut16tFTOS2EJLA4dhB0YtZxpeiD4kcun3MLxSJV30VTg/Tol3JAfFS98hTBMqrjT6i3ZjEuubcK2+fEseV2RPxDEHgMGtFmEls1wht9RcjHzzkvfBSkUuEBd5mhf9Q+Swujf1+6sL72NfTGHaVXaAV1BuI=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=embedjournal.com;
        spf=pass  smtp.mailfrom=siddharth@embedjournal.com;
        dmarc=pass header.from=<siddharth@embedjournal.com> header.from=<siddharth@embedjournal.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1589558327;
        s=zoho; d=embedjournal.com; i=siddharth@embedjournal.com;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:In-Reply-To;
        bh=i3Mm6W/KrRulKC5mcoHwCQYRpmn7OT2z0qAo4Y0yXKs=;
        b=ObhMCqdnsT/fJmONuJu2qVbEWDB45MCIRnqcDr0i5VcvSZM3ItYul4GnQm5Dk5bM
        2WdxCI2ypMwjYno3sFacdv2drBprYxIzPlJIYSkLTr/X2OJjIKDtej5KD/zlURtE35W
        WCaaydOlJKCm25csHpa7mIvHAD9tRmLkWvOaAWuU=
Received: from csiddharth-a01.vmware.com (115.97.41.221 [115.97.41.221]) by mx.zohomail.com
        with SMTPS id 1589558324404513.8227238926163; Fri, 15 May 2020 08:58:44 -0700 (PDT)
Date:   Fri, 15 May 2020 21:28:38 +0530
From:   Siddharth Chandrasekaran <siddharth@embedjournal.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Siddharth Chandrasekaran <csiddharth@vmware.com>,
        srostedt@vmware.com, stable@vger.kernel.org, srivatsab@vmware.com,
        dchinner@redhat.com, darrick.wong@oracle.com,
        srivatsa@csail.mit.edu
Subject: Re: [PATCH v2] Backport xfs security fix to 4.9 and 4.4 stable trees
Message-ID: <20200515155838.GA9039@csiddharth-a01.vmware.com>
References: <cover.1589544531.git.csiddharth@vmware.com>
 <20200515152230.GA2599290@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515152230.GA2599290@kroah.com>
X-ZohoMailClient: External
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 05:22:30PM +0200, Greg KH wrote:
> On Fri, May 15, 2020 at 08:41:07PM +0530, Siddharth Chandrasekaran wrote:
> > Hello,
> > 
> > Lack of proper validation that cached inodes are free during allocation can,
> > cause a crash in fs/xfs/xfs_icache.c (refer: CVE-2018-13093). To address this
> > issue, I'm backporting upstream commit [1] to 4.4 and 4.9 stable trees
> > (a backport of [1] to 4.14 already exists).
> > 
> > Also, commit [1] references another commit [2] which added checks only to
> > xfs_iget_cache_miss(). In this patch, those checks have been moved into a
> > dedicated checker method and both xfs_iget_cache_miss() and
> > xfs_iget_cache_hit() are made to call that method. This code reorg in commit
> > [1], makes commit [2] redundant in the history of the 4.9 and 4.4 stable
> > trees. So commit [2] is not being backported.
> > 
> > -- Sid
> > 
> > [1]: afca6c5b2595 ("xfs: validate cached inodes are free when allocated")
> > [2]: ee457001ed6c ("xfs: catch inode allocation state mismatch corruption")
> > 
> > change log:
> > v2:
> >  - Reword cover letter.
> >  - Fix accidental worong patch that got mailed.
> 
> As the XFS maintainers want to see xfstests pass with any changes made,
> have you done so for the 4.9 and 4.4 trees with this patch applied?

I haven't run them yet. I'll do so and get back with the results
shortly.

-- Sid.
