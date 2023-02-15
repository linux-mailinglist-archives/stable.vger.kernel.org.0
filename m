Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA61697625
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 07:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231276AbjBOGLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 01:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbjBOGLH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 01:11:07 -0500
Received: from NAM11-CO1-obe.outbound.protection.outlook.com (mail-co1nam11on2078.outbound.protection.outlook.com [40.107.220.78])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B1C3346D;
        Tue, 14 Feb 2023 22:11:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G52oHTFVXGuAC+LNiWps+cvTUsR6um3wheKpVS/N4mkP90IF7HZPJvQjVZhimBaGcs3yo3B1RijDSiDv7XHS1YGL1ZlCu8qvbBDlWIxjxc+jVG71GLlj+E2eXkkmPUJu3YOpKfu0PfsRuAkOxp5fvDztr+kBceHPnZfCFd89iTBil3ti8Wum6lxxecXc1fmji6rG3cdbH2lfFiGGSkGPvhlRTXEvYC8saZzbygDWj/pxcWBO4UwZo4IuMGmn5Q/V8nWNeMOWhcAI8pfsrp6lP2CVsiTXxrJEw7ioeSbCsuruwLeuE/FLWzCnSPjGERdL4YYvnDS90qLVLD9RmQgFfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=YMKVOUC0kWQAUEtQbD25kUiZo3xaFgtetgXMTnXYyTg=;
 b=ObtG1+ishXh+NdFSePnCnFpacC46PeNc8/iOPGasFqbr+35l+XaDBHnnG8H9Lfjv/Afn+4UFeJ7+NAqhx3Lhw5tQnEaMNbYXXmcIZiC2z0iy5fr6WmgsLwdOR8XZ2oG3clisQcijvd/19p0o4ScIPWMxr6eIfbRzAXbQCWxJ9kPQAaFR4zIU7AODbX9QA4DyCEmNY9C94KFcI2tAlW6D9DNxjnXA32mABor4+HxXcvtXmjPM3O50Q+MWuxKm4G8Vt2z9HYwmWJJWG5lMgF+RXfhg2Sv5ATHfMOq//GDwdFwe+Nj2mWjEAWQgApW3Vuxl5hRJSGhFA/8Jaw/2U/AUpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=YMKVOUC0kWQAUEtQbD25kUiZo3xaFgtetgXMTnXYyTg=;
 b=r0YKKuKwmF7cVNY/DRFtth5478/MmSZLxbug7kFX4hNMmoUYXI6UQ7f+Abti3rlnijh2zD4RrdBMUPP54EMXYAeR5Z1vwbgGyuqGTAaBN802d9pvN0LIZcgUJ4jLOek43dyShs7a9NvPCpKyE5vfdPlg/mFq8cs3Z+Yldph8cGo=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MN0PR12MB6101.namprd12.prod.outlook.com (2603:10b6:208:3cb::10)
 by CY8PR12MB7217.namprd12.prod.outlook.com (2603:10b6:930:5b::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.26; Wed, 15 Feb
 2023 06:10:58 +0000
Received: from MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c]) by MN0PR12MB6101.namprd12.prod.outlook.com
 ([fe80::a59e:bafb:f202:313c%5]) with mapi id 15.20.6086.024; Wed, 15 Feb 2023
 06:10:58 +0000
Message-ID: <8f099a80-7fd1-c98a-4990-4a936a5a610a@amd.com>
Date:   Wed, 15 Feb 2023 00:10:54 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 1/2] thunderbolt: Read DROM directly from NVM before
 trying bit banging
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Andreas Noever <andreas.noever@gmail.com>,
        Michael Jamet <michael.jamet@intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>, Sanju.Mehta@amd.com,
        stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230214154647.874-1-mario.limonciello@amd.com>
 <20230214154647.874-2-mario.limonciello@amd.com>
 <Y+x0cbSpnIPYjZJE@black.fi.intel.com>
Content-Language: en-US
From:   Mario Limonciello <mario.limonciello@amd.com>
In-Reply-To: <Y+x0cbSpnIPYjZJE@black.fi.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: YT3PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::10) To MN0PR12MB6101.namprd12.prod.outlook.com
 (2603:10b6:208:3cb::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR12MB6101:EE_|CY8PR12MB7217:EE_
X-MS-Office365-Filtering-Correlation-Id: 5e1bb7fc-a10c-4b59-8dc1-08db0f1b6765
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sRFPPyzB6lJGF14NSlD2uLZ595f+in4bEq4r8IsmiitK65BLgldurvi8OazKe02Lq/o3rDlQVN+kn8iluuDbQooTTgCg40jVjcD2KqO3EMWtIWvRvxXCLMH0uusNKUPS+jX8MhNtuCZ09bv0KLPOdeKZJa0r02eHREeK4C2oYzMbzeRUDzuHUD48YNGmjnmNeYamZhiRXaWFQOmTPXxc2BTiwfcZPJ4rovA5/1rBCKv4t1977elAmAfBy6RktPWKRHWvD2HzJLG2ETAJD61V5gvIj7iFkDTbHkJ+uUm01kd178+KEyCclwA6lT/gAM/pavBlBcAX41ZxbBCdzm6mjcJQVFYrhf7a4VoZL0iAqpomTvsYUP6fSCnZoVKzgzv8sxqGd0ZUReyqEcqWXb53cyPBXoo63RSxxwjDM8nqIX5Z5yzFwZUBoWv7btVpEk9d1xd4LOYrZqBaEC4E0I56eFTAcyq1uXGbvcsfWozRlHo3LPehJbYuumr9yG3MtKNbLBwqWxz+IQXl8dOpF635GcJtuCQ6p73zjXqc7ELrzwMmOj2QTGwH2g7FwpHpuaJOi9gvrMZSTX98PDZljP9gQP2VqCmEd7htPK2/s5IQxhyOmyA5ZCQmkhxQ1SVKXM0Lvwds7zWuUv5R5Zy8nlXc2z9SI13U1+n0JhK2PW1o4k/EBXO8hoWvg9A6pmtw6sBrV9uIHkfXGKMlkkT958McVQ/3uR2z8c5oVNyI5bpa/Gc5MZIHGbWXQe52eq86UEOKln8qKjF8bwBf4me9+pJXOg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR12MB6101.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(396003)(376002)(136003)(346002)(39860400002)(366004)(451199018)(83380400001)(2906002)(8936002)(41300700001)(5660300002)(44832011)(36756003)(4326008)(6916009)(8676002)(66946007)(66476007)(54906003)(66556008)(316002)(6486002)(478600001)(53546011)(66574015)(2616005)(31696002)(6506007)(6666004)(6512007)(186003)(86362001)(38100700002)(31686004)(187633001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U0NSSVpTMC9rN3J2aUlFOGF1eEsvcmlzL2kwUkhYdkF0S1huZ0pPMGpha2x3?=
 =?utf-8?B?amtFa3FoNlcyeUhCdXV3LzJGOFpKQlQ5aHZBSDc0SGR2eUhNYllmN0NhTkpG?=
 =?utf-8?B?YUlzRExZcXZibERkcmlxOENZait2elRGMC85R2xEc0hiamZKeVVvTWt0WjlQ?=
 =?utf-8?B?VjJVN0Q2WGJCeS9OTVlFTmErTVV0b3NJYjRJMWdMVVMxaWw5TitielFOR3VZ?=
 =?utf-8?B?SUhsUU1PaENaY1BsUnVwOHVWTHpyUmk5L01tYmZ3Mk1veEZPL3U0L1V2SXhZ?=
 =?utf-8?B?cGgrd2NRWmdXYXZyaGhoY2xsTDk1d2wzYmh0WXB5SlZjbU5sYW1GcG5uMndQ?=
 =?utf-8?B?aTM1blNmSTU4YWxLNCt4aWF6QzNUbzJIb0twUmVnU01TTFRRd2hsa3I0VEcx?=
 =?utf-8?B?ZVpaUkFBc05IVzJPb2l0U3FpMUxqVkVWbzNVb3dKSmpIdkpYNmVUaFBKUUhi?=
 =?utf-8?B?TXR2bW9sYlVkZ3dWNVl5bmc3MWJiZEovUmVZaVBwWmNTc3QrcFVMbHBMWWpt?=
 =?utf-8?B?SUFQTS94RnhsbkxlVGpKZTFHL0xha3Jwa3ZzNlMvZGtSajcvZnFYdWs3VFRI?=
 =?utf-8?B?M2NZd3p2Y1RUbmw4V0MzZ1ZYTmgrdml0WTZnbTYydm5UMzJOZTZZUFk2SlN0?=
 =?utf-8?B?T1ZGbzdQdGVqdFVRQlhaZDA3dnBTQld3SzZPb1VoY0YrdmoyaGVlSzdod2Q3?=
 =?utf-8?B?ekVGZ0o3ck51cjh6L283YW9sSnZsbk5OYXJ3OWtlYWRtZGFjeVdPNlhZcDVa?=
 =?utf-8?B?SlBSckJtUHBmTnVBSm5jL1BhWFN5RmpCUStxNk4xOGxWbGg1TjFIbXVSckcx?=
 =?utf-8?B?L3lxZGZocm5iMUVoSnVzTW10ZmxMblBwcFFjekdUcUdJdk9JZVlTb0NOODBo?=
 =?utf-8?B?bDhkSkV2bDBWdldjNVR6YlkwYnZsR1E3Ym1SSGNRT3dmM0RnaGsyWmxRTGlm?=
 =?utf-8?B?b1hQVi91UkI5S2wvd1VBWEJMcFNiL0ZhbEFsWjh0dGNpYjVjWWhNQmZjaHJV?=
 =?utf-8?B?S1lDcGNkcWlOemM2RWNZa3U2dUFqVkY2SG42VXVxRFp2cTdHaWtXVldpYlpw?=
 =?utf-8?B?aHF6MU9zMmVYdlVaSmdwOVgxRG1rVW1BcktGOVpZYnVzOTNueWZ6cElHSjlH?=
 =?utf-8?B?NFVLcy9NLyt0b1RWTHNoN2NIclpVeTRNTUloRUsyV0xKUnpZTnRVaTNMNjBU?=
 =?utf-8?B?N2hWTWQ3enU1N1FNWngrK0NyRFRqMDBWOU9QVTNDcThjN0VYRHBjaXNoeElz?=
 =?utf-8?B?ZEFEb0drcGNFQWUvbGE0Ui9IR0lhQlljWWdSWnpJcThWTEdOK3RpNWRQTVM2?=
 =?utf-8?B?UjhVT2JyQVAvcnBHRjhSOCtISGdxVWFUL3NRd1hyeE9NRTd2aXNxQWtVU3hL?=
 =?utf-8?B?QnJaTW53aGxTbTBGdU9JaFA0cko0ZHU5SFBSUzBFK3orVkxEL0licmxTT0Zz?=
 =?utf-8?B?OTdmdVhTSkV5NmhWckxQck5icTlrM1YwMWpmNy9IWnFJQjJPTVRLdFd4Mmlk?=
 =?utf-8?B?TE9uU215K2ZMTGhqQWNmWGdvbmlDc1EwSm5sSHZsZ2NCcFZtZzkvTlpHMjRC?=
 =?utf-8?B?YlV0VSsrR3IyY0hlRGc4c0RIZ2xnaHYxVUlRbC9Sbk1PcXluSHJPaUk0T3BH?=
 =?utf-8?B?OXNvZkRkbENBQXdEeDl6eDhCelBVSklGY1VpTDJPVnBWeStETDBIN0s3ZlAr?=
 =?utf-8?B?ak5xUk1QYnhuK3pjWXRwa3FhWGxMMlJ0UDJLQW1KOHNHZkZQMlFCQ3VuMDNK?=
 =?utf-8?B?c3QwazlUSE5WM3hxT3hVMytJUjhUOUl3b0w5ZUlYR0x1cWhvMWZWQVRJMGZv?=
 =?utf-8?B?b0hMU1MrK3Zha2hnVWc0NTBJeHVCRVViR29ia21lWHBPc28rbWo4dUpCK2ht?=
 =?utf-8?B?T21lZkdIbTc4eU1xcDZJc3BiVkVXZkxSclBSUkt4aXN2cjlzU25JMFh2VTBq?=
 =?utf-8?B?NklwSlVjdG5aNlI1cmZnODlwOVZWSXRRUW16QXp0VE8waW5xamJqNm9HcDVK?=
 =?utf-8?B?TGRGUnpyY0FOdU92d0RGMENVV1FQUURIV3NLeHVkSkl6ZTFWR3hWUW1iemZ0?=
 =?utf-8?B?TkJBWVJ3RDNDT0R4QnJMNVNXQzNXNTUzRlF4VDRVSDkwSTlPL0cwRG93SFJs?=
 =?utf-8?B?YWxCQy9zcVRCb3dBM1RwS0VEdWFaekxRYU1PbC9KOGtvcEtPRTdYWjByVXJn?=
 =?utf-8?Q?nljOD7s+NWeGhi3KCNzB/SoKWsPXC26EiX6PwmzEh4tx?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5e1bb7fc-a10c-4b59-8dc1-08db0f1b6765
X-MS-Exchange-CrossTenant-AuthSource: MN0PR12MB6101.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Feb 2023 06:10:57.8642
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: itPs6/xK2piEczI4YFAfBMdt5aI2qNTEipLhej+czd13SpIF16KjOqqJrL2jgB4vUp/dM7dq9hKNQ7rayDUaTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR12MB7217
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 2/14/23 23:58, Mika Westerberg wrote:
> Hi,
>
> On Tue, Feb 14, 2023 at 09:46:45AM -0600, Mario Limonciello wrote:
>> Some TBT3 devices have a hard time reliably responding to bit banging
>> requests correctly when connected to AMD USB4 hosts running Linux.
>>
>> These problems are not reported in any other CM, and comparing the
>> implementations the Linux CM is the only one that utilizes bit banging
>> to access the DROM. Other CM implementations access the DROM directly
>> from the NVM instead of bit banging.
> I'm sure Apple CM uses bitbanging because it is what Andreas reverse
> engineered when he added the initial Linux Thunderbolt support ;-) I
> guess this is then only Window CM? The problem with reading NVM directly
> is that we may lose things like UUID, so I'm wondering if there is
> something else going on.

When I say other CMs, maybe I should have specified which ones were 
checked :)

The following CM get the DROM without bit-banging:

Win11 CM (MS inbox)

Win10 CM (AMD)

Pre-OS CM (AMD)

> Can you give some details, like what is the device in question?

It happens with both AR and TR based TBT3 devices connected to AMD USB4 
router.
It's not any one specific vendor or model, we've seen it across multiple 
vendors with
a failure rate of about 30%.


With an analyzer connected in between we can see that the connected TBT3 
device
does respond to the bit banging correctly, but the response is not 
making it over to
the USB4 router.

It happens with multiple retimer vendors, but it hasn't been checked on 
a retimer-less
system yet.

>> Adjust the flow to try this on TBT3 devices before resorting to bit
>> banging.
>>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
>> ---
>>   drivers/thunderbolt/eeprom.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/drivers/thunderbolt/eeprom.c b/drivers/thunderbolt/eeprom.c
>> index c90d22f56d4e1..d9d9567bb938b 100644
>> --- a/drivers/thunderbolt/eeprom.c
>> +++ b/drivers/thunderbolt/eeprom.c
>> @@ -640,6 +640,10 @@ int tb_drom_read(struct tb_switch *sw)
>>   		return 0;
>>   	}
>>   
>> +	/* TBT3 devices have the DROM as part of NVM */
>> +	if (tb_drom_copy_nvm(sw, &size) == 0)
>> +		goto parse;
>> +
>>   	res = tb_drom_read_n(sw, 14, (u8 *) &size, 2);
>>   	if (res)
>>   		return res;
>> -- 
>> 2.25.1

I guess something else that might be less detrimental the loss of UUID
by reading DROM this way would be to only read DROM this way if any CRC 
failed.

