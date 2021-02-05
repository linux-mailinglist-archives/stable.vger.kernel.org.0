Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3F1231146F
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229808AbhBEWGA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:06:00 -0500
Received: from mail-eopbgr50056.outbound.protection.outlook.com ([40.107.5.56]:31974
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232812AbhBEOwO (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:52:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ax20WAkTCgTEK/4GeZks9FU8NMpxrjLWkkJlIIDdWbgQml+Dt9vKYxWifzKX9u+VEf3nN5IzBr2jgCUR+WKuxn3YpjsMYmjCA/fVFtSN1DNjafyXcXmt8OadrFR8x4O27kHGrnkFz9CLyea6t8Wl5rFjxW03erRLst3a2a5dhm+PJpNWBBp4wgJdGyk2KWbULh3PqOFSbxdWvm7CIoQ9K5yuAey6BXAM+VwMDobsQTG0XVFddGnc3BJcmriv5m6aN+3xYWnz4uww519kp8RifyG26ZItb4+c9eeEM/wR8/VIvxX1iKfltCiAGSF63eOAfBukdBEHznA0hJ1EXDG9LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQn7tNAOwd4VWa1B2iYXIB9jNfOoBh1EbaCIX0dHTSA=;
 b=GVHbE0NjWzzAYxuvYBneOHC+h1uhzMPrTZPA8hKnxQppWIjhiuoYWILmWNQN1mnehh6qyxunSvkIW+F9z0eYQkMhn6IqNA/MDA/hz3IaUFoFka4IvfsDPUqep2fGuXx3jgsxgQjljrPQ52rjHukQnPlSWLHJo4i3TAJ7M0qqtbbfyhj1aLTMP5x6GE5BoxOf8ykOcu3mbTp4RyyYrdJlK/9/ecW2eLjWOtEBx+0+2lT/AQr8UD+i7nnxYKSf+Ga3FT+gPdgMCyECwv7EP1tEYoikjmuUmqPAMT68skyFEtHkwesqzPdwM8XFjQCW8t/ME/6TAgk7i9JSiU69KxZYAw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=kunbus.com; dmarc=pass action=none header.from=kunbus.com;
 dkim=pass header.d=kunbus.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kunbus.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=aQn7tNAOwd4VWa1B2iYXIB9jNfOoBh1EbaCIX0dHTSA=;
 b=FYyagFWCy+uiKTU+OY1/iOa/bUp2GAXsK7AMupRExEoA3eYwl3j+wSeBrP4gLWpIjRss7TX/5ApBiyIdL/EZaCQP2qtf7980tOqiwCKReki4/KjmI5KTq+Qp6qAJLqRBJGv/2+TcIXEiMUvsrtosowXHCBqBp1GuLyp6mDvxyss=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=kunbus.com;
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a0::11)
 by PR3P193MB1117.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:a4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 14:55:10 +0000
Received: from PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73]) by PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 ([fe80::2839:56c8:759b:73%5]) with mapi id 15.20.3784.022; Fri, 5 Feb 2021
 14:55:10 +0000
Subject: Re: [PATCH v3 1/2] tpm: fix reference counting for struct tpm_chip
To:     Jason Gunthorpe <jgg@ziepe.ca>,
        Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc:     peterhuewe@gmx.de, jarkko@kernel.org, stefanb@linux.vnet.ibm.com,
        James.Bottomley@hansenpartnership.com, stable@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1612482643-11796-1-git-send-email-LinoSanfilippo@gmx.de>
 <1612482643-11796-2-git-send-email-LinoSanfilippo@gmx.de>
 <20210205130511.GI4718@ziepe.ca>
From:   Lino Sanfilippo <l.sanfilippo@kunbus.com>
Message-ID: <3b821bf9-0f54-3473-d934-61c0c29f8957@kunbus.com>
Date:   Fri, 5 Feb 2021 15:55:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210205130511.GI4718@ziepe.ca>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [87.130.101.138]
X-ClientProxiedBy: AM3PR03CA0068.eurprd03.prod.outlook.com
 (2603:10a6:207:5::26) To PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:a0::11)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [172.23.16.111] (87.130.101.138) by AM3PR03CA0068.eurprd03.prod.outlook.com (2603:10a6:207:5::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.17 via Frontend Transport; Fri, 5 Feb 2021 14:55:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 90fd9512-d6e4-4242-4d6e-08d8c9e60903
X-MS-TrafficTypeDiagnostic: PR3P193MB1117:
X-Microsoft-Antispam-PRVS: <PR3P193MB1117EFFE9947F3B116A09AC2FAB29@PR3P193MB1117.EURP193.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: W0AOYWg/BAPwWY3meOiBodltOwzqu9D5ntF8FD3VovK9Kh6GkFIArW9y6yeHmI5EOjRT1nOeYTjK+OixpOQN4aCuzdsjStV2b89T9yA4yhK0b08JVXv+JuY8Puja7pM66gIAytq/JMwwtg2IzTX1HN4TLJyK81ZiNAXkO8JfLCbtN4UhC8Nus0fvvhbi5d5rX7SM6Q4IPeRzTI6uvoyGkFfaZKZli6E6s6+lXpO1kTKEoqqk46lAsaHFTbKZ3eHQWcXHvxcZj/HLLtnN0ZF8oorwNmqczGXRGCNhMZEBPl+F9BmDGKowtLEUwDThFOaRoV9rx7uo12OyZhhSbpHH3BE1/ufZgGlIgRNbBL4IPbVSUhhbZ0eJdg2gB2Ex+iiZj86HGtxafj+oSKyCLHMC1RNiaBNhm+qeDFMUXjw2HDDjpEIcYf+MaqJC3omD6Iyz1aRyMUMAxDTELPwoVmSwhsMdsKpR/yfTzmyhtqgpMz5mTQU2qBJbY381UpY3SXaoqlPD0Pc3BBiA6uV+BcRQX9K4wl/lFg6PinAFkyv6dIh6QZCUHy1gP31D/pg0nn+ZjH8kIOqbEwJvWhhwjVaAAA7hp6b7/03BFIOldLq9Usk=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PR3P193MB0894.EURP193.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(4636009)(39830400003)(366004)(376002)(346002)(136003)(396003)(8936002)(83380400001)(16576012)(8676002)(26005)(4326008)(31696002)(31686004)(186003)(66476007)(66556008)(66946007)(52116002)(316002)(478600001)(2906002)(956004)(2616005)(6486002)(110136005)(5660300002)(53546011)(86362001)(36756003)(16526019)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SEpLNlNUeUdaZmtGV20reXYyMmFyQUZMKzNqaHZUaVQ3RXBvSHN1T2YxYWtt?=
 =?utf-8?B?TUQxeFhkMDJtclc5T0p3emtLZDZROUcyN3gzWTVLRFcvMVhwa2x1YjFoaHdH?=
 =?utf-8?B?b1R6Q0UzSUM0Q2FLOHNRVkNhWnoyekp1c0dmRWVZUTNRakwva3M3UUdPcjhw?=
 =?utf-8?B?RHMyMWpnMzBadDAyT3V3ajFvdDNmdzFqbnFJZmVuMHh1cHgvOHV5K085bkxm?=
 =?utf-8?B?OFpnRVNXcUd1QmVwSVV5bzFTQTNvWUI2OGxlN0kxVE5KbzFXLzI2SlllQmxs?=
 =?utf-8?B?M0RsWDJqOSs5QjZvWGZCd3pVemJ6czRQL2lsTXVWQlQ1S0FpRWpqekJ1cDVY?=
 =?utf-8?B?NVRWM1JLQm4yb0d2d2VZSGU4Ti83TlVMdngreVl3NGt0dnV6TzdCdVRDK240?=
 =?utf-8?B?R285L2ppdENqalM2SWk3NjlWY1pQQnIzRENEbW5lMm16cFVKbEZrd1o3eUI0?=
 =?utf-8?B?Sk00cDVZTmIvNzVwTENPVGIzTm1RdnNnZkRIQlBScXRQUi9GblJlMWsxNEtL?=
 =?utf-8?B?L0tXU01nejNDYVN3eWRrQk83bFRBS2FIN0NSYVBJUllOME81KzRJN093d2w5?=
 =?utf-8?B?UnVvdEl2aElYSFl4M3piR1lqU1JKRUU5ZVdSaDhQdCtkcjZyN1JLbG4xUUNV?=
 =?utf-8?B?dXFZRzlKM3J2aWh1Tk03UzFSOUxyTXVKaHJzU09Gc1hBRytoRGlzQ1ZHZGk5?=
 =?utf-8?B?eFNlYXpvNGQ3d2prbXhNblBoOWw3RmhhVjl6Rk9pdXVveEhiNk13QmZ4LzRG?=
 =?utf-8?B?b01mRWthdU12aEtQMGt5cE8xbEpIaXBFL1pyYkNwdjdra3BYZ0Fsa2VFWG4r?=
 =?utf-8?B?QWtKOFZ0Z2NySm1XdlZ3c3BMQXFicUJTNEsvMGI4SG5EMm1icHhuUHRZc2Z5?=
 =?utf-8?B?NzBSRENWRlZNdkoyM1lKd0F0emRMZW1BcHZXcitSOTZITHhnTVRzMUl2cktn?=
 =?utf-8?B?SUFOL3h5RTRlR2hhbGhKRTRDMXpjTUVXaDFuMkNVZnJlR0VqQ2NqVW9peE9B?=
 =?utf-8?B?ZHpOY1l3QW81Vlp1RzUvWFVDdDhtMWRlTE1nRktFWXVWSm9GQVJJc05IRFJQ?=
 =?utf-8?B?ZGt3OS8rQlFsUUZVNDlTR1d6QzBROGRJYThaNkpodUc0SGFQNTJKNkgvakRx?=
 =?utf-8?B?dEcwMnFkbDdrMWJLNS9wK1oxOU9Qc2xHMi8ya1VEWW9aNnBDK09qK21aN1dq?=
 =?utf-8?B?azgrMExUNFBSc0xvVnpwaTcwVzlONStpWTNnUVp3bnl1eUNkV2lqYndWdExS?=
 =?utf-8?B?NytFRGQ2bTU1K0gyRHVzVERqREU3Smt0MThhSjhxYlpCSVVRT1ZwUXVGSUJJ?=
 =?utf-8?B?eDY3V1lOUVJnZUpxQXNVOGZGSXVjTUo1QlJBMEcyNHVZWERVemVDNFdzMW1n?=
 =?utf-8?B?dlAwZkZ1UVdCQ0ZWMzFSeW5rNWdLZFh2cm9MQTJqbm9iRlNrN1BmWTF3Tlcw?=
 =?utf-8?B?MTR1dG5RYXpCOVl2SU5FZXNtMG5Ya3BDdUVHVDVEYW1JczlQTktsZEx6SnMw?=
 =?utf-8?B?TE94Q1JQVGcvN0ZGVGE5amYwZHlQN2NzWFgyY2ZsN2ZNUDV0ODY3SzZiVWsr?=
 =?utf-8?B?S0g3dnFRVkdXWjQrMFJmUS9LT294OFhsT3h1UDVDZTJtay9BNnpJTUEwVm9z?=
 =?utf-8?B?WVN3c2pKL01WM0grR25CWW5SVlhyTkt6TzlxYmNaK0czOVFXQ1g3TDJPRHd1?=
 =?utf-8?B?eWFIaWJzWFNURTlEL2N4bGphMFZXdTRQakVLdE1zSTFGb1JoTi80dFlVYnF2?=
 =?utf-8?Q?712i/lOzWr/JmLbRXwYDuLIeN7CEqvUtlV6V/mV?=
X-OriginatorOrg: kunbus.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 90fd9512-d6e4-4242-4d6e-08d8c9e60903
X-MS-Exchange-CrossTenant-AuthSource: PR3P193MB0894.EURP193.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 14:55:10.5002
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: aaa4d814-e659-4b0a-9698-1c671f11520b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: C7aJSbsrn6l1oTJjPL1w6oKzV1tGJYJxsyRYcGXl/SWyB8J1HDEFYGbYvM1I28Wlvz1tgOaszkJoBz9w9AJmXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3P193MB1117
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On 05.02.21 14:05, Jason Gunthorpe wrote:

>>
>> Commit fdc915f7f719 ("tpm: expose spaces via a device link /dev/tpmrm<n>")
>> already introduced function tpm_devs_release() to release the extra
>> reference but did not implement the required put on chip->devs that results
>> in the call of this function.
> 
> Seems wonky, the devs is just supposed to be a side thing, nothing
> should be using it as a primary reference count for a tpm.
> 
> The bug here is only that tpm_common_open() did not get a kref on the
> chip before putting it in priv and linking it to the fd. See the
> comment before tpm_try_get_ops() indicating the caller must already
> have taken care to ensure the chip is valid.
> 
> This should be all you need to fix the oops:
> 
> diff --git a/drivers/char/tpm/tpm-dev-common.c b/drivers/char/tpm/tpm-dev-common.c
> index 1784530b8387bb..1b738dca7fffb5 100644
> --- a/drivers/char/tpm/tpm-dev-common.c
> +++ b/drivers/char/tpm/tpm-dev-common.c
> @@ -105,6 +105,7 @@ static void tpm_timeout_work(struct work_struct *work)
>  void tpm_common_open(struct file *file, struct tpm_chip *chip,
>                      struct file_priv *priv, struct tpm_space *space)
>  {
> +       get_device(&priv->chip.dev);
>         priv->chip = chip;
>         priv->space = space;
>         priv->response_read = true;

This is racy, isnt it? The time between we open the file and we want to grab the
reference in common_open() the chip can already be unregistered and freed.

As a matter of fact this solution was the first thing that came into my mind, too,
until I noticed the possible race condition. I can only guess that this was what
James had in mind when he chose to take the extra reference to chip->dev in
tpm_chip_alloc() instead of common_open(). 


>> diff --git a/drivers/char/tpm/tpm-chip.c b/drivers/char/tpm/tpm-chip.c
>> index ddaeceb..3ace199 100644
>> +++ b/drivers/char/tpm/tpm-chip.c
>> @@ -360,8 +360,7 @@ struct tpm_chip *tpm_chip_alloc(struct device *pdev,
>>  	 * while cdevs is in use.  The corresponding put
>>  	 * is in the tpm_devs_release (TPM2 only)
>>  	 */
>> -	if (chip->flags & TPM_CHIP_FLAG_TPM2)
>> -		get_device(&chip->dev);
>> +	get_device(&chip->dev);
>>  
>>  	if (chip->dev_num == 0)
>>  		chip->dev.devt = MKDEV(MISC_MAJOR, TPM_MINOR);
>> @@ -422,8 +421,21 @@ struct tpm_chip *tpmm_chip_alloc(struct device *pdev,
>>  	rc = devm_add_action_or_reset(pdev,
>>  				      (void (*)(void *)) put_device,
>>  				      &chip->dev);
>> -	if (rc)
>> +	if (rc) {
>> +		put_device(&chip->devs);
>>  		return ERR_PTR(rc);
> 
> This isn't right read what 'or_reset' does
> 
 
In case of failure installing the action handler devm_add_action_or_reset() puts
chip->dev for us. But we also have put chip->devs since we have retrieved a 
reference to both chip->dev and chip->devs. Or do I miss something here?

> Jason
> 

Regards,
Lino
