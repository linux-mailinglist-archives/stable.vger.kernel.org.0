Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E7A60875C
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232184AbiJVIA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbiJVH7N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 03:59:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9129031232;
        Sat, 22 Oct 2022 00:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4F322B82DF6;
        Sat, 22 Oct 2022 07:49:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3288C433C1;
        Sat, 22 Oct 2022 07:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666424969;
        bh=Qx7YqYDAslYo7Yv+XWnm5lJu4CbNEUcbSjGorjTbQ7k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LXP6qcPO8lswE66ETg1coe7vaUvIyd12O/uYLpq3YGFeVqfAn9lD5v92aPB5zgsRB
         9/OyrJobX2gEKLyf296BHQinga8jt4/bi8ZJeg7oHZ0LEA2YpQDm1dU8AqHwo8slmj
         eS0XhaIP6ubs84WPunYpIdd7xzMYh8p9PLH4rMgM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 326/717] drm/omap: dss: Fix refcount leak bugs
Date:   Sat, 22 Oct 2022 09:23:25 +0200
Message-Id: <20221022072509.072284582@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0399f3390a0a..c4febb861910 100644
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



