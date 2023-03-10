Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9912D6B4AF4
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:28:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234220AbjCJP22 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:28:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234283AbjCJP2K (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:28:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC7F141616
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:16:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B9636193B
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D86C433D2;
        Fri, 10 Mar 2023 15:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678461359;
        bh=0YA7I1Bl4aBpowJL/ulkZt65Xth+uqNe/Ru3S4OPupo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YraPzrNUn+faW6BX7iLbon/sQ0tW4YiRngM1jNJAaW4qJp4eTp/XJlCYgjNxfDaKr
         bzQ2aVa3oIVHqqD5Qdb08qAWhJ4HWGIWeTjosp0HXX23cuIYuEvGKxYM9xG4LNI+oI
         l3llq58eqKbgAOqEaaBOmj+iVm/M+k3ujNbc4bCw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Daniel Scally <dan.scally@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 111/136] usb: gadget: uvc: Make bSourceID read/write
Date:   Fri, 10 Mar 2023 14:43:53 +0100
Message-Id: <20230310133710.536582294@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133706.811226272@linuxfoundation.org>
References: <20230310133706.811226272@linuxfoundation.org>
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

From: Daniel Scally <dan.scally@ideasonboard.com>

[ Upstream commit b3c839bd8a07d303bc59a900d55dd35c7826562c ]

At the moment, the UVC function graph is hardcoded IT -> PU -> OT.
To add XU support we need the ability to insert the XU descriptors
into the chain. To facilitate that, make the output terminal's
bSourceID attribute writeable so that we can configure its source.

Signed-off-by: Daniel Scally <dan.scally@ideasonboard.com>
Link: https://lore.kernel.org/r/20230206161802.892954-2-dan.scally@ideasonboard.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ABI/testing/configfs-usb-gadget-uvc       |  2 +-
 drivers/usb/gadget/function/uvc_configfs.c    | 59 ++++++++++++++++++-
 2 files changed, 59 insertions(+), 2 deletions(-)

diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Documentation/ABI/testing/configfs-usb-gadget-uvc
index 889ed45be4ca6..2d5a5913b5f28 100644
--- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
+++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
@@ -51,7 +51,7 @@ Date:		Dec 2014
 KernelVersion:	4.0
 Description:	Default output terminal descriptors
 
-		All attributes read only:
+		All attributes read only except bSourceID:
 
 		==============	=============================================
 		iTerminal	index of string descriptor
diff --git a/drivers/usb/gadget/function/uvc_configfs.c b/drivers/usb/gadget/function/uvc_configfs.c
index 77d64031aa9c2..9a285592a947c 100644
--- a/drivers/usb/gadget/function/uvc_configfs.c
+++ b/drivers/usb/gadget/function/uvc_configfs.c
@@ -505,11 +505,68 @@ UVC_ATTR_RO(uvcg_default_output_, cname, aname)
 UVCG_DEFAULT_OUTPUT_ATTR(b_terminal_id, bTerminalID, 8);
 UVCG_DEFAULT_OUTPUT_ATTR(w_terminal_type, wTerminalType, 16);
 UVCG_DEFAULT_OUTPUT_ATTR(b_assoc_terminal, bAssocTerminal, 8);
-UVCG_DEFAULT_OUTPUT_ATTR(b_source_id, bSourceID, 8);
 UVCG_DEFAULT_OUTPUT_ATTR(i_terminal, iTerminal, 8);
 
 #undef UVCG_DEFAULT_OUTPUT_ATTR
 
+static ssize_t uvcg_default_output_b_source_id_show(struct config_item *item,
+						    char *page)
+{
+	struct config_group *group = to_config_group(item);
+	struct f_uvc_opts *opts;
+	struct config_item *opts_item;
+	struct mutex *su_mutex = &group->cg_subsys->su_mutex;
+	struct uvc_output_terminal_descriptor *cd;
+	int result;
+
+	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
+
+	opts_item = group->cg_item.ci_parent->ci_parent->
+			ci_parent->ci_parent;
+	opts = to_f_uvc_opts(opts_item);
+	cd = &opts->uvc_output_terminal;
+
+	mutex_lock(&opts->lock);
+	result = sprintf(page, "%u\n", le8_to_cpu(cd->bSourceID));
+	mutex_unlock(&opts->lock);
+
+	mutex_unlock(su_mutex);
+
+	return result;
+}
+
+static ssize_t uvcg_default_output_b_source_id_store(struct config_item *item,
+						     const char *page, size_t len)
+{
+	struct config_group *group = to_config_group(item);
+	struct f_uvc_opts *opts;
+	struct config_item *opts_item;
+	struct mutex *su_mutex = &group->cg_subsys->su_mutex;
+	struct uvc_output_terminal_descriptor *cd;
+	int result;
+	u8 num;
+
+	mutex_lock(su_mutex); /* for navigating configfs hierarchy */
+
+	opts_item = group->cg_item.ci_parent->ci_parent->
+			ci_parent->ci_parent;
+	opts = to_f_uvc_opts(opts_item);
+	cd = &opts->uvc_output_terminal;
+
+	result = kstrtou8(page, 0, &num);
+	if (result)
+		return result;
+
+	mutex_lock(&opts->lock);
+	cd->bSourceID = num;
+	mutex_unlock(&opts->lock);
+
+	mutex_unlock(su_mutex);
+
+	return len;
+}
+UVC_ATTR(uvcg_default_output_, b_source_id, bSourceID);
+
 static struct configfs_attribute *uvcg_default_output_attrs[] = {
 	&uvcg_default_output_attr_b_terminal_id,
 	&uvcg_default_output_attr_w_terminal_type,
-- 
2.39.2



