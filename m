Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631B75F504A
	for <lists+stable@lfdr.de>; Wed,  5 Oct 2022 09:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiJEHYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Oct 2022 03:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbiJEHYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Oct 2022 03:24:38 -0400
Received: from smtp-fw-6002.amazon.com (smtp-fw-6002.amazon.com [52.95.49.90])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5449CCE;
        Wed,  5 Oct 2022 00:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1664954676; x=1696490676;
  h=from:to:cc:date:message-id:references:in-reply-to:
   content-transfer-encoding:mime-version:subject;
  bh=sAnwOBup503KhTsZYl8bBrVGrc8jgV4o1uRbH+z5bFA=;
  b=ma0xgp4812ggD9BvCDWYXiXfq6cjdXO6KgE41RxIA+KS/1QGdcUI65pJ
   vJg8q7/YP4p+y3el395U+4qJu+7giRQnLRvPUwszu4LRCVe5z5r8kXlUD
   Tgs6/fVdkcE+fDCEhvxRUJbbsNS4roXK1S5H7YOtY5B0jpHqQYnSbuE7Y
   U=;
X-IronPort-AV: E=Sophos;i="5.95,159,1661817600"; 
   d="scan'208";a="251968327"
Subject: RE: significant drop  fio IOPS performance on v5.10
Thread-Topic: significant drop  fio IOPS performance on v5.10
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com) ([10.43.8.6])
  by smtp-border-fw-6002.iad6.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Oct 2022 07:24:24 +0000
Received: from EX13MTAUWB001.ant.amazon.com (iad12-ws-svc-p26-lb9-vlan2.iad.amazon.com [10.40.163.34])
        by email-inbound-relay-iad-1d-1c3c2014.us-east-1.amazon.com (Postfix) with ESMTPS id 393D7E018F;
        Wed,  5 Oct 2022 07:24:21 +0000 (UTC)
Received: from EX19D045UWC004.ant.amazon.com (10.13.139.203) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.207) with Microsoft SMTP Server (TLS)
 id 15.0.1497.38; Wed, 5 Oct 2022 07:24:21 +0000
Received: from EX19D017UWC003.ant.amazon.com (10.13.139.227) by
 EX19D045UWC004.ant.amazon.com (10.13.139.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.12; Wed, 5 Oct 2022 07:24:21 +0000
Received: from EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5]) by
 EX19D017UWC003.ant.amazon.com ([fe80::78e9:1d67:81fd:68c5%6]) with mapi id
 15.02.1118.012; Wed, 5 Oct 2022 07:24:21 +0000
From:   "Lu, Davina" <davinalu@amazon.com>
To:     Theodore Ts'o <tytso@mit.edu>
CC:     "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>,
        "adilger.kernel@dilger.ca" <adilger.kernel@dilger.ca>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Mohamed Abuelfotoh, Hazem" <abuehaze@amazon.com>,
        hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>,
        "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
        "Kiselev, Oleg" <okiselev@amazon.com>,
        "Liu, Frank" <franklmz@amazon.com>
Thread-Index: AdjO5vTzPItE0he4TsCHXHwBRGK6iAB1NzvQAJElJTAAIpWHgAE+4VbA
Date:   Wed, 5 Oct 2022 07:24:21 +0000
Message-ID: <b7aaf155f80f4605aff2ccbc4067d9a6@amazon.com>
References: <357ace228adf4e859df5e9f3f4f18b49@amazon.com>
 <1cdc68e6a98d4e93a95be5d887bcc75d@amazon.com>
 <5c819c9d6190452f9b10bb78a72cb47f@amazon.com> <YzTMZ26AfioIbl27@mit.edu>
In-Reply-To: <YzTMZ26AfioIbl27@mit.edu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.43.160.95]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Spam-Status: No, score=-11.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ted,

Thanks for your reply! Sorry for the late reply since I was busy on another=
 urgent EXT4 issue recently.

Understood the concern about the patch here-- the patch is just a simple st=
art and good suggestions on to make it safe update in multiple CPUs.
1.  Max thread number could not really need 256. From my side, ~30 could be=
 good enough and this only apply with cpu_num >=3D some_threads (E.g. 16), =
we can do this in a sysctl/mount option etc...
2. Definitely agree that we need to make safe way and thanks for clear expl=
anation.  A quick question, so if we make sure converting unwritten extents=
 on same inode  is in "atomic" way, then it should be a good patch to start=
 with?

About the larger the journal size -- which can help this IOPS issue, I foun=
d is, with small journal size with bad IOPS, journal transaction are more f=
requently (e.g. from 450 to 700 in a period of time) and each transaction h=
as very less handlers (e.g from 1000 to 70).
Tracing the code, I found: the reserved block exists in each journal update=
 in EXT4 which requires more blocks, then in=20
add_transaction_credits()
if (jbd2_log_space_left(journal) < journal->j_max_transaction_buffers) { //=
since journal size is too small, it has less change to goes into this if to=
 start an journal update.
            if (jbd2_log_space_left(journal) <
                                                journal->j_max_transaction_=
buffers)=20
                   __jbd2_log_wait_for_space(journal); // good to trigger c=
ommit->=20
                   jbd2_log_do_checkpoint() ->  jbd2_log_start_commit() ->
                    __jbd2_log_start_commit  -> journal->j_commit_request =
=3D target;

So most of time, in this func, it has to wait for journal commit... The slo=
wer journal update could affect the IO performance from my understanding (f=
io test is like: one pwrite64 and then followed one fsync). Therefore if we=
 larger the journal size from 128M to 2GB, mostly the "if" condition can go=
 into to ease this problem.

Thanks
Davina

-----Original Message-----
From: Theodore Ts'o <tytso@mit.edu>=20
Sent: Thursday, September 29, 2022 8:36 AM
To: Lu, Davina <davinalu@amazon.com>
Cc: linux-ext4@vger.kernel.org; adilger.kernel@dilger.ca; regressions@lists=
.linux.dev; stable@vger.kernel.org; Mohamed Abuelfotoh, Hazem <abuehaze@ama=
zon.com>; hazem ahmed mohamed <hazem.ahmed.abuelfotoh@gmail.com>; Ritesh Ha=
rjani (IBM) <ritesh.list@gmail.com>; Kiselev, Oleg <okiselev@amazon.com>; L=
iu, Frank <franklmz@amazon.com>
Subject: RE: [EXTERNAL]significant drop fio IOPS performance on v5.10

CAUTION: This email originated from outside of the organization. Do not cli=
ck links or open attachments unless you can confirm the sender and know the=
 content is safe.



On Wed, Sep 28, 2022 at 06:07:34AM +0000, Lu, Davina wrote:
>
> Hello,
>
> My analyzing is that the degradation is introduce by commit=20
> {244adf6426ee31a83f397b700d964cff12a247d3} and the issue is the=20
> contention on rsv_conversion_wq.  The simplest option is to increase=20
> the journal size, but that introduces more operational complexity.
> Another option is to add the following change in attachment "allow=20
> more ext4-rsv-conversion workqueue.patch"

Hi, thanks for the patch.  However, I don't believe as written it is safe. =
 That's because your patch will allow multiple CPU's to run ext4_flush_comp=
leted_IO(), and this function is not set up to be safe to be run concurrent=
ly.  That is, I don't see the necessary locking if we have two CPU's trying=
 to convert unwritten extents on the same inode.

It could be made safe, and certainly if the problem is that you are worried=
 about contention across multiple inodes being written to by different FIO =
jobs, then certainly this could be a potential contention issue.

However, what doesn't make sense is that increasing the journal size also s=
eems to fix the issue for you.  That implies the problem is one of the jour=
nal being to small, and so you are running into an issue of stalls caused b=
y the need to do a synchronous checkpoint to clear space in the journal.  T=
hat is a different problem than one of there being a contention problem wit=
h rsv_conversion_wq.

So I want to make sure we understand what you are seeing before we make suc=
h a change.  One potential concern is that will cause a large number of add=
itional kernel threads.  Now, if these extra kernel threads are doing usefu=
l work, then that's not necessarily an issue.
But if not, then it's going to be burning a large amount of kernel memory (=
especially for a system with a large number of CPU cores).

Regards,

                                        - Ted
