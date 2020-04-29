Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EC441BE6BF
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 20:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726618AbgD2S6a convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 29 Apr 2020 14:58:30 -0400
Received: from lithops.sigma-star.at ([195.201.40.130]:49054 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726423AbgD2S63 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 14:58:29 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 29 Apr 2020 14:58:28 EDT
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 5A18D6071A61;
        Wed, 29 Apr 2020 20:51:08 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id NbIDHCmeZZST; Wed, 29 Apr 2020 20:51:07 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 008C262257A2;
        Wed, 29 Apr 2020 20:51:06 +0200 (CEST)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TPdioTLx9-de; Wed, 29 Apr 2020 20:51:06 +0200 (CEST)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id D3EA26089348;
        Wed, 29 Apr 2020 20:51:06 +0200 (CEST)
Date:   Wed, 29 Apr 2020 20:51:06 +0200 (CEST)
From:   Richard Weinberger <richard@nod.at>
To:     stable <stable@vger.kernel.org>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        John Ogness <john.ogness@linutronix.de>
Message-ID: <1537701093.171645.1588186266734.JavaMail.zimbra@nod.at>
In-Reply-To: <875zdibasg.fsf@vostro.fn.ogness.net>
References: <20200119215233.7292-1-richard@nod.at> <875zdibasg.fsf@vostro.fn.ogness.net>
Subject: Please queue ubifs: Fix ubifs_tnc_lookup() usage in
 do_kill_orphans() for stable (was: Re: [PATCH] ubifs: Fix
 ubifs_tnc_lookup() usage in do_kill_orphans())
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: Please queue ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans() for stable (was: Re: [PATCH] ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans())
Thread-Index: vuDlWTB9U53gSqUpBqsVy2sOOiFwnA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

----- Ursprüngliche Mail -----
> Von: "John Ogness" <john.ogness@linutronix.de>
> An: "richard" <richard@nod.at>
> CC: "linux-mtd" <linux-mtd@lists.infradead.org>, "linux-kernel" <linux-kernel@vger.kernel.org>
> Gesendet: Mittwoch, 29. April 2020 16:56:31
> Betreff: Re: [PATCH] ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()

> Hi Richard,
> 
> Could you CC this patch to stable? It fixes a serious problem that I am
> seeing on real devices (i.e. Linux not being able to mount its root
> filesystem after a power cut). Thanks.

Just checked again, better ask stable maintainers. :-)

Stable maintainers, can you please make sure this patch will make it
into stable?
The upstream commit is:
4ab25ac8b2b5 ("ubifs: Fix ubifs_tnc_lookup() usage in do_kill_orphans()")

I always thought havings a Fixes-Tag is enough to make sure it will
get picked up. Isn't this the case?

Thanks,
//richard
 
> John Ogness
> 
> On 2020-01-19, Richard Weinberger <richard@nod.at> wrote:
>> Orphans are allowed to point to deleted inodes.
>> So -ENOENT is not a fatal error.
>>
>> Reported-by: Кочетков Максим <fido_max@inbox.ru>
>> Reported-and-tested-by: "Christian Berger" <Christian.Berger@de.bosch.com>
>> Fixes: ee1438ce5dc4 ("ubifs: Check link count of inodes when killing orphans.")
>> Signed-off-by: Richard Weinberger <richard@nod.at>
>> ---
>>  fs/ubifs/orphan.c | 4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/ubifs/orphan.c b/fs/ubifs/orphan.c
>> index 54d6db61106f..2645917360b9 100644
>> --- a/fs/ubifs/orphan.c
>> +++ b/fs/ubifs/orphan.c
>> @@ -688,14 +688,14 @@ static int do_kill_orphans(struct ubifs_info *c, struct
>> ubifs_scan_leb *sleb,
>>  
>>  			ino_key_init(c, &key1, inum);
>>  			err = ubifs_tnc_lookup(c, &key1, ino);
>> -			if (err)
>> +			if (err && err != -ENOENT)
>>  				goto out_free;
>>  
>>  			/*
>>  			 * Check whether an inode can really get deleted.
>>  			 * linkat() with O_TMPFILE allows rebirth of an inode.
>>  			 */
>> -			if (ino->nlink == 0) {
>> +			if (err == 0 && ino->nlink == 0) {
>>  				dbg_rcvry("deleting orphaned inode %lu",
> >  					  (unsigned long)inum);
