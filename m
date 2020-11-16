Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC582B4ACF
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 17:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731835AbgKPQWL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 11:22:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730824AbgKPQWK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 11:22:10 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AD94C0613CF;
        Mon, 16 Nov 2020 08:22:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WeXqgN82VXAfdq0Sr+y7P9P52R7PHGKCFOx+In97HKc=; b=NBf98ShYxx1l674aMPRa4mu9fk
        kn7r4PK70qxA8Yz95IHJDVlsunerZL8PLXYdQexz2oafmh1doXPEGRNJcg73C7UfUrLNORUXVLQb8
        NFF7EyzGW4iKUUdl/3ROaMUQhV6iALesjmfL70dCCeRwC3d/LfKI1MSKhwY3H8H7Amj/VexJYqmuu
        hx7wKOf2IP6Ok58FGovCP6anrAk/OgiKaphsplHnbJ5+3VwRktdTE4YZiPOZR+k9b+0cGkJdKyjgX
        moQEm9gDIcq2+Bf67SPfI0FV9cksDUJlAIa3Cj/k6acZJN5AvGMzsPJqCzIBktnz+ejsU5d+fVmN6
        n/oA27rA==;
Received: from hch by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kehGV-000426-1F; Mon, 16 Nov 2020 16:22:03 +0000
Date:   Mon, 16 Nov 2020 16:22:02 +0000
From:   Christoph Hellwig <hch@infradead.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Silviu Vlasceanu <Silviu.Vlasceanu@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [RESEND][PATCH] ima: Set and clear FMODE_CAN_READ in
 ima_calc_file_hash()
Message-ID: <20201116162202.GA15010@infradead.org>
References: <20201113080132.16591-1-roberto.sassu@huawei.com>
 <20201114111057.GA16415@infradead.org>
 <0fd0fb3360194d909ba48f13220f9302@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0fd0fb3360194d909ba48f13220f9302@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by casper.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 16, 2020 at 08:52:19AM +0000, Roberto Sassu wrote:
> FMODE_CAN_READ was not set because f_mode does not have
> FMODE_READ. In the patch, I check if the former can be set
> similarly to the way it is done in file_table.c and open.c.
> 
> Is there a better way to read a file when the file was not opened
> for reading and a new file descriptor cannot be created?

You can't open a file not open for reading.  The file system or device
driver might have to prepare read-specific resources in ->open to
support reads.  So what you'll have to do is to open a new instance
of the file that is open for reading.
