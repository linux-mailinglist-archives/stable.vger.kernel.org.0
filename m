Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CAFA2E394B
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388184AbgL1NWB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:22:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:50398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388140AbgL1NWB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:22:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C98C2076D;
        Mon, 28 Dec 2020 13:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609161680;
        bh=eg4fi6qKnB7mzX9PnPZ8OEhZzr/7dxH8YPQE19RtqU4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TdQz37CwAumBTUb7eai6yjj1juUKvcW9+9In12wXL2RkpqHZzN6j5ZxXLCLEBF/8e
         383jDYNP+4A/RN/boIYhab4PLTtB/mOCRk6bmQLluS4t+yO2apOFmKBKPDvIz29oWp
         yB/c9gMFRYjXgJz/aLeHZ9L/ir+Dl6D1qF4rtmwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Lyude Paul <lyude@redhat.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.19 049/346] drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi
Date:   Mon, 28 Dec 2020 13:46:08 +0100
Message-Id: <20201228124922.160033040@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Xiong <xiongx18@fudan.edu.cn>

commit a34a0a632dd991a371fec56431d73279f9c54029 upstream

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
[sudip: use old functions before rename]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/drm_dp_mst_topology.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -2706,11 +2706,11 @@ bool drm_dp_mst_allocate_vcpi(struct drm
 {
 	int ret;
 
-	port = drm_dp_get_validated_port_ref(mgr, port);
-	if (!port)
+	if (slots < 0)
 		return false;
 
-	if (slots < 0)
+	port = drm_dp_get_validated_port_ref(mgr, port);
+	if (!port)
 		return false;
 
 	if (port->vcpi.vcpi > 0) {
@@ -2725,6 +2725,7 @@ bool drm_dp_mst_allocate_vcpi(struct drm
 	if (ret) {
 		DRM_DEBUG_KMS("failed to init vcpi slots=%d max=63 ret=%d\n",
 				DIV_ROUND_UP(pbn, mgr->pbn_div), ret);
+		drm_dp_put_port(port);
 		goto out;
 	}
 	DRM_DEBUG_KMS("initing vcpi for pbn=%d slots=%d\n",


