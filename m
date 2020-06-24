Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278FE207CCA
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 22:19:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406332AbgFXUTb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 16:19:31 -0400
Received: from mail-eopbgr770055.outbound.protection.outlook.com ([40.107.77.55]:10050
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2406318AbgFXUTa (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jun 2020 16:19:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N7MoZmsRHGxv8sT4XNQv6dOMNPCUNNUF1Zl/G2k8bmoUH9LwOaciyWSTvTK6jsv+uarjCtaNsHwA/J7TlAamlwTK2bIjXUxYhSyPpisCnoS6jpUI9NF7rKru/sI7DL0UmrvVF/G0izBZJg1ktVgOgBVHWJsU/TDgayRyrVhfmsB89fI2uM7xf8ruruVlacXRWUM960jcD8fCzqY3kH4eu/Vn4XoveBjNr9FQZVrJCPpMMVMH4Yz3JnS2UKfOJK9z/YKvOvvC31DBQ+RX9SQIoyaJPBv7qd3HMMx8yi6/bUB9+dFLAq+Gq4XjogEIpTs/ygzEpirfsaIXtQ1BLz7MQw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gk85lOAFwiscFHylOuSNANrAJD4F+unuzk1hJtHV75s=;
 b=IdVmUbWk6Vf9SZXJXMv8OZmwKdyZNqV67nndwD+no1+fprZWbS+uvOie/MIkhhan7wj/PiaGtTB5uxSNegL8BfOUI6jMum8e+4q6t3DSJxXkB9a9d4UUr56fwQBPA9kX5IpEmikfluywW1FfiyH5to5Hf8hCdeR/0ZcbIUs8Bxr/hS+TFydtXwekSOeVHCYgAiWpn9hu5nu67gl0GCt09y/yx87gDFc4ekunxDwfnXpBapsCV3OXrvbH1lSN95fyHol+MxcfdlEBS4+HHYinZ/AnHpMnn2ypX9XQsHsOuEQ4wN81Vn7nM4CgyGFMPoGXCm0SyiLfANROpqRDK5Ar9g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gk85lOAFwiscFHylOuSNANrAJD4F+unuzk1hJtHV75s=;
 b=AE3NGoMVyVd9k7lrotc7Helb0tqrHh9373akXBMwYz+TTO4J7YHI3ichaDZUM+I5jpBdQuEtlZMAZGhpF9RqWQO/zc61RzYOYx8F0Bv2Nyq486rsgWUeRrUW6kwcbyU9zIi96Z+UZmYXHC0daU5E8isAmXg0hMz+tnSlBBq8vlQ=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=amd.com;
Received: from DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) by
 DM5PR12MB1641.namprd12.prod.outlook.com (2603:10b6:4:10::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3109.22; Wed, 24 Jun 2020 20:19:26 +0000
Received: from DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1]) by DM5PR12MB1355.namprd12.prod.outlook.com
 ([fe80::4ce1:9947:9681:c8b1%10]) with mapi id 15.20.3109.027; Wed, 24 Jun
 2020 20:19:26 +0000
Subject: Re: [PATCH] crypto: ccp - Fix use of merged scatterlists
To:     John Allen <john.allen@amd.com>, linux-crypto@vger.kernel.org
Cc:     herbert@gondor.apana.org.au, davem@davemloft.net, bp@suse.de,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20200622202402.360064-1-john.allen@amd.com>
From:   Tom Lendacky <thomas.lendacky@amd.com>
Message-ID: <8b389228-5db3-0242-a137-714143073034@amd.com>
Date:   Wed, 24 Jun 2020 15:19:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
In-Reply-To: <20200622202402.360064-1-john.allen@amd.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN4PR0401CA0038.namprd04.prod.outlook.com
 (2603:10b6:803:2a::24) To DM5PR12MB1355.namprd12.prod.outlook.com
 (2603:10b6:3:6e::7)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from office-linux.texastahm.com (67.79.209.213) by SN4PR0401CA0038.namprd04.prod.outlook.com (2603:10b6:803:2a::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20 via Frontend Transport; Wed, 24 Jun 2020 20:19:25 +0000
X-Originating-IP: [67.79.209.213]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5f237e3e-f224-4f47-a0a1-08d8187be464
X-MS-TrafficTypeDiagnostic: DM5PR12MB1641:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1641B4789506814801E35D5DEC950@DM5PR12MB1641.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-Forefront-PRVS: 0444EB1997
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 5WHoKlfOXadHgfLECu5Xwbv0qPehNtDQTpvy5I+QsUlwXti4byNgvo18tmRfabYg4wZl7RANBq3QwnfrgB7UYHZ/AB3msQGXIlw7cC1yfnOvnFQr9maKTnABKLBMr6HPo7OkQQXCv0OW/2JqdIsUtVBOFrZl61YawCQstGoWpp31U88AxK4hatpCUIurAC8WJJTPjBW61gl0zdjyTvwPgNwylm48NqCRtaDT31Ndm4ZSRKlT9qNADlsZAzGJZomSXuFEwfpK49hIw/Ylvw2XkjgPqhq6r7OPGesTt9D9UjS19SvxDw1osD3+IOnXNwZJCqzydeov6Y1ElwqiUuoSI1W9zZhchRKZIBWJ31TLtCnZ8rhxLvWL35/1iFXeFUO3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR12MB1355.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(2616005)(8936002)(5660300002)(6486002)(66946007)(66476007)(4326008)(66556008)(8676002)(6512007)(36756003)(2906002)(83380400001)(16526019)(478600001)(31686004)(956004)(186003)(86362001)(52116002)(26005)(31696002)(53546011)(6506007)(316002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: zMmil2DNvlAYKtF08gpb8xAhhjZCnoXnn8JjfqTppNQ4U0IYng+2TVsZ9Y3lNkkI6i/pad0z6OG6zeRU3pbF1Fg84UpybS609NCSq60awMDqhG31kFDvFWrmdw+2mB/bxLII8V6oK1Ubwx8PV6YT7rKNyK0I29fJfwsWisSFNlTDB1ol0OXxhTWl+2GVMARfj4F2tEB/I+vlIt0cuRki28dTkwQenaSJ0Z+a3OKVBU2ikYzAJEDIK/yMipZ/+Y/FbEqElqbSoQAhAfo1mZGkdMShYeZ3ixPdMgHBI6mivccF3XyXXu5AG8ROawX9gwYU3cRiB99INb4nmf6X4w+8NTjICtoeRZLbosnd0KA1g6j7YS0XSR3KrEScjx0geSeNP6xKn5ayu+sdXmbYTWDLSSPEX5rL25fcZV5+BG6GtTYWKFUrdJJVktvu6osCGJ1zo7hRT9ghattliaIpaF47MsrmX867dEMe3n8UnDOUBNQ=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5f237e3e-f224-4f47-a0a1-08d8187be464
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jun 2020 20:19:26.6978
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YTT/rvwyAtfksbl7CxqK/hs0OfkxjgUswqfp02YUcP6rVdAfEoNSNkbC/kVBL0Xml2q4rTS7GXjEDy+ppuHKCg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1641
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/22/20 3:24 PM, John Allen wrote:
> Running the crypto manager self tests with
> CONFIG_CRYPTO_MANAGER_EXTRA_TESTS may result in several types of errors
> when using the ccp-crypto driver:
> 
> alg: skcipher: cbc-des3-ccp encryption failed on test vector 0; expected_error=0, actual_error=-5 ...
> 
> alg: skcipher: ctr-aes-ccp decryption overran dst buffer on test vector 0 ...
> 
> alg: ahash: sha224-ccp test failed (wrong result) on test vector ...
> 
> These errors are the result of improper processing of scatterlists mapped
> for DMA.
> 
> Given a scatterlist in which entries are merged as part of mapping the
> scatterlist for DMA, the DMA length of a merged entry will reflect the
> combined length of the entries that were merged. The subsequent
> scatterlist entry will contain DMA information for the scatterlist entry
> after the last merged entry, but the non-DMA information will be that of
> the first merged entry.
> 
> The ccp driver does not take this scatterlist merging into account. To
> address this, add a second scatterlist pointer to track the current
> position in the DMA mapped representation of the scatterlist. Both the DMA
> representation and the original representation of the scatterlist must be
> tracked as while most of the driver can use just the DMA representation,
> scatterlist_map_and_copy() must use the original representation and
> expects the scatterlist pointer to be accurate to the original
> representation.
> 
> In order to properly walk the original scatterlist, the scatterlist must
> be walked until the combined lengths of the entries seen is equal to the
> DMA length of the current entry being processed in the DMA mapped
> representation.
> 
> Fixes: 63b945091a070 ("crypto: ccp - CCP device driver and interface support")
> Signed-off-by: John Allen <john.allen@amd.com>

Acked-by: Tom Lendacky <thomas.lendacky@amd.com>

> Cc: stable@vger.kernel.org
> ---
>   drivers/crypto/ccp/ccp-dev.h |  1 +
>   drivers/crypto/ccp/ccp-ops.c | 37 +++++++++++++++++++++++++-----------
>   2 files changed, 27 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/crypto/ccp/ccp-dev.h b/drivers/crypto/ccp/ccp-dev.h
> index 3f68262d9ab4..87a34d91fdf7 100644
> --- a/drivers/crypto/ccp/ccp-dev.h
> +++ b/drivers/crypto/ccp/ccp-dev.h
> @@ -469,6 +469,7 @@ struct ccp_sg_workarea {
>   	unsigned int sg_used;
>   
>   	struct scatterlist *dma_sg;
> +	struct scatterlist *dma_sg_head;
>   	struct device *dma_dev;
>   	unsigned int dma_count;
>   	enum dma_data_direction dma_dir;
> diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
> index 422193690fd4..64112c736810 100644
> --- a/drivers/crypto/ccp/ccp-ops.c
> +++ b/drivers/crypto/ccp/ccp-ops.c
> @@ -63,7 +63,7 @@ static u32 ccp_gen_jobid(struct ccp_device *ccp)
>   static void ccp_sg_free(struct ccp_sg_workarea *wa)
>   {
>   	if (wa->dma_count)
> -		dma_unmap_sg(wa->dma_dev, wa->dma_sg, wa->nents, wa->dma_dir);
> +		dma_unmap_sg(wa->dma_dev, wa->dma_sg_head, wa->nents, wa->dma_dir);
>   
>   	wa->dma_count = 0;
>   }
> @@ -92,6 +92,7 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
>   		return 0;
>   
>   	wa->dma_sg = sg;
> +	wa->dma_sg_head = sg;
>   	wa->dma_dev = dev;
>   	wa->dma_dir = dma_dir;
>   	wa->dma_count = dma_map_sg(dev, sg, wa->nents, dma_dir);
> @@ -104,14 +105,28 @@ static int ccp_init_sg_workarea(struct ccp_sg_workarea *wa, struct device *dev,
>   static void ccp_update_sg_workarea(struct ccp_sg_workarea *wa, unsigned int len)
>   {
>   	unsigned int nbytes = min_t(u64, len, wa->bytes_left);
> +	unsigned int sg_combined_len = 0;
>   
>   	if (!wa->sg)
>   		return;
>   
>   	wa->sg_used += nbytes;
>   	wa->bytes_left -= nbytes;
> -	if (wa->sg_used == wa->sg->length) {
> -		wa->sg = sg_next(wa->sg);
> +	if (wa->sg_used == sg_dma_len(wa->dma_sg)) {
> +		/* Advance to the next DMA scatterlist entry */
> +		wa->dma_sg = sg_next(wa->dma_sg);
> +
> +		/* In the case that the DMA mapped scatterlist has entries
> +		 * that have been merged, the non-DMA mapped scatterlist
> +		 * must be advanced multiple times for each merged entry.
> +		 * This ensures that the current non-DMA mapped entry
> +		 * corresponds to the current DMA mapped entry.
> +		 */
> +		do {
> +			sg_combined_len += wa->sg->length;
> +			wa->sg = sg_next(wa->sg);
> +		} while (wa->sg_used > sg_combined_len);
> +
>   		wa->sg_used = 0;
>   	}
>   }
> @@ -299,7 +314,7 @@ static unsigned int ccp_queue_buf(struct ccp_data *data, unsigned int from)
>   	/* Update the structures and generate the count */
>   	buf_count = 0;
>   	while (sg_wa->bytes_left && (buf_count < dm_wa->length)) {
> -		nbytes = min(sg_wa->sg->length - sg_wa->sg_used,
> +		nbytes = min(sg_dma_len(sg_wa->dma_sg) - sg_wa->sg_used,
>   			     dm_wa->length - buf_count);
>   		nbytes = min_t(u64, sg_wa->bytes_left, nbytes);
>   
> @@ -331,11 +346,11 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
>   	 * and destination. The resulting len values will always be <= UINT_MAX
>   	 * because the dma length is an unsigned int.
>   	 */
> -	sg_src_len = sg_dma_len(src->sg_wa.sg) - src->sg_wa.sg_used;
> +	sg_src_len = sg_dma_len(src->sg_wa.dma_sg) - src->sg_wa.sg_used;
>   	sg_src_len = min_t(u64, src->sg_wa.bytes_left, sg_src_len);
>   
>   	if (dst) {
> -		sg_dst_len = sg_dma_len(dst->sg_wa.sg) - dst->sg_wa.sg_used;
> +		sg_dst_len = sg_dma_len(dst->sg_wa.dma_sg) - dst->sg_wa.sg_used;
>   		sg_dst_len = min_t(u64, src->sg_wa.bytes_left, sg_dst_len);
>   		op_len = min(sg_src_len, sg_dst_len);
>   	} else {
> @@ -365,7 +380,7 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
>   		/* Enough data in the sg element, but we need to
>   		 * adjust for any previously copied data
>   		 */
> -		op->src.u.dma.address = sg_dma_address(src->sg_wa.sg);
> +		op->src.u.dma.address = sg_dma_address(src->sg_wa.dma_sg);
>   		op->src.u.dma.offset = src->sg_wa.sg_used;
>   		op->src.u.dma.length = op_len & ~(block_size - 1);
>   
> @@ -386,7 +401,7 @@ static void ccp_prepare_data(struct ccp_data *src, struct ccp_data *dst,
>   			/* Enough room in the sg element, but we need to
>   			 * adjust for any previously used area
>   			 */
> -			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.sg);
> +			op->dst.u.dma.address = sg_dma_address(dst->sg_wa.dma_sg);
>   			op->dst.u.dma.offset = dst->sg_wa.sg_used;
>   			op->dst.u.dma.length = op->src.u.dma.length;
>   		}
> @@ -2028,7 +2043,7 @@ ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   	dst.sg_wa.sg_used = 0;
>   	for (i = 1; i <= src.sg_wa.dma_count; i++) {
>   		if (!dst.sg_wa.sg ||
> -		    (dst.sg_wa.sg->length < src.sg_wa.sg->length)) {
> +		    (sg_dma_len(dst.sg_wa.sg) < sg_dma_len(src.sg_wa.sg))) {
>   			ret = -EINVAL;
>   			goto e_dst;
>   		}
> @@ -2054,8 +2069,8 @@ ccp_run_passthru_cmd(struct ccp_cmd_queue *cmd_q, struct ccp_cmd *cmd)
>   			goto e_dst;
>   		}
>   
> -		dst.sg_wa.sg_used += src.sg_wa.sg->length;
> -		if (dst.sg_wa.sg_used == dst.sg_wa.sg->length) {
> +		dst.sg_wa.sg_used += sg_dma_len(src.sg_wa.sg);
> +		if (dst.sg_wa.sg_used == sg_dma_len(dst.sg_wa.sg)) {
>   			dst.sg_wa.sg = sg_next(dst.sg_wa.sg);
>   			dst.sg_wa.sg_used = 0;
>   		}
> 
