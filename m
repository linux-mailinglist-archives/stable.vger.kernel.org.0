Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC34954151A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:28:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359483AbiFGU2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:28:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359664AbiFGUZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:25:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2A1F1D6864;
        Tue,  7 Jun 2022 11:32:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F5C3612E9;
        Tue,  7 Jun 2022 18:32:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B231C341C4;
        Tue,  7 Jun 2022 18:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626743;
        bh=/SXHeppL4FHWK2iK+Q7roRMlKdDXea05upheVTxrlhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mMWlDCd+uQwU5Yk+AvSV+zYDcddeBNR4ZS6Tiww6TwNAk6uljobPGW4Spc2PyCAyR
         tKAS55XHs2fu+DbgJ5a27rL0PYgvvCwzZNePUxH09wgj53znF/aeNiaFi8m6LwdZzV
         wi2RcguFpJ38dxQKicCI6THZPx3iyvcKtqrGa8cc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daisuke Nojiri <dnojiri@chromium.org>,
        Rob Barnes <robbarnes@google.com>,
        Rajat Jain <rajatja@google.com>,
        Brian Norris <briannorris@chromium.org>,
        Parth Malkan <parthmalkan@google.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Tzung-Bi Shih <tzungbi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 471/772] platform/chrome: Re-introduce cros_ec_cmd_xfer and use it for ioctls
Date:   Tue,  7 Jun 2022 19:01:03 +0200
Message-Id: <20220607165002.876040134@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 57b888ca2541785de2fcb90575b378921919b6c0 ]

Commit 413dda8f2c6f ("platform/chrome: cros_ec_chardev: Use
cros_ec_cmd_xfer_status helper") inadvertendly changed the userspace ABI.
Previously, cros_ec ioctls would only report errors if the EC communication
failed, and otherwise return success and the result of the EC
communication. An EC command execution failure was reported in the EC
response field. The above mentioned commit changed this behavior, and the
ioctl itself would fail. This breaks userspace commands trying to analyze
the EC command execution error since the actual EC command response is no
longer reported to userspace.

Fix the problem by re-introducing the cros_ec_cmd_xfer() helper, and use it
to handle ioctl messages.

Fixes: 413dda8f2c6f ("platform/chrome: cros_ec_chardev: Use cros_ec_cmd_xfer_status helper")
Cc: Daisuke Nojiri <dnojiri@chromium.org>
Cc: Rob Barnes <robbarnes@google.com>
Cc: Rajat Jain <rajatja@google.com>
Cc: Brian Norris <briannorris@chromium.org>
Cc: Parth Malkan <parthmalkan@google.com>
Reviewed-by: Daisuke Nojiri <dnojiri@chromium.org>
Reviewed-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/cros_ec_chardev.c   |  2 +-
 drivers/platform/chrome/cros_ec_proto.c     | 50 +++++++++++++++++----
 include/linux/platform_data/cros_ec_proto.h |  3 ++
 3 files changed, 45 insertions(+), 10 deletions(-)

diff --git a/drivers/platform/chrome/cros_ec_chardev.c b/drivers/platform/chrome/cros_ec_chardev.c
index e0bce869c49a..fd33de546aee 100644
--- a/drivers/platform/chrome/cros_ec_chardev.c
+++ b/drivers/platform/chrome/cros_ec_chardev.c
@@ -301,7 +301,7 @@ static long cros_ec_chardev_ioctl_xcmd(struct cros_ec_dev *ec, void __user *arg)
 	}
 
 	s_cmd->command += ec->cmd_offset;
-	ret = cros_ec_cmd_xfer_status(ec->ec_dev, s_cmd);
+	ret = cros_ec_cmd_xfer(ec->ec_dev, s_cmd);
 	/* Only copy data to userland if data was received. */
 	if (ret < 0)
 		goto exit;
diff --git a/drivers/platform/chrome/cros_ec_proto.c b/drivers/platform/chrome/cros_ec_proto.c
index c4caf2e2de82..ac1419881ff3 100644
--- a/drivers/platform/chrome/cros_ec_proto.c
+++ b/drivers/platform/chrome/cros_ec_proto.c
@@ -560,22 +560,28 @@ int cros_ec_query_all(struct cros_ec_device *ec_dev)
 EXPORT_SYMBOL(cros_ec_query_all);
 
 /**
- * cros_ec_cmd_xfer_status() - Send a command to the ChromeOS EC.
+ * cros_ec_cmd_xfer() - Send a command to the ChromeOS EC.
  * @ec_dev: EC device.
  * @msg: Message to write.
  *
- * Call this to send a command to the ChromeOS EC. This should be used instead of calling the EC's
- * cmd_xfer() callback directly. It returns success status only if both the command was transmitted
- * successfully and the EC replied with success status.
+ * Call this to send a command to the ChromeOS EC. This should be used instead
+ * of calling the EC's cmd_xfer() callback directly. This function does not
+ * convert EC command execution error codes to Linux error codes. Most
+ * in-kernel users will want to use cros_ec_cmd_xfer_status() instead since
+ * that function implements the conversion.
  *
  * Return:
- * >=0 - The number of bytes transferred
- * <0 - Linux error code
+ * >0 - EC command was executed successfully. The return value is the number
+ *      of bytes returned by the EC (excluding the header).
+ * =0 - EC communication was successful. EC command execution results are
+ *      reported in msg->result. The result will be EC_RES_SUCCESS if the
+ *      command was executed successfully or report an EC command execution
+ *      error.
+ * <0 - EC communication error. Return value is the Linux error code.
  */
-int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
-			    struct cros_ec_command *msg)
+int cros_ec_cmd_xfer(struct cros_ec_device *ec_dev, struct cros_ec_command *msg)
 {
-	int ret, mapped;
+	int ret;
 
 	mutex_lock(&ec_dev->lock);
 	if (ec_dev->proto_version == EC_PROTO_VERSION_UNKNOWN) {
@@ -616,6 +622,32 @@ int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
 	ret = send_command(ec_dev, msg);
 	mutex_unlock(&ec_dev->lock);
 
+	return ret;
+}
+EXPORT_SYMBOL(cros_ec_cmd_xfer);
+
+/**
+ * cros_ec_cmd_xfer_status() - Send a command to the ChromeOS EC.
+ * @ec_dev: EC device.
+ * @msg: Message to write.
+ *
+ * Call this to send a command to the ChromeOS EC. This should be used instead of calling the EC's
+ * cmd_xfer() callback directly. It returns success status only if both the command was transmitted
+ * successfully and the EC replied with success status.
+ *
+ * Return:
+ * >=0 - The number of bytes transferred.
+ * <0 - Linux error code
+ */
+int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
+			    struct cros_ec_command *msg)
+{
+	int ret, mapped;
+
+	ret = cros_ec_cmd_xfer(ec_dev, msg);
+	if (ret < 0)
+		return ret;
+
 	mapped = cros_ec_map_error(msg->result);
 	if (mapped) {
 		dev_dbg(ec_dev->dev, "Command result (err: %d [%d])\n",
diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
index df3c78c92ca2..16931569adce 100644
--- a/include/linux/platform_data/cros_ec_proto.h
+++ b/include/linux/platform_data/cros_ec_proto.h
@@ -216,6 +216,9 @@ int cros_ec_prepare_tx(struct cros_ec_device *ec_dev,
 int cros_ec_check_result(struct cros_ec_device *ec_dev,
 			 struct cros_ec_command *msg);
 
+int cros_ec_cmd_xfer(struct cros_ec_device *ec_dev,
+		     struct cros_ec_command *msg);
+
 int cros_ec_cmd_xfer_status(struct cros_ec_device *ec_dev,
 			    struct cros_ec_command *msg);
 
-- 
2.35.1



