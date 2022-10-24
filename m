Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E31A60B0C5
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230402AbiJXQKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233908AbiJXQJR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:09:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA31386B0;
        Mon, 24 Oct 2022 07:59:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D623B8166A;
        Mon, 24 Oct 2022 12:22:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F04AFC433C1;
        Mon, 24 Oct 2022 12:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666614166;
        bh=xAGYtDTCGYJp30doSFA5cS5oq9dkqvAuxKbbKOD7lIg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2A06cN83U7pA7EdLnWX0KePhYtl1mimOKZFMyor6PZgrZbs/Dc/eQYWSCPduDHemn
         tWS1Pyh6m6WxHB/w5iqpSDJYXSVz55hafugaheVjM/pQwUEQcJhen3XfZMzs+phEA9
         BheOLClp8sYLuW00ydl1vfnttvIY5tY9fhDlYaqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 158/390] drm/omap: dss: Fix refcount leak bugs
Date:   Mon, 24 Oct 2022 13:29:15 +0200
Message-Id: <20221024113029.428485183@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113022.510008560@linuxfoundation.org>
References: <20221024113022.510008560@linuxfoundation.org>
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
index 6ccbc29c4ce4..d5b3123ed081 100644
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



