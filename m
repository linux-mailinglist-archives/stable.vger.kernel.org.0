Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0CE6B224A
	for <lists+stable@lfdr.de>; Thu,  9 Mar 2023 12:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231384AbjCILIe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Mar 2023 06:08:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231419AbjCILH7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Mar 2023 06:07:59 -0500
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on20614.outbound.protection.outlook.com [IPv6:2a01:111:f400:7e89::614])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E433BF367B
        for <stable@vger.kernel.org>; Thu,  9 Mar 2023 03:02:01 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W6XJ58K6lxkL9lSuxGCBU5PfXtyBTRzBykuW7xAJV4Atga8L443tVpCy5EdAQHGxXz/+SGzvLKrja9LJtgTNlFMidxxjJRV8EoDcN3ITqzSvqj7+zK5B05b2Hf7TavTAiLVk0Ir3JWyU8IyMDttYP9b/Fcv6HTZKSjl4vFB/pM3WxH+Ffb40P7rjKm6dcx61iZ+HxP2oH37PbHBE8B/QrrTY0CpkkXmw1Sg2uKxjiOTj1X5lCUPfIIicBb7TpTxYgCXmSC02PwfiJC2QE5FxU5HMi0fj9OdYzHmdLoqvEyfmAJGEzKj2YC90vvtOjpiuoUhCb36GrDqz0RW/2Z/aqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yBxoFxAQVBpsyIlcg6dmfxP/Ir6LPZbpJBgMUmgdInI=;
 b=aZ+Y1g5IbsnvgaiGkKMJQNtVhXSL8jTMzUF4HsGzQZi1bSalCSA8ux6nfE6fAmX/vil9YscxrIdScHiI5cbVpRBZtXMJhw17vy8Iu7hHM/ybbaBfoXnh8pLqwCR/l89GYghbjNG6/DaNl5gYL1guW3hAiGmeyf7UtL6BFCyq/PaAEcfQVaUfHE8kfPbnNkd+9LyT91KAcq0fhna7fLnkeVnE4HSuU33j91DpP42eKImaiJU+ZOutlP0JseA/8Z2cUxqREPcxGEB4HMchpBldGVtKSJpRAKoRgyh+VunTLiTdD9B6hz2XPIoP8J4bqtN/a6Rh/TW4Z2ewFyC/5bgjqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass (sender ip is
 165.204.84.17) smtp.rcpttodomain=vger.kernel.org smtp.mailfrom=amd.com;
 dmarc=pass (p=quarantine sp=quarantine pct=100) action=none
 header.from=amd.com; dkim=none (message not signed); arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yBxoFxAQVBpsyIlcg6dmfxP/Ir6LPZbpJBgMUmgdInI=;
 b=pRS+u9NTL/WLJQFEs8/xE6DnnAufao8Ceu+x21exFhfqEDGOg1yEs33Q94ii6XHaQgM44oXFDa5X6eTBjeK+82QuWVI7mxeIBosbHDvadoyp2rjo2IC4YtwTPMn7acgUGMfOrmOQ5zpjQZgBK4vBkJ8H1dDcE6w5YRZgebW9vkE=
Received: from DS7PR05CA0067.namprd05.prod.outlook.com (2603:10b6:8:57::12) by
 SA1PR12MB7151.namprd12.prod.outlook.com (2603:10b6:806:2b1::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Thu, 9 Mar
 2023 11:01:37 +0000
Received: from DS1PEPF0000E648.namprd02.prod.outlook.com
 (2603:10b6:8:57:cafe::b9) by DS7PR05CA0067.outlook.office365.com
 (2603:10b6:8:57::12) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19 via Frontend
 Transport; Thu, 9 Mar 2023 11:01:37 +0000
X-MS-Exchange-Authentication-Results: spf=pass (sender IP is 165.204.84.17)
 smtp.mailfrom=amd.com; dkim=none (message not signed)
 header.d=none;dmarc=pass action=none header.from=amd.com;
Received-SPF: Pass (protection.outlook.com: domain of amd.com designates
 165.204.84.17 as permitted sender) receiver=protection.outlook.com;
 client-ip=165.204.84.17; helo=SATLEXMB04.amd.com; pr=C
Received: from SATLEXMB04.amd.com (165.204.84.17) by
 DS1PEPF0000E648.mail.protection.outlook.com (10.167.18.38) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.20.6178.13 via Frontend Transport; Thu, 9 Mar 2023 11:01:37 +0000
Received: from amar-X570-AORUS-ELITE.amd.com (10.180.168.240) by
 SATLEXMB04.amd.com (10.181.40.145) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Thu, 9 Mar 2023 05:01:35 -0600
From:   Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>
To:     <stable@vger.kernel.org>
CC:     <christian.koenig@amd.com>,
        Somalapuram Amaranath <Amaranath.Somalapuram@amd.com>,
        Thomas Zimmermann <tzimmermann@suse.de>
Subject: [PATCH] drm/client: fix circular reference counting issue
Date:   Thu, 9 Mar 2023 16:31:13 +0530
Message-ID: <20230309110113.175871-1-Amaranath.Somalapuram@amd.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.180.168.240]
X-ClientProxiedBy: SATLEXMB04.amd.com (10.181.40.145) To SATLEXMB04.amd.com
 (10.181.40.145)
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS1PEPF0000E648:EE_|SA1PR12MB7151:EE_
X-MS-Office365-Filtering-Correlation-Id: 224dad10-30ef-479b-7bc6-08db208da79e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zohaqLtr/eJ1XbWcAU6mzC43rlIzH3DJQ5kj/tM6vvlfPzdQ62mnbzdTeDbt7xGSgHHH7BVGLhDkvCh30WII6frkJQo4vloii2MilDBtQm9rbKx8JwVYW6iTTDZ6EwzFjqgmc944Vm90rkMilVa4W8QhjH/Lr/wltdx0YYF20VtxS8rY/m5dY+eSYx/1ku11Ya+sg9SEophNBQkll0wuot+0OgYwvyU6mbeaBkUlxx0dm7V7VDEPICc+KIw7IDyzNANj/38j15a/QiwgVJC5ZZI8NV/zAqNivEeJrvGlUs6gl0NylNlc8tJ0TCbmcZ54L1KGjoPQsq4g5po9lg2Orlf3XxO/lK0QU8YtEXSaP5ugqkTP6qxpayU12Oqnvz8OhpVkneJ5EwTtNWbuIuOBYAlTba4x+Tp9Kf4dSkIF+ez9oTObWMEaq7lT6pcfCgSSx+GEXq1YTHlJm9IMsEI0jn0AZc6EXvhf6773aU03T9n+1wGYeYjGYkUKltsDJNrwnKXo11hPftNBcYyAWv0vtW05Jfq8WMqxrzqM8n43dMm3apl9+FHEy9Rk54cix56JCT913yyFtJW5/2xfZF3VOUI61ZL1KHzkALebG1naeyW33kXd3MucMboMSpbddqtU3/IU47mIz8NfxW2+wqutI93k0Jyd/azFI6Q786lTRnso6aPPi5hUQj/hG3nysM9O
X-Forefront-Antispam-Report: CIP:165.204.84.17;CTRY:US;LANG:en;SCL:1;SRV:;IPV:CAL;SFV:NSPM;H:SATLEXMB04.amd.com;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230025)(4636009)(39860400002)(346002)(396003)(376002)(136003)(451199018)(36840700001)(46966006)(40470700004)(40460700003)(36756003)(54906003)(478600001)(966005)(7696005)(5660300002)(316002)(2906002)(8936002)(70586007)(8676002)(70206006)(6916009)(4326008)(41300700001)(82740400003)(81166007)(36860700001)(40480700001)(356005)(86362001)(186003)(6666004)(16526019)(2616005)(1076003)(26005)(83380400001)(82310400005)(336012)(66574015)(426003)(47076005)(36900700001);DIR:OUT;SFP:1101;
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2023 11:01:37.6934
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 224dad10-30ef-479b-7bc6-08db208da79e
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=3dd8961f-e488-4e60-8e11-a82d994e183d;Ip=[165.204.84.17];Helo=[SATLEXMB04.amd.com]
X-MS-Exchange-CrossTenant-AuthSource: DS1PEPF0000E648.namprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR12MB7151
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 85e26dd5100a ("drm/client: fix circular reference counting issue")

We reference dump buffers both by their handle as well as their
object. The problem is now that when anybody iterates over the DRM
framebuffers and exports the underlying GEM objects through DMA-buf
we run into a circular reference count situation.

The result is that the fbdev handling holds the GEM handle preventing
the DMA-buf in the GEM object to be released. This DMA-buf in turn
holds a reference to the driver module which on unload would release
the fbdev.

Break that loop by releasing the handle as soon as the DRM
framebuffer object is created. The DRM framebuffer and the DRM client
buffer structure still hold a reference to the underlying GEM object
preventing its destruction.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: c76f0f7cb546 ("drm: Begin an API for in-kernel clients")
Cc: <stable@vger.kernel.org>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Tested-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230126102814.8722-1-christian.koenig@amd.com
---
 drivers/gpu/drm/drm_client.c | 32 ++++++++++++++++++++------------
 include/drm/drm_client.h     |  5 -----
 2 files changed, 20 insertions(+), 17 deletions(-)

diff --git a/drivers/gpu/drm/drm_client.c b/drivers/gpu/drm/drm_client.c
index 2b230b4d6942..3090b75257b3 100644
--- a/drivers/gpu/drm/drm_client.c
+++ b/drivers/gpu/drm/drm_client.c
@@ -233,21 +233,18 @@ void drm_client_dev_restore(struct drm_device *dev)
 
 static void drm_client_buffer_delete(struct drm_client_buffer *buffer)
 {
-	struct drm_device *dev = buffer->client->dev;
 
 	drm_gem_vunmap(buffer->gem, &buffer->map);
 
 	if (buffer->gem)
 		drm_gem_object_put(buffer->gem);
 
-	if (buffer->handle)
-		drm_mode_destroy_dumb(dev, buffer->handle, buffer->client->file);
-
 	kfree(buffer);
 }
 
 static struct drm_client_buffer *
-drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
+drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height,
+			 u32 format, u32 *handle)
 {
 	const struct drm_format_info *info = drm_format_info(format);
 	struct drm_mode_create_dumb dumb_args = { };
@@ -269,16 +266,15 @@ drm_client_buffer_create(struct drm_client_dev *client, u32 width, u32 height, u
 	if (ret)
 		goto err_delete;
 
-	buffer->handle = dumb_args.handle;
-	buffer->pitch = dumb_args.pitch;
-
 	obj = drm_gem_object_lookup(client->file, dumb_args.handle);
 	if (!obj)  {
 		ret = -ENOENT;
 		goto err_delete;
 	}
 
+	buffer->pitch = dumb_args.pitch;
 	buffer->gem = obj;
+	*handle = dumb_args.handle;
 
 	return buffer;
 
@@ -365,7 +361,8 @@ static void drm_client_buffer_rmfb(struct drm_client_buffer *buffer)
 }
 
 static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
-				   u32 width, u32 height, u32 format)
+				   u32 width, u32 height, u32 format,
+				   u32 handle)
 {
 	struct drm_client_dev *client = buffer->client;
 	struct drm_mode_fb_cmd fb_req = { };
@@ -377,7 +374,7 @@ static int drm_client_buffer_addfb(struct drm_client_buffer *buffer,
 	fb_req.depth = info->depth;
 	fb_req.width = width;
 	fb_req.height = height;
-	fb_req.handle = buffer->handle;
+	fb_req.handle = handle;
 	fb_req.pitch = buffer->pitch;
 
 	ret = drm_mode_addfb(client->dev, &fb_req, client->file);
@@ -414,13 +411,24 @@ struct drm_client_buffer *
 drm_client_framebuffer_create(struct drm_client_dev *client, u32 width, u32 height, u32 format)
 {
 	struct drm_client_buffer *buffer;
+	u32 handle;
 	int ret;
 
-	buffer = drm_client_buffer_create(client, width, height, format);
+	buffer = drm_client_buffer_create(client, width, height, format,
+					  &handle);
 	if (IS_ERR(buffer))
 		return buffer;
 
-	ret = drm_client_buffer_addfb(buffer, width, height, format);
+	ret = drm_client_buffer_addfb(buffer, width, height, format, handle);
+
+	/*
+	 * The handle is only needed for creating the framebuffer, destroy it
+	 * again to solve a circular dependency should anybody export the GEM
+	 * object as DMA-buf. The framebuffer and our buffer structure are still
+	 * holding references to the GEM object to prevent its destruction.
+	 */
+	drm_mode_destroy_dumb(client->dev, handle, client->file);
+
 	if (ret) {
 		drm_client_buffer_delete(buffer);
 		return ERR_PTR(ret);
diff --git a/include/drm/drm_client.h b/include/drm/drm_client.h
index 4fc8018eddda..1220d185c776 100644
--- a/include/drm/drm_client.h
+++ b/include/drm/drm_client.h
@@ -126,11 +126,6 @@ struct drm_client_buffer {
 	 */
 	struct drm_client_dev *client;
 
-	/**
-	 * @handle: Buffer handle
-	 */
-	u32 handle;
-
 	/**
 	 * @pitch: Buffer pitch
 	 */
-- 
2.32.0

