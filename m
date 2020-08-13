Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D3872440AF
	for <lists+stable@lfdr.de>; Thu, 13 Aug 2020 23:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726698AbgHMVfc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Aug 2020 17:35:32 -0400
Received: from mail-bn7nam10on2065.outbound.protection.outlook.com ([40.107.92.65]:28257
        "EHLO NAM10-BN7-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726522AbgHMVfc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Aug 2020 17:35:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gHRgmN9psbd+ueAMBYcilpogVu7thEwYh1SaAeCgZMd5eC8YnM0uYB65wGID89x34lAuYs21WISZ4b/weu42n7EqtkmkScPorLg7YLLqsv4fcBTpjrYIKgD8iRdHu5QEgkRYh6aiwzlBvcHdYXu6RcvrYwRx8TMMwgjAi/4pBULiCsxXBF2Mfu1pqvOqUatzYe7DnoX422rH3foDWZfJ8M0Tbrc+RMgHAYtyCBRfrrN8sKT22xy+OxedFLOIi0IH4c7kV/GFCZbMOnqZYYJl011SnoHZ7GicVxR53AS2NyMevGUpQQAN7DhX3Xv647Bb62bDBcspLtWihvg8yjuSjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScPPtFGjBldxSKtkhsxpGXqclgLkB+oMTVO/Ya9VkxY=;
 b=Sc+c5osRPUUWNRKrzQid/N/OOxQ0dyRbTyyTLWktbQq9qd94hzLbLWzSPYFS492qUL0nmOyiRLiAGA850s3s2c1asghfgyV3yzDZhRM1VyGkIHzHvDfrzerViwlXvMb4IFc1ZGGtuWRRFK4WhqIehco7uwsVzQFx5bRDKL4sYHMtUqQd9Sfpv2Q9g7TpvVdL9LwhjgwM4RAvPb4Wqi3s/UgyOrV87iENZacFl94BpwM7z5zwaP96RPUD0kzOx3pJ0nEVi/Z/DILi5uepa9mDUY5sjw5HV7uabmnuOqPLXzEqq83S5MbBxtNI/11PW8RDaGSEkGVX5kUGZh6x3eFJ1Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ScPPtFGjBldxSKtkhsxpGXqclgLkB+oMTVO/Ya9VkxY=;
 b=kYI4zHknjOn5MxVkHwxn7SUiAnTzJv+wKAsWUh3X+MveF5L1QB6gb6jIdzyZIeDzfwLgcFKFCWwNsDHoMnMngOfxEEHUilDGpTVT9ww3hUy3OeYVFVjLJEkOS00wtgpxtWmIdrGDH93Qz8t9NGmFGH8mh0j6V9JbeRthZsM3whk=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from DM6PR12MB4124.namprd12.prod.outlook.com (2603:10b6:5:221::20)
 by DM5PR12MB1355.namprd12.prod.outlook.com (2603:10b6:3:6e::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.3261.19; Thu, 13 Aug 2020 21:35:30 +0000
Received: from DM6PR12MB4124.namprd12.prod.outlook.com
 ([fe80::75f2:ebaa:bca6:3db7]) by DM6PR12MB4124.namprd12.prod.outlook.com
 ([fe80::75f2:ebaa:bca6:3db7%9]) with mapi id 15.20.3283.016; Thu, 13 Aug 2020
 21:35:29 +0000
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry.Wentland@amd.com, Sunpeng.Li@amd.com,
        Bhawanpreet.Lakha@amd.com, Rodrigo.Siqueira@amd.com,
        Aurabindo.Pillai@amd.com, qingqing.zhuo@amd.com, Eryk.Brol@amd.com,
        Paul Hsieh <paul.hsieh@amd.com>, stable@vger.kernel.org,
        Aric Cyr <Aric.Cyr@amd.com>
Subject: [PATCH 07/17] drm/amd/display: Fix DFPstate hang due to view port changed
Date:   Thu, 13 Aug 2020 17:33:46 -0400
Message-Id: <20200813213356.1606886-8-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200813213356.1606886-1-Rodrigo.Siqueira@amd.com>
References: <20200813213356.1606886-1-Rodrigo.Siqueira@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YTBPR01CA0005.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:14::18) To DM6PR12MB4124.namprd12.prod.outlook.com
 (2603:10b6:5:221::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from atma2.hitronhub.home (2607:fea8:56e0:6d60::2db6) by YTBPR01CA0005.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b01:14::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3283.15 via Frontend Transport; Thu, 13 Aug 2020 21:35:29 +0000
X-Mailer: git-send-email 2.28.0
X-Originating-IP: [2607:fea8:56e0:6d60::2db6]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 2fd06817-f07b-4877-4be3-08d83fd0ccd7
X-MS-TrafficTypeDiagnostic: DM5PR12MB1355:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM5PR12MB13551215CA2D4CB03A8BEF0998430@DM5PR12MB1355.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vdsWrRXeVU3bJ0gF+/6LVIOYj2nev3JlXD4GY3/KBG9bRIciF3KqQ0iICXc2z0PK+GMRUujyPJgZKxBsqp2LkKU08f0pzFWhEHMj3KugCdDd2dvMdT/+WiivHnfNXmTGKmcvqJchi5oByXuGgRDWLBwIAPRoneq4CE6h/i6FmVVpW6ipLTC+qxpNdcTMC5tY8vW1rRiXO6SW+6q0kafAPbvTCzP6KNvPrgHUT3lHOZ/zjFeopUs73RNkPGdCNNX8JOBUZBjP8a8TfbhAOdcBUDbKkq2V2BhnttMgg3v0n4Qoap4hQbjDFyFVNq1HBC8Vvu3KNb9XSzMIFR6nIfkfgw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR12MB4124.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(346002)(376002)(396003)(136003)(2616005)(6512007)(83380400001)(6486002)(4326008)(316002)(478600001)(1076003)(6916009)(66476007)(66556008)(36756003)(52116002)(66946007)(2906002)(6506007)(8676002)(6666004)(54906003)(16526019)(8936002)(5660300002)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: PzHaSgCDjsgVundLai+uOBoN+1Tvp7Y8+rITB80fhsx5lHNV7xGEtHwNI9yKInoFidZ1tkqtGTwskpoq/vve17aDZsftkJBfR3LeltjYXm6XF3kaI0eiB6/Ngj7bNqXVaD5nWi81sP4naTpKU3u6jQmX9ejxDKXYGCmd6FBZiqNd9lnBU5ZrCZN51PrHdKoBQx6/PwsH9YL6WFu9f+HEL5wygf5SR7meNVO0/qEqRrkuHqDq5sp1sBv4zxohljyJI1MSfBE7Wq3GMHnHdvJi3pOeBIj1xvFNdfwQOF2Euscpmm0/a9/khkVeB0PHkDu/UIpeoBD3jVKoSAvotX0Q3P4C2qTJzaSePhYhtEheEi65cwPYj3ToJoCCDwqmP+Spw8r42fPaYoPmT257qJ1bSjXvQshNmI9+UgLu93nJDfZtlw+/dDXfFeF7I56zt+5YEEUegZr4pBIvVegKj9qmUsDw6+RwLFg2IsUAl/vDLMDpsQ8e4Wurm5Om6X+rrs4s82OPxCTJP2YnrK6LxtFBIvrPrXEIfhJbYO9eYQr9/lTrncRdYRoqMXxh8m/ntb2ndbQ0aShuFS5cIecrH3AeXk7/BDAPkjwDhV2U5EuB3Rn8vfSz+Em0z4RuY6fzI8ryDsoSdxA/8Vzjm70G2dydMMVsTJ6kKgQubRgrSgSV01NJ68DsBvPsRCli2hchTGjJ
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fd06817-f07b-4877-4be3-08d83fd0ccd7
X-MS-Exchange-CrossTenant-AuthSource: DM6PR12MB4124.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2020 21:35:29.7026
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: G40BtlPPQsOWx87evqD4Cm9Aq/oLOkxlvCIpJppPvC41pL7mFyXU5w/71dzsi8pmaxESHKBMIGpA0Y97Y9w4Wg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR12MB1355
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Hsieh <paul.hsieh@amd.com>

[Why]
Place the cursor in the center of screen between two pipes then
adjusting the viewport but cursour doesn't update cause DFPstate hang.

[How]
If viewport changed, update cursor as well.

Cc: stable@vger.kernel.org
Signed-off-by: Paul Hsieh <paul.hsieh@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 66180b4332f1..c8cfd3ba1c15 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1457,8 +1457,8 @@ static void dcn20_update_dchubp_dpp(
 
 	/* Any updates are handled in dc interface, just need to apply existing for plane enable */
 	if ((pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed ||
-			pipe_ctx->update_flags.bits.scaler || pipe_ctx->update_flags.bits.viewport)
-			&& pipe_ctx->stream->cursor_attributes.address.quad_part != 0) {
+			pipe_ctx->update_flags.bits.scaler || viewport_changed == true) &&
+			pipe_ctx->stream->cursor_attributes.address.quad_part != 0) {
 		dc->hwss.set_cursor_position(pipe_ctx);
 		dc->hwss.set_cursor_attribute(pipe_ctx);
 
-- 
2.28.0

