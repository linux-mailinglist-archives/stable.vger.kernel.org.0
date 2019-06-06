Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43B5E36ED2
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 10:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfFFIh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 04:37:28 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55533 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbfFFIh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 04:37:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1559810248; x=1591346248;
  h=from:to:cc:subject:date:message-id:references:
   content-transfer-encoding:mime-version;
  bh=syI9k+j/TQ+nhb0pyBRJQv8Kzc3fG/SBH1U49ViEndM=;
  b=bnHAhLK5sfCyA/WUjcaFhPder/6lYIB4Lj5br4o1h8cUKm+om4LJLiC+
   DB2I6a59lRB40J6Q5kIDcCqSlrZjvzsDzhcG42vgkVTh1MJrzVbF1bH60
   COaWcENaVJtbZIicW2139rEAPcY2cRehfovDSJkPEGr4S8IiMl984ctpE
   sAbWBocpOXCSyK+KyEv96YzHlzGPVWaLEUncdx42RYaR+H3wDPWnLN4rj
   YXsEfzqTWhaBmAU9Eu+EhGgpay6qtXoAu6KmoLgKNdvYXGUpOqlExLzQ+
   2q0/TbDw63xK6QU/6FQpFrSZHawT7CFRo7AauNJsyUV+wj8eOlx8oK1Rw
   A==;
X-IronPort-AV: E=Sophos;i="5.63,558,1557158400"; 
   d="scan'208";a="209559276"
Received: from mail-sn1nam02lp2054.outbound.protection.outlook.com (HELO NAM02-SN1-obe.outbound.protection.outlook.com) ([104.47.36.54])
  by ob1.hgst.iphmx.com with ESMTP; 06 Jun 2019 16:37:29 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=sharedspace.onmicrosoft.com; s=selector2-sharedspace-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FVc3KQwx7PS0hZc5QNDsslpGEfHxZ4AsSkqRAfRpaMI=;
 b=Ko70FNTvnQnZEc5F0yE5cWV5Q3JVQKBEHDc+Ah3TPlIQVVu4ugz5kRWOloi+H8Ae8lZM7mhXuW0qdXDmW0TJBriW6rYYyLUajaSl/I2UirWivhgkXTcuVrNMIIv3XjiB1ktTcGXu0ubxcDKfbDG95NN3TgpgR0cIWS3dcEuKuvQ=
Received: from SN6PR04MB5231.namprd04.prod.outlook.com (20.177.254.85) by
 SN6PR04MB4286.namprd04.prod.outlook.com (52.135.72.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.12; Thu, 6 Jun 2019 08:37:26 +0000
Received: from SN6PR04MB5231.namprd04.prod.outlook.com
 ([fe80::903a:ddca:14af:4b90]) by SN6PR04MB5231.namprd04.prod.outlook.com
 ([fe80::903a:ddca:14af:4b90%7]) with mapi id 15.20.1943.023; Thu, 6 Jun 2019
 08:37:26 +0000
From:   Naohiro Aota <Naohiro.Aota@wdc.com>
To:     Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
CC:     David Sterba <dsterba@suse.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] btrfs: fix out-of-bounds access in property handling
Thread-Topic: [PATCH] btrfs: fix out-of-bounds access in property handling
Thread-Index: AQHVHDzV3WhxsyP3oEe92Vdx99tOgA==
Date:   Thu, 6 Jun 2019 08:37:25 +0000
Message-ID: <SN6PR04MB52317231AFA95217DBC107238C170@SN6PR04MB5231.namprd04.prod.outlook.com>
References: <20190606074925.12375-1-naohiro.aota@wdc.com>
 <3d3e1b3f-c36b-88e4-7e13-6dab29404a19@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Naohiro.Aota@wdc.com; 
x-originating-ip: [199.255.47.8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 41893798-e494-48d2-4c5e-08d6ea5a3402
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:SN6PR04MB4286;
x-ms-traffictypediagnostic: SN6PR04MB4286:
wdcipoutbound: EOP-TRUE
x-microsoft-antispam-prvs: <SN6PR04MB428647A485A2AF714755DA468C170@SN6PR04MB4286.namprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(396003)(346002)(366004)(39860400002)(136003)(376002)(199004)(189003)(14444005)(99286004)(86362001)(305945005)(55016002)(476003)(7696005)(446003)(81166006)(76176011)(66556008)(8676002)(6116002)(7736002)(5660300002)(6506007)(486006)(3846002)(256004)(53546011)(76116006)(186003)(52536014)(54906003)(66946007)(102836004)(4326008)(25786009)(316002)(71200400001)(71190400001)(73956011)(9686003)(6436002)(64756008)(229853002)(26005)(66446008)(2501003)(6246003)(8936002)(81156014)(478600001)(110136005)(91956017)(66066001)(2906002)(72206003)(66476007)(53936002)(68736007)(74316002)(33656002)(14454004);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR04MB4286;H:SN6PR04MB5231.namprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: hu6oXqtBrXsdP9hxgG+KGR7UIJPZnEBecDBjDX2vk0DV5zOlZuulT1S+yPSXkWFnoWBhkicYGxqPH9OnEf0RNTa00QMHsn0i3aOgCbrgTAYNLovZkcaYBGeooN8BBCOZuHsWYCy94z0YbxecD7l+XkHN+d48v77cIyS0GN7LvssgJ+/u1a/pZ+03ZYnFIXOQyWhJHhKTcJ6keXxYESAZzTCRCv/NeX0mU2GTwfztvjo40ndc7FDXufrOCFFLtmzfzA3NdKw2kZxZnaKHRpwQnbM2ig7cV2oIogHCuy26iv6E6r9ybwRRJ7dH0KH03enSE24aB/HGfRuUSOxbuAU3GfZoV2mWFo0tC8AI4kCp42ER5Bi89PXwSJVrKIjTRC0dNr+2wvZPyrsAlN0jKQyoj0z0+xEwtT2zL8CzypA5Q94=
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: wdc.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 41893798-e494-48d2-4c5e-08d6ea5a3402
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 08:37:25.8936
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b61c8803-16f3-4c35-9b17-6f65f441df86
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Naohiro.Aota1@wdc.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR04MB4286
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2019/06/06 17:05, Nikolay Borisov wrote:=0A=
> =0A=
> =0A=
> On 6.06.19 =C7. 10:49 =DE., Naohiro Aota wrote:=0A=
>> xattr value is not NULL-terminated string. When you specify "lz" as the=
=0A=
>> property value, strncmp("lzo", value, 3) will try to read one byte after=
=0A=
>> the value buffer, causing the following OOB access. Fix this out-of-boun=
d=0A=
>> by explicitly check the required length.=0A=
>>=0A=
 >>(snip)=0A=
>>=0A=
>> Fixes: 272e5326c783 ("btrfs: prop: fix vanished compression property aft=
er failed set")=0A=
>> Fixes: 50398fde997f ("btrfs: prop: fix zstd compression parameter valida=
tion")=0A=
>> Cc: stable@vger.kernel.org # 4.14+: 802a5c69584a: btrfs: prop: use commo=
n helper for type to string conversion=0A=
>> Cc: stable@vger.kernel.org # 4.14+: 3dcf96c7b9fe: btrfs: drop redundant =
forward declaration in props.c=0A=
>> Cc: stable@vger.kernel.org # 4.14+=0A=
>> Signed-off-by: Naohiro Aota <naohiro.aota@wdc.com>=0A=
> =0A=
> We caught that one yesterday and were testing various fixes for it=0A=
> Johannes just sent his version which IMO makes the code a bit more=0A=
> maintainable.=0A=
> =0A=
=0A=
yeah, that looks good to me. It's much more easy to add new compression =0A=
type. Please pick that one.=0A=
=0A=
> =0A=
>> ---=0A=
>>   fs/btrfs/props.c | 12 ++++++------=0A=
>>   1 file changed, 6 insertions(+), 6 deletions(-)=0A=
>>=0A=
>> diff --git a/fs/btrfs/props.c b/fs/btrfs/props.c=0A=
>> index a9e2e66152ee..428141bf545d 100644=0A=
>> --- a/fs/btrfs/props.c=0A=
>> +++ b/fs/btrfs/props.c=0A=
>> @@ -257,11 +257,11 @@ static int prop_compression_validate(const char *v=
alue, size_t len)=0A=
>>   	if (!value)=0A=
>>   		return 0;=0A=
>>   =0A=
>> -	if (!strncmp("lzo", value, 3))=0A=
>> +	if (len >=3D 3 && !strncmp("lzo", value, 3))=0A=
>>   		return 0;=0A=
>> -	else if (!strncmp("zlib", value, 4))=0A=
>> +	else if (len >=3D 4 && !strncmp("zlib", value, 4))=0A=
>>   		return 0;=0A=
>> -	else if (!strncmp("zstd", value, 4))=0A=
>> +	else if (len >=3D 4 && !strncmp("zstd", value, 4))=0A=
>>   		return 0;=0A=
>>   =0A=
>>   	return -EINVAL;=0A=
>> @@ -281,12 +281,12 @@ static int prop_compression_apply(struct inode *in=
ode, const char *value,=0A=
>>   		return 0;=0A=
>>   	}=0A=
>>   =0A=
>> -	if (!strncmp("lzo", value, 3)) {=0A=
>> +	if (len >=3D 3 && !strncmp("lzo", value, 3)) {=0A=
>>   		type =3D BTRFS_COMPRESS_LZO;=0A=
>>   		btrfs_set_fs_incompat(fs_info, COMPRESS_LZO);=0A=
>> -	} else if (!strncmp("zlib", value, 4)) {=0A=
>> +	} else if (len >=3D 4 && !strncmp("zlib", value, 4)) {=0A=
>>   		type =3D BTRFS_COMPRESS_ZLIB;=0A=
>> -	} else if (!strncmp("zstd", value, 4)) {=0A=
>> +	} else if (len >=3D 4 && !strncmp("zstd", value, 4)) {=0A=
>>   		type =3D BTRFS_COMPRESS_ZSTD;=0A=
>>   		btrfs_set_fs_incompat(fs_info, COMPRESS_ZSTD);=0A=
>>   	} else {=0A=
> =0A=
> This seems redundant as ->validates is supposed to always be called=0A=
> before calling ->apply.=0A=
> =0A=
=0A=
Indeed.=0A=
