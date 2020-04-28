Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7211D1BC89B
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730015AbgD1SeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:34:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:50692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730011AbgD1SeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:34:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67EEC2085B;
        Tue, 28 Apr 2020 18:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098841;
        bh=lu+rWn0DuPCOc6t/Q8s2CXZu/8GtE0gGQvraLXW4+mk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Eobwr+Eui/IJTbttVNwjbKWC2kjW2GpgFNNLgC7Hc9og/JIVtnsnfnEOiC70YSTlo
         j5bsD4/Km6bcoz1UoX9XwB0pMMcLhp9QHctv4u9//0ThJc801FqJ9wv41NNKF0nnhy
         Jfh4id444wrd5OjYTaalb8PY97AfwdlIQLwCD+Ss=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikita Lipski <mikita.lipski@amd.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.6 119/167] drm/dp_mst: Zero assigned PBN when releasing VCPI slots
Date:   Tue, 28 Apr 2020 20:24:55 +0200
Message-Id: <20200428182240.281525612@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182225.451225420@linuxfoundation.org>
References: <20200428182225.451225420@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikita Lipski <mikita.lipski@amd.com>

commit 7bfc1fec1af3e2f0194843855b0d49054fa42fd2 upstream.

Zero Port's PBN together with VCPI slots when releasing
allocated VCPI slots. That way when disabling the connector
it will not cause issues in drm_dp_mst_atomic_check verifying
branch bw limit.

Signed-off-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: cd82d82cbc04 ("drm/dp_mst: Add branch bandwidth validation to MST atomic check")
Cc: <stable@vger.kernel.org> # v5.6+
Link: https://patchwork.freedesktop.org/patch/msgid/20200407160717.27976-1-mikita.lipski@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -4290,6 +4290,7 @@ int drm_dp_atomic_release_vcpi_slots(str
 	if (pos->vcpi) {
 		drm_dp_mst_put_port_malloc(port);
 		pos->vcpi = 0;
+		pos->pbn = 0;
 	}
 
 	return 0;


