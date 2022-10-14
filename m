Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 517A35FF1CC
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 17:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbiJNPzV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 11:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbiJNPzV (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 11:55:21 -0400
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (mail-dm6nam11on2070.outbound.protection.outlook.com [40.107.223.70])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA76A4E188;
        Fri, 14 Oct 2022 08:55:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n2OepVQiBvWM2b2BrxZNCaAk0DZbXqgSwIweCt3G7x36gAUw3ZZAmVkDFFetHxvd/rnfdVPL1u4mM8kPh9bu+IwSmKVBXnA3sylrFPZd89q/3OwZ8yW8YqtZZbvgAD+XtaXwD0HNfSWMyIWvMeCcNJX8Ln2kmBqaaJjFo25X0HGnxW7XU6TV1Pe96jPUoQRbSiR99zLy8D0sG5kYXIOEKG9PRAu4N6et6NCO/Ot63mBnKirfQdi8l4zSPpR+jiWjDzXy02m0rGiyoYya88yOJQtde0arg4Jq5ocMzy969D73yHb8rjzCMUfKx2GBBYvXR9QDfKgfjID1HTWZig/1vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=n3h/lhMFFSfJRo19X7/3289vgcdkA4NL/a92yShcBOk=;
 b=lWdMxZauOuEAv1cGDvSzO1bBCgcdifQpDUT0ZTH7m/1gHCsozVF+QeG9RFD2zgFfX5PXHwNYMO+iy1kKWWWr6iIhm8XqAikC+aAdsRMMiocWUHjf+ckcbIGoRtcpNP4hj6cedOrd0ojlg4ZOAVe1DQkmXSYMtknHXbvoCeHTkbN7Lf+X4MaCe6p5FL9PpZxRkl2Sb170fZAalw4/oRDCXD9a36DCrcRFh7Bhuw73cC63wYEE1xfGLyhdyZ6cnor0V7klkj6xslx3di/D6N17D1t365Dvv4yNoN8hRhG5zB7o/vrFbhH6HjPpaTprxQiuSAw18QVhjVCk9jNsBCw5vQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 216.228.118.232) smtp.rcpttodomain=linuxfoundation.org
 smtp.mailfrom=nvidia.com; dmarc=pass (p=reject sp=reject pct=100) action=none
 header.from=nvidia.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n3h/lhMFFSfJRo19X7/3289vgcdkA4NL/a92yShcBOk=;
 b=a460xxbgtg08Ji1BDE4whrk1yP3lywFMZYO9mNYmU9dn42peweUg8IoAhp4UDhj+bH8VPJcyFBm1VjdYlzqw1o9Kcusu6ck8/6pgcQL726e3SlvM6EE3yfuMDXJoTjUi6J6B42C2AroE2AILRPCMx8pNZmXSZn13tN8oZCNEZ10EWvEfREbRZ3cmd+RC3ww7Ac9noFY5Jo43oHeMwBHZofwAJubdEWPsXFG/ZHMi1XZ0NtA4Dtq9E7iT3Uig2HB9jxKnWto0DlTs6E2QZhNJOL5NK9C67AIFKc3CkWDlXxOYjIG/g68qZ0w+9lDqzN247g4mJ+rI2HozG3uv+w0UJw==
Received: from MW4PR03CA0149.namprd03.prod.outlook.com (2603:10b6:303:8c::34)
 by DS0PR12MB7772.namprd12.prod.outlook.com (2603:10b6:8:138::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5709.21; Fri, 14 Oct
 2022 15:55:16 +0000
Received: from CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
 (2603:10b6:303:8c:cafe::fa) by MW4PR03CA0149.outlook.office365.com
 (2603:10b6:303:8c::34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5723.30 via Frontend
 Transport; Fri, 14 Oct 2022 15:55:16 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 216.228.118.232)
 smtp.mailfrom=nvidia.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=nvidia.com;
Received-SPF: Pass (protection.outlook.com: domain of nvidia.com designates
 216.228.118.232 as permitted sender) receiver=protection.outlook.com;
 client-ip=216.228.118.232; helo=mail.nvidia.com; pr=C
Received: from mail.nvidia.com (216.228.118.232) by
 CO1NAM11FT078.mail.protection.outlook.com (10.13.175.177) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5723.20 via Frontend Transport; Fri, 14 Oct 2022 15:55:16 +0000
Received: from drhqmail203.nvidia.com (10.126.190.182) by mail.nvidia.com
 (10.127.129.5) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.26; Fri, 14 Oct
 2022 08:54:58 -0700
Received: from drhqmail202.nvidia.com (10.126.190.181) by
 drhqmail203.nvidia.com (10.126.190.182) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.986.29; Fri, 14 Oct 2022 08:54:58 -0700
Received: from jonathanh-vm-01.nvidia.com (10.127.8.9) by mail.nvidia.com
 (10.126.190.181) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.986.29 via Frontend
 Transport; Fri, 14 Oct 2022 08:54:58 -0700
From:   Jon Hunter <jonathanh@nvidia.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <stable@vger.kernel.org>, <torvalds@linux-foundation.org>,
        <akpm@linux-foundation.org>, <linux@roeck-us.net>,
        <shuah@kernel.org>, <patches@kernelci.org>,
        <lkft-triage@lists.linaro.org>, <pavel@denx.de>,
        <jonathanh@nvidia.com>, <f.fainelli@gmail.com>,
        <sudipm.mukherjee@gmail.com>, <srw@sladewatkins.net>,
        <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 5.4 00/38] 5.4.218-rc1 review
In-Reply-To: <20221013175144.245431424@linuxfoundation.org>
References: <20221013175144.245431424@linuxfoundation.org>
X-NVConfidentiality: public
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Message-ID: <7dd0f5f6-9c55-4cda-8d97-492332512ada@drhqmail202.nvidia.com>
Date:   Fri, 14 Oct 2022 08:54:58 -0700
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1NAM11FT078:EE_|DS0PR12MB7772:EE_
X-MS-Office365-Filtering-Correlation-Id: c34a3544-4c7f-49a4-60fb-08daadfc7cab
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7cIN+qbrkYxvi0VXhcpia2eVzH+EM0qoUoyyhEe7y+EwotEfhmZqp+R5ifsrmKfpMUXZ6z56MDR1BaF3WdXmUvfpIescWUyOhFyxW4R6KOTDB3xYqBY6oXNaHY3nTFzG1qVnKwt8vDFoxTQl3ZwYiCj4OzfKXeI6FUQl9G+D7XHNLyHDR8Xblj3CfHfK9Ygq8EiKW1HvzVvfjxe1qWhmqPMjwEZfyjnj1llwglbTLWB+svsYUE114BaCHiE3cysLkIohQ5J2qSSDZ1tvYnG06WQCSjwgHpRC82DlXx5m3ZyDrbYRgaiJXM99ACAJzTpoz4/rtTwWb48ZS8fCGe+JiEIqJcq2lAA8X4wDQ6vgMYvDqMEjptIG6YEf8/8cz9D/R8HSaDomrmYqGEckyIziPdW8ZbnRGwAUVwhsbosmGM8X3x2NTWjIIfVMInHUHkke9InxTi/JQQ7meWpqiLrymCuzfoCGEbCFY2YitPrNxpTKsC3HI4wClgn+2DGbmLA0MTqDhiDjbOvoMISkq24uOJo83S19BtN7P/JmDuuv+vGDNl6Cp47td35ubWwPMz6CEsMJrwyTwhFqQr8zTKH3Qq/0SJfW0t07iKxvWa1cIgp+b5YvN4IBWiWNrjdWwlw9xA2+kEJvoM2/c4uMju5HyAtqbugS7UUYckKk9ynL3NGhyPlnGx9MqXK/9ud8OBmAPVa++RA6SZ/Wt4/Db1FscfIQE4YhqCTIDB7g0TITUpQa+oth5KyuW9by6eJgq2F1WqC7M3sx+0TQfKiU9LQkRFOzjN7U3iHZadxF15CNQxe03KA0YdqeX5WvWhZJ63RF4kYuN7ku+qaQJtwIwtHtLjiiHExqi+6gQ7JwJhg0XGw=
X-Forefront-Antispam-Report: CIP:216.228.118.232;CTRY:US;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mail.nvidia.com;PTR:dc7edge1.nvidia.com;CAT:NONE;SFS:(13230022)(4636009)(376002)(39860400002)(136003)(346002)(396003)(451199015)(46966006)(36840700001)(40470700004)(31686004)(82310400005)(40460700003)(31696002)(86362001)(356005)(7416002)(2906002)(5660300002)(70586007)(41300700001)(4326008)(8676002)(316002)(6916009)(70206006)(7636003)(54906003)(8936002)(82740400003)(478600001)(36860700001)(966005)(40480700001)(426003)(336012)(47076005)(186003)(26005);DIR:OUT;SFP:1101;
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Oct 2022 15:55:16.0379
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: c34a3544-4c7f-49a4-60fb-08daadfc7cab
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=43083d15-7273-40c1-b7db-39efd9ccc17a;Ip=[216.228.118.232];Helo=[mail.nvidia.com]
X-MS-Exchange-CrossTenant-AuthSource: CO1NAM11FT078.eop-nam11.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR12MB7772
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 13 Oct 2022 19:52:01 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.218 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

All tests passing for Tegra ...

Test results for stable-v5.4:
    10 builds:	10 pass, 0 fail
    26 boots:	26 pass, 0 fail
    59 tests:	59 pass, 0 fail

Linux version:	5.4.218-rc1-g34b618a713e7
Boards tested:	tegra124-jetson-tk1, tegra186-p2771-0000,
                tegra194-p2972-0000, tegra20-ventana,
                tegra210-p2371-2180, tegra210-p3450-0000,
                tegra30-cardhu-a04

Tested-by: Jon Hunter <jonathanh@nvidia.com>

Jon
