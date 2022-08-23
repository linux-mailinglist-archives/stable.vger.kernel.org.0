Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CDA859EDAB
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 22:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234103AbiHWUnu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 16:43:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231804AbiHWUn1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 16:43:27 -0400
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (mail-bn1nam07on2085.outbound.protection.outlook.com [40.107.212.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B5DC03
        for <stable@vger.kernel.org>; Tue, 23 Aug 2022 13:36:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NLm2Qn4pZ7Mnxz7cBJ4/fTAA6ToUKwgD/4hIv+lamQjix0ho+dmMh9UiaQvsTWk7HXEshDti5mTk5QHoUWuk4VkT+hKz+lIHF9wPnZJ8+Pu77RENVQDgjXpr0ne0b6MSliGnPaCXLmLGzVQO0HjZmfL9X+AflBvZBvlTj0WD/5JDf54ZBIUmcfyu8y4g1n2qYmjgs2FKfeRB4Zee88BiyBDsSZxSa/mKfmXxEUph5a0YU4jB/1i/0SNQmOjGNlqegXcAY5byx44vpVVXo70gVvfCufIYMRRqpU4U/O3HKj5lahRQIy1Y9DQmr8pbEkNJAtelgU1duY5pj0fJf3m6yg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=aAl+9Hys/sn5s9Wc+NKh42cfbtrHX8hLO8Pa+LmK49M=;
 b=Wj+NSkqd4flTzECOl90pGKEXH1tmlTi5peKpXQ87172InbcpAbT8Qm39XYArBVhmmJsQArlfp4+f/9uWnTDSb4KfHBnh0q+wUJD9VZWZncm0YKTmjFqb+3AHEmhary8xMu7yYW/k97ahkXxFC213MyrN6KtA+X+kjv0dK/o9NsQ1KMYuEQLe0M8r4txO2CpbdqyQ34saS3ezokL2rL1Qo6j5O/pPd+Ze67VNaG3UJghkkl8h5Frm5JmkkBYrB1TNKLAwWbIHC/wSeQf4Kp6+45acEjG2SQGlRsdHaO7I6a5ensoHMueauvVl6xb7gU0DAxLXnPXGsxrd50z8abVY/A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aAl+9Hys/sn5s9Wc+NKh42cfbtrHX8hLO8Pa+LmK49M=;
 b=PxlDsl8kE0A/z/gSs2EdI7z/6k0lFTQX0WFDoyO238rQ8zfVDZHiQlAeqYPjD19VDm7102vGPCBS/MkNVlmMMi7OsC+w10EPzLi7w4mBg+Njz4hb7SW33q8/okkUoqLRMl5T7IChky8XqmYJE6JTUhwQTqmD1L2+wrVBOZvpwUE=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY5PR12MB6600.namprd12.prod.outlook.com (2603:10b6:930:40::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5566.14; Tue, 23 Aug
 2022 20:36:20 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::e00a:1f8c:dcd1:afc3%5]) with mapi id 15.20.5546.022; Tue, 23 Aug 2022
 20:36:20 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>
Subject: RE: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore interrupt
 status and wake" failed to apply to 5.10-stable tree
Thread-Topic: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore
 interrupt status and wake" failed to apply to 5.10-stable tree
Thread-Index: AQHYtgMWC1IYx6GQ/0yEgbIX5jx9Ea288ppQ
Date:   Tue, 23 Aug 2022 20:36:20 +0000
Message-ID: <MN0PR12MB610100C31BEDC1E3C46264C6E2709@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <166115772810989@kroah.com>
In-Reply-To: <166115772810989@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-08-23T20:36:11Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=f351863f-2def-4ba9-8c4b-1c2e99ed2323;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-08-23T20:36:18Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: d583afc7-5f20-4cd3-a794-d36f8bc66a70
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b432710e-9190-45da-6e40-08da854722f6
x-ms-traffictypediagnostic: CY5PR12MB6600:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: NpUOAfYuo/M7YMDcZLUsXFcMjaa916tCpkheTzfHT1Flc/wkcZwoetqvKVl1AbKuyyILAr/u2R3gvG6xYinBP10Hs7p9TvXXX8rmtKd4lnsl2yznchWew0JWVmzWqAPMQceejcp1Eo8VjAe3UAiA2y5pMbUO6j/IMI5xPmeHJiTNESnTtKulwMFt7Gv3SRLLlJ+oLo+iaFUg6ncTcNzHtmSFPytdJQW9QGC947MBE7yQJr4eUQG/OF7GVpOsTogW8YU0oOes+ggqLgNq23ssFKmU7WeLEvPnNYvUtallrJvlYYgCVoWaMa6qa5X3u+NRpF2YBHamz6Ohgicv7SHHdRI5ZENPbWaN1SLx9Uejz+DjrApK87Xqb6aN/+5aQiylTELjZ7JItkRqzTUnYti9Zpgtp6JPBvFFJjmZjJSQoQsV39OsBeWvhg3RmIzrkoefPmTk5gObW4R6gzInqM5kisyIejtre0ZVhcwz2luOx8juOu2bpln6bHz+5GIyfw9Noc7Cn6zmLfLvvrYvlH7niJTYyKvOeHJGLRG+PZL/sK7OOs5UWdiybWW/Z6Y+k90D8ij2CgkwqcTHoQJKVP+IsYWtn/q9KNd3NUWqvIIOYqipxeOUnKXNWM9NNivlMjmKgyT26/HDkOd9t92hF7See+CKECPl8QeRmHRh8iXMXrvJCjBN9UWfj6dEhBAe9kGHdo4y1fHvrBtgvxUlF3sKC/j+luHK3ZbDHaO51BCQ9OKoAhQbX6XkWw0fX56mrxgOrmTaqQdVk9weJ2MmNrD19fH0qzuGwWoR0BDYl0yJ2+M=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(346002)(39860400002)(396003)(366004)(136003)(376002)(5660300002)(8676002)(8936002)(316002)(33656002)(4326008)(52536014)(2906002)(9686003)(45080400002)(966005)(71200400001)(110136005)(41300700001)(478600001)(54906003)(26005)(7696005)(53546011)(6506007)(55016003)(38070700005)(38100700002)(86362001)(186003)(83380400001)(122000001)(64756008)(66556008)(66946007)(66446008)(66476007)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?HnvaqqCkvjDR+9HSUDcRmwImPXiDlYpTIJTeh6VKAYhulT246OgS1YAIoj4M?=
 =?us-ascii?Q?gfR34+uKpeEx02AhcGkG7XcaJHMsUd1kTSBbxUJpvyjvh/FHtj3tl6VEuR1v?=
 =?us-ascii?Q?72XLmC1hsnnor/t+fbU/cFSUoNjaYnFe9RDgclRYdf0KxdxVzZCo4Q5WJ0wo?=
 =?us-ascii?Q?F4sW18G5SqSulHlMLiAK9+4sysy+NL73nhelA81xQnzTUqqLjgUZWT8ShE51?=
 =?us-ascii?Q?TKKG22r+WGMF3XSOSbdwVheFjQ3wwhmu7VWYbinDXK9blAbjIZqMRoqgm/dw?=
 =?us-ascii?Q?Scg7p8RkHeA2U/PanSrLriyJzs1VBr4UVELyX9ViGrrVBCfUX+cRYFETvISf?=
 =?us-ascii?Q?CjK3eaCyRE5Ux4lkuLJrTXWZJ5gAkpAOxNcu1V4FWobvm+W1pPWyZD0MTvll?=
 =?us-ascii?Q?60SPQziE/PcVM/gPkPRPnNGYsdlId8H/Xtae8TXTPKCGVQK9gRx5MmZVrTta?=
 =?us-ascii?Q?dm6yVUm30pVM4DTpfqyxhOHFAa+1TxoRGeNrz4Kjxcxbu25QEDSEs+zHuTxy?=
 =?us-ascii?Q?XtKImg0MNrbRKs9L7XEca3zc1RloBkkwxFJH99w3Jmc+lgeedkNH7ps0NT05?=
 =?us-ascii?Q?IIeWR7fW6imyrVOchRK8+B8u8cYvv/0lo3HlWyoc3IgU+GKpktPYl9ajEwOH?=
 =?us-ascii?Q?MDb93f8rd/bqQ4W3hGmhI8gf55DTrJajrRAqT7CQNHiWcUIT+24FRf71+5nQ?=
 =?us-ascii?Q?i599hqsXp3icqPCkHrw2+5veadxGZ/zNUaCRiscMWbNwdg5rZAUrG9QOAnkr?=
 =?us-ascii?Q?INEt+LAEfdYFlqDk8ach3sOiz9M0EKVZScFNrOSrfj1U7FhRn2Vd1+LSqQ/b?=
 =?us-ascii?Q?/4P1yZQ6y1ZYZfp073d+/AHRDYQivpaeU4chfeKzbAKndBHTnhpYbFOBHluE?=
 =?us-ascii?Q?Y5PhGVhXzEq3gcVrdEpkb573kk43qvpFtmB7pq+aH+EhIkek97fxlqliKkUb?=
 =?us-ascii?Q?99/kwyN2HWrZlPDQDW6RwQeycln92Nqu4EFdAOCroe+ntrpd9OIcCFzw2fE2?=
 =?us-ascii?Q?SqjbOZIXufvqMBMsDFTBcXibrCyNYclvghgS52fK6Yfc9Kgs1LdzrSgGALTX?=
 =?us-ascii?Q?GbNQA5zJzoofZ84aIn7nOGRsogdO5Fmeh2FhwOddSSqRtmehxfJMrHzZXXNG?=
 =?us-ascii?Q?V50gV/I4qJrkljf92db4TtIPwpp5msOdFQrkgqVafQMCW/edMo7yxkd/VDuj?=
 =?us-ascii?Q?+kfo0XsRkG/mGLPD6CSqPOfrtXeT8c0l9cKaoF++4Szv8geZpnS0KT1H/Odl?=
 =?us-ascii?Q?nBQElKCONULXP0znwSgkNsHYDdvOQoceHCJj5p6Mmuz++dXv6a/1tP/nsoow?=
 =?us-ascii?Q?MEORmAfRjYq8Ymj6WhtgdRC6YXXm0yb8zgMg5onYrR8uLKQ5A+GZuZ2Te0fm?=
 =?us-ascii?Q?tGavMViwqQktbPBmjeLEvhWvaOc43PSguzmf7C8xJRtTiLqtt9qRgwGa5Knp?=
 =?us-ascii?Q?wkljfdmgCeOyb1jZjCZzd79OsGA0BlLv9v7Wz1WvMTu6F/XH2jlHOZSZyMb0?=
 =?us-ascii?Q?AniltWhBeRUC3cybNxDmdeMgzN1rXf0yG89rjzbgUACG/Dg7gjlaxH3IKdSq?=
 =?us-ascii?Q?BxiaUOon9Oz9pdCyyrI=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b432710e-9190-45da-6e40-08da854722f6
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Aug 2022 20:36:20.1625
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: izl5BaYY4En1YC33Myh/zB+BSNuidNXeuu6Zd+OcWzJw8wEQqu7oXdDUTRJUhLVh8ZHirEtAy6JWpbwSIPHM9Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY5PR12MB6600
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

> -----Original Message-----
> From: gregkh@linuxfoundation.org <gregkh@linuxfoundation.org>
> Sent: Monday, August 22, 2022 03:42
> To: Natikar, Basavaraj <Basavaraj.Natikar@amd.com>;
> linus.walleij@linaro.org; Limonciello, Mario <Mario.Limonciello@amd.com>
> Cc: stable@vger.kernel.org
> Subject: FAILED: patch "[PATCH] pinctrl: amd: Don't save/restore interrup=
t
> status and wake" failed to apply to 5.10-stable tree
>=20
>=20
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I had a look at this and the other ones that failed to apply.  I tried to a=
pply this commit
( commit b8c824a869f220c6b46df724f85794349bafbf23 ) to all of them and then=
 built it.

5.10.y: success
5.4.y: success
4.19.y: success
4.14.y: success
4.9.y: failed

So I'm not sure why the automated stuff failed for you for 4.14.y through 5=
.10.y.

Considering it worked for me and built successfully can you have a try with=
 it again
at least on 4.14.y +?

Thanks,

>=20
> thanks,
>=20
> greg k-h
>=20
> ------------------ original commit in Linus's tree ------------------
>=20
> From b8c824a869f220c6b46df724f85794349bafbf23 Mon Sep 17 00:00:00 2001
> From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
> Date: Mon, 13 Jun 2022 12:11:26 +0530
> Subject: [PATCH] pinctrl: amd: Don't save/restore interrupt status and wa=
ke
>  status bits
>=20
> Saving/restoring interrupt and wake status bits across suspend can
> cause the suspend to fail if an IRQ is serviced across the
> suspend cycle.
>=20
> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
> Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
> Fixes: 79d2c8bede2c ("pinctrl/amd: save pin registers over
> suspend/resume")
> Link:
> https://nam11.safelinks.protection.outlook.com/?url=3Dhttps%3A%2F%2Flore.
> kernel.org%2Fr%2F20220613064127.220416-3-
> Basavaraj.Natikar%40amd.com&amp;data=3D05%7C01%7Cmario.limonciello%4
> 0amd.com%7C19c619f81b23432a6eb608da841a3772%7C3dd8961fe4884e608e
> 11a82d994e183d%7C0%7C0%7C637967545388890457%7CUnknown%7CTWFp
> bGZsb3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVC
> I6Mn0%3D%7C3000%7C%7C%7C&amp;sdata=3DFz3iik5pd2tlwxvCBiA9BNA5gJ2s
> U66y0NqNrrRkpM4%3D&amp;reserved=3D0
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
>=20
> diff --git a/drivers/pinctrl/pinctrl-amd.c b/drivers/pinctrl/pinctrl-amd.=
c
> index e497df89a4a7..9ec97c6db5e9 100644
> --- a/drivers/pinctrl/pinctrl-amd.c
> +++ b/drivers/pinctrl/pinctrl-amd.c
> @@ -918,6 +918,7 @@ static int amd_gpio_suspend(struct device *dev)
>  {
>  	struct amd_gpio *gpio_dev =3D dev_get_drvdata(dev);
>  	struct pinctrl_desc *desc =3D gpio_dev->pctrl->desc;
> +	unsigned long flags;
>  	int i;
>=20
>  	for (i =3D 0; i < desc->npins; i++) {
> @@ -926,7 +927,9 @@ static int amd_gpio_suspend(struct device *dev)
>  		if (!amd_gpio_should_save(gpio_dev, pin))
>  			continue;
>=20
> -		gpio_dev->saved_regs[i] =3D readl(gpio_dev->base + pin*4);
> +		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> +		gpio_dev->saved_regs[i] =3D readl(gpio_dev->base + pin * 4) &
> ~PIN_IRQ_PENDING;
> +		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>  	}
>=20
>  	return 0;
> @@ -936,6 +939,7 @@ static int amd_gpio_resume(struct device *dev)
>  {
>  	struct amd_gpio *gpio_dev =3D dev_get_drvdata(dev);
>  	struct pinctrl_desc *desc =3D gpio_dev->pctrl->desc;
> +	unsigned long flags;
>  	int i;
>=20
>  	for (i =3D 0; i < desc->npins; i++) {
> @@ -944,7 +948,10 @@ static int amd_gpio_resume(struct device *dev)
>  		if (!amd_gpio_should_save(gpio_dev, pin))
>  			continue;
>=20
> -		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin*4);
> +		raw_spin_lock_irqsave(&gpio_dev->lock, flags);
> +		gpio_dev->saved_regs[i] |=3D readl(gpio_dev->base + pin * 4)
> & PIN_IRQ_PENDING;
> +		writel(gpio_dev->saved_regs[i], gpio_dev->base + pin * 4);
> +		raw_spin_unlock_irqrestore(&gpio_dev->lock, flags);
>  	}
>=20
>  	return 0;
