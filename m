Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99C29441874
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhKAJru (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:47:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:51430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232077AbhKAJpV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:45:21 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4243A611C3;
        Mon,  1 Nov 2021 09:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635759005;
        bh=kx8NzaheoLqcK/H0E/xap/2zfJs2fmHAzd15T2mc0uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j3Fo6lvlKZKRqR5BIVMe1WD9+O/wndlepy9aOvT36R3/8v2HqIhernhZ6p1VRpR1/
         oP6iB9O+61QQIp0upOLbFbvYv52Ehdza7BqGjUn17wAOXfStXe4Nmm2Snm4TJDXBj2
         QwnQ2LIFAKkiYX7ab33UATYHCvuM+ZwKULmKHR+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 032/125] drm/amd/display: Require immediate flip support for DCN3.1 planes
Date:   Mon,  1 Nov 2021 10:16:45 +0100
Message-Id: <20211101082539.320907363@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 672437486ee9da3ed0e774937e6d0dd570921b39 upstream.

[Why]
Immediate flip can be enabled dynamically and has higher BW requirements
when validating which voltage mode to use.

If we validate when it's not set then potentially DCFCLK will be too low
and we will underflow.

[How]
DM always requires support so always require it as part of DML input
parameters.

This can't be enabled unconditionally on older ASIC because it blocks
some expected modes so only target DCN3.1 for now.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1591,6 +1591,13 @@ static int dcn31_populate_dml_pipes_from
 		pipe = &res_ctx->pipe_ctx[i];
 		timing = &pipe->stream->timing;
 
+		/*
+		 * Immediate flip can be set dynamically after enabling the plane.
+		 * We need to require support for immediate flip or underflow can be
+		 * intermittently experienced depending on peak b/w requirements.
+		 */
+		pipes[pipe_cnt].pipe.src.immediate_flip = true;
+
 		pipes[pipe_cnt].pipe.src.unbounded_req_mode = false;
 		pipes[pipe_cnt].pipe.src.gpuvm = true;
 		pipes[pipe_cnt].pipe.src.dcc_fraction_of_zs_req_luma = 0;


