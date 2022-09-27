Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3437F5EC4C5
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 15:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiI0NnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Sep 2022 09:43:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiI0NnQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Sep 2022 09:43:16 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2069.outbound.protection.outlook.com [40.107.223.69])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22F2EE21F0;
        Tue, 27 Sep 2022 06:43:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GbiSx9fJUVSi6++UbDsXF4FkYbyCH3AJNcXZIG75HEzoMQZYLe8EOUGXi25x2I1FUv81IsE0NSs+Zkb2HUBs4vWAp/peoWuhhT+I9nUdT+IaXGpluGpTk/R7gQySFEcuzJ3jol8eb18o604BmqcQN09uM3pk61fcPvaso81+CL+6/yzM1OqMfHGDbryYTg/tQnOL5RmlA2xFpu7IZ2DJcDgu8ni8piat0n/itkNYOrWq5Sq7qFqF1HPo+KaOzrC3ouKorAE0MJwHdSM6znC1FQaWZbzaEfursSKfHUDWjPeSxPnJhzduTqQtZVjV/z/Xrzb3gXZLcF7rua02zmIVPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G2cFlMBeO/E3XVSuI4AIODbviG/1Z7cC1DJ653U8Ek4=;
 b=HFI/sTQk1wSKcvYvs39TwPY2KhtjMAB5c1lNVw8nNrPFQRWhLsApn8t09feq9oAzAd54s4s222SFW7DP18btCUcc/7M5Xwx2T4rA5ytZ58asFOz8W+pvJTU74XwKI9N14Cli75wU02kN0G9TPEN/+BUZqaT6xOsKxmPeeX/pvDveycNpI5hlB/gKvSmRkOq/7tCmB8duRJO9DCQXcAKipObrqFf4l18D/A2m7H6zOHbKyOWPyDXC9/ibndta97hIc2Xu5fZpidWyHFi9xckeCtPR1vc3YN7xDCKNTzODKx+BiqAmPPSBuFdNW5eKNbxt0LPPt+6LoCgFadiRBZOBaQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G2cFlMBeO/E3XVSuI4AIODbviG/1Z7cC1DJ653U8Ek4=;
 b=jIWSKEwRo6EG4d+kNFTUjrQlmJDdUZ7G+nLMbejUnLDbEgGirAvhFM0GG4dJDhx1wIpUCZKVsSKH1w5Tb3ivaQXL7YabbYK0voRwWYeAj00ugypgKqQCrHWVCsZLcSMUhh/yuYuc6uKiGe+QlxdSTgumrdmxn1vugE2fpUmcbraDUyPhz3WwpP/FEAbBd3NFuRJE5AMSQRqYK0uf/a2DvIU96ZLsqqvK/RoO9wlrLgZHK1goggNGK+wfSYgwMenEcnCIt9sqM6pkWpUAc6pmW98XdfbqIMTmBr6WRn+Wsaiy2TXRp+c4nyqL4DSJiTQaiqmHLUCFtq4gvAvyLJCAjw==
Received: from PH0PR12MB5500.namprd12.prod.outlook.com (2603:10b6:510:ef::8)
 by CH0PR12MB5188.namprd12.prod.outlook.com (2603:10b6:610:bb::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.26; Tue, 27 Sep
 2022 13:43:13 +0000
Received: from PH0PR12MB5500.namprd12.prod.outlook.com
 ([fe80::7940:4aca:1c44:40eb]) by PH0PR12MB5500.namprd12.prod.outlook.com
 ([fe80::7940:4aca:1c44:40eb%8]) with mapi id 15.20.5654.026; Tue, 27 Sep 2022
 13:43:13 +0000
From:   Wayne Chang <waynec@nvidia.com>
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     "heikki.krogerus@linux.intel.com" <heikki.krogerus@linux.intel.com>,
        "quic_linyyuan@quicinc.com" <quic_linyyuan@quicinc.com>,
        "quic_jackp@quicinc.com" <quic_jackp@quicinc.com>,
        "saranya.gopal@intel.com" <saranya.gopal@intel.com>,
        "tiwai@suse.de" <tiwai@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] usb: typec: ucsi: Don't warn on probe deferral
Thread-Topic: [PATCH v2 1/1] usb: typec: ucsi: Don't warn on probe deferral
Thread-Index: AQHY0mzGbYrBI2CY3EivDSamlrXcIw==
Date:   Tue, 27 Sep 2022 13:43:13 +0000
Message-ID: <PH0PR12MB5500D3A1DF88B8EA531DE165AF559@PH0PR12MB5500.namprd12.prod.outlook.com>
References: <20220927122913.2642497-1-waynec@nvidia.com>
 <YzLvTgzMce9TDzDA@kroah.com>
Accept-Language: en-US, zh-TW
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH0PR12MB5500:EE_|CH0PR12MB5188:EE_
x-ms-office365-filtering-correlation-id: a96f8817-e285-4b68-4e75-08daa08e394a
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Ro/wYq7Utzc4PQuc06e2zTBJgfuMeOxSe2lz9abp1MdAg2TjTaSQCzj/fgC5Sy3auh1PpQvhhw31PDdFv72GtITY0M/N02oeZQCvA4ONLDvNmj1daRna9Z9oX3NvD26N9F+XJ3cPsrtnDV7WKZpDKBnYkF2au9blvOjwXDJa/UCG9Z4W8tueyNM3513gWYMq4OA9c/JdH5/CxsCx9RQ7N55WcvkFLTx6DPJvbemWtaSRW9li+UMV6Naoo86nTHrxHfTF42OQMFdebR5u2nimcT/1x9tvbvIRsh+0wnFYl/L3IZEh6N9VKWVCzVRaODCxDa1pknxw8iAEaBP9bFgFNCrxAgdUQqXTVcQO0cKVVkVXkZUOAyFEOzY830gf1JgGdTUL49U6wDOU8QzGAY90v9Bqz/Zywk3tkpz8oOvTSdm9AOxuf109gQ3y7cmx36S+dq5prm3x0yVUqkjGrAlqzzlpF2mCv1C+u5ST0WeRI0Nmr2szW0JweqUB8NOSsiXSDJaCVeU9VZqv1pjmbcvmc4pXCVlmN7VzcHGjxHQMah4xt7IbJjv9IQdp6v2QCQxAx05x8bKV5TVDOO+xR0hivp7piKMOHnPeMpm667Dlan3N+Z5L2NCNHy9fRUxW6K+Iw4omSZrM+tzXH1YIoQ/qcM3VJOEGwVrdzhwDLCqYqWddJl6SELoB6J5xZR9lF5flKgnnVqy2s2i930LAcUDjQLAqgXuaCAmHeb7Qw++TrShworQIk0vKaY2Ie2svtdS2exGwnN0rAPdpsvsmzj4ugw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR12MB5500.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(39860400002)(136003)(376002)(346002)(451199015)(54906003)(6916009)(4744005)(478600001)(316002)(66556008)(66946007)(66476007)(91956017)(76116006)(71200400001)(52536014)(41300700001)(7696005)(6506007)(53546011)(2906002)(5660300002)(8936002)(9686003)(66899015)(26005)(38070700005)(83380400001)(33656002)(122000001)(38100700002)(55016003)(186003)(64756008)(4326008)(66446008)(8676002)(86362001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?bhP7RcQTsxKkOGLvrjP2+SsSlGeZl9Vr2RulMQ/aUUYr4X9J3xjDm21Mbhew?=
 =?us-ascii?Q?BAeNfeesjNrWv407nBOMDdep8i3+iB34hHsq9+as62SVf2be+MGI3sGtj3lN?=
 =?us-ascii?Q?czJ/U0UKxnmBphHseSlVe/DJfSaZ56X3sHhwCQ2ddeLwDo3voKSKM9wvceRh?=
 =?us-ascii?Q?TZhhEqPK7PtQxNdh0uHA78TL035YsHqZ85u6si5kCGnCIRgxp7SRwp0gKehS?=
 =?us-ascii?Q?ZQZJLQqx1oodmlXyTTuhXmElinOOPh2ZUckaunJo6bGmH+XnDbMxhzzFOvCg?=
 =?us-ascii?Q?YfiBxCBeLVEy0T2uu9Wy4zjABMlX/6n18omV0pHejD/vpxw6NCrd5nipWoRd?=
 =?us-ascii?Q?aVmheem3REEyODGdMBDUWHbva2qEe1REdd1aUOPcfER7Grk7HKQTIfMrXmiu?=
 =?us-ascii?Q?t5KhHXFLJB1QnVe5YeJ/iWw/oY50jYpDmf5ZwuKZyfQSsUK7AAAthuf8KoyE?=
 =?us-ascii?Q?4VJfvEtMi+r3gsHc/6U/GiJAmFcizxUT6Z4WHU1/HV08BwUszLukrgqP2UrO?=
 =?us-ascii?Q?XBqGGWwsOPQ1nxUgL/Q/A4lqiDDj+7ukJQOYs+O63fHE54jHIZxard7j2A6n?=
 =?us-ascii?Q?kJQmhOXYZ3l11gbCnQMJHuP30rW0JtNg2UWpWfPNMqiLINvrQAFD6U9pk8UM?=
 =?us-ascii?Q?YmpHcHYUEEXseo/5CxLMl0DUQu+8WVjvdMRPs5SJyzQ+8vy+501sBK0BuZRl?=
 =?us-ascii?Q?5VquhCrWHMOMav+ozvr2yr1BhumXO5nQjRp/cW0YpOspUf7P0O1u6MYjR7Lk?=
 =?us-ascii?Q?KTBw1x4VqK2GfvZrpA9beqIvMU9egyzuTU8zakT0+mA1W3DCUC5JGoU3ekFQ?=
 =?us-ascii?Q?X69StSJ5If5RR3VPtJhBLCkAbb8G122fAVJgoUCGB/C855HI7aKAX4xV8BNP?=
 =?us-ascii?Q?oR4qTdme7OTu9SB8HOTMZKdzYOwDyjej95ySAGzuxOJxl0MtcuLBlPe/YB2q?=
 =?us-ascii?Q?B6i/fRQo2q+KBRPE3mfiNkhL2JK0Pw0F+dhSEklXlIbSOmZf7sy0ixc9yw1C?=
 =?us-ascii?Q?vRMWGAiBmNHpsYWsK+6IVdX+R6Jiijg/Ydq5L0MSqswue9HetXg0VW3TXjRP?=
 =?us-ascii?Q?5iNMMt4V0YYRNsdisxYl/cD3ic1eW977fWaxWGdREI0NmE0Bklo1r38SzFuq?=
 =?us-ascii?Q?vSCk3RVqexsvtWMQkYt9NoCc3P6mURRudt6OwhuOODbSnws8keFtnOG4Bsuf?=
 =?us-ascii?Q?MgwIbbtk1JASW6OdXPzrK9+5W0IdPp3B5033jLQYikM16COAZLcBubLR1Hu2?=
 =?us-ascii?Q?B9IJwol18aHEDCdtoDLw9gHDcg+/g2ww7y+lanzNLXn31dmcKNu5WQbJGqIS?=
 =?us-ascii?Q?tAYbGVV1/2iOEqisiaWHYDl7Q3hY7xkqnK9HIuQ1eqXbD05HNxN5cHPGd1vx?=
 =?us-ascii?Q?3ECmohqGLnSGEDI6xe13w+GAYrb/NTPJxP7ZXJYgKupmSQE+Atlb1wnsU96Y?=
 =?us-ascii?Q?+Q/irSfn5xe6krNNDE/UK2NsNv6L5WE3Q83jzZaMdEjEJD+j+lB0mmCKSpZX?=
 =?us-ascii?Q?DfIHLMLuv1OBIp44IwkRQUtfaEW6C5A/qHGxv1hXuV1VgxRmApKcttQEDK26?=
 =?us-ascii?Q?5i95H1bZ8C4IKH2GJrkQHSHmzYQKly65j7kHgjNv?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH0PR12MB5500.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a96f8817-e285-4b68-4e75-08daa08e394a
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Sep 2022 13:43:13.2849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: A+97grxNvMOH4YcMmV15qREUEaYvDhHjIbQjI7GU/Dg4jZWaoxh1+RVdZJsjBsykFuh7MOym/HAPJ3ylMCejWw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR12MB5188
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,=0A=
=0A=
Thanks for the review.=0A=
=0A=
On 9/27/22 20:40, Greg KH wrote:=0A=
> External email: Use caution opening links or attachments=0A=
> =0A=
> =0A=
> On Tue, Sep 27, 2022 at 08:29:13PM +0800, Wayne Chang wrote:=0A=
>> Deferred probe is an expected return value for fwnode_usb_role_switch_ge=
t().=0A=
>> Given that the driver deals with it properly, there's no need to output =
a=0A=
>> warning that may potentially confuse users.=0A=
>>=0A=
>> Fixes: 3c162511530c ("usb: typec: ucsi: Wait for the USB role switches")=
=0A=
>> Cc: stable@vger.kernel.org=0A=
> =0A=
> Why is this a bugfix that needs to be backported?  The current code=0A=
> works the same as what you are changing it to be, there's no functional=
=0A=
> difference, right?=0A=
> =0A=
> thanks,=0A=
> =0A=
> greg k-h=0A=
> =0A=
=0A=
Yes, there's no functional difference but clears probe deferral warnings.=
=0A=
I'll send v3 to remove them.=0A=
=0A=
thanks,=0A=
Wayne.=0A=
