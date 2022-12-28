Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278D665836D
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:47:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235086AbiL1Qrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:47:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234081AbiL1QrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC3BCF9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:42:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47A2EB817AC
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:42:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD75C433D2;
        Wed, 28 Dec 2022 16:42:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245736;
        bh=aDWG8fbGBA74watHfo590CXtwV6HBAc+NsS3rF7zHhI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1+UO/Z/KZqngOe9fR7iEZFPNeBPtKxyiEWz0bqfev27/lYyQU3nnusjIqysxhCryx
         bhWl0J//SQkdV5tFtmhA+3fcyNlHhkvHM+ZBMHcpXjEgTA/mdyp3PhPvOabJ0PsU4f
         wuCoAOa4j9VvhcwsDXHsvrUTBznvfqNzCt+6iuyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hannes Reinecke <hare@suse.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0946/1073] nvme-auth: dont override ctrl keys before validation
Date:   Wed, 28 Dec 2022 15:42:14 +0100
Message-Id: <20221228144353.733225720@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 01604350e14560d4d69323eb1ba12a257a643ea8 ]

Replace ctrl ctrl_key/host_key only after nvme_auth_generate_key is successful.
Also, this fixes a bug where the keys are leaked.

Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index cd2e2bfeae82..3582a28a1dce 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3739,13 +3739,17 @@ static ssize_t nvme_ctrl_dhchap_secret_store(struct device *dev,
 	memcpy(dhchap_secret, buf, count);
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_secret)) {
+		struct nvme_dhchap_key *key, *host_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->host_key);
+		ret = nvme_auth_generate_key(dhchap_secret, &key);
 		if (ret)
 			return ret;
 		kfree(opts->dhchap_secret);
 		opts->dhchap_secret = dhchap_secret;
+		host_key = ctrl->host_key;
+		ctrl->host_key = key;
+		nvme_auth_free_key(host_key);
 		/* Key has changed; re-authentication with new key */
 		nvme_auth_reset(ctrl);
 	}
@@ -3789,13 +3793,17 @@ static ssize_t nvme_ctrl_dhchap_ctrl_secret_store(struct device *dev,
 	memcpy(dhchap_secret, buf, count);
 	nvme_auth_stop(ctrl);
 	if (strcmp(dhchap_secret, opts->dhchap_ctrl_secret)) {
+		struct nvme_dhchap_key *key, *ctrl_key;
 		int ret;
 
-		ret = nvme_auth_generate_key(dhchap_secret, &ctrl->ctrl_key);
+		ret = nvme_auth_generate_key(dhchap_secret, &key);
 		if (ret)
 			return ret;
 		kfree(opts->dhchap_ctrl_secret);
 		opts->dhchap_ctrl_secret = dhchap_secret;
+		ctrl_key = ctrl->ctrl_key;
+		ctrl->ctrl_key = key;
+		nvme_auth_free_key(ctrl_key);
 		/* Key has changed; re-authentication with new key */
 		nvme_auth_reset(ctrl);
 	}
-- 
2.35.1



