Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634223ACE21
	for <lists+stable@lfdr.de>; Fri, 18 Jun 2021 16:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhFRPAp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 11:00:45 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:31055 "EHLO
        mailout1.w2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234831AbhFRPAk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 11:00:40 -0400
X-Greylist: delayed 580 seconds by postgrey-1.27 at vger.kernel.org; Fri, 18 Jun 2021 11:00:37 EDT
Received: from uscas1p2.samsung.com (unknown [182.198.245.207])
        by mailout1.w2.samsung.com (KnoxPortal) with ESMTP id 20210618144844usoutp01ada70eb0788dde429235d51363a9ab2c~JtJxs3PoR2822828228usoutp01S;
        Fri, 18 Jun 2021 14:48:44 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w2.samsung.com 20210618144844usoutp01ada70eb0788dde429235d51363a9ab2c~JtJxs3PoR2822828228usoutp01S
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1624027724;
        bh=NwpSqfChnbYWL67ohYJmb5b6V9dEA+79cx1XRyd86T8=;
        h=From:To:CC:Subject:Date:In-Reply-To:References:From;
        b=YiZHTIk9QK+563ZMQhei2EpP6zvJVlLnGyC/LPs1Wwei6ClXIcD1reRSyKc3Vf7Qg
         6Yi9ejOKrfKTr4XgxnFVtmQ1Kz4Gkt6xS/rBUTyui3PMDrjDzUSRViTXhor/irXNc1
         LNgCpmcWPx25imHGukVYhaxT4l9Iok1I9BEE+pfI=
Received: from ussmges2new.samsung.com (u111.gpu85.samsung.co.kr
        [203.254.195.111]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210618144844uscas1p2705fb2a126bd71955a11b8795bee3182~JtJxkNTu60144801448uscas1p27;
        Fri, 18 Jun 2021 14:48:44 +0000 (GMT)
Received: from uscas1p1.samsung.com ( [182.198.245.206]) by
        ussmges2new.samsung.com (USCPEMTA) with SMTP id 94.29.53491.C42BCC06; Fri,
        18 Jun 2021 10:48:44 -0400 (EDT)
Received: from ussmgxs2new.samsung.com (u91.gpu85.samsung.co.kr
        [203.254.195.91]) by uscas1p2.samsung.com (KnoxPortal) with ESMTP id
        20210618144844uscas1p280d192b12fc852b36879565030b13cd6~JtJxK6dXb0371003710uscas1p2x;
        Fri, 18 Jun 2021 14:48:44 +0000 (GMT)
X-AuditID: cbfec36f-f09ff7000001d0f3-8b-60ccb24c467a
Received: from SSI-EX2.ssi.samsung.com ( [105.128.2.146]) by
        ussmgxs2new.samsung.com (USCPEXMTA) with SMTP id DB.93.26904.B42BCC06; Fri,
        18 Jun 2021 10:48:43 -0400 (EDT)
Received: from SSI-EX1.ssi.samsung.com (105.128.2.226) by
        SSI-EX2.ssi.samsung.com (105.128.2.227) with Microsoft SMTP Server
        (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
        15.1.2242.4; Fri, 18 Jun 2021 07:48:43 -0700
Received: from SSI-EX1.ssi.samsung.com ([fe80::255d:1bae:c3ae:e3c3]) by
        SSI-EX1.ssi.samsung.com ([fe80::255d:1bae:c3ae:e3c3%7]) with mapi id
        15.01.2242.008; Fri, 18 Jun 2021 07:48:43 -0700
From:   Adam Manzanares <a.manzanares@samsung.com>
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
CC:     Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Shaun Tancheff <shaun@tancheff.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jens Axboe <axboe@fb.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 1/2] blk-zoned: allow zone management send operations
 without CAP_SYS_ADMIN
Thread-Topic: [PATCH v3 1/2] blk-zoned: allow zone management send
        operations without CAP_SYS_ADMIN
Thread-Index: AQHXYRgQMteA58G2kEuU7Azlx40Z/qsaVTmA
Date:   Fri, 18 Jun 2021 14:48:43 +0000
Message-ID: <20210618144843.GA33886@bgt-140510-bm01>
In-Reply-To: <20210614122303.154378-2-Niklas.Cassel@wdc.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [105.128.2.176]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <BE5F368FAE175742BB504CA5C6918049@ssi.samsung.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrGKsWRmVeSWpSXmKPExsWy7djXc7o+m84kGHz7KGzxf88xNovVd/vZ
        LFrbvzFZLHizl81i7y1ti8u75rBZLD/+j8niwZ/H7BaTT59gtViw8RGjA5fHxOZ37B6Xz5Z6
        fHx6i8Vj/ZarLB437k9h8vi8Sc6j/UA3UwB7FJdNSmpOZllqkb5dAlfGwo7zrAVn+CpmHfvI
        0sDYwtPFyMkhIWAicWfrU7YuRi4OIYGVjBIvtj+DclqZJO4te88KU/Vm/SWoxFpGiR8fu6Cc
        j4wSnzsWM0M4Bxgldn4/wAbSwiZgIPH7+EZmEFtEQFPi86m1rCBFzAJTmSWmdL5n6mLk4BAW
        SJG4/NgDoiZVou32Qah6I4nDBxaxgNgsAqoSH5+dAIvzAp3xYWcn2HxOARuJ9283M4LYjAJi
        Et9PrWECsZkFxCVuPZnPBHG2oMSi2XuYIWwxiX+7HrJB2IoS97+/ZIeo15FYsPsTG4RtJ7Fq
        VTeUrS2xbOFrqL2CEidnPmGB6JWUOLjiBgvILxIC/zkk2q7MhVrgIrGreyXUYmmJv3eXMUEU
        7WKUmDP7IyuEc5hRYtOF5YwQVdYSN152MU5gVJmF5PJZSK6aheSqWUiumoXkqgWMrKsYxUuL
        i3PTU4uN8lLL9YoTc4tL89L1kvNzNzECk9rpf4fzdzBev/VR7xAjEwfjIUYJDmYlEV7OzDMJ
        QrwpiZVVqUX58UWlOanFhxilOViUxHmZIibGCwmkJ5akZqemFqQWwWSZODilGph0T7BZzvnz
        cJf6GrFtKi+nPD6r9fjJ5/nJG+se5gZejmXQEfVZ9X8j06bd32JuLPH1vDlNy6PKz7k9NdJn
        gfvFBef+b+XOl/y+VV140Y5zZsGKG39khs642DHtdMqDb7ejhdd7vlphZHtxo6B0xIrUz7/X
        pK+boaEWvtV8S2BGdfoSqRRHFs9nR1O0vx0NMjLZ/YV50ccTNyccvKB9Nm/OnKfXFvxOi597
        adN7Y6nzz04LXuGyD92nOvtAtuZRkW+cvyoWf3u8gXHnnf6P+V9E53lPWxts1HJv7uXFjb63
        Fi/Ji4z3OLRsuWjh4RmLZmnotyUt6tA/Z7x22p+mJkeedflvH/yy/tTA1WNu+dozbKoSS3FG
        oqEWc1FxIgDjfPRk2QMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrEIsWRmVeSWpSXmKPExsWS2cA0Sdd705kEg+UvTS3+7znGZrH6bj+b
        RWv7NyaLBW/2slnsvaVtcXnXHDaL5cf/MVk8+POY3WLy6ROsFgs2PmJ04PKY2PyO3ePy2VKP
        j09vsXis33KVxePG/SlMHp83yXm0H+hmCmCP4rJJSc3JLEst0rdL4MpY2HGeteAMX8WsYx9Z
        GhhbeLoYOTkkBEwk3qy/xNbFyMUhJLCaUWLG2vVMEM5HRomDq1+yQjgHGCVO7H7FDtLCJmAg
        8fv4RmYQW0RAU+LzqbVgRcwCU5kluhZPZ+xi5OAQFkiRuPzYA6ImVeLFt0XsELaRxOEDi1hA
        bBYBVYmPz06AzeEFOuPDzk6oMw4ySjS197OCJDgFbCTev93MCGIzCohJfD+1hgnEZhYQl7j1
        ZD4TxA8CEkv2nGeGsEUlXj7+xwphK0rc//6SHaJeR2LB7k9sELadxKpV3VC2tsSyha+hjhCU
        ODnzCQtEr6TEwRU3WCYwSsxCsm4WklGzkIyahWTULCSjFjCyrmIULy0uzk2vKDbKSy3XK07M
        LS7NS9dLzs/dxAhMBqf/HY7ewXj71ke9Q4xMHIyHGCU4mJVEeDkzzyQI8aYkVlalFuXHF5Xm
        pBYfYpTmYFES530ZNTFeSCA9sSQ1OzW1ILUIJsvEwSnVwGRz6P2EFR96jtj8F912QDSao+Xf
        dQs/tuCrEeIztn+t2sfwgkPW4298hvDTnXnLLxk/frdg5/TJNzQkFV5Oe+r3uyHKUMjlwMtO
        NbZHy5OaS5qPL9te/O2F6Mbk1KQW9wuaT1ckXf/07rNmyQJ3i8tv4k+Zi8hEbmW99GW3hXvm
        Js+vwsUF3AITdLaL2BXsXMGfwlcS+ndq2Kb8DdftLzfN/y5V/Xaqjmvzz1OPFHb53lH66f1u
        m+6zN26NhScOcniahR88/DX5H++TKT/Ws/AeD5pybU9s4DKlslO3ed99+P44+cPcCLH5/1fd
        2HPz4/fd+5YzCa85a3/q+8rLucGHHd/+S2w40WsXP+XCzGqd70osxRmJhlrMRcWJAJIP1Zx1
        AwAA
X-CMS-MailID: 20210618144844uscas1p280d192b12fc852b36879565030b13cd6
CMS-TYPE: 301P
X-CMS-RootMailID: 20210614122356uscas1p1cd196d14f778284120dde445dfba4611
References: <20210614122303.154378-1-Niklas.Cassel@wdc.com>
        <CGME20210614122356uscas1p1cd196d14f778284120dde445dfba4611@uscas1p1.samsung.com>
        <20210614122303.154378-2-Niklas.Cassel@wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:23:20PM +0000, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
>=20
> Zone management send operations (BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE
> and BLKFINISHZONE) should be allowed under the same permissions as write(=
).
> (write() does not require CAP_SYS_ADMIN).
>=20
> Additionally, other ioctls like BLKSECDISCARD and BLKZEROOUT only check i=
f
> the fd was successfully opened with FMODE_WRITE.
> (They do not require CAP_SYS_ADMIN).
>=20
> Currently, zone management send operations require both CAP_SYS_ADMIN
> and that the fd was successfully opened with FMODE_WRITE.
>=20
> Remove the CAP_SYS_ADMIN requirement, so that zone management send
> operations match the access control requirement of write(), BLKSECDISCARD
> and BLKZEROOUT.
>=20
> Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
> Cc: stable@vger.kernel.org # v4.10+
> ---
> Changes since v2:
> -None
>=20
> Note to backporter:
> Function was added as blkdev_reset_zones_ioctl() in v4.10.
> Function was renamed to blkdev_zone_mgmt_ioctl() in v5.5.
> The patch is valid both before and after the function rename.
>=20
>  block/blk-zoned.c | 3 ---
>  1 file changed, 3 deletions(-)
>=20
> diff --git a/block/blk-zoned.c b/block/blk-zoned.c
> index 250cb76ee615..0789e6e9f7db 100644
> --- a/block/blk-zoned.c
> +++ b/block/blk-zoned.c
> @@ -349,9 +349,6 @@ int blkdev_zone_mgmt_ioctl(struct block_device *bdev,=
 fmode_t mode,
>  	if (!blk_queue_is_zoned(q))
>  		return -ENOTTY;
> =20
> -	if (!capable(CAP_SYS_ADMIN))
> -		return -EACCES;
> -
>  	if (!(mode & FMODE_WRITE))
>  		return -EBADF;
> =20
> --=20
> 2.31.1

LGTM

Reviewed-by: Adam Manzanares <a.manzanares@samsung.com>=
