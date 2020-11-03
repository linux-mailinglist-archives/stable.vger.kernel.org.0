Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D00B82A5678
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732727AbgKCU7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:35036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732560AbgKCU7o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 25FA1223BF;
        Tue,  3 Nov 2020 20:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437183;
        bh=NGI8kfOtgD+B03FqUS/r+/N6XslvOicZxXgEFEfwXSM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zs+P9SBI329CDIAbUKZB5+gh72w1J4ISn/HntqfHfh4j6/U7PS+MEO9ZErgs2zlua
         7pIh18AndS3ghDfVmg4gI5hWgb9ixQGHO4f9d2DRZn7QirZ0MVIOhnDkajJWM0ROV4
         RbtTscoXMNWY6jQzNASIWMkUEl6BylZsf9n87ftU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jay Cornwall <jay.cornwall@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 182/214] drm/amdkfd: Use same SQ prefetch setting as amdgpu
Date:   Tue,  3 Nov 2020 21:37:10 +0100
Message-Id: <20201103203307.760826744@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jay Cornwall <jay.cornwall@amd.com>

commit d56b1980d7efe9ef08469e856fc0703d0cef65e4 upstream.

0 causes instruction fetch stall at cache line boundary under some
conditions on Navi10. A non-zero prefetch is the preferred default
in any case.

Fixes soft hang in Luxmark.

Signed-off-by: Jay Cornwall <jay.cornwall@amd.com>
Reviewed-by: Felix Kuehling <Felix.Kuehling@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c
+++ b/drivers/gpu/drm/amd/amdkfd/kfd_device_queue_manager_v10.c
@@ -58,8 +58,9 @@ static int update_qpd_v10(struct device_
 	/* check if sh_mem_config register already configured */
 	if (qpd->sh_mem_config == 0) {
 		qpd->sh_mem_config =
-				SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
-					SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT;
+			(SH_MEM_ALIGNMENT_MODE_UNALIGNED <<
+				SH_MEM_CONFIG__ALIGNMENT_MODE__SHIFT) |
+			(3 << SH_MEM_CONFIG__INITIAL_INST_PREFETCH__SHIFT);
 #if 0
 		/* TODO:
 		 *    This shouldn't be an issue with Navi10.  Verify.


