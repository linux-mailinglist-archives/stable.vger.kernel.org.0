Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D902366AC7
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 14:28:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239766AbhDUM3R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 08:29:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239808AbhDUM3R (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 08:29:17 -0400
Received: from angie.orcam.me.uk (angie.orcam.me.uk [IPv6:2001:4190:8020::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ED080C06174A;
        Wed, 21 Apr 2021 05:28:43 -0700 (PDT)
Received: by angie.orcam.me.uk (Postfix, from userid 500)
        id F02F792009C; Wed, 21 Apr 2021 14:28:41 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by angie.orcam.me.uk (Postfix) with ESMTP id E940492009B;
        Wed, 21 Apr 2021 14:28:41 +0200 (CEST)
Date:   Wed, 21 Apr 2021 14:28:41 +0200 (CEST)
From:   "Maciej W. Rozycki" <macro@orcam.me.uk>
To:     David Laight <David.Laight@ACULAB.COM>
cc:     Joe Perches <joe@perches.com>, Khalid Aziz <khalid@gonehiking.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: RE: [PATCH v2 1/5] scsi: BusLogic: Fix missing `pr_cont' use
In-Reply-To: <bcb0b8fa8e1f404989c9d6450be10074@AcuMS.aculab.com>
Message-ID: <alpine.DEB.2.21.2104211417040.44318@angie.orcam.me.uk>
References: <alpine.DEB.2.21.2104201934280.44318@angie.orcam.me.uk> <alpine.DEB.2.21.2104201940430.44318@angie.orcam.me.uk> <bcb0b8fa8e1f404989c9d6450be10074@AcuMS.aculab.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Apr 2021, David Laight wrote:

> > Update BusLogic driver's messaging system to use `pr_cont' for
> > continuation lines, bringing messy output:
> 
> If reasonably possible it is best to avoid use of pr_cont().

 I know, however for that the whole driver's messaging system would have 
to be redesigned.  Joe (cc-ed) has offered to do it with the original 
iteration, however I believe consensus has been it will best be done as a 
separate follow-up change, while this small fix can be easily backported.

> If there are concurrent writes from multiple cpu I believe
> the writes still get separated.
> (Something has to give...)

 NB this driver may not see a lot of SMP use as I reckon it's had some 
portability issues, and in any case the hardware requires port I/O which 
precludes its use with some of the most recent PCIe systems which do not 
support PCI I/O cycles anymore.  And older systems were often UP.  Not 
that the driver should not be kept in a clean style of course.

  Maciej
