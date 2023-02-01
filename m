Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9984686F06
	for <lists+stable@lfdr.de>; Wed,  1 Feb 2023 20:39:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231704AbjBATje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Feb 2023 14:39:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbjBATjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Feb 2023 14:39:33 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2045.outbound.protection.outlook.com [40.107.220.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43732ED54;
        Wed,  1 Feb 2023 11:39:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JAuSukCEwQTIzswqRwGhWX+RAYTmmAdRmCFlKVqFgsBYPwVAWmZmY9OAXm8WcC370BF2j9VRudXaeDJnXWfbYLbGAQEnHlPZ5BXCt4mQRY6v8dwnATY8s9kC2tPFsNBuBiJ2tnP1qEE5E+XyK432CZ/8Nf20pZu2aRPak/8ZyE1RjOf3xYj17Yap23hhg79Md5J6TMe6AEuIRYF6BXUZvp6ZksCz6qN9XB5qcOA7eIfR4jSClLNh2rS+NE4uIayh3zmMLB4dkBWSCBl/Se4nZMZfSSSX0/dkDae2c93B/SxPaO1lSCrJg13Xnm4G2ohOi9b7SYyz2xlRibk0BVDxDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=fkfDhkHottKswi2uJGViYS7pvnehS0LqjPmRUQkSouI=;
 b=LtNrelR+5okvyNAuGAsvG0S/eKnezKwEWy1ldDFvgXTbT1HoCvW4W+1sz97WOqXWvRFAFJs+/nxJtnsc0kLyrskcUbhyuF+3PuQ1FHL4MmuorJSQ+3exmsP1NT4o8b4Tt6QE+9cmCGvtXf/tEckCtMJoZEUdA+GILbOusrY6K9PDVsePTNXvAwI69QG+pkV9KtzWQa1xteSQpyrkNJ9f/GEeYWUZpb7rVCEcFok8NuH5fNF1HKjif7nDkoJ90lU6dyDpow74BBEXKSzbwWwT9BdJwfMIh1nmJzsWgFZgMqib5Kn05lNuz2AdavFIUcrcaUjXwiEZYyfAlAI+iGSRNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fkfDhkHottKswi2uJGViYS7pvnehS0LqjPmRUQkSouI=;
 b=HLKe8xeAsED7glT2duxu2Lx3C36L5NtX1rEJmvwI6EwLCn77yRWCYxqtFFwSXKvUOIGJqODbzao/NylVdALo0UtQYdeumZt4OUTddsm/PwZxUsfxwekx4UFyjql2/e+jH3sbrAJJVgWfoUBDMdnl0n5BVmg2IVfHJCZsNsAEnxI=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SA0PR12MB7076.namprd12.prod.outlook.com (2603:10b6:806:2d5::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6043.38; Wed, 1 Feb
 2023 19:39:29 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%7]) with mapi id 15.20.6043.036; Wed, 1 Feb 2023
 19:39:29 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Sasha Levin <sashal@kernel.org>,
        "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
CC:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>
Subject: RE: Patch "gpiolib: acpi: Allow ignoring wake capability on pins that
 aren't in _AEI" has been added to the 6.1-stable tree
Thread-Topic: Patch "gpiolib: acpi: Allow ignoring wake capability on pins
 that aren't in _AEI" has been added to the 6.1-stable tree
Thread-Index: AQHZNlxGYWVwehi0BUa0NomsQnXBF666fFiA
Date:   Wed, 1 Feb 2023 19:39:29 +0000
Message-ID: <MN0PR12MB6101CA1D078964276862BBAAE2D19@MN0PR12MB6101.namprd12.prod.outlook.com>
References: <20230201164307.1305059-1-sashal@kernel.org>
In-Reply-To: <20230201164307.1305059-1-sashal@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-02-01T19:39:28Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=513407c8-4ef5-472f-af8a-c7d40a073760;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-02-01T19:39:28Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: 0d26dd1e-a2c8-484a-ac16-2c6dfe3a64c8
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SA0PR12MB7076:EE_
x-ms-office365-filtering-correlation-id: 83581d66-84db-446f-7f1a-08db048c091c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: SVWs5dKBFag2qzxejwoz48XiiTpmTmuSWssUiT9lu+i2zYoSlxYGuhTkM0Mrpn7awidaADKpThHTLzjBg8/EDj3SAGhcZV9cWq4V1c9XjU5ENlhm53BnV4zJZZtDLqW4jgWV3Nrzrw2iSXfi+psDIqVRz4vStr4Qxaix7i/NoOZJyRrw3T1Myz62hrqVdAmAsJvoKSRzEGeJink+HbsuHvcS3mfxIc7ldT2/vN+b/pZf1Vx2Bn1MgP4MP/Xl/m+UwmwtMRequ0uLNV0KT+5rurwdJG1lwWG9mZeZTs2D04hwSvVkGUoDguxc2RuLHp9rdJyl5LsoiF9RwifVX2xge04MBFKW0KNAzfCdXieJNvU+dpNQbgO712ccWj2zb46P4urgZQtIgqcbx9zm/0QJN8EOD1qHCv1hLMZSRUxTIm+MHmtxx0aJuAOVIUvq8GB9QbG3NRS9Q0r0ws8/ckMKHdBduYqArGPbnZLfzZk1IkTzHJ2vK437jNHaSh6O34XAnhMB73BQNt/Ez4uA51XO3hsyN1+cGhfWI1MzjsbZ2XNB+jTemMnuMHbiEbW/YVVXckxOjSqVvDRyUyLKu58qI2jaIlrvhmzwSOZCSFPHuZ9bYrIO9Jw7vw4d0Ux6MvF9x+BPs6k3cpLtA+5faz8lqR8IhGeAVVZfB0ybhBXSBfxd5T/Ecrl5aM4MP/ApOX7zlMRo7Vf1IRvDcpKiizAfk8aYv0+UDehkM+nyhnO/upU=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(376002)(39860400002)(366004)(346002)(136003)(396003)(451199018)(8936002)(52536014)(53546011)(38070700005)(7696005)(54906003)(5660300002)(2906002)(55016003)(71200400001)(33656002)(478600001)(316002)(110136005)(86362001)(6506007)(66446008)(64756008)(966005)(66946007)(66476007)(66556008)(4326008)(83380400001)(8676002)(76116006)(9686003)(186003)(122000001)(41300700001)(38100700002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?sTji5yzK8hDD2bA0/oXNdCoHBlNQx3acSFR2OO4iTI7dzZfuHt8JSxRLAMwQ?=
 =?us-ascii?Q?XHMXQvcw6muaqAaqw7kgVvgNIvyBsc9Dmc7xsZj0L/JMnZesfJoM5R5oxHhF?=
 =?us-ascii?Q?UNoFOQl5FV4SA2nx6SrUSl7qnvyMP5IqLUnnT2tG3GbJs99O9GFz0ohT/Y9m?=
 =?us-ascii?Q?zqTQBkTB5wC3XXZxZZ1Vh/AkADA2Oh3PBRYl73WYavVwlFEn1gBxIiXkSMZi?=
 =?us-ascii?Q?/Eu36bG8lEGsk565Owc9Fu6ovSppRF1UPtzBxezNG+DrhAy1anmt7secqOQD?=
 =?us-ascii?Q?SXs+EvRVLWdyILllee86QbicYiZWNpJzxjHrlG50HyKgJ5nU151RhOuYK78/?=
 =?us-ascii?Q?PwiZG75loItStZ348qPMYaValaCIGkmPtl/Lq1XedWHUNP8b4gj0WgIYs6QS?=
 =?us-ascii?Q?Ez4/+xDWlv+pcTyXgqeL1WbV8yQPPTpIf3qC3XG9B3KNH7l3biAaZvzdRwQ4?=
 =?us-ascii?Q?6DhiVT3DqTEdprq5uMrRSLVVElHRLaZBD4nvQpD1v+rCYs50MVVbfQrreuJd?=
 =?us-ascii?Q?B2yjokCia8uGcbNovXvdhv1lKF/WX25QSWDCAwNd01lq9MMiB+ey9r9Wni16?=
 =?us-ascii?Q?/59VZjtsUW7SBkmygRR5XuBJ+xxYTDpLpe5SAX097ZwpHe4E3qfC27gw6QiX?=
 =?us-ascii?Q?CMfzVdLwcteSUzJBbEFg6hKSev+2H6rqeroeySMf9shNwV6rtkWwzzMn8tVa?=
 =?us-ascii?Q?xyajj53OaTXzcw5W8IdRdriWaH8EBMxAU/hSb4m65TRPotyF0WbO090bZ+lu?=
 =?us-ascii?Q?9qCpBmgmTnrBkYeqSvZE1cffBzH5GdZGnZ5BAfQI9YRU+cOyj8iT5an0zxI2?=
 =?us-ascii?Q?DQJIZtNG/T+AYIeFMqnMJiZdHJg2cCrzbzI9CDmaxLbS8NoX2bRFpsrYKYup?=
 =?us-ascii?Q?x8owzQGaNgAFCj9Pa6n3tQyhRo+mJdl/HA8uH4yhWnVcJhJ57rG++RLORIAg?=
 =?us-ascii?Q?bdwyR72LCoVKIDIxQu3sHg0R+Je1fsVQXOCBZlt41mgDFtnBTEezssCA3Px9?=
 =?us-ascii?Q?KfL7PxqotG5DTze+QgQqxDh+6J17nl7pDjcZlioePYutxd/J8M7L5jBKZA9k?=
 =?us-ascii?Q?i8RmQB8/qX5QWn/GZKM4xQkRM23uvgycNKcbQFcYBufh05UalEyXhVnUrCgC?=
 =?us-ascii?Q?Z01+U3OUlbC6BKCkCZUcpvrna2KqgjkK0vtHqusfewSIK69WGWmjFAiBThiz?=
 =?us-ascii?Q?yvTjbGZMVZA6MO1WQF9RFsXysZkFw34gaUdfF8zuWi2oWsAZ71yYJbSahsiL?=
 =?us-ascii?Q?aGZ/ivh87ShCH6DOwr4CD2vvJk6ME2oHsO4yE7UELnDMe7I7gjFvm/ceKFPc?=
 =?us-ascii?Q?HqkWQSYMt9Dj71NelL8g+1LNX/+Y6hW7AZ9rQlYdmojqIXodAeyec1O7GmQo?=
 =?us-ascii?Q?HVasZ49d1SHWhlhy/fze8+Un1Cqb2j1bjirGt+p/p7dVi6yKm+Xauuwyr+mO?=
 =?us-ascii?Q?cc8JIpoaxT7V/E2h48JsnoHcK0ZHTuHpHIptjG64Cd2e0A8S6w6BFD0qj2zj?=
 =?us-ascii?Q?DuMWEcDx/Cz3NUm4HGfRp0F9fmtVIitJ6u6veAUt/AdIRRtDIFHrslfuZANy?=
 =?us-ascii?Q?rSSAaaa0mv9oTzQ7Q+RHw8f4YExhEACgdIjf2ckgUCIeR01ClpULotjuM/ag?=
 =?us-ascii?Q?ZVLVoK4rDU5qtxZxQIlVprA=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 83581d66-84db-446f-7f1a-08db048c091c
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Feb 2023 19:39:29.7227
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: F866GE5WnY8a5nLISocJsZIVJkZHgdciBnqWMeDEkkz2lJi8TXioiuNly2qyKK3qXBDExxA99/KX9M51Og2Y6g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB7076
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]



> -----Original Message-----
> From: Sasha Levin <sashal@kernel.org>
> Sent: Wednesday, February 1, 2023 10:43
> To: stable-commits@vger.kernel.org; Limonciello, Mario
> <Mario.Limonciello@amd.com>
> Cc: Mika Westerberg <mika.westerberg@linux.intel.com>; Andy Shevchenko
> <andriy.shevchenko@linux.intel.com>; Linus Walleij
> <linus.walleij@linaro.org>; Bartosz Golaszewski <brgl@bgdev.pl>
> Subject: Patch "gpiolib: acpi: Allow ignoring wake capability on pins tha=
t aren't
> in _AEI" has been added to the 6.1-stable tree
>=20
> This is a note to let you know that I've just added the patch titled
>=20
>     gpiolib: acpi: Allow ignoring wake capability on pins that aren't in =
_AEI
>=20
> to the 6.1-stable tree which can be found at:
>     http://www.kernel.org/git/?p=3Dlinux/kernel/git/stable/stable-
> queue.git;a=3Dsummary
>=20
> The filename of the patch is:
>      gpiolib-acpi-allow-ignoring-wake-capability-on-pins-.patch
> and it can be found in the queue-6.1 subdirectory.
>=20
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.

Hi Sasha,

I suggest you also pick up two other fixes to go with this one.

1) this fix which was in the same series:

4cb786180dfb ("gpiolib: acpi: Add a ignore wakeup quirk for Clevo NL5xRU")

2) This fix which is tangentially related (fixes something from the same or=
iginal
series that exposed the regressions).

d63f11c02b8d ("gpiolib-acpi: Don't set GPIOs for wakeup in S3 mode")

>=20
>=20
>=20
> commit 832a64f6e1557e017da518199dcab0e5fdca2808
> Author: Mario Limonciello <mario.limonciello@amd.com>
> Date:   Mon Jan 16 13:37:01 2023 -0600
>=20
>     gpiolib: acpi: Allow ignoring wake capability on pins that aren't in =
_AEI
>=20
>     [ Upstream commit 0e3b175f079247f0d40d2ab695999c309d3a7498 ]
>=20
>     Using the `ignore_wake` quirk or module parameter doesn't work for an=
y
> pin
>     that has been specified in the _CRS instead of _AEI.
>=20
>     Extend the `acpi_gpio_irq_is_wake` check to cover both places.
>=20
>     Suggested-by: Raul Rangel <rrangel@chromium.org>
>     Link: https://gitlab.freedesktop.org/drm/amd/-
> /issues/1722#note_1722335
>     Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>     Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
>     Signed-off-by: Sasha Levin <sashal@kernel.org>
>=20
> diff --git a/drivers/gpio/gpiolib-acpi.c b/drivers/gpio/gpiolib-acpi.c
> index a7d2358736fe..27f234637a15 100644
> --- a/drivers/gpio/gpiolib-acpi.c
> +++ b/drivers/gpio/gpiolib-acpi.c
> @@ -361,7 +361,7 @@ static bool acpi_gpio_in_ignore_list(const char
> *ignore_list, const char *contro
>  }
>=20
>  static bool acpi_gpio_irq_is_wake(struct device *parent,
> -				  struct acpi_resource_gpio *agpio)
> +				  const struct acpi_resource_gpio *agpio)
>  {
>  	unsigned int pin =3D agpio->pin_table[0];
>=20
> @@ -754,7 +754,7 @@ static int acpi_populate_gpio_lookup(struct
> acpi_resource *ares, void *data)
>  		lookup->info.pin_config =3D agpio->pin_config;
>  		lookup->info.debounce =3D agpio->debounce_timeout;
>  		lookup->info.gpioint =3D gpioint;
> -		lookup->info.wake_capable =3D agpio->wake_capable =3D=3D
> ACPI_WAKE_CAPABLE;
> +		lookup->info.wake_capable =3D
> acpi_gpio_irq_is_wake(&lookup->info.adev->dev, agpio);
>=20
>  		/*
>  		 * Polarity and triggering are only specified for GpioInt
