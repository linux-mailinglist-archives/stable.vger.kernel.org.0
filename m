Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B881531607
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241396AbiEWRdR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241116AbiEWR0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:26:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E459B5AA4B;
        Mon, 23 May 2022 10:21:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 52F4360916;
        Mon, 23 May 2022 17:19:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1C4C385A9;
        Mon, 23 May 2022 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326364;
        bh=1YPWRqiatRImRhuaqwicVnhVovt5RkXaCgB9gKfRFLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjR0IFPTYdmnrfwYQ0QwA4HEAQOleWK0Hw2dp87gW1hoDXjfwYH0Cyiyb6gfmo7nn
         2VVllR5912yJTe7yzV5egarwXQEl0HQ29J+gxKBOYoAvvTkUj/7MFnWe3c/XB1tp1g
         MKOzwk+AL1M2X84qpVzrj4kXbdlB2is6apAlyQQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.15 059/132] drm/dp/mst: fix a possible memory leak in fetch_monitor_name()
Date:   Mon, 23 May 2022 19:04:28 +0200
Message-Id: <20220523165833.061532981@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
References: <20220523165823.492309987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangyu Hua <hbh25y@gmail.com>

commit 6e03b13cc7d9427c2c77feed1549191015615202 upstream.

drm_dp_mst_get_edid call kmemdup to create mst_edid. So mst_edid need to be
freed after use.

Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Cc: stable@vger.kernel.org
Link: https://patchwork.freedesktop.org/patch/msgid/20220516032042.13166-1-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4834,6 +4834,7 @@ static void fetch_monitor_name(struct dr
 
 	mst_edid = drm_dp_mst_get_edid(port->connector, mgr, port);
 	drm_edid_get_monitor_name(mst_edid, name, namelen);
+	kfree(mst_edid);
 }
 
 /**


