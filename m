Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C712584433
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 18:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229634AbiG1QdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 12:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiG1QdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 12:33:19 -0400
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (mail-dm6nam10on2083.outbound.protection.outlook.com [40.107.93.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C072A408;
        Thu, 28 Jul 2022 09:33:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kIDMe5J7Q8IjurFy8i/H/weHbsAjIu92oD9X2MjPaWxHnAVO/0gwdMkmBg4zNtWcX035YPLqpAUO0uLVG536WLSUhSDWxwOB3xzHnHf+EdbAAwogiMPseIEpDSrvAwSyeA3ZlRFGCZ8qUVxumuxjqv7lG8w6CQ8dXsUTYBw3qdvsFusPU5C1W/QeRWIYZDDrYz2p+/B4T/huroJRFn+6lNMxMJBMz+00jUYqjYNn2qFHOd/Fq8RuShJUfwAGQqw+zhkXNtzXeB+/Ah2es7fUrWCmSnO4zIcYsWAFyguSqk5kJ8un6ZpW2PGwZOm9QJe88MgE8yChWWYGHwL9hUnKGw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oSgWuGBTBMJA+UeWp5ch+6OMOomCRXMjNQCW+DrlL2Y=;
 b=YzK6fyfWsGBJ2zdikDCZCsDrmP7JkdplD9Ma8oVTnX3x8HsVWOe6uN4Lc6V8WHUWShprL5Hf5E9udhSYtfka7jxbvItDEt2aQBsCtaPuYRefzJtzYrnWZIrzWwAUahw/6gKDscfLf0q9YZp7xNi4Ky1G/ANnifIHvZbfKANsJLm3kl9zmqP9aOFLp5mBCQ6dYDRTO5IKUqqv0ksKlynTIv6stOYCxCsUin3qOU5ZDKvpKDkT9ZJiTH82FnjvPf7f9eonJhkrAaGahnKZxQsl0iaigeRNZ/Ps9hAk1lB2WMEzUIxShDWcGLTr1xIoaSeR0STkQbGSZVizAhehHyBdTw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 12.22.5.234) smtp.rcpttodomain=gmail.com smtp.mailfrom=nvidia.com;
 dmarc=temperror action=none header.from=nvidia.com; dkim=none (message not
 signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oSgWuGBTBMJA+UeWp5ch+6OMOomCRXMjNQCW+DrlL2Y=;
 b=brmMtDETyzVbTVOpCisikN/u7z3wvRuzEaNVJHMok4KMwTfPxXj3mQ/iuJXxNQaDMS7T5n0SQOr45jVztyJrfvV/y4qn/riEurbm75mZugEU+6DzyTIx6UDsvSyKtgVtApo1BOCEilJlg34uI6PnJl9Tn6P94lmXvu0Edv+NLm2cmG7Xz+AZsyzHEqGHGnuV+214fkjs05sokxLFtPHQyuHFO/kBhsLYF9US3ae5Yju/UeNibj5LixSodjfZc1vInTh9JO9r4E7fOXl94lpkIrkjAtMMT+LRF8c4dB6uTF+XQ8U8DSvW5TLxmHuJbHl8e1L7ujd1u1PHw0D5V512Kw==
Received: from DM6PR07CA0053.namprd07.prod.outlook.com (2603:10b6:5:74::30) by
 MN2PR12MB3150.namprd12.prod.outlook.com (2603:10b6:208:c7::15) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5458.18; Thu, 28 Jul 2022 16:33:14 +0000
Received: from DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
 (2603:10b6:5:74:cafe::d3) by DM6PR07CA0053.outlook.office365.com
 (2603:10b6:5:74::30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5458.19 via Frontend
 Transport; Thu, 28 Jul 2022 16:33:14 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is 12.22.5.234)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=temperror action=none header.from=nvidia.com;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of nvidia.com: DNS Timeout)
Received: from mail.nvidia.com (12.22.5.234) by
 DM6NAM11FT052.mail.protection.outlook.com (10.13.172.111) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.5482.10 via Frontend Transport; Thu, 28 Jul 2022 16:33:11 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by DRHQMAIL101.nvidia.com
 (10.27.9.10) with Microsoft SMTP Server (TLS) id 15.0.1497.32; Thu, 28 Jul
 2022 16:30:20 +0000
Received: from rnnvmail203.nvidia.com (10.129.68.9) by rnnvmail203.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Thu, 28 Jul
 2022 09:30:20 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.129.68.9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26 via Frontend
 Transport; Thu, 28 Jul 2022 09:30:19 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <slade@sladewatkins.com>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/202] 5.15.58-rc2 review
In-Reply-To: <20220728133327.660846209@linuxfoundation.org>
References: <20220728133327.660846209@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <1032a83d-0d96-4fe2-a4d2-381b924059d2@rnnvmail203.nvidia.com>
Date:   Thu, 28 Jul 2022 09:30:19 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 13137246-c249-42f2-4b02-08da70b6dd00
X-MS-TrafficTypeDiagnostic: MN2PR12MB3150:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZou5xmc+lt6eIc7cyDWk3dreexHjZOsXFGQbWoTQ8woePK0QF1nrgZ00YukMbs/Lxhl5lTWoMlUNGYXZTiVrTS6qEF+X+8PPLcVuGaGRclgPcfet76CCUh4L1gpWtUaF9EPaksF3q7fNAilDAkL/rKvlTSxYr0OszPXY29nGDN/lbtToqSX04CTB+4D7N+ZowhT7jx18LV+/rqgZpD+Yfow2EBxVcHLzCdg7jD1cHn5GozvHax90WDIuOCTY5WX5Ua/FJKVt6PUC1MfteWokLk+WAQqshnSNWaUw6WDUHKKB4H3uGFAL9UUKEPescfqS5Vt21czt898MBGPkttuLefX7nwU+TQowIdHwAdngRTauAESxM17u/14I5Ku8HTlUSg7nCVoj0Qpq5pBb/15O/ix/cry5KQEqu1jzQxc9Vx6X6oil4V+1OfQ44XN2U8WyUZZ6QjSEx3t5Xyp+gV6gNkvT4kVlcBv5u6bW2iTrgMlUx3N9mCc6q7fSjA2I8LNWpcN9Cwshc0VLY9S9yr6FXDaF9SjDCKbGiKtW7uNHvR5TjvXfxIOWt0xzF3RaHtQ0Grh6fzRC6jPmM8H4Fg+PxbHwBMS/yooEm/hLh4Ptxqd5rqORf++SQlkT7ttbXJPPyIYseGZj7gMoM9pMoG5y+PrUNUwogheLd5/4aeXWEEWfzLNOZflvT/0i7a2aF9oH+MtX6Sd85FcHVIAmBuDf3L00124o+rnBQ1vgSFDMgwZF9eCRTQo7BcHM0ojK3G7nt9N407LzNbCFma9h1wJrZ3bTGl5U2NAeEHdBcXlSgXIk1QIDvu+aiPul/pYI8xNkwNETflDJ2MNnLgwFHCFHQVnNMnH2uQdB4h1KW1Ju6nke1J9sLQsyuCzJq/IKdKQLnwZQ0hPE3VfG7doIy7AxhrAOt3F0e1QX0sxyHZtjqQ=
X-Forefront-Antispam-Report: CIP:12.22.5.234;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:InfoNoRecords;CAT:NONE;SFS:(13230016)(4636009)(39860400002)(136003)(376002)(396003)(346002)(40470700004)(36840700001)(46966006)(63350400001)(336012)(186003)(26005)(63370400001)(426003)(54906003)(4326008)(47076005)(31686004)(8676002)(70586007)(70206006)(316002)(6916009)(86362001)(41300700001)(966005)(7416002)(5660300002)(478600001)(8936002)(2906002)(356005)(40480700001)(82310400005)(81166007)(82740400003)(40460700003)(36860700001)(31696002)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jul 2022 16:33:11.9395
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 13137246-c249-42f2-4b02-08da70b6dd00
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[12.22.5.234];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: DM6NAM11FT052.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR12MB3150
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 28 Jul 2022 15:33:50 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 13:32:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.58-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.15:
    10 builds:	10 pass, 0 fail
    28 boots:	28 pass, 0 fail
    114 tests:	114 pass, 0 fail

Linux version:	5.15.58-rc2-g77a604df16d5
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra194-p3509-0000+p3668-0000,
                tegra20-ventana, tegra210-p2371-2180,
                tegra210-p3450-0000, tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
