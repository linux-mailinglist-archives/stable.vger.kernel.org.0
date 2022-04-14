Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917DB501E1B
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 00:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344220AbiDNWPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 18:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238638AbiDNWPC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 18:15:02 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2068.outbound.protection.outlook.com [40.107.223.68])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C221BA317;
        Thu, 14 Apr 2022 15:12:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hjJl0Uk85izNsDOuwfeGm1nelh6UJP6LREg6jpkv8ix6g8qthIssYV6xVPBGOaGImrJiiERIuR5DsPU6QlPQYXDl0xV4wvw0tBpTOAzX5jLYJ0+sMKHVs3Mal7NV7ZFd4M4mRbxrQ99vC/pRnPfy6VzLEpqMvGIuKUsJYiw94Gilqk18DvjocC6EwnzM4ruKxMA5Rv0tVPDqnjZtCX5kZLKtD3jCaB8UC+1+UZdMih/j4dOaqWaXq0hppFrxHDvEUETA/yG0Q++oxKT3DYazc8OSWAIOT/o7mLofqCadshU1TK1b+iISMTJ3vtRgCiu8IIuKgBd5dv2gVF0KeoqfMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QfBSTnHUdOHGIzPwxe3u02YHJmnWhCtE1GE+iIS+VbU=;
 b=H1oizyXPTCKEijJtLPtuzn77X0fdRb2VMg/ys7kBn9rl7Lh5w5jIebJDU5cUYBlPXemE5mTEA7FpLAUeBmSkAtcPnLl/S7NJxMGBPBUj7nORBWfx+kua97U0usKqB+EzEy7nZF+T9wnI0MkSQxU4FoeQTAJbQGx50ie69bf4UCG42r5qzTei84lyb4vtgnPyh8VYLz8y9bfKLtRYPluFXoZ5/lAHKSpfr0RApTElV4ZOEUpXB2Qn72hX7soQLS7bQ2WOV0f6XqahpFQhlloQweg7UJxITiXAwfpgqbW2kgL8vvJM2b8JdinqcIuO6KAz3kooEer7lUyGe6+nl3JF6A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QfBSTnHUdOHGIzPwxe3u02YHJmnWhCtE1GE+iIS+VbU=;
 b=KzieGbFT4+OlyiGAwgefgxmFRna/5RydUklMmqYNjGAbe+owgUWs4wYlkfU18W4Wp74KfPvDPjuN8ltOy+1hu1M5aZfA0HITWUbQysKq2h45/5WPNaa6qUjEYQuDUQ6K0YisvCwhZIvxtejj1EMi++Esa7SZeqy+M8xpGEYbJ1o=
Received: from BL1PR12MB5157.namprd12.prod.outlook.com (2603:10b6:208:308::15)
 by DM6PR12MB3068.namprd12.prod.outlook.com (2603:10b6:5:3e::25) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Thu, 14 Apr
 2022 22:12:31 +0000
Received: from BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603]) by BL1PR12MB5157.namprd12.prod.outlook.com
 ([fe80::3157:3164:59df:b603%7]) with mapi id 15.20.5164.018; Thu, 14 Apr 2022
 22:12:31 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     Linus Walleij <linus.walleij@linaro.org>,
        Marc Zyngier <maz@kernel.org>
CC:     Shreeya Patel <shreeya.patel@collabora.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>,
        "Natikar, Basavaraj" <Basavaraj.Natikar@amd.com>
Subject: RE: Broken GPIO IRQ mappings in 5.18-rc2
Thread-Topic: Broken GPIO IRQ mappings in 5.18-rc2
Thread-Index: AdhPmoYGuKdCoNM9R5SwKUX4ClBqjQAsCaEAAAB5dBA=
Date:   Thu, 14 Apr 2022 22:12:31 +0000
Message-ID: <BL1PR12MB51575BDBF12135D57A91CB16E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com>
References: <BL1PR12MB51577A77F000A008AA694675E2EF9@BL1PR12MB5157.namprd12.prod.outlook.com>
 <CACRpkdbjkC6r4Npg_DJSDD9JOZ0R4aWBc5qQYnQThqYTt2KniQ@mail.gmail.com>
In-Reply-To: <CACRpkdbjkC6r4Npg_DJSDD9JOZ0R4aWBc5qQYnQThqYTt2KniQ@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2022-04-14T22:11:24Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=57453391-d753-4b4d-bd6b-ecf36937c5b5;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2022-04-14T22:12:29Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: a22d8b0a-4993-4efb-83cb-4d28269b332b
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 2c6a9a34-11cb-487a-f362-08da1e63deda
x-ms-traffictypediagnostic: DM6PR12MB3068:EE_
x-microsoft-antispam-prvs: <DM6PR12MB306848052FE4A6880AF22FFFE2EF9@DM6PR12MB3068.namprd12.prod.outlook.com>
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nOBSKj1Vyt8T/AX6iJbK1YlKSWZzjFL6auYuwdL8wg0qbYk1Z4uCkpwM7K2PCEu/0gYMtc62+sT2Qw7g9iL3sk4koygBL9DrqG7OckhbaK7zfOAmwmEyBPJT6JxE8SLfYsSO3yp9cDnqInzyeRygBxoF4qpkB/KQHiYhePgR7r+gTYdrkHsttzgTTT5nIaLEFqWiewKB9ad0bM4bSUipnzTeEdRvbPK7LeoLNy04zMKt2wkDSPTCx84hVphFvOTR4LyAJsbZQNYf/RDyxG3nCBPqzSq8IkxHGUm+9oNNFcTfyIzrVUrh1/9MLs7gSZ/YJJlkLEOZtQU2DQxMp9SPw0LPz0FXOMozfLWamlucEeTyKt4tupKA+1JsM4W7xwUQOmwp6dZjvYej1E+M5q5UNhU8lENFgaU5UHderqCFMFxICGW0sky541Dw8qMNVO3zZjmqktK2H/3xvuvf9Fmqan8xJu4CZ7aZPwVZD6CH865B0dUaB2ahPFwzgMe10BP2USJuRO6YsI+rXhLZmsEFc3iScAAargREgqc2KXR8C37yaervvIPbWcAo5Z++Q/rK/SIGzmcCiUszfsBFOd9Rad8QpYwlrfRt4GlOw1CZ3GjShYJtoXRBWh84kLih9s2VA/NY8t/XEz60KkOoYwegXjK+6UyLuiFGfGtlBjtjieeUeAfv24VoYqI3+wjqs7gtiYUaUtngJ022fzKH+o/5mMXt0qoVcOFMf94XDO0AflzxlY1eRhVACj/wJIWvL+M2a6iFtYDjwGZvZxZEOIpzzPMcVQDsMX8wb6efs2wHAYw=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5157.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(86362001)(7696005)(9686003)(83380400001)(64756008)(8676002)(66556008)(66946007)(66446008)(76116006)(66476007)(33656002)(53546011)(186003)(508600001)(966005)(4326008)(8936002)(2906002)(122000001)(55016003)(110136005)(6506007)(316002)(5660300002)(38100700002)(38070700005)(52536014)(54906003)(71200400001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?SGJUT2NNQ1FFRUxwbjZHTUpiQ2xCc1dnY0hQV05UYUYzdkQ4VTYrL0lVQlBJ?=
 =?utf-8?B?enZLQURoanU3NXhna2MrOVF4NXdlZkh0OVpCcVFmOC9ZRWhCTVpPSDRzNTRY?=
 =?utf-8?B?V2ExWGhNS1J3TWMydjNtdVoyaXVRbmMrR2NwWWprWGpObGFhWllFKzhYeDRE?=
 =?utf-8?B?T3M3dFFwcVFVTkVNUVRxWGpVUXhvTHN2NWQrc0R1M3Z1eG5lR0EzN3BNbXVv?=
 =?utf-8?B?bkFFQkxGN1FTbkFna0MyaXNkWFMzYWxBSmQ3azJYY3pHMkh5VTBXR0JoY0h4?=
 =?utf-8?B?SHVVS3U1Ky9LWm5NNDdsL1ZjTUNTcld6V2ViT1BzZUFuTWcveUFWVkVzNkVT?=
 =?utf-8?B?TVFmMWx1NXM2UE9veFQwNWF3b2IvbnZXUUhmOHdtMEJ6cjlmTVQ0ZzVpRjBi?=
 =?utf-8?B?VTh0ZXZ5MU1wZ2tJY3hWaTdQaWc0TnVTaXdCQWsvdGV5aUdlYkd4Q0xrVk5n?=
 =?utf-8?B?UzBFc2k2RnV2VDg2MzhtRmZ3am9lUVE5Wk15czF5QjR2RXZrejNvODJyZm9M?=
 =?utf-8?B?VnRsVzZWam1uYXREdHJSaDd3RE9RNFozZWRLNTRTZXJXNDZFZkM3clhZNHhV?=
 =?utf-8?B?WXBpTTlJSVhjcStBbWQzTnJYejdFWmlSS0xUT1A3d3NLRVZsVExFRU5TV2Fu?=
 =?utf-8?B?b210NU55ckxFcTFzTFZ5MW9ocHRFNkdhOEdXOXZjRmRWTFIrM0ZZQ2NaeUVZ?=
 =?utf-8?B?SEcxdDdWK0VlVTZSQUNoWExoQWU0ckFzNUlmdml5K2RFL1YxVWt2bHpndE1P?=
 =?utf-8?B?UHVSN0tTNnFhenAxNGROSTFzNDVCVEhEZDhIQURCZmJGUGE4c1YxZDN5Snkv?=
 =?utf-8?B?UDl1RVcwSVRoOGlUZXZiZlN0aEZGRnhQWUFmSHBLMVp6bUFaNXBOUlZveFpk?=
 =?utf-8?B?cytCb3REcmkxWE9LS00vMXhMZWxubkZ0L1orNXJMZTVXSDJEcDZrUVFzSG53?=
 =?utf-8?B?a3ExTWZRd1RLRi9QWkVUSGh4RGFkMVVkb29tcHN2dXJVQjVqKzRjSjlzZ3g3?=
 =?utf-8?B?cU9jdWFZc1lhTDdZaTN0NU0rRDJCR2FTVzVEZXZSbEdGSFk3bDhEWTZQZFNx?=
 =?utf-8?B?OVFXMjJqL0NRUzJTcVUrbzQ3c3dNRi9LV0U2Ky83VU4zeWszQW82VVJXRDRj?=
 =?utf-8?B?Um1zTkI3dkgwd2hubjZPMWRKZWc1VVppN0MvN2EyWm45ejQyVUdDSDdaZGFq?=
 =?utf-8?B?MTU0OUQycGhxd1Q3ZjltUWN3WmRES2d1R0lCMWp6UmdvdkZiUGIxQXhOeUdw?=
 =?utf-8?B?V3hqL3p1UWpodEcxT2FSckEyLzNKSG9IeWFsZW1POXA2c2c4dllOTjdlRnh5?=
 =?utf-8?B?YTVsNlh4aEZZbEw2b2xaNXdYNkxpVHA5ZXUrdnRMb3dtazZsL2RHM041STN0?=
 =?utf-8?B?TTZxUDk3dUlKUjZxZjRlWDA1M2VMSi9ZNk9Ba0R5SCtyNDdTcnlZV3NhTS9G?=
 =?utf-8?B?SHJmaXE3UXBSa0M1cGkxNXNkbldEaFl1cXBpSE5GMHpEQ0pQWDlpZ2Z1Wi9U?=
 =?utf-8?B?M0l2RlZQSjE4ZkVOZmZoUEVYcXJ6c25zQjVENlBRUVcwSDFoUkljbEhtNG94?=
 =?utf-8?B?L2dQVWpxbmM1dmdZaDNYTUNhekM1aVhyWGNQaGRIOEwrM3NCM3l5NEJKTW9B?=
 =?utf-8?B?UGcrOURHNi9oL2dnaGRMZG5HQXBOYjc4b24yKzNJT1p3RW9Tb2hCSWZpSGRX?=
 =?utf-8?B?N3ZpcUtCL2V1enVmWi9rWG9DY2hzSG85cUs1RnhQbTRoQ21NeUVrRHVMWTZ6?=
 =?utf-8?B?UXJYTnZtMWVRSm93SGtGRUVSa2ROa1NrT3NvSzVJUVVPc05pdWtEUFBZeUk5?=
 =?utf-8?B?cVdnTVVNS255OXl5WjI2MS8reWFOUWRXSDFTb3FVbEgxU0JDdjZycE1pN0VK?=
 =?utf-8?B?ZTJFY0ZCUWdISWQ0Z29KMkUyWC9NWFhqVURkK1R5VC92Y0MrRzZleHhIY3Z2?=
 =?utf-8?B?TDROM3dOZzBnazNaUWtPTnFmMXVqSmhRNVQxVjRRSkdCcFk2dmJQWkMzdEFL?=
 =?utf-8?B?R1ROSVRyQjJRejZiTW1MdktSWVZDaXlOdEZSK0paV29UZ3F5VGh4MUJVYVhE?=
 =?utf-8?B?dC8zVFJRV0hlMHhXRXRHNkZ5VGhvazY0eStLQzAwcVhhUTkrRzl3cVo0SmEz?=
 =?utf-8?B?akx3b3ZPYXhrQ2VmNkxsY1RWcWgvVURCTytVK0swNTlKNDdHdWliWGdDQ2RM?=
 =?utf-8?B?OUl1em1id3FadTVRdm81YlBCWWhJWE01MVZrS3lzRk1zclk1YUFRMXVkRXRB?=
 =?utf-8?B?WmJNM0FxRThXTWRvRkNUK3JZL3krS2xnVkVNVUNIMHlsL29oY1d2cjR0S2xC?=
 =?utf-8?B?ZHBtM21sNlFWYzFoMFgvOGFleHE0Z0I1cXlzNTR5ZU9kdktKemJMNWMxSFdV?=
 =?utf-8?Q?UZY59HqG+iQ7A9JNeLfQS5oZhzJ52ymxaNF3oU7WtfwRR?=
x-ms-exchange-antispam-messagedata-1: XO1d80eksfL4mA==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5157.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c6a9a34-11cb-487a-f362-08da1e63deda
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2022 22:12:31.4102
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MQbloQYV/7P+c15d9F7VkYwBjpOmqEWQ/Vsa6r3MhsuJ5nvYK/tLkI5XJjAOo+TOOwZBtmz0vN4WHy65Jsed9A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR12MB3068
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

W1B1YmxpY10NCg0KDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogTGlu
dXMgV2FsbGVpaiA8bGludXMud2FsbGVpakBsaW5hcm8ub3JnPg0KPiBTZW50OiBUaHVyc2RheSwg
QXByaWwgMTQsIDIwMjIgMTY6NTgNCj4gVG86IExpbW9uY2llbGxvLCBNYXJpbyA8TWFyaW8uTGlt
b25jaWVsbG9AYW1kLmNvbT47IE1hcmMgWnluZ2llcg0KPiA8bWF6QGtlcm5lbC5vcmc+DQo+IENj
OiBTaHJlZXlhIFBhdGVsIDxzaHJlZXlhLnBhdGVsQGNvbGxhYm9yYS5jb20+OyBzdGFibGVAdmdl
ci5rZXJuZWwub3JnOw0KPiBBbmR5IFNoZXZjaGVua28gPGFuZHkuc2hldmNoZW5rb0BnbWFpbC5j
b20+OyBCYXJ0b3N6IEdvbGFzemV3c2tpDQo+IDxicmdsQGJnZGV2LnBsPjsgb3BlbiBsaXN0OkdQ
SU8gU1VCU1lTVEVNIDxsaW51eC1ncGlvQHZnZXIua2VybmVsLm9yZz47DQo+IG9wZW4gbGlzdCA8
bGludXgta2VybmVsQHZnZXIua2VybmVsLm9yZz47IEdvbmcsIFJpY2hhcmQNCj4gPFJpY2hhcmQu
R29uZ0BhbWQuY29tPjsgTmF0aWthciwgQmFzYXZhcmFqDQo+IDxCYXNhdmFyYWouTmF0aWthckBh
bWQuY29tPg0KPiBTdWJqZWN0OiBSZTogQnJva2VuIEdQSU8gSVJRIG1hcHBpbmdzIGluIDUuMTgt
cmMyDQo+IA0KPiBPbiBUaHUsIEFwciAxNCwgMjAyMiBhdCAzOjIxIEFNIExpbW9uY2llbGxvLCBN
YXJpbw0KPiA8TWFyaW8uTGltb25jaWVsbG9AYW1kLmNvbT4gd3JvdGU6DQo+IA0KPiA+IFtQdWJs
aWNdDQo+ID4NCj4gPiBIaSwNCj4gPg0KPiA+IEkgbm90aWNlZCBvbiBhIHZhcmlldHkgb2YgbWFj
aGluZXMgdGhhdCBwb3dlciBidXR0b24gd2Fzbid0IHdvcmtpbmcNCj4gYW55bW9yZSBzdGFydGlu
ZyB3aXRoIDUuMTgtcmMyLg0KPiA+IEluIGRpZ2dpbmcgZGVlcGVyLCBJIG5vdGljZSB0aGF0IGEg
bmV3IGVycm9yIGlzIGludHJvZHVjZWQgYXMgd2VsbCBkdXJpbmcNCj4gYm9vdHVwOg0KPiA+DQo+
ID4gWyAgICAwLjY4ODMxOF0gYW1kX2dwaW8gQU1ESTAwMzA6MDA6IEZhaWxlZCB0byB0cmFuc2xh
dGUgR1BJTyBwaW4gMHgwMDAwIHRvDQo+IElSUSwgZXJyIC01MTcNCj4gPiBbICAgIDAuNjg4MzM3
XSBhbWRfZ3BpbyBBTURJMDAzMDowMDogRmFpbGVkIHRvIHRyYW5zbGF0ZSBHUElPIHBpbiAweDAw
MkMgdG8NCj4gSVJRLCBlcnIgLTUxNw0KPiA+IFsgICAgMC42ODgzNDhdIGFtZF9ncGlvIEFNREkw
MDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluIDB4MDAzRCB0bw0KPiBJUlEsIGVy
ciAtNTE3DQo+ID4gWyAgICAwLjY4ODM1OV0gYW1kX2dwaW8gQU1ESTAwMzA6MDA6IEZhaWxlZCB0
byB0cmFuc2xhdGUgR1BJTyBwaW4gMHgwMDNFIHRvDQo+IElSUSwgZXJyIC01MTcNCj4gPiBbICAg
IDAuNjg4MzY5XSBhbWRfZ3BpbyBBTURJMDAzMDowMDogRmFpbGVkIHRvIHRyYW5zbGF0ZSBHUElP
IHBpbiAweDAwM0EgdG8NCj4gSVJRLCBlcnIgLTUxNw0KPiA+IFsgICAgMC42ODgzNzldIGFtZF9n
cGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluIDB4MDAzQiB0bw0K
PiBJUlEsIGVyciAtNTE3DQo+ID4gWyAgICAwLjY4ODM4OV0gYW1kX2dwaW8gQU1ESTAwMzA6MDA6
IEZhaWxlZCB0byB0cmFuc2xhdGUgR1BJTyBwaW4gMHgwMDAyIHRvDQo+IElSUSwgZXJyIC01MTcN
Cj4gPiBbICAgIDAuNjg4Mzk5XSBhbWRfZ3BpbyBBTURJMDAzMDowMDogRmFpbGVkIHRvIHRyYW5z
bGF0ZSBHUElPIHBpbiAweDAwMTEgdG8NCj4gSVJRLCBlcnIgLTUxNw0KPiA+IFsgICAgMC42ODg0
MTBdIGFtZF9ncGlvIEFNREkwMDMwOjAwOiBGYWlsZWQgdG8gdHJhbnNsYXRlIEdQSU8gcGluIDB4
MDAxMiB0bw0KPiBJUlEsIGVyciAtNTE3DQo+ID4gWyAgICAwLjY4ODQyMF0gYW1kX2dwaW8gQU1E
STAwMzA6MDA6IEZhaWxlZCB0byB0cmFuc2xhdGUgR1BJTyBwaW4gMHgwMDA3IHRvDQo+IElSUSwg
ZXJyIC01MTcNCj4gPg0KPiA+IEl0IGxvb2tzIGxpa2UgSVJRcyBhcmVuJ3QgZ2V0dGluZyBhc3Np
Z25lZCB0byB0aGUgR1BJTyBwaW5zIGFueW1vcmUgYW5kDQo+IGluc3RlYWQgc2hvd2luZyB0aGlz
IGRlZmVycmVkIHByb2JpbmcgbWVzc2FnZSBpbiA1LjE4LXJjMi4NCj4gPiBJIGJpc2VjdGVkIGFu
ZCBjb25maXJtZWQgaXQncyBjYXVzZWQgYnkNCj4gPiBjb21taXQgNTQ2NzgwMWYxZmNiZGM0NmJj
NzI5OGE4NGRiZjNjYTFmZjJhNzMyMCAoImdwaW86IFJlc3RyaWN0IHVzYWdlDQo+IG9mIEdQSU8g
Y2hpcCBpcnEgbWVtYmVycyBiZWZvcmUgaW5pdGlhbGl6YXRpb24iKQ0KPiA+DQo+ID4gSSBkb24n
dCBzZWUgdGhhdCBwcm9iaW5nIGV2ZXIgZ2V0cyBhIGNoYW5jZSB0byBydW4gYWdhaW4gdGhvdWdo
IGFzIGl0IGp1c3QNCj4gc2hvd3MgdGhlIGRldl9lcnIgYW5kIHJldHVybnMgQUVfT0sgZm9yIHRo
ZQ0KPiA+IGZ1bmN0aW9uIHRoYXQgd2Fsa3MgX0FFSSAoYWNwaV9ncGlvY2hpcF9hbGxvY19ldmVu
dCkuDQo+ID4NCj4gPiBGWUkgLSBJJ20gQ0MnaW5nIHN0YWJsZSBiZWNhdXNlIHRoaXMgY29tbWl0
IHdlbnQgdG8gc3RhYmxlIHRvby4NCj4gDQo+IFBhZ2luZyBNYXJjIFp5bmdpZXIgYXMgSVJRIG1h
aW50YWluZXIuIEhlIG1pZ2h0IGhhdmUgc3VnZ2VzdGlvbnMuDQo+IA0KPiBUb3J2YWxkcyBhbHJl
YWR5IHBvaW50ZWRseSBjb21wbGFpbmVkIGFib3V0IHRoZSBzZW1hbnRpY3MgaW4gdGhpcyBwYXRj
aCwNCj4gc2hvdWxkIGl0IHNpbXBseSBiZSByZXZlcnRlZD8NCj4gDQo+IFlvdXJzLA0KPiBMaW51
cyBXYWxsZWlqDQoNCllvdSBtaWdodCBub3QgaGF2ZSBzZWVuIGl0IHlldDsgYnV0IEkgZGlkIGxv
b2sgYXQgbGl0dGxlIGJpdCBtb3JlIGFmdGVyIHNlbmRpbmcgdGhpcw0KYW5kIGNhbWUgdXAgd2l0
aCBhIHNvbHV0aW9uIHRoYXQgd2lsbCBsZXQgeW91IGtlZXAgaXQuDQpodHRwczovL2xvcmUua2Vy
bmVsLm9yZy9saW51eC1ncGlvLzIwMjIwNDE0MDI1NzA1LjU5OC0xLW1hcmlvLmxpbW9uY2llbGxv
QGFtZC5jb20vDQoNClRoYW5rcywNCg==
