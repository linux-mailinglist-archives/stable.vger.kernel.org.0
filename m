Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310E3531845
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:53:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241982AbiEWRoi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:44:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241743AbiEWRf4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:35:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADEF87A0F;
        Mon, 23 May 2022 10:29:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3AFAF61194;
        Mon, 23 May 2022 17:28:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42406C385A9;
        Mon, 23 May 2022 17:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326912;
        bh=wkVrRs3ZmXWibR3yswrRvgW92+HWI718OMiomhJwUwg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DBLiRQRGPlY1bTnUJNf3mptOGBGNjHk5/ECadAhAr6nMetD1+syA251B+7InjDk76
         gaK+3qZgcQJ4/Wp0sfd8KzEnYTXsrS0hNZ3hcfwID8cL8KI/ji65Ppo5C08bnC1Njr
         B5SliDu4C9ZTwPpFZQ4pRD3+8435+KQxczZt1BcM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangyu Hua <hbh25y@gmail.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.17 065/158] drm/dp/mst: fix a possible memory leak in fetch_monitor_name()
Date:   Mon, 23 May 2022 19:03:42 +0200
Message-Id: <20220523165841.635430513@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
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
@@ -4852,6 +4852,7 @@ static void fetch_monitor_name(struct dr
 
 	mst_edid = drm_dp_mst_get_edid(port->connector, mgr, port);
 	drm_edid_get_monitor_name(mst_edid, name, namelen);
+	kfree(mst_edid);
 }
 
 /**


