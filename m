Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4D15BC0E9
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 03:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbiISBIJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Sep 2022 21:08:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiISBIH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Sep 2022 21:08:07 -0400
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD9BD13F3A
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 18:08:05 -0700 (PDT)
Received: from epcas3p2.samsung.com (unknown [182.195.41.20])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20220919010802epoutp04fdfd5df962d0c74484c5e9a863dbd8d7~WHZ9kNrwJ2126721267epoutp04H
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 01:08:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20220919010802epoutp04fdfd5df962d0c74484c5e9a863dbd8d7~WHZ9kNrwJ2126721267epoutp04H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1663549682;
        bh=NDoR4FS/YkfgMXQLIMHDdM8BwQ3egJu9CTsYYwFrncY=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=OzXxhOaI8KJmnkWtEKSiQgEnE/w8a0RN9Fb5nNM5GW7fMuYHceuPoVD8mj6jG7G7t
         dzZ+rAI8X3tMZjcbtLSXGDVPdKvEcOZNmMWoM5L5qigbfBxrpqBlX3vH98R36csfTU
         02bdttU0liBJFuOBX/P2wx+pliHUUX9STdAjXPu0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas3p2.samsung.com (KnoxPortal) with ESMTP id
        20220919010802epcas3p23d5f62a37afdd1bb50890bc1ec1b207c~WHZ9NbLrb1183311833epcas3p2k;
        Mon, 19 Sep 2022 01:08:02 +0000 (GMT)
Received: from epcpadp4 (unknown [182.195.40.18]) by epsnrtp2.localdomain
        (Postfix) with ESMTP id 4MW6422WDSz4x9QL; Mon, 19 Sep 2022 01:08:02 +0000
        (GMT)
Mime-Version: 1.0
Subject: RE: [PATCH v4] page_alloc: consider highatomic reserve in watermark
 fast
Reply-To: jaewon31.kim@samsung.com
Sender: Jaewon Kim <jaewon31.kim@samsung.com>
From:   Jaewon Kim <jaewon31.kim@samsung.com>
To:     Greg KH <gregkh@linuxfoundation.org>, yong w <yongw.pur@gmail.com>
CC:     Jaewon Kim <jaewon31.kim@samsung.com>,
        "mhocko@kernel.org" <mhocko@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "wang.yong12@zte.com.cn" <wang.yong12@zte.com.cn>,
        YongTaek Lee <ytk.lee@samsung.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <YyREk5hHs2F0eWiE@kroah.com>
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <1891546521.01663549682346.JavaMail.epsvc@epcpadp4>
Date:   Sun, 18 Sep 2022 10:41:40 +0900
X-CMS-MailID: 20220918014140epcms1p43196006395c81ea4b5ff727cde997cdc
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
X-CPGSPASS: Y
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20220916094017epcas1p1deed4041f897d2bf0e0486554d79b3af
References: <YyREk5hHs2F0eWiE@kroah.com>
        <ab879545-d4b2-0cd8-3ae2-65f9f2baf2fe@gmail.com>
        <YyCLm0ws8qsiEcaJ@kroah.com>
        <CAOH5QeAUGBshLQdRCWLg9-Q3JvrqROLYW6uWr8a4TBKxwAOPaw@mail.gmail.com>
        <CGME20220916094017epcas1p1deed4041f897d2bf0e0486554d79b3af@epcms1p4>
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

>On Wed, Sep 14, 2022 at 08:46:15AM +0800, yong w wrote:
>> Greg KH <gregkh@linuxfoundation.org> =E4=BA=8E2022=E5=B9=B49=E6=9C=8813=
=E6=97=A5=E5=91=A8=E4=BA=8C 21:54?=E9=81=93=EF=BC=9A
>>=20
>> >
>> > On Tue, Sep 13, 2022 at 09:09:47PM +0800, yong wrote:
>> > > Hello,
>> > > This patch is required to be patched in linux-5.4.y and linux-4.19.y=
.
>> >
>> > What is "this patch"?  There is no context here :(
>> >
>> Sorry, I forgot to quote the original patch. the patch is as follows
>>=20
>>     f27ce0e page_alloc: consider highatomic reserve in watermark fast
>>=20
>> > > In addition to that, the following two patches are somewhat related:
>> > >
>> > >       3334a45 mm/page_alloc: use ac->high_zoneidx for classzone_idx
>> > >       9282012 page_alloc: fix invalid watermark check on a negative =
value
>> >
>> > In what way?  What should be done here by us?
>> >
>>=20
>> I think these two patches should also be merged.
>>=20
>>     The classzone_idx  parameter is used in the zone_watermark_fast
>> functionzone, and 3334a45 use ac->high_zoneidx for classzone_idx.
>>     "9282012 page_alloc: fix invalid watermark check on a negative
>> value"  fix f27ce0e introduced issues
>
>Ok, I need an ack by all the developers involved in those commits, as
>well as the subsystem maintainer so that I know it's ok to take them.
>
>Can you provide a series of backported and tested patches so that they
>are easy to review?
>
>thanks,
>
>greg k-h

Hello I didn't know my Act is needed to merge it.

Acked-by: Jaewon Kim <jaewon31.kim@samsung.com>

I don't understand well why the commit f27ce0e has dependency on 3334a45, t=
hough.

Thank you
Jaewon Kim
