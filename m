Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 164E452A798
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 18:06:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345357AbiEQQG0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 12:06:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350806AbiEQQGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 12:06:17 -0400
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (mail-dm3nam07on2082.outbound.protection.outlook.com [40.107.95.82])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 941E922284;
        Tue, 17 May 2022 09:06:14 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jVUwRC5N8DTHCWPx7eajVp5M2EmYLS0IFyvWsyjb/va5UpF1Y16juGU3et8a/tFynYjW7KFNcqDXazFuREA4gkYiO4zBa5JVrLosdqUIgMvzDzYEwNWwRL2DcRl3BiL8bhfZVvwU1JIz75PRQbjK6rtnSv/ibwKl7izSkJqt6bv7n6pYMBC37o1wlXKFTszR8x3eZsTIGE5eeCsk4CI3IZQa+Qb+hRWn71Ms3iR4wWObYNsmZGwBNxhbGPKV1S8icFm8iJaSpu0vxoFGkJ/VKsGONi/zZxZlm/yHP59j4vEXe0kh6rYDX3YNN4QaM2QChSH6D5d57AjEFGbbgjo+bg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kTpXsBx2v+O0OkISWUdrcFrNXLNLRpUVKGgvINVpLc8=;
 b=eQ2eLxJmffQr8Eee5xSba4yov++gnqS5ZZESdCAUR6JBkxbTv3NzIuTprZzYfcZVMOjXmu4QKScHOqN5qvXUxkv1DQzL0eeymn/rf3E++PYDuDxP1obicIHgjEyn3lLw0HYb69QcKEePh36j7GrIvM8R+Mn1yEKZDBXmqk+sQX+NlgKrKkk+iEw4oJ9OltgZR7z6cSsKkmlGe4H/D8WNlIajrlOg85WaUdoFWqppXVTkJvzk30fWUJSROTDkujadmj0wQJXtKPMthfxSDUemq3hTyPE3eXoZIZXhlPFyun7JGCG4J+z24ZTvRNwCMr8hBb/3fDD0PSbf7tBCeqIyTg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kTpXsBx2v+O0OkISWUdrcFrNXLNLRpUVKGgvINVpLc8=;
 b=jA2zRth/2MMw6iy1sxwjIU4M+2LHV0OUqkIj8jFcUxV78VGXVsfJyhFwMnWV2LncTSsYO3P1mYQK9vOpLnmD/tmB+9N9hLh/DDwDagm8+gTOaXjibl5xGFbLUdEbgugxZ0xsU8+f8X/s+KLO2mYmSTuDpWkPrJaWk+beK90WoFg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BL1PR12MB5995.namprd12.prod.outlook.com (2603:10b6:208:39b::20)
 by BYAPR12MB3445.namprd12.prod.outlook.com (2603:10b6:a03:ac::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Tue, 17 May
 2022 16:06:10 +0000
Received: from BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::f010:1c99:9c9f:7cc6]) by BL1PR12MB5995.namprd12.prod.outlook.com
 ([fe80::f010:1c99:9c9f:7cc6%9]) with mapi id 15.20.5250.013; Tue, 17 May 2022
 16:06:10 +0000
Date:   Tue, 17 May 2022 11:06:07 -0500
From:   John Allen <john.allen@amd.com>
To:     Tom Lendacky <thomas.lendacky@amd.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        seanjc@google.com, Ashish.Kalra@amd.com,
        linux-kernel@vger.kernel.org, theflow@google.com,
        rientjes@google.com, pgonda@google.com, stable@vger.kernel.org
Subject: Re: [PATCH v3] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Message-ID: <YoPH7ztF50b6ge9G@dell9853host>
References: <20220517153958.262959-1-john.allen@amd.com>
 <e0d23029-21e9-b1bb-9d35-1bfcdd3dca12@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e0d23029-21e9-b1bb-9d35-1bfcdd3dca12@amd.com>
X-ClientProxiedBy: CH2PR02CA0024.namprd02.prod.outlook.com
 (2603:10b6:610:4e::34) To BL1PR12MB5995.namprd12.prod.outlook.com
 (2603:10b6:208:39b::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46e0a8ea-e53d-4fb4-be17-08da381f28a8
X-MS-TrafficTypeDiagnostic: BYAPR12MB3445:EE_
X-Microsoft-Antispam-PRVS: <BYAPR12MB3445A75542FCEB8A955716A09ACE9@BYAPR12MB3445.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pTAo9yiIehsAsmBqbLkT9A7IhtZwv5ltesapo/4E7pt6Wtg7bhwjJO2lBLD2sCzBRaOs0iM6IJpd0H8vgxLPJRBwhBpBUgSssaiiFikSbCMUnCh3LglN4YqYuwrv21sHGRdpiAQSdYKg8NkBTWG9OTUf093zMWNtXQzt7gFTSZ7S8X0ijbm9XEFv2noD82J9pkhwH3c4C8e/9kx68G3ZZN/dRW48JRx412uiiTBzvDK7q7rf+TzE5lELWwTQgrTiKqO28MpNimNoJ/1GVWaTpNQF7Q5aaVo/RXKnOF3W8dhKxd3+fTvc/hja4O4EP2S4+mGtJtHire7pTA08Wt0rqGovbG12lfR/55forzvw2BRORpIT7XSdcl4aEgCuHXT71NUHV9Qji7jr2u72EliAkziLaOHcPM1jQHLPwdAs3H3UZL7OOru/Td0xrPhHwnr5ZqIMC08jxm74NhVPXqKUbIOmerD9aHypNb3KC/PpXo9JXd3knwCMI+4PyEccWNqBI4dD4dVrVhgjkgXaGvnYEm+6NltYTIWfUZq6AlfF5/RHyB8cCKVADwzev+I683XdAw46TuJptzdRhrUNj773FPlT+xypLp6VJia2C6qNwzQQaLHjYGhXuD6b56xvhRVxD/vbGgCddSMRUtyaFLwGgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BL1PR12MB5995.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(7916004)(366004)(33716001)(83380400001)(6486002)(8936002)(44832011)(508600001)(6512007)(2906002)(6636002)(6506007)(8676002)(5660300002)(26005)(186003)(66556008)(66946007)(66476007)(53546011)(6862004)(4326008)(9686003)(38100700002)(316002)(86362001)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?id3hf4gm0btW56cA5CL8tRdx8iK4UjRuPe5z4DTupuEvGpxxmqFIETQQd1t6?=
 =?us-ascii?Q?N/nE9FWZNyvvEhQhV10hMulvdLEft8KfxQRgLVNAm8KYbovieP+sV3zEi3bz?=
 =?us-ascii?Q?e5NQYeQzwg757299JG0JEH2ngFHRRL++/VFv1xppECYO5zzB6Kh547HIk1+E?=
 =?us-ascii?Q?SELQ2PURnPCOSdHRA8+QupJAMt2iHV3IawgRVBv/8qTT1jMKt+pwBQG776rr?=
 =?us-ascii?Q?/Ma5u93UpQtr8YPi5Fpf8ZAnpQlU4fLBg16FVxbRXHOXxFEK1/WwSzjfxjP7?=
 =?us-ascii?Q?uVhwFTTdozKZeVP3ycWhzPy60HW6DcK2rMt0lb+O979NbXdJHNaevJKuPZvA?=
 =?us-ascii?Q?7OjD9X8hljD8byIdcabiYmQ2Q+GkQ5Sj/wfyJrVbrTdjcDB7zqAD8L20gge4?=
 =?us-ascii?Q?Gqjq3CfToqNuEaMjGZ91kF+OHbM+Mpzvr7nzPWg+GX5cF1nrzODoDHur+grm?=
 =?us-ascii?Q?ad1mloO/hQf7skjluE1qutEnVkIDQs3+wtEyzPaGPImIyZfyIuieCA3M9tcF?=
 =?us-ascii?Q?uAakFzuro5nFNabcig4QFsHEymaXLcihOtCtK6LUf+PAK/BntIcB/SlnwNWS?=
 =?us-ascii?Q?OyhxorJXNLr07X9fM89UESCWbqgIshnDB/2qjdyt8Auopf7sZFlvxAIWrAWc?=
 =?us-ascii?Q?XqUu0qYKS8qlrBcfucAVHxUbuXpSR/R97Qlehskz+qulb7s/8en0+rGgGafa?=
 =?us-ascii?Q?E+wbGtAln+aX+uIioZ8XeFaMLrrl3rtkzSoHhl6wj4ln5bwHVQSWzn6nLWD9?=
 =?us-ascii?Q?kMgvlQD6tvYdigUED2tDDlPOekkvVfLNL6ribPBGQYiPit+SQCxO13pSPKQg?=
 =?us-ascii?Q?PGHJZuNAR4ydqYYtGTpAWnd4VbI23F0rQRC4YHFT+in2+uJ2E1vc/YJ29fYy?=
 =?us-ascii?Q?wOqc+32oFtxyEW8x7+jJKLVBLn9A9nSutFDnWBqtE3aS8ELPlb767QR39sSN?=
 =?us-ascii?Q?C+hgXzAW0ndf/wtSZMZggBs8++Tj5w4mSpZ85/gcYgBpp6WCE7xKCnHZ5Twb?=
 =?us-ascii?Q?Xim4zWd7IVSsD9/ASUxRMF6hlT7DWHaRTFDU0cvgA6rCUrxiw5a5vnGwLMto?=
 =?us-ascii?Q?Oi7Q7uioFxOEIxEKx/3GQOAojR5k67nSRNo/c0SxcCmp+1AWw+V1d6RsS+TA?=
 =?us-ascii?Q?ZFIA0tVVUN3xwh/vTcU9HJ29WcDEKzhPqw8j0fD2nT/XL3q/6VKU0lK0Jp52?=
 =?us-ascii?Q?06mS8v7gxMklJHlhQcYYKhKn+9W8p4ZlWiQUnrhcmUHhHUX7YkiFxx5pbAq8?=
 =?us-ascii?Q?x3fUG17SdUfvfXDkfyjy6X7xEWWi0s2cBzG062L5G170WqcVMagCY9gX6Zvt?=
 =?us-ascii?Q?ZvXHYmZTkaLeq3pC4jBVeU9d+ObhhUp7QDoCcAmFFpa3qFQ+D4So8kBpSO0W?=
 =?us-ascii?Q?JnDPBlplgS88wgIbSE1AIO0Y4WQbwkbUzh7bEDdGM41TeaW4cKesGGkh7NM+?=
 =?us-ascii?Q?7CHlnQIrCybFljQdG/lFlcKr9j+BASxrlHnKwkNqx3kPicEAqVPcHHmDbHuo?=
 =?us-ascii?Q?Pj4mUnlYbn4WeGO+c+2mMnf7Toc2IejA57I8R8MBNRfVnU/ivW5pf/AilpLf?=
 =?us-ascii?Q?kkdAKiMmYNHhukXqoGu/ieIiu4wA5sIKujQA5VJ2D3n+JQBqIgDScAHp1GXO?=
 =?us-ascii?Q?bhho5+CFrnu9NS+/P5w1BL8vOdQIbaN/5p5zAW/8Bx1CiXtMr9xBSdZ9gSUY?=
 =?us-ascii?Q?mf5siaKl+AooC8KFeLRx/gnoKBrSJswVXr8dOoXf94YdaRmPlhQWa/ok4yLn?=
 =?us-ascii?Q?8T+qrpPhwg=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46e0a8ea-e53d-4fb4-be17-08da381f28a8
X-MS-Exchange-CrossTenant-AuthSource: BL1PR12MB5995.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 16:06:10.4874
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b5B1bTBK4PapBnVBp4Q4nHUvLx9yL2n65+EOWGuw3riprQxC+AZophqAZXoj6UpJLIyaqsha93CvAbbxg6KSGg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR12MB3445
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 17, 2022 at 10:50:08AM -0500, Tom Lendacky wrote:
> On 5/17/22 10:39, John Allen wrote:
> > For some sev ioctl interfaces, input may be passed that is less than or
> > equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> > firmware returns. In this case, kmalloc will allocate memory that is the
> > size of the input rather than the size of the data. Since PSP firmware
> > doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> > issue may return uninitialized slab memory.
> > 
> > Currently, all of the ioctl interfaces in the ccp driver are safe, but
> > to prevent future problems, change all ioctl interfaces that allocate
> > memory with kmalloc to use kzalloc and memset the data buffer to zero in
> > sev_ioctl_do_platform_status.
> > 
> > Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> > Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> > Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> > Cc: stable@vger.kernel.org
> > Reported-by: Andy Nguyen <theflow@google.com>
> > Suggested-by: David Rientjes <rientjes@google.com>
> > Suggested-by: Peter Gonda <pgonda@google.com>
> > Signed-off-by: John Allen <john.allen@amd.com>
> > ---
> > v2:
> >    - Add fixes tags and CC stable@vger.kernel.org
> > v3:
> >    - memset data buffer to zero in sev_ioctl_do_platform_status
> > ---
> >   drivers/crypto/ccp/sev-dev.c | 10 ++++++----
> >   1 file changed, 6 insertions(+), 4 deletions(-)
> > 
> > diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> > index 6ab93dfd478a..da143cc3a8f5 100644
> > --- a/drivers/crypto/ccp/sev-dev.c
> > +++ b/drivers/crypto/ccp/sev-dev.c
> > @@ -551,6 +551,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
> >   	struct sev_user_data_status data;
> >   	int ret;
> > +	memset(&data, 0, sizeof(data));
> > +
> 
> Probably needs an additional Fixes: tag now?
> 
> Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")

Thanks, Tom. I'll add the additional tag in the next revision.

Thanks,
John

> 
> Thanks,
> Tom
> 
> >   	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
> >   	if (ret)
> >   		return ret;
> > @@ -604,7 +606,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
> >   	if (input.length > SEV_FW_BLOB_MAX_SIZE)
> >   		return -EFAULT;
> > -	blob = kmalloc(input.length, GFP_KERNEL);
> > +	blob = kzalloc(input.length, GFP_KERNEL);
> >   	if (!blob)
> >   		return -ENOMEM;
> > @@ -828,7 +830,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
> >   	input_address = (void __user *)input.address;
> >   	if (input.address && input.length) {
> > -		id_blob = kmalloc(input.length, GFP_KERNEL);
> > +		id_blob = kzalloc(input.length, GFP_KERNEL);
> >   		if (!id_blob)
> >   			return -ENOMEM;
> > @@ -947,14 +949,14 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
> >   	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
> >   		return -EFAULT;
> > -	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
> > +	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
> >   	if (!pdh_blob)
> >   		return -ENOMEM;
> >   	data.pdh_cert_address = __psp_pa(pdh_blob);
> >   	data.pdh_cert_len = input.pdh_cert_len;
> > -	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
> > +	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
> >   	if (!cert_blob) {
> >   		ret = -ENOMEM;
> >   		goto e_free_pdh;
