Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36F296C3112
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 12:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230034AbjCUL6M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 07:58:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229746AbjCUL6L (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 07:58:11 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2058.outbound.protection.outlook.com [40.107.92.58])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6116C4C6C8;
        Tue, 21 Mar 2023 04:57:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QJvLEyYEOpDwezVMS8ZTGWZsjgB8dSBD7o5yIxh14aw+S/HbjnwJSZQ7x5fgVrLS65Hdrq8VjqkIPse6bg2q6ZfLzeR3Crw18qOjGeYgF/evzOY7nzx1PW3NCysAMbifHVHm0YDhYguZNEYKdWaJZgyMzLrKRMQaP2kLtXwd7xCmZ/r6yfFkCsyF61DGQJZI2KnPZotDJ7Zua9R/PtmaYX8T2fbXeZ4R03zqu0ONXwlyrq+4rx1Jw3jWbkMTSDftcbKGW0zZcPNju7FUjcuhpiUHVBjX9RQFa4qvXftxgmgmgYtTZMnN9IriWZ7oGFF5dtzJ8kEvmpC7gkkbQ82uLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lF1vJrVRIe/fJDBDyJYKD4/RGRDxQ7rXhwUC8HeUG/s=;
 b=AI27crf6boJH2An5ySMA0sL61nMh7T2v4QZqwBOUc72RfcJ8QvYBSGD9/w5zizgUnfoUO+POL8nD+PfhMUScCeyrNITm+syL5+e+izrq5gtrSbq0IVByWrP9M+iIFKYmrLUMBNKHRNwLI/n6OvIvI9O1yPM99rg5gZaCMoI+Rf7GRBvbp99gB+f4xfWYCEmVdEneQ2oFrCtcTAe9qtQ4+7pMFis1QjGI5EoVHcuV+YftVYIEDhtHXX+W09QIsfN4hYj6jCcYq5QAy+ylSUX072QMe59GV0r91q8g+GVjj7I8Bty9hpGqjNNGWI1A5rH8+0hCb8t2rIcI0wcp8Vd1SQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lF1vJrVRIe/fJDBDyJYKD4/RGRDxQ7rXhwUC8HeUG/s=;
 b=jKQuLDhCfCTXgmq7bSCGqiHiwuGVMdLxapf40yFIbynnBCGzCAmw7XuuDJElX6zRb4u9GLldYBuB74egombT7S4CAG3EeaIldnw40uxzKxju1MUG9pnRMUbueXtomA4dI4l28JnU9OYFt5W8irYp4NHMro81KudRVeWPUljuPeREnWy+x5Yb18eIK9P2LqcpstBPaUqtPPNQyxtpxrch2jrQukUqX/wUbddBS96W+sJmreAHarEuUgFrH0gSBBYowIJjPYjPyA8eRMXwrR1ZzOVZ1MBncd/rafWVy7wpW6y7recxiVzJyZPmMw30dFpAbsNe+v8D3SouDzAfyUZe5Q==
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=nvidia.com;
Received: from CO6PR12MB5444.namprd12.prod.outlook.com (2603:10b6:5:35e::8) by
 DS7PR12MB8273.namprd12.prod.outlook.com (2603:10b6:8:da::14) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.37; Tue, 21 Mar 2023 11:57:42 +0000
Received: from CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07]) by CO6PR12MB5444.namprd12.prod.outlook.com
 ([fe80::5464:997b:389:4b07%9]) with mapi id 15.20.6178.037; Tue, 21 Mar 2023
 11:57:42 +0000
Message-ID: <b779d70b-1b73-5c8c-f01d-d482f7a8103e@nvidia.com>
Date:   Tue, 21 Mar 2023 11:57:27 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
References: <20230320145513.305686421@linuxfoundation.org>
From:   Jon Hunter <jonathanh@nvidia.com>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO0P265CA0009.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:355::20) To CO6PR12MB5444.namprd12.prod.outlook.com
 (2603:10b6:5:35e::8)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO6PR12MB5444:EE_|DS7PR12MB8273:EE_
X-MS-Office365-Filtering-Correlation-Id: 50e5636e-95ff-4c32-9897-08db2a037a01
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3JDQ7YTf6qS/WBR+xRBvAod3V2ocNTMnd8fesV5j4UtQ5QgGfe/Yv88mG5SnRMyGaJgYqNJ/BkV6yZCP8aN59dt8AIztj/TOpu886Z45Qu7r+xDmfnWvYWLcTy05cSJ7h5AUBb5YjHIYH2K/LdeYLPWtM20MDSzVdZsmz1229dmmHmz2UqZacqYDo3pGks4k61TObhF0DjCZdtGe/mwvZnU3P8dXVRRwv5gracXg9EnXba5xrRYbSsh9stCw+YshGbgSVo+tcyUur+g4dgamxzRICw/lo8xEq9M5H0g00ZpY07vtk/atTcybyULIyQc/5uloMiLPtjWjWS6GjAk8XJx2rMEtv8FRmz4Eo53iUZg89NtATAzp6T9P1I8x4BwBrNS5jX7fvvCraBlZbv4kY/OayWftbEthx2jbwbgoPIOy8ePbGzgt34CZbUT/Ly8vHPsSQ00AH0qPSVmLq/e1af2kxv3ifresMDd1/azmMpeGuAZRMZhptTNin3I6ChxsfnJHXJ5OkdT/8fCVXrpQDWJ7GKs9Ua3E78LzThG5e8JNL0N1eeZwA9+X2PLX13eJjHss5iqET7JC74V3RIcbq+De2F2HVvoRUEERdPiDEbbFK7KicM8KOUbCy4JdVu91o14k11w4F00nhsvCbuLpvZ6wz7Jb/G4dwUhIfTjkeqsJzofh4G0oaaa2JJ6r/7LPILKxoR2wStyx9nfSMA7gkkPVLB8yfBck3sku2YUUynhOkCzuzdsJT4WRLbWEWhoe1el87I7uVurTLUyr7O7O7A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO6PR12MB5444.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(136003)(376002)(366004)(346002)(39860400002)(396003)(451199018)(31686004)(2616005)(966005)(316002)(6512007)(6666004)(55236004)(53546011)(6486002)(478600001)(26005)(6506007)(186003)(7416002)(31696002)(38100700002)(86362001)(4744005)(66946007)(5660300002)(41300700001)(4326008)(2906002)(8936002)(36756003)(66476007)(66556008)(8676002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U3VVbExPeVVQZWFSOTFzekJEOFZPcWprRG5FbWhGREltd0JxbE8yYm94cDY5?=
 =?utf-8?B?MnNVTG44YkZleW0wYXhZRHZmVnRJc081OWE5MkMrSDBIWGNha3FxVlNmZ3V5?=
 =?utf-8?B?Q0Q4T1c1b01zNjA2L3Q0ZGFhRENZSDVyOTVlS3V5SEQrOCs2TUpKaXNaSDVD?=
 =?utf-8?B?UDZZN2k3K2txVmRRd2VmNVkyZTRMUDlaMFVyNVZuTEI0c1ZZZVFURmxNRU03?=
 =?utf-8?B?d0VIRHpBWG0zSkdxM2JmeXd4RFM5eXZnUjlIa0p1RTd5K2xEV2xVTStpdVBj?=
 =?utf-8?B?eFhJdzZDMFMrc0NrYUg5cUJIMldaVDVEc2pQMFowZzkxZFphWDZZRzRHR0Jj?=
 =?utf-8?B?NVYyK0JsZnc4TEJCZGNjUkxtOGpLZjFOdURaWm9pMEJQcGdvdTFXZGJ2cDhF?=
 =?utf-8?B?ZkNMQ1hJb3dzbDh4K29jZGZiUDBDdmhLV2xVRERxZ1l2Qis4SUl4K1Q0eHdB?=
 =?utf-8?B?ek1hRVdVYklvOFliTnk1TmpJMmpqKzBvMDZmVVdGSGVuRDlvcXRaZ0VFaXZR?=
 =?utf-8?B?K2JIMUpnOFF1eTdyRWw1QldwMm15bE9BdTI1Ly9Fc0NhUkNQRGN3QzFMbG1p?=
 =?utf-8?B?MjN1QW5EV0RPRkRyWkJBV3VOVTV2dkdqOGx4dGFBT1pDUXk4Vm1HemE0eGtT?=
 =?utf-8?B?cVdqaWl1VVVYTUd5SHVYaGVRTlRhNjRyYTdUdS9vL0gvVkRBMEVGVVhOcmN2?=
 =?utf-8?B?VjdXN1R4UXUvdUVWekRpYjZtQktJZzk2SnorZkhkY2JvdFUyc09kVmJqdWxj?=
 =?utf-8?B?RW9VVm02VHBwREorZjB5UEplMVhMWFhBSjJRYVhNMzFFSTU2bzVsNldYelVy?=
 =?utf-8?B?bXZIUFBhUUQ1Z2s4aytGQTFIL0pDakxWaURMM2xSUEhEY2FUS3ZiMTJUakdi?=
 =?utf-8?B?U3NqMGpmU0tCbXIvSEIrb0lXM05jem9XVVBORE5oMjQ0Sis1OHZLOEViK2VD?=
 =?utf-8?B?WGFaa2FLM0xUOUpDV2ZISGdkV09STjBPNEtPSVB2T24vRjdWNWE5Qm01Zkhh?=
 =?utf-8?B?NnZTZ2JqZk4wcUJ1Z1haZDJRcXR1bCtKK1IwWjNoeDJwMlZWTW5TVEhqRWdX?=
 =?utf-8?B?QWxKYkQ4bm84RDI2WDBKSjRvVm1vTFo1d3BLQVcwTVlwWlBESGNENDFmRGlz?=
 =?utf-8?B?OENLbFh3dTlkTlh2d1pSMFdzTTY1SGtDa1BGVk9tSDV3aHJXN2pSODdNaWlT?=
 =?utf-8?B?cTZ2YkZhWUZkZldoNHBNTzNFVzIxVi9DMnBkNm1JeUQyVThqYWV4Z1hzWWE2?=
 =?utf-8?B?YzdCbzdacmNnN29MSHovV09yOG54NlB3Zk9yNFpTaWw0aFVsSm1OSUlMOEhv?=
 =?utf-8?B?eDUza0JLVy9zYkpXelRKNzNncDdrTG9IMkxSVERQSHpKM1dyMGhld2UxcENr?=
 =?utf-8?B?cVFHcmlZUFJFdWxPKzJubm1Vd2pFVk1ZbTRZWnBMZmZnOVBaV0ZNZ2FhQXlT?=
 =?utf-8?B?eXV1ellvWEtIRFYzRjFuTElpZTBXNnN6bEx0NjVVbTZ2dnFsR3NoZkZMUy9O?=
 =?utf-8?B?eE9BY2VnNWYxQjdET0kvNk1oRkpJWGdwYXNQS01VSisyTnlvZWZLUkNMY0k2?=
 =?utf-8?B?UDFER05OWVo2UDNobHZnVVcyZlRLOThvOFYrNWVhUmc4S0J6eUs4aFA0b0Ez?=
 =?utf-8?B?dHd6bEh0Mlp5Mms5aFR2SW4yRk5yWXFZVVNCL0VhU1BBRzEvQ2tsSkdFbGFk?=
 =?utf-8?B?V0haajJzbTUrdy9McGIwbi9XdmhNbkRzR0xyci9SRWZFZGxocFVVUUUrLzdz?=
 =?utf-8?B?c3lUNm1ZVDJUV2JxVlo3dHVvdXhjR0FwKzJwZzB0L3pvZERDdzhIRS9EMG0r?=
 =?utf-8?B?aUFoUWxMYXFueFdtajRaY05qYWxDc3VING0wdStrdy9VYllMSnpjMXd5QTZo?=
 =?utf-8?B?WlhjY1NLWmlROC9ZVnZxTXFuQ29LZmp2RXlqWEpUZ2FVZmdiVXZ0N1hqU245?=
 =?utf-8?B?cmZ4RUZ1MEZKd3B2UGdON2RJc2NDdk42UzltWVljTlJyRlRPc1puS01LemM1?=
 =?utf-8?B?eW5SS1FuUE1OMFRwVWE0NEkyMlN2ZVZoc05QRU0wVjdOK3Q0TlJ4KzFSUDlh?=
 =?utf-8?B?MFJkY2tHQTZDRk16VWhjck5HdlBDcEpqd0kvUkZydlJhZHlTYlBObm1DTVVy?=
 =?utf-8?B?cU9SRFpOMFdXeHhOY3grbmlocktHZjI4L0hWMlZWQnVpVkhERU1oTkwvbFVH?=
 =?utf-8?B?dGc9PQ==?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50e5636e-95ff-4c32-9897-08db2a037a01
X-MS-Exchange-CrossTenant-AuthSource: CO6PR12MB5444.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Mar 2023 11:57:42.6687
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JsBOiI88dM4fKZHJfk/VWubPNbuOn8u0J7mubclU2Sa83LlxVYfHEERpP7T4tco0CFU3qZw93kPIUXl3qeeOAQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS7PR12MB8273
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 20/03/2023 14:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra.

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Due to infrastructure issues, no test report available, but all tests 
are passing.

Jon

-- 
nvpublic
