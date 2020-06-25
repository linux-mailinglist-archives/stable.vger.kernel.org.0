Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 127BC20A4AD
	for <lists+stable@lfdr.de>; Thu, 25 Jun 2020 20:21:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390636AbgFYSVa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jun 2020 14:21:30 -0400
Received: from mail-bn8nam12on2077.outbound.protection.outlook.com ([40.107.237.77]:38592
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2390489AbgFYSV3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jun 2020 14:21:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nuJle5Kbv6vrZh357EX4Otjj5cAULzQpB7nN4oe2UCihrk21afAwxOCGNoLkewfNZIC7zxWb7dEohvEybByNr3173HE96E76VQlSkM73wSzkpmsRT6Zv5sGzocPi77rmd5haO7WJpS9Srsz4cajamjdpJdhr4DWiqUpvTDhBgYVe2lBDUvuRyS10vU++UZWvWkJ5KKjHq24bKvNVcrj2pI3hmHAs19WMIzgQcDLgB+DP6tIfO5GgltoVf58lyzo3OtJTKvsb8Aefvmbq6z0QMQmfps0thDUP1A8OPf1pwaSoqoV/H6dDvH4kou5tYQRIPMRCUKibm6vQzoXhRz9TjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p67MwtBnpXuDJEGInqOsVW5dOjZ3cQvX/rv5SOu7rFw=;
 b=K5BV6P/CNBeKgjmPFN3wGT4CYC/WULmLvkqL4q4j/jktKt8RwVZdegp8Zbal5UysA4qz/wTKSJDGZM9wOuv+voOevoEfHUCaCXQX8Y3GJI57CJN7Gw1YR9648FGE0DvKAoKJAbik9/eTvh92bGhpzOd9C5SSj0I93f89oM5Hc9LN0rmlWlzkhWYOAuY3zB/1IuU4zWU9XLeD085ZonhHOphxdVQ4eOWyuT/9OJ4awRXp1AYJcwfwPrecA8aubtNS+bpWNXdK5UBhJLgbnTl3NRLMoSYxb2529afLoc4EJ1zOVOY96pVv5BTvk7q3/A7WED5WdVU13/4fdofqvxqG8Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p67MwtBnpXuDJEGInqOsVW5dOjZ3cQvX/rv5SOu7rFw=;
 b=tl7anXDHz3hsJf23lHLmrFbbbg6M4zeO5VHF6bLBvMPHAVfWDeOjW4sswIztjHx4o6nQaU6qxJ2VBpKPWN7XUdJj2W3YI1yB76EI6FcccGI9v+cFZdi6xm5oLndOQBtbVXSyZAhO+yrhZXJTUilc7cWMO0+Qo5v1225Is1VkIIw=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=amd.com;
Received: from SN1PR12MB2590.namprd12.prod.outlook.com (2603:10b6:802:2e::17)
 by SA0PR12MB4464.namprd12.prod.outlook.com (2603:10b6:806:9f::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Thu, 25 Jun
 2020 18:21:26 +0000
Received: from SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05]) by SN1PR12MB2590.namprd12.prod.outlook.com
 ([fe80::c179:ec27:4476:8e05%7]) with mapi id 15.20.3131.021; Thu, 25 Jun 2020
 18:21:26 +0000
Date:   Thu, 25 Jun 2020 13:21:13 -0500
From:   John Allen <john.allen@amd.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-crypto@vger.kernel.org, thomas.lendacky@amd.com,
        herbert@gondor.apana.org.au, stable@vger.kernel.org
Subject: Re: [PATCH] crypto: ccp - Fix use of merged scatterlists
Message-ID: <20200625182113.GA733263@mojo.amd.com>
References: <20200622202402.360064-1-john.allen@amd.com>
 <20200625145356.4377E20781@mail.kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200625145356.4377E20781@mail.kernel.org>
X-ClientProxiedBy: DM5PR13CA0046.namprd13.prod.outlook.com
 (2603:10b6:3:7b::32) To SN1PR12MB2590.namprd12.prod.outlook.com
 (2603:10b6:802:2e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from mojo.amd.com (165.204.77.1) by DM5PR13CA0046.namprd13.prod.outlook.com (2603:10b6:3:7b::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.10 via Frontend Transport; Thu, 25 Jun 2020 18:21:26 +0000
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: f1eb0219-9697-4d5e-8b14-08d8193492ca
X-MS-TrafficTypeDiagnostic: SA0PR12MB4464:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA0PR12MB44644F0CA349035C477BC4619A920@SA0PR12MB4464.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3631;
X-Forefront-PRVS: 0445A82F82
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ld8EmX9WaRgXmSy8r1B7kn/CifxW6rbBW2AMrcwwtbjMGiD7o3Z/7N5mSVLE27NLsUPZqi6nyDrJ7+oCu3wLdppnDCf55l+GahqovMsfS/GZDVeBluIB1ZfHCrh1pBsf6QKBs4S3nMiNuQ1Os20XTo4LPSO3YWoItCV1Xv17JuUyeEermsxTOd76AgUS9uhabTSBV5tEdhrBs6QqwEspPMNT9voTH0Oj8ViW5p/dsM2sZeYIGqH4sRqy47UJ8vq83qbM8ppVI5OKvomGNDvkcU8x090aTtlD0+BxwcVre6juN184yDvzbHbODez/ld3sSWOTohPCkMfZ9dvf9QIxqg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN1PR12MB2590.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(346002)(396003)(376002)(136003)(39860400002)(2906002)(5660300002)(478600001)(66476007)(44832011)(66556008)(66946007)(6666004)(33656002)(6916009)(1076003)(4326008)(55016002)(4744005)(86362001)(8936002)(186003)(26005)(316002)(956004)(16526019)(7696005)(52116002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 3p9jFXSOls9fojukFYwelCvR7N2tq3QfnvQr8tAfTxUDLXyGHXgtIruGwrQC7BE9V/bd2wgfQ6S1jIbpa3OBKN1n15Wg+VptrI1NJqI3/aT6SBaMZQBGdmLpS21V9w2BA6ZeAYd5RSAFW/IaKsIbuPG/0nq3WYwBzyDFTBdVttFDQRRv96CrAOPZ2Dw9966RMMKvM7HB1O0IC768nIOZhBYg3FoiWJNrxENbnkt0+jaWcw0ocxWLgVEkOsfliP8kpge7dYvmTwqG5w4iC4AGTMpPufhabFMbv2P8zDsL+2A8ZFDSDzSQNuUNFVvg8FVNNURDsI6PmvwxzEWYXSVWoEB70p5LNCs4zEJhBPLf7pZIhwRCJFkJxNfO8baN0J5lT64Y8jx92McS8Fp0Gg727wHsqXNTBftSZmjtOobdOgxYuCzPgG1Re6RJ1ROBYs4AqMWpUT4tvtzTiiEj9xwRT7Pdz0ZDY9FZg+0OWt9kycQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f1eb0219-9697-4d5e-8b14-08d8193492ca
X-MS-Exchange-CrossTenant-AuthSource: SN1PR12MB2590.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Jun 2020 18:21:26.6365
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FpRJ02SJ9VT7kZv+D8GcFc+WDtWKj9HSyJHLcAsy5DqsuIvP6J9/rGX4i9Sj/695dXGc096IMr7CXZ3dO4zVMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR12MB4464
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 25, 2020 at 02:53:55PM +0000, Sasha Levin wrote:
> Hi
> 
> [This is an automated email]
> 
> This commit has been processed because it contains a "Fixes:" tag
> fixing commit: 63b945091a07 ("crypto: ccp - CCP device driver and interface support").
> 
> The bot has tested the following trees: v5.7.5, v5.4.48, v4.19.129, v4.14.185, v4.9.228, v4.4.228.
> 
> v5.7.5: Build OK!
> v5.4.48: Build OK!
> v4.19.129: Build OK!
> v4.14.185: Build OK!
> v4.9.228: Build OK!
> v4.4.228: Failed to apply! Possible dependencies:
>     3f19ce2054541 ("crypto: ccp - Remove check for x86 family and model")
>     553d2374db0bb ("crypto: ccp - Support for multiple CCPs")
>     c7019c4d739e7 ("crypto: ccp - CCP versioning support")
>     ea0375afa1728 ("crypto: ccp - Add abstraction for device-specific calls")
> 
> 
> NOTE: The patch will not be queued to stable trees until it is upstream.
> 
> How should we proceed with this patch?

Please apply this patch to v4.9.x and newer.

Thanks,
John

> 
> -- 
> Thanks
> Sasha
