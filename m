Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11014240D2B
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 20:49:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728247AbgHJStm convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Mon, 10 Aug 2020 14:49:42 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:57218 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727904AbgHJStm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 14:49:42 -0400
X-Greylist: delayed 532 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Aug 2020 14:49:41 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id CD01161D8ABB;
        Mon, 10 Aug 2020 20:40:47 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id hU8bXeKPAT8V; Mon, 10 Aug 2020 20:40:47 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 6AAEC61D8ABC;
        Mon, 10 Aug 2020 20:40:47 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aOzKDsZ6vDg5; Mon, 10 Aug 2020 20:40:47 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id 425DD61D8ABB;
        Mon, 10 Aug 2020 20:40:47 +0200 (CEST)
Date:   Mon, 10 Aug 2020 20:40:47 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        stable <stable@kernel.org>
Message-ID: <1475688016.229129.1597084847149.JavaMail.zimbra@nod.at>
In-Reply-To: <20200810163851.GB24408@amd>
References: <20200810151804.199494191@linuxfoundation.org> <20200810151804.911709325@linuxfoundation.org> <20200810163851.GB24408@amd>
Subject: Re: [PATCH 4.19 14/48] mtd: properly check all write ioctls for
 permissions
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF78 (Linux)/8.8.12_GA_3809)
Thread-Topic: properly check all write ioctls for permissions
Thread-Index: SPuvyTwnFDc3qnA8Gvg/tEw1EZFuYQ==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "Pavel Machek" <pavel@denx.de>
>> When doing a "write" ioctl call, properly check that we have permissions
>> to do so before copying anything from userspace or anything else so we
>> can "fail fast".  This includes also covering the MEMWRITE ioctl which
>> previously missed checking for this.
> 
>> +	/* "safe" commands */
>> +	case MEMGETREGIONCOUNT:
> 
> I wonder if MEMSETBADBLOCK, MEMLOCK/MEMUNLOCK, BLKPG, OTPLOCK and
> MTDFILEMODE should be in the list of "safe" commands? Sounds like they
> can do at least as much damage as average MEMWRITE...

Most of the ioctls you listed are not write-exclusive because existing
user space applications (such as mtd-utils) issue them on a read-only fd.
So, we didn't want to break them.
Before we move such an ioctl to the "non-safe" list, common user space needs to
be inspected. This includes, android, openwrt, mtd-utils, etc...

On the other hand, this is a raw mtd, it is hard to draw the line.
For NAND even reading allows an attacker doing harm, she can trigger read-distrurb
super efficiently using the read ioctl...

So passing an mtdchar fd (no matter whether read or write mode) to untrusted
entities is a bad idea.

Thanks,
//richard
