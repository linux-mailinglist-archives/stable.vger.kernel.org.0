Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBB065D80C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239858AbjADQKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:10:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239930AbjADQJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:09:59 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 125A03D9D7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:09:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B5EF4B8172C
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4B8C433EF;
        Wed,  4 Jan 2023 16:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672848581;
        bh=bw7FXJhJLfBMHxzwbkYQcEZPEKwDcmUR3+5lOLW33kM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuybQkgdkEv/H1pfeWTLUiMIfr/4UiUnl7n5iZHHFccEfWw2W1N70FfENBZ7nh0v7
         Uu8O18Or9PP/brlqEAFV/GJ+zTq+GubVTltPukQIyvzInAzdJkupfWnYaLWI6arHbq
         P6YswtzFcRadKB4R97KkDKTk/68RPIwE4IwMRh/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yazen Ghannam <yazen.ghannam@amd.com>,
        Borislav Petkov <bp@suse.de>
Subject: [PATCH 6.1 029/207] EDAC/mc_sysfs: Increase legacy channel support to 12
Date:   Wed,  4 Jan 2023 17:04:47 +0100
Message-Id: <20230104160512.842203436@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
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

From: Yazen Ghannam <yazen.ghannam@amd.com>

commit 25836ce1df827cb4830291cb2325067efb46753a upstream.

Newer AMD systems, such as Genoa, can support up to 12 channels per EDAC
"mc" device. These are detected by the device's EDAC module, and the
current EDAC interface is properly enumerated. However, the legacy EDAC
sysfs interface provides device attributes only for channels 0 to 7.
Therefore, channels 8 to 11 will not be visible in the legacy interface.
This was overlooked in the initial support for AMD Genoa.

Add additional device attributes so that up to 12 channels are visible
in the legacy EDAC sysfs interface.

Fixes: e2be5955a886 ("EDAC/amd64: Add support for AMD Family 19h Models 10h-1Fh and A0h-AFh")
Signed-off-by: Yazen Ghannam <yazen.ghannam@amd.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20221018153630.14664-1-yazen.ghannam@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/edac_mc_sysfs.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -298,6 +298,14 @@ DEVICE_CHANNEL(ch6_dimm_label, S_IRUGO |
 	channel_dimm_label_show, channel_dimm_label_store, 6);
 DEVICE_CHANNEL(ch7_dimm_label, S_IRUGO | S_IWUSR,
 	channel_dimm_label_show, channel_dimm_label_store, 7);
+DEVICE_CHANNEL(ch8_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 8);
+DEVICE_CHANNEL(ch9_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 9);
+DEVICE_CHANNEL(ch10_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 10);
+DEVICE_CHANNEL(ch11_dimm_label, S_IRUGO | S_IWUSR,
+	channel_dimm_label_show, channel_dimm_label_store, 11);
 
 /* Total possible dynamic DIMM Label attribute file table */
 static struct attribute *dynamic_csrow_dimm_attr[] = {
@@ -309,6 +317,10 @@ static struct attribute *dynamic_csrow_d
 	&dev_attr_legacy_ch5_dimm_label.attr.attr,
 	&dev_attr_legacy_ch6_dimm_label.attr.attr,
 	&dev_attr_legacy_ch7_dimm_label.attr.attr,
+	&dev_attr_legacy_ch8_dimm_label.attr.attr,
+	&dev_attr_legacy_ch9_dimm_label.attr.attr,
+	&dev_attr_legacy_ch10_dimm_label.attr.attr,
+	&dev_attr_legacy_ch11_dimm_label.attr.attr,
 	NULL
 };
 
@@ -329,6 +341,14 @@ DEVICE_CHANNEL(ch6_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 6);
 DEVICE_CHANNEL(ch7_ce_count, S_IRUGO,
 		   channel_ce_count_show, NULL, 7);
+DEVICE_CHANNEL(ch8_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 8);
+DEVICE_CHANNEL(ch9_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 9);
+DEVICE_CHANNEL(ch10_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 10);
+DEVICE_CHANNEL(ch11_ce_count, S_IRUGO,
+		   channel_ce_count_show, NULL, 11);
 
 /* Total possible dynamic ce_count attribute file table */
 static struct attribute *dynamic_csrow_ce_count_attr[] = {
@@ -340,6 +360,10 @@ static struct attribute *dynamic_csrow_c
 	&dev_attr_legacy_ch5_ce_count.attr.attr,
 	&dev_attr_legacy_ch6_ce_count.attr.attr,
 	&dev_attr_legacy_ch7_ce_count.attr.attr,
+	&dev_attr_legacy_ch8_ce_count.attr.attr,
+	&dev_attr_legacy_ch9_ce_count.attr.attr,
+	&dev_attr_legacy_ch10_ce_count.attr.attr,
+	&dev_attr_legacy_ch11_ce_count.attr.attr,
 	NULL
 };
 


