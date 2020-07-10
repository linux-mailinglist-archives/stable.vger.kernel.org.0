Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73FF221BE7F
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 22:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726965AbgGJUeI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 16:34:08 -0400
Received: from mail-eopbgr760048.outbound.protection.outlook.com ([40.107.76.48]:50830
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726725AbgGJUeH (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 16:34:07 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bC/mlVa4JSB7Tw2rrtQ+SdTGbLksdIN3vKmljTUTR4XAfLSS5WaKzZcBrYbV7r1tLdbLOdi3Iea8oGZQoUosvwyJr2KZtLFotX7TmHqD2K1du4VYElKq2H2JR3JtNLGUjkUBqYk70O5Q41Q1P1dQobPBjKhgTzDLh8hu2QmQ7hlE4ML19v+wXOsRA+zC4KdR1AxXuukfKBZi2YH2K+hoklP/PIaUwqjpYaE7seRTQigKxtl6IPmmCzEme9xtzJUNn9xMfWqI8YQWZD/0VgyAg8HeGvBldQvxsZV0nioOtTLSGd6O9RJm8+UWF1P1Qaiyb4GFV+hfV90ldOYAZ6LMYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8J3RmcBl2Jn90aB6ogeSk05au9Er6SH9pmQtkWAMss=;
 b=XgnBrejzSWgcjzCE4g0DjfKZardP5meGPohNJ/Z2Ot/tMAGQDx3cUBH1pAmaBAQlg2rdf2LDO5TiZWhFFYT4p/5+XAP60bWhEAkeJ8BcaaI8U/dNM1UiqqLEasz+a0668bTfKpAgpL+zZHM04g3Ea9rnu26DEjlk7NsqsZTmTlLeivk4ASRtjZ/XngidxCVsBSVjGlqph4ADhOQuDEFzAMq2LxW42TbM1PV7GFfE2R+xV3RODIa0KFvj9BUR7otTEOPeQ3mlBWag6Tu7IWq2eDX+vNHBHHAplAVlDcSdhkU9CCM8iVPI7uj7Be7+hbM6h78dHXAS2uDCWHxjg38TXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=amdcloud.onmicrosoft.com; s=selector2-amdcloud-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z8J3RmcBl2Jn90aB6ogeSk05au9Er6SH9pmQtkWAMss=;
 b=1exAqHqJboRJh8C7qTXVna3HqGtZCskMtkGC9AaNAtW43Rpf24V0hH5YhI/xf5IGwf55QYVKJaBioVAMyNkBfbJx+u39SoAwcnxKT/xnDAg6/siCY6ZSxs/aODuZCFSJ9LfLRfkNnSTTJ5/VBattLoUAaU20m74mrSzjFpfpPn0=
Authentication-Results: lists.freedesktop.org; dkim=none (message not signed)
 header.d=none;lists.freedesktop.org; dmarc=none action=none
 header.from=amd.com;
Received: from CH2PR12MB4198.namprd12.prod.outlook.com (2603:10b6:610:7e::23)
 by CH2PR12MB4231.namprd12.prod.outlook.com (2603:10b6:610:7d::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21; Fri, 10 Jul
 2020 20:34:05 +0000
Received: from CH2PR12MB4198.namprd12.prod.outlook.com
 ([fe80::9013:9410:7d60:cce1]) by CH2PR12MB4198.namprd12.prod.outlook.com
 ([fe80::9013:9410:7d60:cce1%9]) with mapi id 15.20.3174.023; Fri, 10 Jul 2020
 20:34:05 +0000
From:   Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
To:     amd-gfx@lists.freedesktop.org
Cc:     Harry.Wentland@amd.com, Sunpeng.Li@amd.com,
        Bhawanpreet.Lakha@amd.com, Rodrigo.Siqueira@amd.com,
        Aurabindo.Pillai@amd.com, qingqing.zhuo@amd.com, Eryk.Brol@amd.com,
        Josip Pavic <Josip.Pavic@amd.com>, stable@vger.kernel.org,
        Aric Cyr <Aric.Cyr@amd.com>
Subject: [PATCH 10/10] drm/amd/display: handle failed allocation during stream construction
Date:   Fri, 10 Jul 2020 16:33:25 -0400
Message-Id: <20200710203325.1097188-11-Rodrigo.Siqueira@amd.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200710203325.1097188-1-Rodrigo.Siqueira@amd.com>
References: <20200710203325.1097188-1-Rodrigo.Siqueira@amd.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: YTOPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b00:15::38) To CH2PR12MB4198.namprd12.prod.outlook.com
 (2603:10b6:610:7e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from atma2.hitronhub.home (2607:fea8:56a0:8440::b10e) by YTOPR0101CA0025.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:b00:15::38) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.21 via Frontend Transport; Fri, 10 Jul 2020 20:34:05 +0000
X-Mailer: git-send-email 2.27.0
X-Originating-IP: [2607:fea8:56a0:8440::b10e]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 37bc2f50-ac81-40de-4add-08d8251096dc
X-MS-TrafficTypeDiagnostic: CH2PR12MB4231:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CH2PR12MB4231CE2FB04B59C3F52AEDA998650@CH2PR12MB4231.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tqiyYN9/E3CqpvmqQUVXirbs50zp9SbG29ciqR5I5d4hOtGGy78EELAotk/fZWa1dppaIg2HJa74UqFuXWPjFTHxb1SnFRXtYV9drStZpBppSfDBfG04kSdbGBnzq+cq+AopRZi5HGxUuQr5nr1iNTC9RZx85SSsbI3UOuoYm0oprg13tKrcP4priprrY6lo5lP1Sq/qLiZ8EnCfAKePho8L8psdgh9Jp+rMI2vLMRa7nLRrYbrJr8QhRMJthqF64HXtVn8sWPmZtaT0yxAFjunrx28PTPYpl7dBBKazLf2b7wkviKcjgiorbOsK5dlWKh8ZHNOaGX7QiBoPzS0yPQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH2PR12MB4198.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(346002)(366004)(54906003)(2616005)(8936002)(8676002)(6512007)(478600001)(316002)(16526019)(5660300002)(186003)(4326008)(86362001)(6916009)(52116002)(6506007)(6486002)(1076003)(6666004)(36756003)(66476007)(66556008)(66946007)(83380400001)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: m2MoAGnkx1qlyfoDk9fmVWAQnGF9guLc8PoecvotqkPJSa/g9Vh+hPtNEsGuuNzhCdH4ZYuj34yR+3YJoAfVV+a1cOIi2Wh3fhAdw62AqKGzyK+fNHnexfaG2URyosHi/RPZKWikuKOlvvnfuje19iBx++BzifU6OyW2Fi/1gcIAESmi4O7N8YP6bs7QeIIb6f4GeuvwaTSqJ91HixTK7H22HSBm2ctU9/l2l8AMWk0Qa9bsAuEpZpQUWoUeF3Pd1QYTFBsiXuaO2m/eB6rGvNZ5yk8O9elLV5CdFnHYfwj1i46K+nAbCjNo515k1Zb9gORpe2OWZoJN12rR3faBfEcXExZEFSX4sOUZbF6FC6BmP2OWOH5mskw9nUA4/R/Qvff45N6aSABaVkrOQFv5Ehqt7JmzEfReIImRI7iKww+1s6Ft6+Vmm5H5R+alRilffm+se2AT9daaFrjRUX4/H2DnKwBQKrS0pfkFRLrNFzDDn/B4JQPEvQezD6gsNSDFjiY0StXYzZ7P/2lBfYcgLw==
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 37bc2f50-ac81-40de-4add-08d8251096dc
X-MS-Exchange-CrossTenant-AuthSource: CH2PR12MB4198.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jul 2020 20:34:05.4973
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4NTkPvMLA7B6FP6hMmXOPo7s0B8PXtrdZlDnBiE++v/+BdGkUVeJopkQsw3sL31xJkDnRhtOm2IZLH6FQn0ZdQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4231
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Josip Pavic <Josip.Pavic@amd.com>

[Why]
Failing to allocate a transfer function during stream construction leads
to a null pointer dereference

[How]
Handle the failed allocation by failing the stream construction

Cc: stable@vger.kernel.org
Signed-off-by: Josip Pavic <Josip.Pavic@amd.com>
Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
---
 .../gpu/drm/amd/display/dc/core/dc_stream.c   | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
index 3b897372ed27..d6989d115c5c 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_stream.c
@@ -56,7 +56,7 @@ void update_stream_signal(struct dc_stream_state *stream, struct dc_sink *sink)
 	}
 }
 
-static void dc_stream_construct(struct dc_stream_state *stream,
+static bool dc_stream_construct(struct dc_stream_state *stream,
 	struct dc_sink *dc_sink_data)
 {
 	uint32_t i = 0;
@@ -118,11 +118,17 @@ static void dc_stream_construct(struct dc_stream_state *stream,
 	update_stream_signal(stream, dc_sink_data);
 
 	stream->out_transfer_func = dc_create_transfer_func();
+	if (stream->out_transfer_func == NULL) {
+		dc_sink_release(dc_sink_data);
+		return false;
+	}
 	stream->out_transfer_func->type = TF_TYPE_BYPASS;
 	stream->out_transfer_func->ctx = stream->ctx;
 
 	stream->stream_id = stream->ctx->dc_stream_id_count;
 	stream->ctx->dc_stream_id_count++;
+
+	return true;
 }
 
 static void dc_stream_destruct(struct dc_stream_state *stream)
@@ -164,13 +170,20 @@ struct dc_stream_state *dc_create_stream_for_sink(
 
 	stream = kzalloc(sizeof(struct dc_stream_state), GFP_KERNEL);
 	if (stream == NULL)
-		return NULL;
+		goto alloc_fail;
 
-	dc_stream_construct(stream, sink);
+	if (dc_stream_construct(stream, sink) == false)
+		goto construct_fail;
 
 	kref_init(&stream->refcount);
 
 	return stream;
+
+construct_fail:
+	kfree(stream);
+
+alloc_fail:
+	return NULL;
 }
 
 struct dc_stream_state *dc_copy_stream(const struct dc_stream_state *stream)
-- 
2.27.0

