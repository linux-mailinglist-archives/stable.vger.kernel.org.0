Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE098678283
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 18:03:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbjAWRDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 12:03:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232517AbjAWRDr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 12:03:47 -0500
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam02on2047.outbound.protection.outlook.com [40.107.95.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D9A918A94
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 09:03:39 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=L/5r1J7N7oiZI6tm2yu3WwrURzH73lNWegzAMFr9TXeRzSW+47XQDuA+X83XeRtOyJ+xvMyDru4KC5c9R5qOLbyyULEOYwzfHcnp5dqG8gARUbgeJY9EH3wqejByoSxAAIuus14ZuLbSkgw4cTb9sYrQndvOPovTb+O9OXqaVXRkrsrhi/lG4DiZJKOFqC1ke5swUTaYyobxZY6gfitXDEfCDJxO6GrjoWdLu1s3pVjF0xD8OJmcyHRjCsVPqWY38SN9jHP3XHqXOncpeyKdCQth0cDysRhTjtPhWEbQJnyuXjvsqb5FEyOhsF7T3BBo+wIEkL1RknGfsdO8GhmTDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kVwPX5E6WhR7mM4R/zPagoQdcJg2vO4tv0que421Wvo=;
 b=LgmLeqNEM4PgJLJCa4gBepVxtJxIbcu0rPT/4E+ZOOIoKHA5DK48MS7OkmgFqfHzBuyJ+jQ+LbTosYQrJ4lvRk5bSD8AlNkF+nl0voKevgIEXeQD3MvjizUha835FtFelVVBDIDgjOOzyiH/pPDwpD4WIWG/fohJLFIT0kx7Wqe9m2OWsL1IoFQKNfAlWmQxQP1biYh/RpJ4H6lVrhMolSqdX3i7UqBW1B4SeMJeDsI2tswOsbs72Z02Gapk7Ok2RnUH+hEzBn2w7PDZhBg92BU3sxKVX/kjxzysk06o8NjqJtkpICr1RgHiJcgm8IR1/F/+4CbLbMWa953FJTDzOA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kVwPX5E6WhR7mM4R/zPagoQdcJg2vO4tv0que421Wvo=;
 b=MJY5ah6Ck2uHxnsrD/x0uSRxpQBV0dcsn5hpJyGibnFi3P1TKHkr4OWT7bXb2at43crSqPJ/C5h9B9PFnBG7T3StNBWuNJ/QhVyG3kiNWaidb0R2Fzzpl9nakm/x07FD1+VjwxuslBhCQijbVJ/l7jk4ts06uxeyWy50tQpbX5g=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from CO6PR12MB5427.namprd12.prod.outlook.com (2603:10b6:5:358::13)
 by SJ0PR12MB5662.namprd12.prod.outlook.com (2603:10b6:a03:429::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6002.33; Mon, 23 Jan
 2023 17:03:36 +0000
Received: from CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::152b:e615:3d60:2bf0]) by CO6PR12MB5427.namprd12.prod.outlook.com
 ([fe80::152b:e615:3d60:2bf0%6]) with mapi id 15.20.6002.033; Mon, 23 Jan 2023
 17:03:36 +0000
Message-ID: <2f37b537-5ce9-ff5c-d577-24d6ac6b5efe@amd.com>
Date:   Mon, 23 Jan 2023 12:03:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 0/7] Fix MST on amdgpu
Content-Language: en-US
To:     Didier 'OdyX' Raboud <odyx@debian.org>,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     ville.syrjala@linux.intel.com, stanislav.lisovskiy@intel.com,
        bskeggs@redhat.com, jerry.zuo@amd.com, mario.limonciello@amd.com,
        lyude@redhat.com, stable@vger.kernel.org, Wayne.Lin@amd.com
References: <20230119235200.441386-1-harry.wentland@amd.com>
 <4499220.LvFx2qVVIh@turnagra>
From:   Harry Wentland <harry.wentland@amd.com>
In-Reply-To: <4499220.LvFx2qVVIh@turnagra>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: YT3PR01CA0002.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:86::10) To CO6PR12MB5427.namprd12.prod.outlook.com
 (2603:10b6:5:358::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5427:EE_|SJ0PR12MB5662:EE_
X-MS-Office365-Filtering-Correlation-Id: 3c39aeb4-6e98-4e30-5f86-08dafd63c415
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Z20edbr4qUq/ah/4k6lxZYCdcLYULgxrZcAYt7SlOOmS+Mgy+O3wVSfzLXlTbiJzkkgdoFO4pPt5UCCthBEcnwdhAPXE1DtfpaHazNqRibbts7O9wi2XY45gJwz4AyK50Dry44qbL1sS4ZTjY4XX84+ysUQCDtPWhWc+7Rnp7lyeGtofDdPwcc6cfyyxL99Mf9HAZSN83nNm2cXLQZrDl/MS65ApYxfREtbrUr+Qv24X1BlIyVaUC8CeSOlMtTJUu70gMnmDDFI/kO1fIetp0IbTvDopifqaKdm8TQsPAgusIkLpaeyKQuOvupwvhSXkhAZsoRQ+xMQ7xxrsYBHBJKSrXmacC+dfrm477HwhGMfjQKsnWfv1WEM1oTQYfKgwtC91rJKgEKG3UT5WuvSPMPP2UFEmpKTHQrxwBo211bqmbWAtOWSftpq4TsZPgOCfCpQ1Bz2Cnqjr+ozLvcXu3vYE3U4EefPv5VZqA0ulTB5SEMKxB5veAO/uXlmGtNvHOs/z99nTabg6RaQcGqwTVJntDpX/GDVow2wcuLdSzO1phMBs/8xnn+d/uI74SqNCKyOELKJODf/9C/+7a1/mx90PllCA+Ocbk37g+nIxxnNl3R/PDuNAxgOqDONPbCBrlhWhBeEVUQQLlR/Clwvt9KXSrfa+PCBVOy4ufgWJqeHRCPnVHcc/DYnRPMxmU+PC
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5427.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(366004)(396003)(346002)(376002)(136003)(39860400002)(451199015)(83380400001)(31696002)(38100700002)(41300700001)(86362001)(4744005)(2906002)(44832011)(8936002)(5660300002)(4326008)(26005)(8676002)(53546011)(186003)(6506007)(6512007)(6666004)(66476007)(66556008)(316002)(2616005)(66946007)(478600001)(966005)(6486002)(31686004)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VFBLUXYrVnk0bkpHbE5HbDIwVlhFME5KM0UrQk8rUUd1UWFRcTNpMkdiOHM3?=
 =?utf-8?B?QW5QK1o5RW9vMmNZUHFnaTZYdkwweGoySUdIZmdOSUxJa2M3WWNVWDZwcFl4?=
 =?utf-8?B?OVZXTzZvSDZCb2o1VHN4M3lqLzY0YjRWSlZndkZHQWlnUXFrY0QyQnFyRVVL?=
 =?utf-8?B?VUdIcklmWTMrWnE5aE5wYVk5RVNQZjYxNUdhVkpuaksyN2VuTGc5T0IxeUVS?=
 =?utf-8?B?QWxLVko0L0Q4NTN2YTVSZ1NUckM5ZThKVjNtcEwvdHBuT1RZMzcvK0Vrbk81?=
 =?utf-8?B?eW5nb1hLZUlXdjBOR0JRYUdHSmE0dWxIU2ZqTE1EUHkrQ05mcHpPMVd2cGZw?=
 =?utf-8?B?MFkwc0d5Qmh0bjVoSnJCUjlBWVducnFvSkdnV2lKQzE2b1pqd0FySjVOcFQ4?=
 =?utf-8?B?djJTcFBxMWVsdDBOYlNUM2FaNXFUVUE4YXJTLzVRUTVHQWZvcWZwK1p0UW94?=
 =?utf-8?B?ZVdsR0s5bGZQV090SWNmRHVhK3ZCNkNqbWFJeFZmTzRWT2dObmRmbmtXWWdZ?=
 =?utf-8?B?SWdjS29oNTBzNkFSL01iQlV6RTZLTnRtN1ZZOU1TZ0F2NllGbFk1YWMzT1pY?=
 =?utf-8?B?OFBJbVBWRHRGQ2xMRjR1RkhUeVJoWlNYUmhFa2xFdG05N2xNK3pKV1FKZTBi?=
 =?utf-8?B?UWRaK0llaTZvMEd6SHAwVFNJSVc5eVBtV3d5T0RpZE45ZTV0bFBNMFB4VGNP?=
 =?utf-8?B?WmYwZnRUM0o0UUIvWE5yRTRabWVjQUo0a3k0cUlDTmkwQXJyeS8zNzRUWkow?=
 =?utf-8?B?RVFrS0VEdkN0bVBFQlBnR295cUVyR2ovNU5NRU91WjNsaGZWZlQ3Y0xWdDJD?=
 =?utf-8?B?UElISTRFUHAxcVBMVWlxdTBybmROTFRMYUxCZTBmd2F6NnRUWlhsUG1kdk9Y?=
 =?utf-8?B?a2N3TElOdXl4bFBDYXc2S0drVGZubHpzaGE5bCtScHk2VVEzNjNpcUc3U2tP?=
 =?utf-8?B?QWlKZ21IMjl1dEE1Z1FHRncyaUNtM1VDQVhBSVIvYTZhaXh3c3gySEJ3QVpF?=
 =?utf-8?B?WWlGckwvYlM3M3BaUytEVTBuOXBTYytDTjBENndrSVNUaEVrMEFqbzYyRUZE?=
 =?utf-8?B?UXQ1UzB3OHVwdkIvSkFOSUhLMUJxYzN3cURZdW1RWHBqUGdYUE84VnZTTFhv?=
 =?utf-8?B?N3hGLzUvV2xwcGI2eU5UdmFENk8vUWI5WmhiSEhQVFZvbUZlZGNoVjlOTy8v?=
 =?utf-8?B?WjNGaEJjblRpR3g4ZUdmcGVjVEd5SG1pYStiZlFPL0pKd3hPbDM1c2JXR01B?=
 =?utf-8?B?MjlOOVdCY3B6b1F5VnNjUVpYRmNPYUp5MG1Ibmp4Y1JuZ3JGY1NJRFRUMUh0?=
 =?utf-8?B?MFVPa2lIYXNydER2VXRpRzRNcC96elpoYzVWbUUxOVBNTy9pZysxdFJsSHRM?=
 =?utf-8?B?VnlUUU9sNzlLT3NwMTh4RDQ3Z09Lb2tvR3hXM2xmM25qdnlpcGhweVZqdTBI?=
 =?utf-8?B?MHBMTjMwUnJQNjkvVEpDT1J0QWpDMDM5bnY1UitHamFDZ2JlT3ZSOFMzRmNP?=
 =?utf-8?B?VEJnWXVmRVA1V1JqaUE4bUpOanUxaE1BdUVWQ3g1aE9lMGg5K3ZlRU9ZbFpq?=
 =?utf-8?B?d0xRWjY1d3hqOC8rZE1wZW9GOWE0N0ViYTd1MVl3eG4zbHBFdUFTQ09kY0V2?=
 =?utf-8?B?amlNZEVQeWloamxiRFBCeTY3ZXI0RHF4OGdKT0JFUlQwVS84ODNyZzcwSk1w?=
 =?utf-8?B?dUpqYlFacVZtWnN6bGlYTlBDWXNQYXlZSjRhVkhHV1d5ZFFtcjdWMGVta2Ey?=
 =?utf-8?B?Z2JEQzQxcXBtZGhEV3BBY0o2SnFSdGFNQXNVcmkrMEJUZkIweGxuRDJZRUZ0?=
 =?utf-8?B?d1JnbStqTGY0MGxDNkdhZkI3OHBuZCtMWUZHMWd3ZkxlTHlldCszYS8yc2oy?=
 =?utf-8?B?TUViRXFlUjVFTUJUeWxnTVlZVmZKbzc2cHRrOXhWTlhUUEJSbFhJQUJoN0ZV?=
 =?utf-8?B?SjJBb2NHS1gzcjI2RnpLQ09XMUNUdVBJSmNwUnY1d2xKbXhtbEZycHdFMTMz?=
 =?utf-8?B?MHNmTjhjS0JjR0thTXA5dmFhWXhtR3p0a3B0YmorbCs2L1pDRElFelE2Lzhu?=
 =?utf-8?B?RUdSSnFGalk1a3djRGwxQktHb29oditkdVl1VEZsUXNrTFNRcVBnMUh5bkQ2?=
 =?utf-8?Q?2ZEIqeYfZXEMWofHeDCeFAxIt?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3c39aeb4-6e98-4e30-5f86-08dafd63c415
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5427.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2023 17:03:36.2326
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UdRSic0zTfQZWd5vnueHPca6xA6wg7a1TQRMOt96K0GLBX7/y8NU+f8LkgvGkTg39c2X5AzcWQCfE3Gd5Hp2Mg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR12MB5662
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/22/23 14:12, Didier 'OdyX' Raboud wrote:
> For the whole series, as rebased on v6.1.7. Tested on this Thinkpad X13 AMD 
> Gen2:
> 
> Tested-By: Didier Raboud <odyx@debian.org>

Thanks.

Harry

> 
> Le vendredi, 20 janvier 2023, 00.51:53 h CET Harry Wentland a écrit :
>> MST has been broken on amdgpu after a refactor in drm_dp_mst
>> code that was aligning drm_dp_mst more closely with the atomic
>> model.
>>
>> The gitlab issue: https://gitlab.freedesktop.org/drm/amd/-/issues/2171
>>
>> This series fixes it.
> 
> 

