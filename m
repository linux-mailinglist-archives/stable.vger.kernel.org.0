Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D1E1C5E13
	for <lists+stable@lfdr.de>; Tue,  5 May 2020 18:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729791AbgEEQ5f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 May 2020 12:57:35 -0400
Received: from mail-eopbgr1300121.outbound.protection.outlook.com ([40.107.130.121]:22048
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729593AbgEEQ5e (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 May 2020 12:57:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcLHCgAE6+hkJ+yAFHd+IsKUQZVOriTwMww+Oc6hTTwk66lbvkeAd6QxU6r0l8koDXYNwAhuGgtNq7yANdqsr2WIZZazlhrO/D82oEWRMHlwncqQ7VvnVEsuBsgSxrO/0bRnTMib9PK5aNKsIftXSh2RYu00U9ktbpDcXl9xeWWpfLOPZdXtqknl8IKCRrk4k+KBSt+9c/LYl19JUgwQBAKt9ql4dL62NyGyGwp/fIfX8OOSmNqDlSmOvzMdgTU3OZV6okvKNW9rGlrCxXrIc2f6/TYj11engY6r7xKkwQLEZbtZrGBc+fkLJn8mCPHV5zncYEJZcLLX9k2cHgteyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+XvLmKtnHFngU0YVDOioPfO7C0J8oVFWi7eBFmbzdI=;
 b=b2BM/QuIMkH+EOFL400LTfwUG4Ved2BC3n00hfDKPQb4+YayNsA+z7FXH9wU+khKZHuriJnUWPjbSzYgAvLAYdRPiRdBc48qVmnXM1Sn0lyAewm+xxaDHcwT8DsJx0IE7U2N8YqZTh4Xtxs4o2W83Js65zvvehQRUb7HVPhtI6dVlcDKkqaFKTyTEGcnctmft9wlcBg9cdZxWtuLLUMCBjoSVt1QbWDd5x2x46kYMVzZ56Ezz0OuEGm3espLMSDcpPFBLEmNtLFiLKiW1uqIBID1sFoOSocuUUGlv7PIibl7xV6Ujhaa9e6gk/OK8zVwrcMkhVq3vwiUnqT73LuG6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=d+XvLmKtnHFngU0YVDOioPfO7C0J8oVFWi7eBFmbzdI=;
 b=PYFHb1OXyqfV4IFdiiyC3VJeedYumNjAzMWeDD3iSWjdvd+SmnDwZpiOWV92lERTv/c6B69sE7iIM3M6s6B0pIwNtT0a1uyY7dMBvh4FkBkKTlW8rEn8zu/i7+wlBEwp8KRec5VoB2llRCvVnJx9yHFp3A0Yfe00i6bjzgsb3Kg=
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b2::12)
 by HK0P153MB0308.APCP153.PROD.OUTLOOK.COM (2603:1096:203:b4::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.6; Tue, 5 May
 2020 16:57:29 +0000
Received: from HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a]) by HK0P153MB0273.APCP153.PROD.OUTLOOK.COM
 ([fe80::2d07:e045:9d5b:898a%2]) with mapi id 15.20.3000.007; Tue, 5 May 2020
 16:57:29 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     Pavel Machek <pavel@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: RE: [PATCH 4.19 11/37] PM: hibernate: Freeze kernel threads in
 software_resume()
Thread-Topic: [PATCH 4.19 11/37] PM: hibernate: Freeze kernel threads in
 software_resume()
Thread-Index: AQHWItYczJvBU24xf0upt/fD9/XJlaiZsm/w
Date:   Tue, 5 May 2020 16:57:29 +0000
Message-ID: <HK0P153MB02735D98EC84BFA89CD86C57BFA70@HK0P153MB0273.APCP153.PROD.OUTLOOK.COM>
References: <20200504165448.264746645@linuxfoundation.org>
 <20200504165449.741334238@linuxfoundation.org> <20200505120956.GA28722@amd>
In-Reply-To: <20200505120956.GA28722@amd>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Owner=decui@microsoft.com;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2020-05-05T16:57:26.4714578Z;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=General;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Application=Microsoft Azure
 Information Protection;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=f5356558-d1c5-47b8-8314-6624f85243e9;
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Extended_MSFT_Method=Automatic
authentication-results: denx.de; dkim=none (message not signed)
 header.d=none;denx.de; dmarc=none action=none header.from=microsoft.com;
x-originating-ip: [2601:600:a280:7f70:cd:5276:efe2:23fa]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: cd2d5060-3a8f-49ba-9894-08d7f1156585
x-ms-traffictypediagnostic: HK0P153MB0308:
x-microsoft-antispam-prvs: <HK0P153MB030866BD6CBFA56FAA6F54C8BFA70@HK0P153MB0308.APCP153.PROD.OUTLOOK.COM>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0394259C80
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Mta44fCgL3mK3eC/imIAWRuw94ULqVA9ummprDZNjK2vc+Tc6AruCPhPFM7qDuvcBAQVq1BkYrqyNBrCvOlaiGEre/WA3NVSD/1WdG4FCcbOOdWybNuqDldCtjCNhXauS9dp8V0snH2TrCHLb/Ma7SBfAd3+cMI8Kax0PDHOvh6s7Vwt9MgnDpEJCGqqCNKhBUaH+rCzhkDPPz3YsNL1Cgz1+2oMTSu3/eD8U05k8U7uZqomUeQOhEXY85iRF4XrooJP4ecPxyLw74VIsPXh9vEeYoCprZgUj9ACzJVqMqjUsrCeFUP/Wi9HtofdummxNuirQsY8pAmDbub+1GF384+kKGOufRByQ1JWtEivJi9iH2wOeATuPBGmTxyqOxSnhJqE928y4nWokd/jLWNb4HidxcoUoY7Cva35PuYclHGZJtJKgOfrwzMCY7Ge0CpnbUWAy0JKNI8oDOjXp6S9rXoq0FIoPLnN12wJdCEgmTx6Riwv+V+nxVTgCNrZ+a9Fa6k2ZpM/ydGzbcuMCwJD6zecs/r+tIBmaD6MAyVyVtlahgRGtAyiGJskiRvumNT21pzRZMbfas/pXg6Nic3T1OL8hzmOz/cmDbI1Lfh0zVCvjpxH2A4ZUZS+snK2uff3HvOFYXlqvkMdypp5naIqWg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HK0P153MB0273.APCP153.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(346002)(366004)(396003)(376002)(39860400002)(33430700001)(186003)(316002)(54906003)(10290500003)(33656002)(966005)(110136005)(86362001)(478600001)(2906002)(66946007)(64756008)(66476007)(7696005)(6506007)(76116006)(53546011)(52536014)(5660300002)(4326008)(66556008)(66446008)(8676002)(8936002)(9686003)(55016002)(82950400001)(82960400001)(8990500004)(71200400001)(33440700001)(30253002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: VTiFcuuojlsl2jIIhhDR8h7z2asldZHi+K8Nt4XP5Zl4V3rlre6z41LsJGy0x1h6PZK+bNiYfJvk3iAZ7Sv/Tyhk1Ve1OmS0l8lSOPWgSD2UKg2D/RJM9kMeWofvyUIqbCBJRo+7p6ii49lV/a4cHFUc//kCKGd5XefsmFtbOUoxvWjN5dGsFGYIN2U1SHrWlFEakJ/oOnPlpj/UL4uwNADz36G/srlFI8rcKKsjDJ/uxjzL+zHChZzrak5AHcBly+Xc52XD7dHQPIpl603+CwvjKzQ+IPoMSjJeTGpYUMVVJ1auFMO6rditzwk5c7/a+mUyF+GfJDuwksxXqysKSkydE+qzeDGm2J34PSoMl0Dg14PsDTAB/czPFPiG8bfyB2u8iECEHIntl+f4iYYL9NHYQKIugsobvljDZvZ5VLzmbXZ6de/jHDwyXJJFBXqCI27bsTKeJiVJcAPMdecRVIc9yrrlnR8s5pDp1in+RPjg2Cz4MgA+QX5J4jQYqPmnsvMmdYXNzoj0wlHuoGlAjUwuYr6a4QCMLXqf4MRFUSadQAytFLZzeLVUNq6dtA9gv4bDk8To78XOBtg7l76DVT7N/Q2qEL/jsJpwhDWfBgu9X0TxQy52VwkDO6Br4SIIgTYmTgfQNmllj70MwgUbYZFU0CbNPPjDQpEE+WbVj/5sk1s+86Ok4FJGSFoP0B9KLSUquD3HNPd0bO5URKMkNdIbeCSf3FsoxcmMeFOYJvpjPnuQnkAKBgj+AH5Og+Ru+y15FOF+3YSgEF8bGDyDL+cv9LyBMYELtPkjeg2pUDTzuIhfmuLV/tp1pe6hgrdB3CT7iLtWL6R4edWmRG3FkxIrqPL/2UjH2FVss2a/BHA=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cd2d5060-3a8f-49ba-9894-08d7f1156585
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 May 2020 16:57:29.2378
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jUIw1x40UePviHcpyevF6JUzS+uX2B9fzGrApsBfQqcK8xvHoAQGu3JskqCDYfILGwfN8QksnWE5HYt63Rw+3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HK0P153MB0308
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> From: Pavel Machek <pavel@denx.de>
> Sent: Tuesday, May 5, 2020 5:10 AM
> To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Dexuan Cui
> <decui@microsoft.com>; Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Subject: Re: [PATCH 4.19 11/37] PM: hibernate: Freeze kernel threads in
> software_resume()
>=20
> Hi!
>=20
> > commit 2351f8d295ed63393190e39c2f7c1fee1a80578f upstream.
> >
> > Currently the kernel threads are not frozen in software_resume(), so
> > between dpm_suspend_start(PMSG_QUIESCE) and resume_target_kernel(),
> > system_freezable_power_efficient_wq can still try to submit SCSI
> > commands and this can cause a panic since the low level SCSI driver
> > (e.g. hv_storvsc) has quiesced the SCSI adapter and can not accept
> > any SCSI commands: https://lkml.org/lkml/2020/4/10/47
> >
> > At first I posted a fix (https://lkml.org/lkml/2020/4/21/1318) trying
> > to resolve the issue from hv_storvsc, but with the help of
> > Bart Van Assche, I realized it's better to fix software_resume(),
> > since this looks like a generic issue, not only pertaining to SCSI.
>=20
> I believe it is too soon to merge this into stable. It is rather big
> hammer. Yes, it is right thing to do. But I'd wait for 5.7 to be
> released before merging it to stable.
>=20
> It needs some testing and it did not get any.
>=20
> Best regards,
> 							Pavel

Hi,
I did do some testing in a Linux VM running on Hyper-V:
Without the patch, I can easily hit the panic I described in the first link
above. With the patch, my Linux VM can hibernate >10K times without
seeing the panic and I don't see any issue caused by the patch.

That being said, I don't mind waiting for 5.7 before we merge the patch
to stable. It would be good for the patch to get more testing from others.

Thanks,
-- Dexuan
