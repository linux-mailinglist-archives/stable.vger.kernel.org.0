Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0ECC5AB0DB
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 15:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238352AbiIBM7n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:59:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238639AbiIBM7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:59:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 917B7C7B9E;
        Fri,  2 Sep 2022 05:40:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B8295B82AC7;
        Fri,  2 Sep 2022 12:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EFFC433D6;
        Fri,  2 Sep 2022 12:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121918;
        bh=/GzZFNJ4zbZE3yw3cxjtkbCmRfMDh5qUScV5IZLRNnw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2nT1A7IpGpyIyGUM9BhO5wZK5UAiAsZJ/kQCn6ViCSCtihCC6jBcdp8N8Hs+YPGsn
         KQWZhYLeTFKUvapXBwVZ+/CSyst33TP34LT8v+bE7AoiCVDCX7xx1ae0bdA5vhh/KT
         8970r1P6BLgDrYmddRdTQSm/CVKvPLlwguXXepRo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Timo Alho <talho@nvidia.com>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Jon Hunter <jonathanh@nvidia.com>
Subject: [PATCH 5.15 06/73] firmware: tegra: bpmp: Do only aligned access to IPC memory area
Date:   Fri,  2 Sep 2022 14:18:30 +0200
Message-Id: <20220902121404.657506377@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Alho <talho@nvidia.com>

commit a4740b148a04dc60e14fe6a1dfe216d3bae214fd upstream.

Use memcpy_toio and memcpy_fromio variants of memcpy to guarantee no
unaligned access to IPC memory area. This is to allow the IPC memory to
be mapped as Device memory to further suppress speculative reads from
happening within the 64 kB memory area above the IPC memory when 64 kB
memory pages are used.

Signed-off-by: Timo Alho <talho@nvidia.com>
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Cc: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/tegra/bpmp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/firmware/tegra/bpmp.c
+++ b/drivers/firmware/tegra/bpmp.c
@@ -201,7 +201,7 @@ static ssize_t __tegra_bpmp_channel_read
 	int err;
 
 	if (data && size > 0)
-		memcpy(data, channel->ib->data, size);
+		memcpy_fromio(data, channel->ib->data, size);
 
 	err = tegra_bpmp_ack_response(channel);
 	if (err < 0)
@@ -245,7 +245,7 @@ static ssize_t __tegra_bpmp_channel_writ
 	channel->ob->flags = flags;
 
 	if (data && size > 0)
-		memcpy(channel->ob->data, data, size);
+		memcpy_toio(channel->ob->data, data, size);
 
 	return tegra_bpmp_post_request(channel);
 }
@@ -420,7 +420,7 @@ void tegra_bpmp_mrq_return(struct tegra_
 	channel->ob->code = code;
 
 	if (data && size > 0)
-		memcpy(channel->ob->data, data, size);
+		memcpy_toio(channel->ob->data, data, size);
 
 	err = tegra_bpmp_post_response(channel);
 	if (WARN_ON(err < 0))


