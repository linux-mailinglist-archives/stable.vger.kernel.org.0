Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78ED76D4A54
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbjDCOq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233979AbjDCOqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7178016943
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:45:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 57E63B81D4E
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:45:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96F5EC433AA;
        Mon,  3 Apr 2023 14:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533152;
        bh=2yk3mSoZsgl+ZpcSVkJPGjIYMWZ98Hz3bFfkME3RJqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTCfx+YvJsA/iZXsB9KIQO5CUy+qfkEwvulVH/Mo+rislgcNS4ej7oyIjDz1QIWpw
         /y51GxLNdeZxCVeGNUOriLZaCgCUtdXVIIRxrQyYxRitkfMncEG+gi07FOqUSrriCV
         MgaQZdajvca46SQiXlcpO4b0hey1kB0Ti581GJvw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Pearson <mpearson-lenovo@squebb.ca>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 074/187] platform/x86: think-lmi: Add possible_values for ThinkStation
Date:   Mon,  3 Apr 2023 16:08:39 +0200
Message-Id: <20230403140418.381403503@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <mpearson-lenovo@squebb.ca>

[ Upstream commit 8a02d70679fc1c434401863333c8ea7dbf201494 ]

ThinkStation platforms don't support the API to return possible_values
but instead embed it in the settings string.

Try and extract this information and set the possible_values attribute
appropriately.

Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
Signed-off-by: Mark Pearson <mpearson-lenovo@squebb.ca>
Link: https://lore.kernel.org/r/20230320003221.561750-4-mpearson-lenovo@squebb.ca
Reviewed-by: Thomas Weißschuh <linux@weissschuh.net>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/think-lmi.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/think-lmi.c
index ccd085bacf298..74af3e593b2ca 100644
--- a/drivers/platform/x86/think-lmi.c
+++ b/drivers/platform/x86/think-lmi.c
@@ -1450,6 +1450,26 @@ static int tlmi_analyze(void)
 			if (ret || !setting->possible_values)
 				pr_info("Error retrieving possible values for %d : %s\n",
 						i, setting->display_name);
+		} else {
+			/*
+			 * Older Thinkstations don't support the bios_selections API.
+			 * Instead they store this as a [Optional:Option1,Option2] section of the
+			 * name string.
+			 * Try and pull that out if it's available.
+			 */
+			char *item, *optstart, *optend;
+
+			if (!tlmi_setting(setting->index, &item, LENOVO_BIOS_SETTING_GUID)) {
+				optstart = strstr(item, "[Optional:");
+				if (optstart) {
+					optstart += strlen("[Optional:");
+					optend = strstr(optstart, "]");
+					if (optend)
+						setting->possible_values =
+							kstrndup(optstart, optend - optstart,
+									GFP_KERNEL);
+				}
+			}
 		}
 		/*
 		 * firmware-attributes requires that possible_values are separated by ';' but
-- 
2.39.2



