Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2906A6DEFAE
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231402AbjDLIxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbjDLIw7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:52:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32CD7AB5
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:52:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06B476319C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:51:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19581C433D2;
        Wed, 12 Apr 2023 08:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289514;
        bh=H1qmMxjG+fUZjN1Cp4bxsMl1HtKmBvjX7IbzJvHyxWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JMrIuzo/W3NuxlwtFJy74TJMIXiE6f5kRxGQL0QxPp2SAQQCs1WEnh5Zmvou3bJFz
         n/KZ0C267+u7ZEUCp73kiQ74ROGC2KshR54XNWB+d4q9osWedDvFo/M0Q9VPg8daQ/
         3jmGteoBMmadFd6TtIcdcyeSLEuMS0Sf5IKZBLdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>,
        Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.2 129/173] ASoC: SOF: avoid a NULL dereference with unsupported widgets
Date:   Wed, 12 Apr 2023 10:34:15 +0200
Message-Id: <20230412082843.361858470@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>

commit e3720f92e0237921da537e47a0b24e27899203f8 upstream.

If an IPC4 topology contains an unsupported widget, its .module_info
field won't be set, then sof_ipc4_route_setup() will cause a kernel
Oops trying to dereference it. Add a check for such cases.

Cc: stable@vger.kernel.org # 6.2
Signed-off-by: Guennadi Liakhovetski <guennadi.liakhovetski@linux.intel.com>
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://lore.kernel.org/r/20230329113828.28562-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/sof/ipc4-topology.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/sound/soc/sof/ipc4-topology.c
+++ b/sound/soc/sof/ipc4-topology.c
@@ -1686,6 +1686,14 @@ static int sof_ipc4_route_setup(struct s
 	u32 header, extension;
 	int ret;
 
+	if (!src_fw_module || !sink_fw_module) {
+		/* The NULL module will print as "(efault)" */
+		dev_err(sdev->dev, "source %s or sink %s widget weren't set up properly\n",
+			src_fw_module->man4_module_entry.name,
+			sink_fw_module->man4_module_entry.name);
+		return -ENODEV;
+	}
+
 	sroute->src_queue_id = sof_ipc4_get_queue_id(src_widget, sink_widget,
 						     SOF_PIN_TYPE_SOURCE);
 	if (sroute->src_queue_id < 0) {


