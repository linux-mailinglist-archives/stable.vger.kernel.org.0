Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E83FC24B350
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:45:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729203AbgHTJpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:45:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:42668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729155AbgHTJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:44:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A534722CAF;
        Thu, 20 Aug 2020 09:44:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916643;
        bh=gt9J90YxiTewYRvQZD/vhF0BJRoLAcmDDVwMBuPbrF8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUyX41ON0xqMRsh/IOqdHn7bTLN7pbKJKiPufh1a/X4OA6Ngre/KwBlZdStV1crb+
         t70/dJJXFCola1vRLJBHUBBbkriX3jrWruC2qhT8cvVw/8flFCqPGzewLsln4Dznta
         /iXPN8+mG5KKXZSBem38TC1HkaBTAY21Ni7Itw4U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        Xin Xiong <xiongx18@fudan.edu.cn>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.7 201/204] drm: fix drm_dp_mst_port refcount leaks in drm_dp_mst_allocate_vcpi
Date:   Thu, 20 Aug 2020 11:21:38 +0200
Message-Id: <20200820091616.222343459@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
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
@@ -4319,11 +4319,11 @@ bool drm_dp_mst_allocate_vcpi(struct drm
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
@@ -4339,6 +4339,7 @@ bool drm_dp_mst_allocate_vcpi(struct drm
 	if (ret) {
 		DRM_DEBUG_KMS("failed to init vcpi slots=%d max=63 ret=%d\n",
 			      DIV_ROUND_UP(pbn, mgr->pbn_div), ret);
+		drm_dp_mst_topology_put_port(port);
 		goto out;
 	}
 	DRM_DEBUG_KMS("initing vcpi for pbn=%d slots=%d\n",


