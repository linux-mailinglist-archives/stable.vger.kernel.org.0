Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E7FE34C98
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 17:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbfFDPvo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 11:51:44 -0400
Received: from imap1.codethink.co.uk ([176.9.8.82]:39292 "EHLO
        imap1.codethink.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728002AbfFDPvo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jun 2019 11:51:44 -0400
Received: from [167.98.27.226] (helo=xylophone)
        by imap1.codethink.co.uk with esmtpsa (Exim 4.84_2 #1 (Debian))
        id 1hYBit-0007gh-4r; Tue, 04 Jun 2019 16:51:39 +0100
Message-ID: <1559663498.24330.85.camel@codethink.co.uk>
Subject: Re: Patch "coredump: fix race condition between
 mmget_not_zero()/get_task_mm() and core dumping" has been added to the
 4.4-stable tree
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Michal Hocko <mhocko@kernel.org>
Cc:     stable@vger.kernel.org, aarcange@redhat.com,
        akpm@linux-foundation.org, jannh@google.com, jgg@mellanox.com,
        oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com,
        torvalds@linux-foundation.org, stable-commits@vger.kernel.org
Date:   Tue, 04 Jun 2019 16:51:38 +0100
In-Reply-To: <20190604150756.GA24221@kroah.com>
References: <155965961313615@kroah.com>
         <20190604145216.GJ4669@dhcp22.suse.cz> <20190604150756.GA24221@kroah.com>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.22.6-1+deb9u1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2019-06-04 at 17:07 +0200, Greg KH wrote:
> On Tue, Jun 04, 2019 at 04:52:31PM +0200, Michal Hocko wrote:
> > Please note that I have posted my backport today
> > http://lkml.kernel.org/r/20190604094953.26688-1-mhocko@kernel.org and it
> > differs from this one. Please have a look!
> 
> Ah, good point, I just noticed that.  Ben, any thoughts as to the
> difference?

- The additional fix in binder makes sense to me, and is also needed in
4.9.  I'm not sure why I missed it.

- I don't understand why collapse_huge_range() needs to be fixed, but
then I really don't understand the khugepaged code at all!  So I would
trust Michal on this.

- The userfaultfd fixes look different because I picked "userfaultfd:
don't pin the user memory in userfaultfd_file_create()" first and
Michal did not.  I don't think it makes sense to be calling
mmget_still_valid() in these functions if they don't use
mmget_not_zero() or similar.  But again, Michal is the expert here.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom
