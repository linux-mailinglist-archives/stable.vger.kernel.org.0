Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0C3C60A753
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:49:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234495AbiJXMs6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234592AbiJXMpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326F62250F;
        Mon, 24 Oct 2022 05:09:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 835A4612C3;
        Mon, 24 Oct 2022 12:08:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95B8CC433D6;
        Mon, 24 Oct 2022 12:08:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613334;
        bh=o4w8XgtE59JzAVRdbtF4cnGcQAvWAo4f2hVevgR+zp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AlyP9nE0u2smyncLW5EOlZvWM7LzGoiIHIySRnezLdcE1ok2qCGs7N9N0tIXyK4gC
         8tWJpHa2+ujGz5v1sLgQ8GM4YJhzC1sEQobhVb2MSn1Lrqv612gYyIuXqJXjhVkWvm
         KSYycvb8dy55mZJbNLspUpmaqQyFcDWI7LPZkXb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/255] drm/omap: dss: Fix refcount leak bugs
Date:   Mon, 24 Oct 2022 13:30:08 +0200
Message-Id: <20221024113005.744434614@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
index ac93dae2a9c8..7f1d0a9afafb 100644
--- a/drivers/gpu/drm/omapdrm/dss/dss.c
+++ b/drivers/gpu/drm/omapdrm/dss/dss.c
@@ -1173,6 +1173,7 @@ static void __dss_uninit_ports(struct dss_device *dss, unsigned int num_ports)
 		default:
 			break;
 		}
+		of_node_put(port);
 	}
 }
 
@@ -1205,11 +1206,13 @@ static int dss_init_ports(struct dss_device *dss)
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



