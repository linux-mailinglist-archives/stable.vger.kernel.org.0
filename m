Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 138326B4760
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:50:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232946AbjCJOuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233050AbjCJOs6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:48:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF15C20568
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:47:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E6EEB822DE
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:47:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3DB2C433A4;
        Fri, 10 Mar 2023 14:47:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459659;
        bh=ZLiJnHjlLIZSOIMAJZqAW4NoMMwoJahbJugPoUf7trI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Cv18Us1A7zTN3oNX1jF//AruEcR8Kg5NlNg4QgOi3WBCIC6cSwNl4RCh6WvEsjl9V
         4jM3tR2+eZpOIJER3WCIa909Lxzc5feIYbV+VyU1MWUM/L4UJeCmmgc4a86fB2m4gB
         u2f6E6bExF6XJpCsMFUloI4mE7Tmx1ADUM0Lw+s0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sean Christopherson <seanjc@google.com>,
        Brijesh Singh <brijesh.singh@amd.com>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/529] crypto: ccp: Use the stack and common buffer for status commands
Date:   Fri, 10 Mar 2023 14:33:40 +0100
Message-Id: <20230310133808.545360240@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit 38103671aad38e888743dd26c767869cfc15adca ]

Drop the dedicated status_cmd_buf and instead use a local variable for
PLATFORM_STATUS.  Now that the low level helper uses an internal buffer
for all commands, using the stack for the upper layers is safe even when
running with CONFIG_VMAP_STACK=y.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20210406224952.4177376-7-seanjc@google.com>
Reviewed-by: Brijesh Singh <brijesh.singh@amd.com>
Acked-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: 91dfd98216d8 ("crypto: ccp - Avoid page allocation failure warning for SEV_GET_ID2")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/sev-dev.c | 27 ++++++++++++---------------
 drivers/crypto/ccp/sev-dev.h |  1 -
 2 files changed, 12 insertions(+), 16 deletions(-)

diff --git a/drivers/crypto/ccp/sev-dev.c b/drivers/crypto/ccp/sev-dev.c
index 75341ad2fdd8a..1aac3a12a6c7c 100644
--- a/drivers/crypto/ccp/sev-dev.c
+++ b/drivers/crypto/ccp/sev-dev.c
@@ -304,15 +304,14 @@ static int sev_platform_shutdown(int *error)
 
 static int sev_get_platform_state(int *state, int *error)
 {
-	struct sev_device *sev = psp_master->sev_data;
+	struct sev_user_data_status data;
 	int rc;
 
-	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS,
-				 &sev->status_cmd_buf, error);
+	rc = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, error);
 	if (rc)
 		return rc;
 
-	*state = sev->status_cmd_buf.state;
+	*state = data.state;
 	return rc;
 }
 
@@ -350,15 +349,14 @@ static int sev_ioctl_do_reset(struct sev_issue_cmd *argp, bool writable)
 
 static int sev_ioctl_do_platform_status(struct sev_issue_cmd *argp)
 {
-	struct sev_device *sev = psp_master->sev_data;
-	struct sev_user_data_status *data = &sev->status_cmd_buf;
+	struct sev_user_data_status data;
 	int ret;
 
-	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, data, &argp->error);
+	ret = __sev_do_cmd_locked(SEV_CMD_PLATFORM_STATUS, &data, &argp->error);
 	if (ret)
 		return ret;
 
-	if (copy_to_user((void __user *)argp->data, data, sizeof(*data)))
+	if (copy_to_user((void __user *)argp->data, &data, sizeof(data)))
 		ret = -EFAULT;
 
 	return ret;
@@ -457,21 +455,20 @@ EXPORT_SYMBOL_GPL(psp_copy_user_blob);
 static int sev_get_api_version(void)
 {
 	struct sev_device *sev = psp_master->sev_data;
-	struct sev_user_data_status *status;
+	struct sev_user_data_status status;
 	int error = 0, ret;
 
-	status = &sev->status_cmd_buf;
-	ret = sev_platform_status(status, &error);
+	ret = sev_platform_status(&status, &error);
 	if (ret) {
 		dev_err(sev->dev,
 			"SEV: failed to get status. Error: %#x\n", error);
 		return 1;
 	}
 
-	sev->api_major = status->api_major;
-	sev->api_minor = status->api_minor;
-	sev->build = status->build;
-	sev->state = status->state;
+	sev->api_major = status.api_major;
+	sev->api_minor = status.api_minor;
+	sev->build = status.build;
+	sev->state = status.state;
 
 	return 0;
 }
diff --git a/drivers/crypto/ccp/sev-dev.h b/drivers/crypto/ccp/sev-dev.h
index dd5c4fe82914c..3b0cd0f854df9 100644
--- a/drivers/crypto/ccp/sev-dev.h
+++ b/drivers/crypto/ccp/sev-dev.h
@@ -46,7 +46,6 @@ struct sev_device {
 	unsigned int int_rcvd;
 	wait_queue_head_t int_queue;
 	struct sev_misc_dev *misc;
-	struct sev_user_data_status status_cmd_buf;
 	struct sev_data_init init_cmd_buf;
 
 	u8 api_major;
-- 
2.39.2



