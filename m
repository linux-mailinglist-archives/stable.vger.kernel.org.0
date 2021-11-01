Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61A6B441849
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:43:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234469AbhKAJpb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:47992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234069AbhKAJoD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:44:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10997613A1;
        Mon,  1 Nov 2021 09:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758954;
        bh=4V7qoFImzIn0NxruFr6anX4bfZWvBmk8A0gaz+IFVx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aN+uJ75GzZD4vFl7Xxhnw4960vN1lcakuLdg9IrELvpip7PcPAO5CY4xlngDvtlAh
         AJgy7AhR0LjI8F2AjZ6H+ccDHwE1JQFlH1pl5HMWDuW0qvVv/FG+4fDhZEddybtnlX
         +c6ZhCPFeZ74J+w4ddixCUYjHhBuLrYBkAmjWNUU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 052/125] drm/amd/display: increase Z9 latency to workaround underflow in Z9
Date:   Mon,  1 Nov 2021 10:17:05 +0100
Message-Id: <20211101082543.040866268@linuxfoundation.org>
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

From: Eric Yang <Eric.Yang2@amd.com>

commit 4835ea6c173a8d8dfbfdbb21c4cd987d12681610 upstream.

[Why]
Z9 latency is higher than when we originally tuned the watermark
parameters, causing underflow. Increasing the value until the latency
issues is resolved.

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>
Signed-off-by: Eric Yang <Eric.Yang2@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -217,8 +217,8 @@ struct _vcs_dpi_soc_bounding_box_st dcn3
 	.num_states = 5,
 	.sr_exit_time_us = 9.0,
 	.sr_enter_plus_exit_time_us = 11.0,
-	.sr_exit_z8_time_us = 402.0,
-	.sr_enter_plus_exit_z8_time_us = 520.0,
+	.sr_exit_z8_time_us = 442.0,
+	.sr_enter_plus_exit_z8_time_us = 560.0,
 	.writeback_latency_us = 12.0,
 	.dram_channel_width_bytes = 4,
 	.round_trip_ping_latency_dcfclk_cycles = 106,


