Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9AF7B52A757
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 17:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350446AbiEQPuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 11:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234543AbiEQPuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 11:50:14 -0400
Received: from NAM12-MW2-obe.outbound.protection.outlook.com (mail-mw2nam12on2048.outbound.protection.outlook.com [40.107.244.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EEB424AE;
        Tue, 17 May 2022 08:50:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NnjDqMHaChFnmUDADF8UQvVuGgOvT4kxOI22wpoT+9jaVN/s3/5TjGQ5M7tEESyfEt/jFHD+1ReO670a/T5/jdCoIklaC0XFW89PvDRdk24Nr9r+63uzb5cBjqJHVsNserUB3qbvETDbuNo/NUQ0lTQTT54IvwnYg+8pG6KSAep8iLR36SvO8OY5/JKjQvjZtP1zOK9MmePD/omJ4QEC/hByG0uZXZMz6aDQ65DHB2AOHFVrdICrHoaHvjRWbgazfIpH7h++ErlWPTQa+2mgKYu6Eaxiip2IGWajuhkSemYRvl19YeZnOCK0//NsYLamBu7YwDnymfzQ33Yi7LrlHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=+AfdnHkrsB8hvOnfwFuh0+FlxbNKsiOVp9HqYS+8yNo=;
 b=bZtYnvtOlQmYEdGA7DNySe+j+D3MLK8xiz3MaiaIWiabBb1lVD38rbtTp5FeHNLOM8HAKe4polUJMfxWM/16B8YD4sppn853dCASJMz3IfK/xwR8vh5HdUGWijWTMcogXGTtJhoypm3X5+o6X1cEnUlbGJeXo0w73PYiHo9iDjzbezE7duAk9AVSo6o7lavt1dugw3YNJu7PddrvcZT/3sZGyPvJ1qlPW1SabosS+sQA3LIxX4sBFO37xdC9uyzPm5RcR5cfTveSBaXIWJ8OqIuUZY2V/nkF6CONMfmDqAm79pVrROpFxyS+j+Jt4ZnebddADG2v/IbXfXCblBuDFQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+AfdnHkrsB8hvOnfwFuh0+FlxbNKsiOVp9HqYS+8yNo=;
 b=L1hfk3c0rfnfJgbTm4vLxCM3EW16jHp82RpeuLdjAEl39o++gs72kDj+yAwYwPFKqM5H8G30VKRU2w3S9n5hLfc02tNFKwaq9TsAY0Mayoa+vZkJVAguPqEkHJSkQfJA6i9vSh8R4+T7dWifYpaG6jEoeYam826JiZ8J2rguVGg=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
 by DM5PR12MB1594.namprd12.prod.outlook.com (2603:10b6:4:e::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5250.17; Tue, 17 May 2022 15:50:10 +0000
Received: from DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a]) by DM4PR12MB5229.namprd12.prod.outlook.com
 ([fe80::db8:5b23:acf0:6f9a%4]) with mapi id 15.20.5250.018; Tue, 17 May 2022
 15:50:10 +0000
Message-ID: <e0d23029-21e9-b1bb-9d35-1bfcdd3dca12@amd.com>
Date:   Tue, 17 May 2022 10:50:08 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH v3] crypto: ccp - Use kzalloc for sev ioctl interfaces to
 prevent kernel memory leak
Content-Language: en-US
To:     John Allen <john.allen@amd.com>, herbert@gondor.apana.org.au,
        linux-crypto@vger.kernel.org
Cc:     seanjc@google.com, Ashish.Kalra@amd.com,
        linux-kernel@vger.kernel.org, theflow@google.com,
        rientjes@google.com, pgonda@google.com, stable@vger.kernel.org
References: <20220517153958.262959-1-john.allen@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
In-Reply-To: <20220517153958.262959-1-john.allen@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR05CA0025.namprd05.prod.outlook.com (2603:10b6:610::38)
 To DM4PR12MB5229.namprd12.prod.outlook.com (2603:10b6:5:398::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3fc66352-9727-45ad-3f5d-08da381cec33
X-MS-TrafficTypeDiagnostic: DM5PR12MB1594:EE_
X-Microsoft-Antispam-PRVS: <DM5PR12MB159463404095B82503F36105ECCE9@DM5PR12MB1594.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: llMoM5ImIkLM2lKy/msPo7ItNp23dzzSR8hHlZWRINcTnfxi34uJfhLSrD63iFgHaErJbira+0e2kcrT37QfvjB52fmbs5XQCZekQQRya3oh9UFCKSXPlkcBlel2hdM71Y1PQ/kqTnY8MUVpeA7l6PhjxfSdoOt66+mX+C20XcqESe6DrEfhjN3e1YGk5OMJT4rUzvia4Cj98HX4TbwOW4woJD4YbOuuPTtvIcXNZlslPTN6NsWUMQyDcZ3BVvIFH6CoTGw9TaxBr8atbY8NrdbJRg8IU7rZ7QXZvCsdnTayXui4ZWgGqzeV/g6CQBA9omSLTJejUDP3YqPcd8D+BH3IaYJ0A30dXPHAjeuxTjXkTUy/060KMl3ha4FKL72Zi4Kdt+OV1edb6yL318e0a7QAU4hYSngyQP2LPAht3xomUd7B2hyLxVlvLx9q4zeZRDXK3LMtqFj4ev4r2f1lub/cZaBZbqw0vkUVq1ssglpbfh3mhX7+3ij5FWOy4o5PnVB4sZ/NhpkMEfkByTEdSrAUo2GHVi7V8ElMMaOUNBB71gyRGXYToEJfYmGvTTR+cjQD3lpy+7Cvf7RiuQl/6JkxxiZXeGGbP2LvgBbGOhV2tIp2J94yxlLEpiTmaP8VmsdxnziU1YKS0nw/v27bm1cWYTFoY+InDiwpU8Q8bMIVeGSL/OmJ+fbxF2pQn3vh8PCeUQcNz6cO+y9qhz94McED5JZf8bDcj8KJoI/4vsEXu4e49o5lx9mCtbx6Z/zk
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5229.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(8676002)(2616005)(2906002)(4326008)(31696002)(186003)(66476007)(66946007)(31686004)(5660300002)(66556008)(36756003)(53546011)(6506007)(83380400001)(508600001)(6512007)(6486002)(316002)(86362001)(38100700002)(8936002)(26005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V2ZjQ0Y4YjdZRS8wWkxDbGRYeVJPdU9EL3NGV3NQRHBrR3kyS0VJMUZNMjhY?=
 =?utf-8?B?SGFqK3E5YnB1RmNmV1Z2QXIybk5RZS9HVTZDajZGYTRFMmM0dHBlYUJxVFQ1?=
 =?utf-8?B?U2xLTDRKamMyQTdaRWlpcVhpU3BrR0x4RVpwdXQ4N0tKZ2pwbXV1Y2xjc0Nw?=
 =?utf-8?B?d0NyYzkreWRnMUZMTFNobFp4VHg3dVlGMVdIaHZvNk45dWgxcHNmTlhOVkI5?=
 =?utf-8?B?NFdEeXJDQXN3ajllSFRBNkh3bHlzNmN0UndJa0NwRlpqR09jejVuOCs2ak1k?=
 =?utf-8?B?Sjhza2lRWXIrOFNNNis1VmNpTjIvcFE2b21KUzNIamRVVlgxQm5DMkw3YUFT?=
 =?utf-8?B?eEZJTDRjYTI4Ykd3SXYvemVuMlNuSTNvU2tKWTRGVXpMR09xbDRkODBNa3dU?=
 =?utf-8?B?SWNmZnBXVS8vaG95Ykoxd0ZpWjZUV2x1dzExUWttY2VrenlkclFEYkY4d2Zq?=
 =?utf-8?B?T2k3QU02YXVrWFVuaS9yWkxSa3FRYThXdkc2T2d4dE9YcGswYTNuWGswZU1T?=
 =?utf-8?B?bCtBYUNpQmkvTW9iKzI2anlqNVR0dElJZFM5WGc5VWt1SHVKN2Z0U1RtMHRB?=
 =?utf-8?B?cjhrOUJSNGZGc0IvZk90cUVSY3RoK3llUysyTlhVandrNU5oUnUxeS9oc040?=
 =?utf-8?B?NlV3S3FSSHVoWmE3Tmx2elFvV1JZNnNpOURnWmdUdDBoYTlXRE5vbjIyaUpO?=
 =?utf-8?B?YlF5YmdiNk5QRENRTVpYZnMyRktISmFLa0plUGN6bjh2OGtDWWxpK0dPMUhD?=
 =?utf-8?B?dGxhRjQ2THpZS2VQenVxNHNDMGozeVNnVDA1UGc1dWlBSXJreCtlaVZJWmpV?=
 =?utf-8?B?ZE4vdFlzbXR0dmpVdFFEc2twSkdFNFd2cGc1bU5JMlAzVk54SkNKaUZKdWRE?=
 =?utf-8?B?Uk40cm9kZGl3U1ZxUkdZQnQ5RnQ0TU1SODA4YW5xSlZrWHFhZEw5YThaOHlp?=
 =?utf-8?B?dU9DNlNEREJPT0ZWU1ZZcUNVQlZDQjhteWdqRWZTamZRRWhyRVZtRHFsc1VL?=
 =?utf-8?B?dFV1YXNnSGFWK3NxM0VFcHpBS052S01xb0ZQa1hqSjZ4MnNmTTFqSldCenhr?=
 =?utf-8?B?cVZML0tvdE9TTVBTR1hiV3VEbExiN09RR2lobU5jZk5sWDZjajBQRndtRmxL?=
 =?utf-8?B?djNnRXEyZzcyb0ZNb0owUWh2cU1kMytyYXZ6eFhoRWYvNUsrclUraHJtNDQz?=
 =?utf-8?B?RGltbTVjcWdxandVQ3JVcW5SWUhWSUpEdHVvdndnOU5PQXFLeFlVQVk2VzJj?=
 =?utf-8?B?MWU3ZmNNU1JDRWNVbVNrQ3JFbXNRU05GUnJ3bndhS05UWkNLaW5HVkxtM0RO?=
 =?utf-8?B?ZVZTT1UwbU1Lb2R3b1RkWE1uMGI1YWdvRkpGamZxUGE1emJsQzJOemN0dHQ4?=
 =?utf-8?B?VDJjLzBlUHlEcjQ4QXQvY0ZFTnVpMjIzblBkMnpmMEYvbEI5ekNQbHBNZzJ2?=
 =?utf-8?B?L3hYTmZtVlhCeWJFNWRIelhIWG55R044Nll5b0RQUjcvYkgyem1aSkMwK1NJ?=
 =?utf-8?B?NlhpaWNWOVN4eS93ellaLzYzNDBkUFE0UWc4NG51dGUwTURBMzlkb1FoUG44?=
 =?utf-8?B?NE92TjloSDlzQlJrdEtMRjdWOCs4akhtNzcyOGtRM2o3Z1ZnU2Y1d3FPc1RV?=
 =?utf-8?B?VmVYdDVpb0VCR0d0TS9pTWgyMEN1c2F6dGFlRHlmZHFvaDBTMnBRQnE3aTlE?=
 =?utf-8?B?ZXlaKzVQUllzRmJ0VE5xTHNnSDdjbDg4OVA4bTFIQ1FqK0xJSGp4RmUwR3I5?=
 =?utf-8?B?ZUhIN3hQZnFaK2V6VW9JcVNwRGZrVWNUS0tkVTgvV3h3ZFdhZlB0SC91UDdz?=
 =?utf-8?B?QkVaU3BsWENOS0p6VzhMRnNNc3ZXamFDMjVrd3hVMllUb2FNQ096dXJaK0Rm?=
 =?utf-8?B?U0c4b2tpLzhuU2lDaTNqMkczcTBRb3VYcGF2S0QyM0FIVXIxYXJXU2dKNHNY?=
 =?utf-8?B?emJobG50ZERqVVRIRklEM0o0cnVDV0Q1TitlckZ0Zm9rYTJIOHhmUm1yemlP?=
 =?utf-8?B?eTZFb0dSTWxDd0ZFdkJ0T3hCWFpnb0RXZzBEcGJCcWFocFcwbTUxWHYvTExx?=
 =?utf-8?B?ZnZuYlF6WUFOc0VodWtZUGl3WXI0TEN4WTk2VHk0UkxmQy9XTXBXbWVPRDFn?=
 =?utf-8?B?b1MwM0dzM0lxdFdWRDhwdGxYMlRSbHEwRDVYVmM4ZEQ0MThRZUVyaTFla21I?=
 =?utf-8?B?L0FTWjNlR0J5TVZNSVowMGg0UVRyalBGUHRMellKMDBibExZOHlOZGd5bW5z?=
 =?utf-8?B?My9IMDlCUm5pNnlBTS9vNFd0TG9Kdll2RE9pYkt0L2F3T2NwMzdacVF2RG9I?=
 =?utf-8?B?aS9JOVpQVUhaa0RINU1wUGRTZ0d5SXUzcCtndnQ0eWdTNW9Nc2Q0Zz09?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3fc66352-9727-45ad-3f5d-08da381cec33
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5229.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 May 2022 15:50:10.0461
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: h0AeKZuDEftdFj7EIjJpsoRrYtC1LlniZJOt+xnL3wpeRp9LgIPRSZbTK5xVttMa06zcmU1a0k55iwLJcP6f0w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1594
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/17/22 10:39, John Allen wrote:
> For some sev ioctl interfaces, input may be passed that is less than or
> equal to SEV_FW_BLOB_MAX_SIZE, but larger than the data that PSP
> firmware returns. In this case, kmalloc will allocate memory that is the
> size of the input rather than the size of the data. Since PSP firmware
> doesn't fully overwrite the buffer, the sev ioctl interfaces with the
> issue may return uninitialized slab memory.
> 
> Currently, all of the ioctl interfaces in the ccp driver are safe, but
> to prevent future problems, change all ioctl interfaces that allocate
> memory with kmalloc to use kzalloc and memset the data buffer to zero in
> sev_ioctl_do_platform_status.
> 
> Fixes: e799035609e15 ("crypto: ccp: Implement SEV_PEK_CSR ioctl command")
> Fixes: 76a2b524a4b1d ("crypto: ccp: Implement SEV_PDH_CERT_EXPORT ioctl command")
> Fixes: d6112ea0cb344 ("crypto: ccp - introduce SEV_GET_ID2 command")
> Cc: stable@vger.kernel.org
> Reported-by: Andy Nguyen <theflow@google.com>
> Suggested-by: David Rientjes <rientjes@google.com>
> Suggested-by: Peter Gonda <pgonda@google.com>
> Signed-off-by: John Allen <john.allen@amd.com>
> ---
> v2:
>    - Add fixes tags and CC stable@vger.kernel.org
> v3:
>    - memset data buffer to zero in sev_ioctl_do_platform_status
> ---
>   drivers/crypto/ccp/sev-dev.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
> index 6ab93dfd478a..da143cc3a8f5 100644
> --- a/drivers/crypto/ccp/sev-dev.c
> +++ b/drivers/crypto/ccp/sev-dev.c
> @@ -551,6 +551,8 @@ static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
>   	struct sev_user_data_status data;
>   	int ret;
>   
> +	memset(&data, 0, sizeof(data));
> +

Probably needs an additional Fixes: tag now?

Fixes: 38103671aad3 ("crypto: ccp: Use the stack and common buffer for status commands")

Thanks,
Tom

>   	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
>   	if (ret)
>   		return ret;
> @@ -604,7 +606,7 @@ static int sev_ioctl_do_pek_csr(struct sev_issue_cmd *argp, bool writable)
>   	if (input.length > SEV_FW_BLOB_MAX_SIZE)
>   		return -EFAULT;
>   
> -	blob = kmalloc(input.length, GFP_KERNEL);
> +	blob = kzalloc(input.length, GFP_KERNEL);
>   	if (!blob)
>   		return -ENOMEM;
>   
> @@ -828,7 +830,7 @@ static int sev_ioctl_do_get_id2(struct sev_issue_cmd *argp)
>   	input_address = (void __user *)input.address;
>   
>   	if (input.address && input.length) {
> -		id_blob = kmalloc(input.length, GFP_KERNEL);
> +		id_blob = kzalloc(input.length, GFP_KERNEL);
>   		if (!id_blob)
>   			return -ENOMEM;
>   
> @@ -947,14 +949,14 @@ static int sev_ioctl_do_pdh_export(struct sev_issue_cmd *argp, bool writable)
>   	if (input.cert_chain_len > SEV_FW_BLOB_MAX_SIZE)
>   		return -EFAULT;
>   
> -	pdh_blob = kmalloc(input.pdh_cert_len, GFP_KERNEL);
> +	pdh_blob = kzalloc(input.pdh_cert_len, GFP_KERNEL);
>   	if (!pdh_blob)
>   		return -ENOMEM;
>   
>   	data.pdh_cert_address = __psp_pa(pdh_blob);
>   	data.pdh_cert_len = input.pdh_cert_len;
>   
> -	cert_blob = kmalloc(input.cert_chain_len, GFP_KERNEL);
> +	cert_blob = kzalloc(input.cert_chain_len, GFP_KERNEL);
>   	if (!cert_blob) {
>   		ret = -ENOMEM;
>   		goto e_free_pdh;
