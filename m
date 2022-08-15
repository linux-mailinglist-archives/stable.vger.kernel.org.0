Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFD8593267
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 17:47:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbiHOPrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 11:47:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230487AbiHOPqo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 11:46:44 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C61D418372
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:46:40 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id gp7so7248310pjb.4
        for <stable@vger.kernel.org>; Mon, 15 Aug 2022 08:46:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=digitalocean.com; s=google;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc;
        bh=XRj0PDiSMZynH1zCQWiVZaBOl7oXuBXsH66ocbP/Vuw=;
        b=F7TtGfnrlBum+rJkazEj/TAtZgpkyGjwRPhWlRkECnHGBtcEyMnRNBakk4wt7b6Y1x
         9JmAafWwiJdYej0NFGzPrrOenVsusTQ9d6UGFAke+rPVaWmCGhdGB5myQ/DVfjaY4+RO
         fcbowmlOD7w16kcMSui93Rlofhg4/xXy90m98=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc;
        bh=XRj0PDiSMZynH1zCQWiVZaBOl7oXuBXsH66ocbP/Vuw=;
        b=XrO9AwE6k16PIwzEIaVbTR2o3/o+mom0z4JVu+K4y17BDW0Pl/EeG/octHfBMHY2qO
         Bplxm2J8O9CppuyFtC13Nj149Ans9H2AxLIgBIF9AWJ3qDKhc7Nj7WrDAiR5Q5bZnEjr
         59PJUEUJtupBMGUA4v7uKmZk/WvCS38K0RR/BSbNoGMoCPpxR+gl510BYZnbKy8GcLRE
         oygMZAwWStH9wIMmM275k9/U5iB9gbms0ewT0+JrBpFbEvrU0GQHnF9yWlZ77OzuYzGf
         Yb8eJe3hlXSt6ZlJ3CIYZTTz/7NsuVB9XScm12zI5aKFmE8k9R08BnZbDnIDDs7aFkOG
         3Wcg==
X-Gm-Message-State: ACgBeo1qq4dtOu2JKwLuQ2E+swMwrH7FxxIomhC2++NO+o7+9cbBvgk9
        MWIesildEh+/Y763Tx0Lnmy2EVWXozgvww==
X-Google-Smtp-Source: AA6agR59rgz10UcqrkCCYcZ8/YekSq2pViqBSKyziEk0QofgJ02b0L9XOKKOmH6Ssxo53FgF2y2VXA==
X-Received: by 2002:a17:902:b18e:b0:172:5c92:d8da with SMTP id s14-20020a170902b18e00b001725c92d8damr11000857plr.26.1660578400164;
        Mon, 15 Aug 2022 08:46:40 -0700 (PDT)
Received: from smtpclient.apple (ip72-201-141-123.ph.ph.cox.net. [72.201.141.123])
        by smtp.gmail.com with ESMTPSA id s11-20020a170902ea0b00b0016be96e07d1sm7141083plg.121.2022.08.15.08.46.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 15 Aug 2022 08:46:39 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.120.0.1.13\))
Subject: Re: [REGRESSION] v5.17-rc1+: FIFREEZE ioctl system call hangs
From:   Vishal Verma <vverma@digitalocean.com>
In-Reply-To: <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
Date:   Mon, 15 Aug 2022 08:46:32 -0700
Cc:     Song Liu <song@kernel.org>, stable@vger.kernel.org,
        regressions@lists.linux.dev, Thomas Deutschmann <whissi@whissi.de>,
        Jens Axboe <axboe@kernel.dk>
Content-Transfer-Encoding: quoted-printable
Message-Id: <0FBCAB10-545E-45E2-A0C8-D7620817651D@digitalocean.com>
References: <000401d8a746$3eaca200$bc05e600$@whissi.de>
 <000001d8ad7e$c340ad70$49c20850$@whissi.de>
 <2a2d1075-aa22-8c4d-ca21-274200dce2fc@leemhuis.info>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
X-Mailer: Apple Mail (2.3654.120.0.1.13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Just saw this. I=E2=80=99m trying to understand whether this happens =
only on md array or individual nvme drives (without any raid) too?
The commit you pointed added REQ_NOWAIT for md based arrays, but if it =
is happening on individual nvme drives then that could point to =
something with REQ_NOWAIT I think.

> On Aug 15, 2022, at 3:58 AM, Thorsten Leemhuis =
<regressions@leemhuis.info> wrote:
>=20
> Hi, this is your Linux kernel regression tracker. Top-posting for =
once,
> to make this easily accessible to everyone.
>=20
> [CCing Jens, as the top-level maintainer who in this case also =
reviewed
> the patch that causes this regression.]
>=20
> Vishal, Song, what up here? Could you please look into this and at =
least
> comment on the issue, as it's a regression that was reported more than
> 10 days ago already. Ideally at this point it would be good if the
> regression was fixed already, as explained by "Prioritize work on =
fixing
> regressions" here:
> =
https://docs.kernel.org/process/handling-regressions.html#prioritize-work-=
on-fixing-regressions
>=20
> Ciao, Thorsten
>=20
> On 11.08.22 14:34, Thomas Deutschmann wrote:
>=20
>>=20
>> Hi,
>>=20
>> any news on this? Is there anything else you need from me or I can =
help
>> with?
>>=20
>> Thanks.
>>=20
>>=20
>> -- Regards, Thomas -----Original Message----- From: Thomas =
Deutschmann
>> <whissi@whissi.de> Sent: Wednesday, August 3, 2022 4:35 PM To:
>> vverma@digitalocean.com; song@kernel.org Cc: stable@vger.kernel.org;
>> regressions@lists.linux.dev Subject: [REGRESSION] v5.17-rc1+: =
FIFREEZE
>> ioctl system call hangs Hi, while trying to backup a Dell R7525 =
system
>> running Debian bookworm/testing using LVM snapshots I noticed that =
the
>> system will 'freeze' sometimes (not all the times) when creating the
>> snapshot. First I thought this was related to LVM so I created
>> https://listman.redhat.com/archives/linux-lvm/2022-July/026228.html
>> (continued at
>> =
https://listman.redhat.com/archives/linux-lvm/2022-August/thread.html#2622=
9) Long story short: I was even able to reproduce with fsfreeze, see =
last strace lines
>>> [...]
>>> 14471 1659449870.984635 openat(AT_FDCWD, "/var/lib/machines", =
O_RDONLY) =3D3
>>> 14471 1659449870.984658 newfstatat(3, "",
>> {st_mode=3DS_IFDIR|0700,st_size=3D4096, ...}, AT_EMPTY_PATH) =3D 0
>>> 14471 1659449870.984678 ioctl(3, FIFREEZE
>> so I started to bisect kernel and found the following bad commit:
>>=20
>>> md: add support for REQ_NOWAIT
>>>=20
>>> commit 021a24460dc2 ("block: add QUEUE_FLAG_NOWAIT") added support
>>> for checking whether a given bdev supports handling of REQ_NOWAIT or =
not.
>>> Since then commit 6abc49468eea ("dm: add support for REQ_NOWAIT and =
enable
>>> it for linear target") added support for REQ_NOWAIT for dm. This =
uses
>>> a similar approach to incorporate REQ_NOWAIT for md based bios.
>>>=20
>>> This patch was tested using t/io_uring tool within FIO. A nvme drive
>>> was partitioned into 2 partitions and a simple raid 0 configuration
>>> /dev/md0 was created.
>>>=20
>>> md0 : active raid0 nvme4n1p1[1] nvme4n1p2[0]
>>>      937423872 blocks super 1.2 512k chunks
>>>=20
>>> Before patch:
>>>=20
>>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>>=20
>>> Running top while the above runs:
>>>=20
>>> $ ps -eL | grep $(pidof io_uring)
>>>=20
>>>  38396   38396 pts/2    00:00:00 io_uring
>>>  38396   38397 pts/2    00:00:15 io_uring
>>>  38396   38398 pts/2    00:00:13 iou-wrk-38397
>>>=20
>>> We can see iou-wrk-38397 io worker thread created which gets created
>>> when io_uring sees that the underlying device (/dev/md0 in this =
case)
>>> doesn't support nowait.
>>>=20
>>> After patch:
>>>=20
>>> $ ./t/io_uring /dev/md0 -p 0 -a 0 -d 1 -r 100
>>>=20
>>> Running top while the above runs:
>>>=20
>>> $ ps -eL | grep $(pidof io_uring)
>>>=20
>>>  38341   38341 pts/2    00:10:22 io_uring
>>>  38341   38342 pts/2    00:10:37 io_uring
>>>=20
>>> After running this patch, we don't see any io worker thread
>>> being created which indicated that io_uring saw that the
>>> underlying device does support nowait. This is the exact behaviour
>>> noticed on a dm device which also supports nowait.
>>>=20
>>> For all the other raid personalities except raid0, we would need
>>> to train pieces which involves make_request fn in order for them
>>> to correctly handle REQ_NOWAIT.
>> =
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/=
?i
>> d=3Df51d46d0e7cb5b8494aa534d276a9d8915a2443d
>>=20
>> After reverting this commit (and follow up commit
>> 0f9650bd838efe5c52f7e5f40c3204ad59f1964d)
>> v5.18.15 and v5.19 worked for me again.
>>=20
>> At this point I still wonder why I experienced the same problem even =
after I
>> removed one nvme device from the mdraid array and tested it =
separately. So
>> maybe there is another nowait/REQ_NOWAIT problem somewhere. During =
bisect
>> I only tested against the mdraid array.
>>=20
>>=20
>> #regzbot introduced: f51d46d0e7cb5b8494aa534d276a9d8915a2443d
>> #regzbot link:
>> https://listman.redhat.com/archives/linux-lvm/2022-July/026228.html
>> #regzbot link:
>> =
https://listman.redhat.com/archives/linux-lvm/2022-August/thread.html#2622=
9
>>=20
>>=20
>> -- Regards, Thomas
>>=20

