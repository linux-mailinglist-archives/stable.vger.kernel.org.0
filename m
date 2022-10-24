Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CA4960BA77
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 22:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234543AbiJXUh0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 16:37:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234331AbiJXUgi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 16:36:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417C6D2E2;
        Mon, 24 Oct 2022 11:48:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72600B81999;
        Mon, 24 Oct 2022 12:43:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BCDC433D6;
        Mon, 24 Oct 2022 12:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666615429;
        bh=nNKAQ3i0wiJd72HKsfnVhMi/xXXab3eMPr7Tq3CWO8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J4B37YgBn7f5EyMRNMwzyld/jhsfhCx0D4/JJzXGA0nXsLTh07TiCCSuswbsewvvA
         LrUItegzDRjkm9pzOQfj0bHVN7lXuWzncgx+x4J6JVwBa6EQiDtQBfpioEiXvVt6oc
         ehoEIx7i1QHxy8ajS07nz5niVLOW5bQsD+A7/Xa4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 230/530] drm/omap: dss: Fix refcount leak bugs
Date:   Mon, 24 Oct 2022 13:29:34 +0200
Message-Id: <20221024113055.498379556@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 8b42057e62120813ebe9274f508fa785b7cab33a ]

In dss_init_ports() and __dss_uninit_ports(), we should call
of_node_put() for the reference returned by of_graph_get_port_by_id()
in fail path or when it is not used anymore.

Fixes: 09bffa6e5192 ("drm: omap: use common OF graph helpers")
Signed-off-by: Liang He <windhl@126.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220722144348.1306569-1-windhl@126.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/omapdrm/dss/dss.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/omapdrm/dss/dss.c b/drivers/gpu/drm/omapdrm/dss/dss.c
index d6a5862b4dbf..7567e2265aa3 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1176,6 +1176,7 @@ static void __dss_uninit_ports(struct dss_device *dss, unsigned int num_ports)
 		default:
 			break;
 		}
+		of_node_put(port);
 	}
 }
 
@@ -1208,11 +1209,13 @@ static int dss_init_ports(struct dss_device *dss)
 		default:
 			break;
 		}
+		of_node_put(port);
 	}
 
 	return 0;
 
 error:
+	of_node_put(port);
 	__dss_uninit_ports(dss, i);
 	return r;
 }
-- 
2.35.1



