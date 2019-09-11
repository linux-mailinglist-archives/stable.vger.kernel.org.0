Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0A67B0462
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 21:04:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730198AbfIKTEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 15:04:38 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:37166 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbfIKTEi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Sep 2019 15:04:38 -0400
X-Greylist: delayed 309 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Sep 2019 15:04:38 EDT
Received: from quad.stoffel.org (66-189-75-104.dhcp.oxfr.ma.charter.com [66.189.75.104])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id A4F161E275;
        Wed, 11 Sep 2019 14:59:28 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id 36B8CA5B0D; Wed, 11 Sep 2019 14:59:28 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <23929.17424.161332.501830@quad.stoffel.home>
Date:   Wed, 11 Sep 2019 14:59:28 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>, dm-devel@redhat.com,
        stable@vger.kernel.org
Subject: Re: [dm-devel] [PATCH V2] dm-raid: fix updating of
        max_discard_sectors limit
In-Reply-To: <20190911133523.GA32121@redhat.com>
References: <20190911113133.837-1-ming.lei@redhat.com>
        <20190911133523.GA32121@redhat.com>
X-Mailer: VM 8.2.0b under 25.1.1 (x86_64-pc-linux-gnu)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> On Wed, Sep 11 2019 at  7:31am -0400,
Mike> Ming Lei <ming.lei@redhat.com> wrote:

>> Unit of 'chunk_size' is byte, instead of sector, so fix it.
>> 
>> Without this fix, too big max_discard_sectors is applied on the request queue
>> of dm-raid, finally raid code has to split the bio again.
>> 
>> This re-split done by raid causes the following nested clone_endio:
>> 
>> 1) one big bio 'A' is submitted to dm queue, and served as the original
>> bio
>> 
>> 2) one new bio 'B' is cloned from the original bio 'A', and .map()
>> is run on this bio of 'B', and B's original bio points to 'A'
>> 
>> 3) raid code sees that 'B' is too big, and split 'B' and re-submit
>> the remainded part of 'B' to dm-raid queue via generic_make_request().
>> 
>> 4) now dm will hanlde 'B' as new original bio, then allocate a new
>> clone bio of 'C' and run .map() on 'C'. Meantime C's original bio
>> points to 'B'.
>> 
>> 5) suppose now 'C' is completed by raid direclty, then the following
>> clone_endio() is called recursively:
>> 
>> clone_endio(C)
-> clone_endio(B)		#B is original bio of 'C'
-> bio_endio(A)
>> 
>> 'A' can be big enough to make handreds of nested clone_endio(), then
>> stack can be corrupted easily.
>> 
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>> ---
>> V2:
>> - fix commit log a bit
>> 
>> drivers/md/dm-raid.c | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
>> index 8a60a4a070ac..c26aa4e8207a 100644
>> --- a/drivers/md/dm-raid.c
>> +++ b/drivers/md/dm-raid.c
>> @@ -3749,7 +3749,7 @@ static void raid_io_hints(struct dm_target *ti, struct queue_limits *limits)
>> */
>> if (rs_is_raid1(rs) || rs_is_raid10(rs)) {
limits-> discard_granularity = chunk_size;
>> -		limits->max_discard_sectors = chunk_size;
>> +		limits->max_discard_sectors = chunk_size >> 9;
>> }
>> }
>> 
>> -- 
>> 2.20.1
>> 

Mike> Thanks a lot Ming!  But oof, really embarassing oversight on my part!

Mike> FYI, I added a "Fixes:" tag to the commit header and switched to
Mike> shifting by SECTOR_SHIFT instead of 9, staged commit for 5.4 is here:

Mike> https://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-5.4&id=509818079bf1fefff4ed02d6a1b994e20efc0480

Mike> --
Mike> dm-devel mailing list
Mike> dm-devel@redhat.com
Mike> https://www.redhat.com/mailman/listinfo/dm-devel



Would it make sense to re-name the variable to chunk_size_bytes as
well?  
