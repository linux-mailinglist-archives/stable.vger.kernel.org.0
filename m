Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011D024BE55
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726887AbgHTNXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728301AbgHTJeR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2B9C20724;
        Thu, 20 Aug 2020 09:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916057;
        bh=G9O5B4bLDz3YgKLmYiE6G55P498/DsEZrzkcwiX6g2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VL2iHv3n4M9ta9iUQIUeiARi3PDU3+MkGFi2yuGvISOn/cL/NELl5V85J4ApWMTTb
         F9gHl+nO8I5X7p8i63wD5XlwtboSRadPjTD5Asvk5Y7+nA0q3w4WZ0PvWiun6J69nK
         qdySxZg1WZQa5D6f85aHZhL98hayIXjWZE40gJDo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.8 229/232] drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi
Date:   Thu, 20 Aug 2020 11:21:20 +0200
Message-Id: <20200820091623.866683973@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

commit a34a0a632dd991a371fec56431d73279f9c54029 upstream.

drm_dp_mst_allocate_vcpi() invokes
drm_dp_mst_topology_get_port_validated(), which increases the refcount
of the "port".

These reference counting issues take place in two exception handling
paths separately. Either when “slots” is less than 0 or when
drm_dp_init_vcpi() returns a negative value, the function forgets to
reduce the refcnt increased drm_dp_mst_topology_get_port_validated(),
which results in a refcount leak.

Fix these issues by pulling up the error handling when "slots" is less
than 0, and calling drm_dp_mst_topology_put_port() before termination
when drm_dp_init_vcpi() returns a negative value.

Fixes: 1e797f556c61 ("drm/dp: Split drm_dp_mst_allocate_vcpi")
Cc: <stable@vger.kernel.org> # v4.12+
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: Xin Xiong <xiongx18@fudan.edu.cn>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200719154545.GA41231@xin-virtual-machine
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4262,11 +4262,11 @@ bool drm_dp_mst_allocate_vcpi(struct drm
 {
 	int ret;
 
-	port = drm_dp_mst_topology_get_port_validated(mgr, port);
-	if (!port)
+	if (slots < 0)
 		return false;
 
-	if (slots < 0)
+	port = drm_dp_mst_topology_get_port_validated(mgr, port);
+	if (!port)
 		return false;
 
 	if (port->vcpi.vcpi > 0) {
@@ -4282,6 +4282,7 @@ bool drm_dp_mst_allocate_vcpi(struct drm
 	if (ret) {
 		DRM_DEBUG_KMS("failed to init vcpi slots=%d max=63 ret=%d\n",
 			      DIV_ROUND_UP(pbn, mgr->pbn_div), ret);
+		drm_dp_mst_topology_put_port(port);
 		goto out;
 	}
 	DRM_DEBUG_KMS("initing vcpi for pbn=%d slots=%d\n",


