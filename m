Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 871E66E2B31
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 22:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjDNUjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 16:39:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjDNUjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 16:39:46 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2057.outbound.protection.outlook.com [40.107.244.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 947C344A8
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 13:39:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b+NIgt112mTot8n1eflAw4GfYiub5XYZ9CSRsG/bQcAiJrr2O93QPeEMPyhOqQVHiDAUoIg//3x75fUuLSR1nycs7AnUFzANBGCt0KjcxK+TDEhghlv+z6jdbpOowVG1gSJWsaNyL8oytZfb95ng8PsOmXhJSOQKGAjF2HMBHLcnY/PnzlRsruNuS1HGsdrsG/5JyLNr2MPdr86OD5n0LA+C3/aReAh5m/oFPgKRdiK4WWm/RpaSs5GYmFGHf/m8sdUxzEaRfYo+DfiE3gjIv7vXqR3o+mFNa98jgndn6NbPpHYegkkR75EoGrOCmsYGt4Ujp09r4T02cE0mrVDBZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=P/YRtU6hXttUg2x60xuH8dQv3gmQppi2FlWs5SHQNK0=;
 b=Dl3NYeE8DkzSLJ0VvyCQg7vYeBxIZlD1v1H1ibxh0ks/x1dDf6b8vusrbO+dpgWfACh4B2pPw30cRtJy/Dwq2wWwCBQHuIIaW4OQBLluHqVyou2O8AQ8QI8b+xyEaBxnsEOixAlZYW1I2v/uR+8aQPdqADLlxjFkdrvSpNW5WQddYBtIDBeB+8cp+3+KDzts+IzuuxB+mNaG1UzKCKxtxFaUYRJstyg+ViIiG6GjA3rtLrF6x9WERE7vcfaxKL2NeNYgUCBf+gPVoj852lQWwX1XUeVtvZVd/lzs92O+LSdZZulP5r9nL6vHPitlcnIYWM6eyNCjxPpzM9x6TJs5Jg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P/YRtU6hXttUg2x60xuH8dQv3gmQppi2FlWs5SHQNK0=;
 b=L3ElQj/2+5v46GrI/HBKQ18h1w+HJQXHd5g+6NpCqVSqgtVpkgZEt2/DmJHJ4FQniX/YE3mkhge7L2STNvEoXW4G0Hr3i0KaMP5ucmIZWEG4ZGYUm1JH+7TIiKKDARVvSbdHGwvdahPeJmjnN5zcG1LBPDpjMkC2QIifBSTVFJo=
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by SA1PR12MB8843.namprd12.prod.outlook.com (2603:10b6:806:379::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.30; Fri, 14 Apr
 2023 20:39:41 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::f4d:82d0:c8c:bebe%2]) with mapi id 15.20.6277.036; Fri, 14 Apr 2023
 20:39:40 +0000
From:   "Limonciello, Mario" <Mario.Limonciello@amd.com>
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC:     "Gong, Richard" <Richard.Gong@amd.com>
Subject: Fix regression from 6.1.23 / 6.2.10
Thread-Topic: Fix regression from 6.1.23 / 6.2.10
Thread-Index: AdlvETvIMRmWDTlFSdqoFgXuSOt+gw==
Date:   Fri, 14 Apr 2023 20:39:40 +0000
Message-ID: <MN0PR12MB6101320AE0809F672AAFD25EE2999@MN0PR12MB6101.namprd12.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Enabled=true;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SetDate=2023-04-14T20:39:39Z;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Method=Privileged;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_Name=Public-AIP 2.0;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_SiteId=3dd8961f-e488-4e60-8e11-a82d994e183d;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ActionId=c2389239-4243-468c-ac71-677f6f835604;
 MSIP_Label_d4243a53-6221-4f75-8154-e4b33a5707a1_ContentBits=1
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_enabled: true
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_setdate: 2023-04-14T20:39:39Z
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_method: Privileged
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_name: Public-AIP 2.0
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_siteid: 3dd8961f-e488-4e60-8e11-a82d994e183d
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_actionid: cbc4cb18-ce91-406c-b4c7-4ee3f3af6b35
msip_label_d4243a53-6221-4f75-8154-e4b33a5707a1_contentbits: 0
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MN0PR12MB6101:EE_|SA1PR12MB8843:EE_
x-ms-office365-filtering-correlation-id: 5242f495-e890-4861-547f-08db3d285f3c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: mCJc1hpvFORRg+HID5pq7x6sFbb48v0iCWity81OTd0FObYH+pqf3eOSLxSmmPQDuUj5V77A/tSOBh3/9+xzaheenSzFN3O2l8QJX/uzmdIRb/JkW+W2bZXsoTehkXxDGKzht6hotzdu4ogzEgVO/alDxR0Q6lN0g7t2dyyzFxpmH3U6NcrWXJTXhqH+PnE9jjOyFlpElCYDV1joTzZcrVGDDk4ekoHzyZEyks7D9ah+lUAV7eqkcrd1bsX+Uwnbh5hsOJb5NafGms6wfURdylmcT6lu4UeIHvpzVNuOPcAHI3e0OAarV9timtMC0xSpPTOhxhFj1hiSlh7KnsrzjKOXkXBXCLLNaHq8/KQc6EH2iUvDtLXKM+tBzERkTdymcWwpXnnXdss1yYB4PENii2QqNB+oGh4hNdCL5O+uhQR82sbR79tSjkrTuf797cFK6hNYgG+CbDMxoM91dCzE3PImdBCwjM9rIOXTnfA2ILgTMSptEVJPbLLDCN2tsX1ByOy6Tu5fNhiSdG7h1gFNtKV6TRTZpzNg5lwBNoQNu1m5/+mOsh/kVxiZGMVHrS3O4Toj9fUD9dG8NKrXLS+fgMcqOl5gYPyqsWKFh9Sexbd/75YRLYxenDxL10StREn1
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(396003)(346002)(136003)(39860400002)(366004)(376002)(451199021)(5660300002)(71200400001)(7696005)(4744005)(66556008)(2906002)(66476007)(66446008)(76116006)(4326008)(66946007)(64756008)(38070700005)(86362001)(38100700002)(122000001)(41300700001)(33656002)(52536014)(8676002)(316002)(8936002)(478600001)(55016003)(9686003)(110136005)(6506007)(26005)(186003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?RcceS70KlGDZNb6a8cSbHqJ5/TpVHYRTt1YyTRRnmyR4AJbrpy5il8qdstod?=
 =?us-ascii?Q?hIX6/H1t2QvCJOXtBjvEfvgKvgm8CvKnNvbFygDiZyQpykZR66NlKKyPbskb?=
 =?us-ascii?Q?6lL7djI3bAirQ1O3OFZSyI1nFFmJr0X7AWPWh4sVLs9TLMAtUfbpIIkx4Icb?=
 =?us-ascii?Q?bT0chSGzMhnXVITFOedtc+Ura99ypBHCpIScRVCFZgjGGmVSaw5FQ2g1Qd+X?=
 =?us-ascii?Q?ldF8fAxn6QaS2GkzEPb+Ak0ZCBq4PIeza/7k7tLhZHNVy4Xp3l8Z5g7bCdoQ?=
 =?us-ascii?Q?DtIJYLfXZ6txwO69O+Mbvczjn8W4x1FCYWl2sFmWtribFpac8HEJ51v+LwKD?=
 =?us-ascii?Q?H9RNWud5K0XREfBOVIDzI/XGcZIgmsbMiS8zOYj/xjdvRwPBfZTEMzWA7ycV?=
 =?us-ascii?Q?GEbVMgbqzinjKzpDKLaFAQO5EkGL36dguqc5Z6oak4StDIiEJ1mo6ieF+ujA?=
 =?us-ascii?Q?Ua9BN1/jFNr+YbNIf+0olzt58wVoZFm/t4TIwy+7GNfV1DYkrw/g1elqoLaS?=
 =?us-ascii?Q?RXlqf3tpWh+dSGVVsm9AferSMgVD/9lHHEv8cNnjs8v3qKrceGr63BXDUGr3?=
 =?us-ascii?Q?izIhu2WWnctxy53g6OJX86o9KJC3L1+wYe5FSkFnbu1SMwNh/CyV3zCyDP8S?=
 =?us-ascii?Q?+3ecVna3eFqYphC9+fdYjrI5/7VCUCI/dWNvPm7K9E2uQMPdS++Y2X+NxrIg?=
 =?us-ascii?Q?iriPg/CYGztuPOKj5vOHZKnGvkMEp5xlmHS/YdYazkS1aJUX0ARG0y+PQ5O2?=
 =?us-ascii?Q?GEsFC5gBlm3AAGnXoY3WTcEQqOiqP3LdMnD0jfdA71HkWUgBicbvr0m/8V/+?=
 =?us-ascii?Q?b/7oFs52C0YnwqD7PHupdUuOGLRKit1coFgiMLXpEKIrX2QAlu7qBtRpizLo?=
 =?us-ascii?Q?OztoBjJNo5QoPvI5xhKfccjWxfuIPKQz0ZCMO3Wf0uf+0le/USx9kdQ7U5FB?=
 =?us-ascii?Q?6ipDNeO/nISzTW3DyCgZhqwNs3CGaheGP0sgjmsaFX8yb3/OiZG2nF2YzKy7?=
 =?us-ascii?Q?w4sncbzvLgVyF+daHunD0GOdH72wB8IJ22scoYi9DNXXSkoXa3zrmR0fWzGo?=
 =?us-ascii?Q?IEnwcqP2CjPoaLoYimw9iWCEaw0zEVQKJEeFEaXNfqSeoMiVIWtNo868plfR?=
 =?us-ascii?Q?kBYXD+s/oU9Ok4+whVroKBObGAttYJVlktTanmZ9hns6wBBJQ2NM9OWspVKT?=
 =?us-ascii?Q?tDjHGPzOHukvC/aW16l7DLwQFLWgQsACqvdzYzP/uFXb7gyphA+iHXoSG8Bu?=
 =?us-ascii?Q?8vdvYPbOoLJPq7nhQt0WzUykpiCPLUBdk/teBCijkIN/nOPKIMz7XpCQopVO?=
 =?us-ascii?Q?rFElh1WSyvNyw3d9UtdfzUnwmFPGKwJ9OE/H9a8UF6CJF2lzpsw4qId03/bC?=
 =?us-ascii?Q?KoQIphp4Iw5QH8fv5ugmZwcNAjZgBSO6tLq1/e5LLCLwglSOfQMWqSZv/ro7?=
 =?us-ascii?Q?7/XlUgY/ZGUzLfTeBfE3uOuAnRVtJNWaFpRp4pouw1X0dSmIfVQ9mdB1cW9y?=
 =?us-ascii?Q?qlhdXoSLqR0F6NerH8ezcF4LhKPFQcwNqtMWqWfoo3dzTlCLEXXcsKjxFa2W?=
 =?us-ascii?Q?Pv0rdf2910q7znDYlxE=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5242f495-e890-4861-547f-08db3d285f3c
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Apr 2023 20:39:40.8675
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wDW83JfoX1P/4xtB3XpNAh8A1iPj233hEEYwpAuhu3MTHoaenWQFjcboIKm/2bTLo96PBa26dwADpAqadhMFmg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB8843
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Public]

Hi,

A regression was introduced in kernel 6.1.y and 6.2.y from=20

5.15.y: 6c1bc7b50e02 ("pinctrl: amd: Disable and mask interrupts on resume"=
)
6.1.y: d9c63daa576b ("pinctrl: amd: Disable and mask interrupts on resume")
6.2.7: 7ecbc2275a13 ("pinctrl: amd: Disable and mask interrupts on resume")

The commit that caused it has been reverted upstream as:

534e465845eb ("Revert "pinctrl: amd: Disable and mask interrupts on resume"=
")

Can you please revert in the 3 stable trees that picked it up as well?

Thanks!=
