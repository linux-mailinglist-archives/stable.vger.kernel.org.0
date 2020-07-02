Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63AF3211D2D
	for <lists+stable@lfdr.de>; Thu,  2 Jul 2020 09:40:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbgGBHk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jul 2020 03:40:59 -0400
Received: from mail-eopbgr50091.outbound.protection.outlook.com ([40.107.5.91]:45891
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726362AbgGBHk6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jul 2020 03:40:58 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QzghQ4UX0ZKIZEBPnSoEYHEPegI93Ekh5IhnN8yxEgqM0smb7dVQBBx8a/S1grRPQGm+wo0hjwcyg/UUZIE2kzdWMwaNoUmuHHyroM12ATsAHdnyEK2SYSsKJU/2mEZxgfr243W48qLiBP8qwauGehBkz9yQi+Ls0+RevXrlRp2whckGDV2C2RJXe9Wy14pvhXyuDy2VqUG7u7K9ok9QcGRIz+CRQvyP4xOMW3+AI3DE8s2TDvcbe5T0nT607vjSDkl9IRbxIerHSMk2J/ukLOtD+X8uTRRra4pNSxRavprjSBlnGfS6EIkNyT95n53U6BRY6MEeNIBccoFBG3xRLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DL1Vch+ryh3rRdod7q+1VqIdguL4r5DjymDqfsB+qw=;
 b=TPnM2uT18oFkaqgu24Nc/Dd6W0x/x9bu8UxlSedokGkXRh17nmJ6KWi4/x2hEwlTsbsQjm/vxTsdlIrnxAcGMdI8gqDwGGz9eaYMGWnDPwnP2oyJQQTTCAVgkl2gyCmbbE0oMlvF0j4aQtgMGLV6YsGRdPiKdud6PMmL9h5VP6JkAkO3IKcS+E5HNn8v3+097bsi3vt3YYITgBYzV5XfsTGjqPBMhVoZG3uTC6efJ+IGLDVzA9tmqlGBGIW+co/+7Lqa3LPFdYiNFMJS6w0ylkzyjJEnMkOdAvpB6EeLKRkV+DqbiUTt2vkES2aArMu1yXmRh9Dh0Jo9o14z7p8mqg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=virtuozzo.com; dmarc=pass action=none
 header.from=virtuozzo.com; dkim=pass header.d=virtuozzo.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9DL1Vch+ryh3rRdod7q+1VqIdguL4r5DjymDqfsB+qw=;
 b=PdKA8hRhEJmYjDVuHQvasHCiY/gA4AtqZcq/XXUUVW3ZkentrE2Zzhf4O/RvU0HOLFmv78T8GFJPUehu3iMeABiNMTctZgALuhGLftirPQ6977G1qfOgvni/oIDU8SroE+38E1lookMjWU07gW4tXexKIYyNyDdO50PmO+GrifY=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=virtuozzo.com;
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com (2603:10a6:208:162::17)
 by AM0PR08MB3428.eurprd08.prod.outlook.com (2603:10a6:208:de::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.22; Thu, 2 Jul
 2020 07:40:54 +0000
Received: from AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::189d:9569:dbb8:2783]) by AM0PR08MB5140.eurprd08.prod.outlook.com
 ([fe80::189d:9569:dbb8:2783%6]) with mapi id 15.20.3153.024; Thu, 2 Jul 2020
 07:40:54 +0000
Subject: Re: [PATCH v4.10] netfilter: nf_conntrack_h323: lost .data_len
 definition for Q.931/ipv6
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
References: <c2385b5c-309c-cc64-2e10-a0ef62897502@virtuozzo.com>
 <20200624121232.GA28150@salvia>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <462357d7-290a-1f08-282f-0d310e0b0876@virtuozzo.com>
Date:   Thu, 2 Jul 2020 10:40:52 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200624121232.GA28150@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR02CA0080.eurprd02.prod.outlook.com
 (2603:10a6:208:154::21) To AM0PR08MB5140.eurprd08.prod.outlook.com
 (2603:10a6:208:162::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.16.24.21] (185.231.240.5) by AM0PR02CA0080.eurprd02.prod.outlook.com (2603:10a6:208:154::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.20 via Frontend Transport; Thu, 2 Jul 2020 07:40:53 +0000
X-Originating-IP: [185.231.240.5]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 23452a40-9a54-4162-e808-08d81e5b4006
X-MS-TrafficTypeDiagnostic: AM0PR08MB3428:
X-Microsoft-Antispam-PRVS: <AM0PR08MB3428FAD891CCDC2642172D6AAA6D0@AM0PR08MB3428.eurprd08.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:409;
X-Forefront-PRVS: 0452022BE1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: RFD9ajx7q7pq1N28XOpskavHjznvyHMh95OdYtbBfT73D24uF/kLE0Pdy4SH7HzuJL0px01f5w2LwWVCP+Sta4fo0cnNstLsWM3yeSkW4XOEpvI+iORkuNWzR0983Y3iozoo1Jv6wiyVHfqqJspQY/s1N2ZqXzuz2e+0FUoh5jT8W/AlBpGIkW74kvCXWoCpPaQYIQG6J11u/5MBu4ELJqQBxghBHXNI1dRDfX2TgFyROM2/zzcBlyTaashXFE6aCPGTIjnEsuH21RVAtZ3JQFuuWo/52bL2o2ZF9G5Uz5osJtfP4eRoknB8kKGEMQMs7fgHEcE9DyWy2dABQGBfqRmk4pcRN14iVMd9munZ7Akh0i/f2NhsGd1iFwXiZp8TWpgb/zVI+WVai/ifaD60RkekKwMmmUoD/2M6A5oA8TqMSjjuoynQXku28Q7ReyBoyFhzvF4Ic74fkhlN/F0hewYDPivZIvHynj+IWbFXVeo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR08MB5140.eurprd08.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(39830400003)(366004)(136003)(346002)(396003)(376002)(52116002)(16576012)(8936002)(956004)(66556008)(36756003)(86362001)(8676002)(31696002)(26005)(66476007)(186003)(16526019)(53546011)(66946007)(31686004)(110136005)(316002)(6486002)(83380400001)(5660300002)(2616005)(478600001)(2906002)(966005)(142923001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: 590Rmvxr45j+ILdbZZaXDu7bI34hXex4RSiNkt9QUrd5dNSHTKiXnX0VvaPU6yQQGHA0Y4VXvzH4wO2jYc5qvDATwiWS+2uPoqGb3NJveXpbTjOEWvnC35gxXkHAxVqk50NfJCqzwJd06h4s7Eh8UkbEVNbZVhmoUBiGJcsMoPJ+a/QaFEYivNUxk2YaoOnSYUiguGFlzJfcX8FgY2Zmja7cUIZsAlf398MFKXsTjK3GCiJal6IFL8OEWEJgGgMgYUD4hTVwyPa6+ZAEwtEe9lDc2wcUsb8AGMVxiNXJE9F0kr5AL/rMH4PBqFek8F0kUQK0eWUujs7qOlrJ30en3j0KdP1mSCxrvUC3jUJRKl+Z7AAC5uja6Epl6kYEoWmpVzg0vMIXJMdY690bh756JsaL8s0j2f7aFSFENwsqA5i+izH1gitzo2xx1K0MCwkF7AKUvuFzmRdNHsWRBEvqB2IT9tUp925EQzv6aXun0wY=
X-OriginatorOrg: virtuozzo.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 23452a40-9a54-4162-e808-08d81e5b4006
X-MS-Exchange-CrossTenant-AuthSource: AM0PR08MB5140.eurprd08.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Jul 2020 07:40:54.0695
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 0bc7f26d-0264-416e-a6fc-8352af79c58f
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3WIgP/D0ZrTEZWj08qyAqFbjXA/yoHLWJRbh2dkqNdUHz3fHfilmgAcrMArGcVjTW9vZdCxEvv4qIPDl8XKjLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR08MB3428
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/24/20 3:12 PM, Pablo Neira Ayuso wrote:
> CC'ing stable@vger.kernel.org
> 
> On Tue, Jun 09, 2020 at 10:53:22AM +0300, Vasily Averin wrote:
>> Could you please push this patch into stable@?
>> it fixes memory corruption in kernels  v3.5 .. v4.10
>>
>> Lost .data_len definition leads to write beyond end of
>> struct nf_ct_h323_master. Usually it corrupts following
>> struct nf_conn_nat, however if nat is not loaded it corrupts
>> following slab object.
>>
>> In mainline this problem went away in v4.11,
>> after commit 9f0f3ebeda47 ("netfilter: helpers: remove data_len usage
>> for inkernel helpers") however many stable kernels are still affected.
> 
> -stable maintainers of: 3.16, 4.4 and 4.9.
> 
> Please apply this patch, thanks.

It fixes CVE-2020-14305
https://access.redhat.com/security/cve/CVE-2020-14305

>> cc: stable@vger.kernel.org
>> Fixes: 1afc56794e03 ("netfilter: nf_ct_helper: implement variable length helper private data") # v3.5
>> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>
>> ---
>>  net/netfilter/nf_conntrack_h323_main.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/net/netfilter/nf_conntrack_h323_main.c b/net/netfilter/nf_conntrack_h323_main.c
>> index f65d93639d12..29fe1e7eac88 100644
>> --- a/net/netfilter/nf_conntrack_h323_main.c
>> +++ b/net/netfilter/nf_conntrack_h323_main.c
>> @@ -1225,6 +1225,7 @@ static struct nf_conntrack_helper nf_conntrack_helper_q931[] __read_mostly = {
>>  	{
>>  		.name			= "Q.931",
>>  		.me			= THIS_MODULE,
>> +		.data_len		= sizeof(struct nf_ct_h323_master),
>>  		.tuple.src.l3num	= AF_INET6,
>>  		.tuple.src.u.tcp.port	= cpu_to_be16(Q931_PORT),
>>  		.tuple.dst.protonum	= IPPROTO_TCP,
>> -- 
>> 2.17.1
>>
