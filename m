Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59AAEF7A50
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 18:57:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726939AbfKKR5F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 12:57:05 -0500
Received: from mail-eopbgr730049.outbound.protection.outlook.com ([40.107.73.49]:46674
        "EHLO NAM05-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726763AbfKKR5F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 12:57:05 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UVAZ79RzbzFBup0C1BV4Y6Bo88CqdT9I3ckEoAtQp6eVW03Cx4FdYk+Idrm3Qy/QB/LGMtGiMwtH9hIXMVgVcVL6URswTfzeFrYYkWu+9slRti4LqQvn1Ro5JP2t8IC1ILR6WiCtSoC4Z5b/XBvVL5em6AKquSXLB+k42zqMLGkEi6Z8lI/+NnQrFzm73SDE94Y9Q4ndqzAyKn/A+4ZvIAnBsrFmyj+liN1qzcm2hf88+lJxkuMpn6qX+6kxdvOKRIUbF8d+5TmFCXtaQVtfXPa0cwqhr/3ZGA6FCOs19e4xXyCNIqNx85DWZBRJGNYqOMCrlrqtVskdfADNwlVMXw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHxdWyjI1CEGpFaebmpMJXDphuvjga1HarhHd/wit6o=;
 b=axv4XU0DnIx0Zh/QREdaASa7UaZ0CVb08tDkUiBJLPzE1re+fkTiEoePDJP0nlHcADh5ueOAb/MKDryV6och1yUJmRteX85W4GPCo0T5ckZdxbp0/ntQvTbmvZ6H5PjrpSgEkG4UbN85m4buOWwZ7sUQJcVIxAmRP12PbrKLIXHlkj2igBDOujVOoM25JAvnxMlhu6QvGeM05snzFSPQxWH6v45zGQHvLSj+F7tNEo7+eP612XvgpUsac7Qo0D3w5ThAOUC60MEcMWEOpvlaxxJThOyvl3jBzwYVCCxjDbbz5lqcdItqpUZvXoqTDwatZ4IrMddNynGPrXbb3yZmKA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MHxdWyjI1CEGpFaebmpMJXDphuvjga1HarhHd/wit6o=;
 b=bZMCmDZgsaCRQS3JJoLcDcwKKMXW+pBuUuLa9tZ6Y7LRQMXEXPeMMQlwKDlkU1DRdqQIEXVFpdGB7TXuIv3GcA+Q2lf3s1JO2ufNBr1o7kC6RYHSMhlqLoyi433Bei/WZXxUJstyyM8YA9ba4ExK5wcbr7UO8s++inttHYMXcQA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Gary.Hook@amd.com; 
Received: from DM5PR12MB1449.namprd12.prod.outlook.com (10.172.40.14) by
 DM5PR12MB1658.namprd12.prod.outlook.com (10.172.34.136) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.24; Mon, 11 Nov 2019 17:56:23 +0000
Received: from DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::2811:ef21:da57:3869]) by DM5PR12MB1449.namprd12.prod.outlook.com
 ([fe80::2811:ef21:da57:3869%10]) with mapi id 15.20.2430.027; Mon, 11 Nov
 2019 17:56:23 +0000
From:   Gary R Hook <gary.hook@amd.com>
To:     ghook@redhat.com
Cc:     Gary R Hook <gary.hook@amd.com>, stable@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>
Subject: [PATCH] crypto: ccp - Add support for valid authsize values less than 16
Date:   Mon, 11 Nov 2019 11:56:01 -0600
Message-Id: <20191111175601.32011-1-gary.hook@amd.com>
X-Mailer: git-send-email 2.17.1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SN2PR01CA0018.prod.exchangelabs.com (2603:10b6:804:2::28)
 To DM5PR12MB1449.namprd12.prod.outlook.com (2603:10b6:4:10::14)
MIME-Version: 1.0
X-Mailer: git-send-email 2.17.1
X-Originating-IP: [165.204.77.1]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 04851016-65bb-4cb0-a176-08d766d076dd
X-MS-TrafficTypeDiagnostic: DM5PR12MB1658:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB1658AB500CC733525DCE77A1FD740@DM5PR12MB1658.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-Forefront-PRVS: 0218A015FA
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(979002)(4636009)(346002)(39860400002)(376002)(366004)(136003)(396003)(189003)(199004)(36756003)(305945005)(50466002)(6666004)(1076003)(6512007)(6486002)(6436002)(186003)(66066001)(52116002)(5660300002)(6506007)(386003)(46406003)(47776003)(486006)(54906003)(2616005)(476003)(99286004)(316002)(26005)(4326008)(3846002)(6116002)(2906002)(81166006)(2351001)(81156014)(2361001)(230700001)(14454004)(23726003)(25786009)(6916009)(478600001)(7736002)(66476007)(14444005)(66556008)(8676002)(86362001)(50226002)(66946007)(97756001)(8936002)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR12MB1658;H:DM5PR12MB1449.namprd12.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: amd.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8ybLUWCK7ODfZQWL/9esPCkCxYFB0baGyHIxHlrSQgYs+AOs2vRprkI3xJM7KGs10SbX8CLxDiC3mcfoxdKHPfHkLwBgg81agADJANgSZSeYAKaoOaLYhB56rMP4UEdaNxn9gdzVrxUHvO7FY9ZJBl0oIR/QXWwsdj1rmQH+OwoTqf9YI9g6euly4zzgfQ4emJ9XsFCFOpgen3g6IqzSnHWhPii7CI/BH/B6LPdIg7i69HsnHGCns9H0/WOoNb92sn/zUvlD9bwvtnQdDgWuqT4pEWMkkljEa0RofKf2Ijr4I8IlTfMTz1RT3vUqf8r2dNePjhWVtSyIwnbyZEONaDDXbbB+66CgWxE89rycpRmz+NC2wP11KFBwcWXGNeSvNzKVeGM9F25kAMQL8I9raRrtYGmWXjmiESbb9lML7p4e4u7ZF8Vb+DOmn8LwInh+
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 04851016-65bb-4cb0-a176-08d766d076dd
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Nov 2019 17:56:23.2690
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SV+KeJT2T9DSXL+67j9fcxLSIhIHw68vmfzlJbMgldBDUntETlJsJbEiDk6Kho0E
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1658
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

AES GCM encryption allows for authsize values of 4, 8, and 12-16 bytes.
Validate the requested authsize, and retain it to save in the request
context.

Fixes: 36cf515b9bbe2 ("crypto: ccp - Enable support for AES GCM on v5 CCPs")
Cc: <stable@vger.kernel.org>
Signed-off-by: Gary R Hook <gary.hook@amd.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---
 drivers/crypto/ccp/ccp-crypto-aes-galois.c | 14 ++++++++++++
 drivers/crypto/ccp/ccp-ops.c               | 26 +++++++++++++++++-----
 include/linux/ccp.h                        |  2 ++
 3 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/drivers/crypto/ccp/ccp-crypto-aes-galois.c b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
index d22631cb2bb3..02eba84028b3 100644
--- a/drivers/crypto/ccp/ccp-crypto-aes-galois.c
+++ b/drivers/crypto/ccp/ccp-crypto-aes-galois.c
@@ -58,6 +58,19 @@ static int ccp_aes_gcm_setkey(struct crypto_aead *tfm, const u8 *key,
 static int ccp_aes_gcm_setauthsize(struct crypto_aead *tfm,
 				   unsigned int authsize)
 {
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	return 0;
 }
 
@@ -104,6 +117,7 @@ static int ccp_aes_gcm_crypt(struct aead_request *req, bool encrypt)
 	memset(&rctx->cmd, 0, sizeof(rctx->cmd));
 	INIT_LIST_HEAD(&rctx->cmd.entry);
 	rctx->cmd.engine = CCP_ENGINE_AES;
+	rctx->cmd.u.aes.authsize = crypto_aead_authsize(tfm);
 	rctx->cmd.u.aes.type = ctx->u.aes.type;
 	rctx->cmd.u.aes.mode = ctx->u.aes.mode;
 	rctx->cmd.u.aes.action = encrypt;
diff --git a/drivers/crypto/ccp/ccp-ops.c b/drivers/crypto/ccp/ccp-ops.c
index 59f9849c3662..ef723e2722a8 100644
--- a/drivers/crypto/ccp/ccp-ops.c
+++ b/drivers/crypto/ccp/ccp-ops.c
@@ -622,6 +622,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 
 	unsigned long long *final;
 	unsigned int dm_offset;
+	unsigned int authsize;
 	unsigned int jobid;
 	unsigned int ilen;
 	bool in_place = true; /* Default value */
@@ -643,6 +644,21 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 	if (!aes->key) /* Gotta have a key SGL */
 		return -EINVAL;
 
+	/* Zero defaults to 16 bytes, the maximum size */
+	authsize = aes->authsize ? aes->authsize : AES_BLOCK_SIZE;
+	switch (authsize) {
+	case 16:
+	case 15:
+	case 14:
+	case 13:
+	case 12:
+	case 8:
+	case 4:
+		break;
+	default:
+		return -EINVAL;
+	}
+
 	/* First, decompose the source buffer into AAD & PT,
 	 * and the destination buffer into AAD, CT & tag, or
 	 * the input into CT & tag.
@@ -657,7 +673,7 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 		p_tag = scatterwalk_ffwd(sg_tag, p_outp, ilen);
 	} else {
 		/* Input length for decryption includes tag */
-		ilen = aes->src_len - AES_BLOCK_SIZE;
+		ilen = aes->src_len - authsize;
 		p_tag = scatterwalk_ffwd(sg_tag, p_inp, ilen);
 	}
 
@@ -839,19 +855,19 @@ static int ccp_run_aes_gcm_cmd(struct ccp_cmd_queue *cmd_q,
 
 	if (aes->action == CCP_AES_ACTION_ENCRYPT) {
 		/* Put the ciphered tag after the ciphertext. */
-		ccp_get_dm_area(&final_wa, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ccp_get_dm_area(&final_wa, 0, p_tag, 0, authsize);
 	} else {
 		/* Does this ciphered tag match the input? */
-		ret = ccp_init_dm_workarea(&tag, cmd_q, AES_BLOCK_SIZE,
+		ret = ccp_init_dm_workarea(&tag, cmd_q, authsize,
 					   DMA_BIDIRECTIONAL);
 		if (ret)
 			goto e_tag;
-		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, AES_BLOCK_SIZE);
+		ret = ccp_set_dm_area(&tag, 0, p_tag, 0, authsize);
 		if (ret)
 			goto e_tag;
 
 		ret = crypto_memneq(tag.address, final_wa.address,
-				    AES_BLOCK_SIZE) ? -EBADMSG : 0;
+				    authsize) ? -EBADMSG : 0;
 		ccp_dm_free(&tag);
 	}
 
diff --git a/include/linux/ccp.h b/include/linux/ccp.h
index 7e9c991c95e0..43ed9e77cf81 100644
--- a/include/linux/ccp.h
+++ b/include/linux/ccp.h
@@ -173,6 +173,8 @@ struct ccp_aes_engine {
 	enum ccp_aes_mode mode;
 	enum ccp_aes_action action;
 
+	u32 authsize;
+
 	struct scatterlist *key;
 	u32 key_len;		/* In bytes */
 
-- 
2.17.1

