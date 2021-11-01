Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD48441832
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233473AbhKAJpD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234021AbhKAJnw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 671BB613B3;
        Mon,  1 Nov 2021 09:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758949;
        bh=PM0ehFfKIDOVMm7Ab2SJMwKl2xdbhvey/4y9vTV4Nmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2Sd7FlKZetxSf9LVv2eLLWRUsPc8DphvTgO/fDqglRf6GJc8IYF8Vl6I7raTiF4qy
         gUzx+DhV4qo4J2p/N8t/WM/Ut25rJkX7BvGD1KzrLxxSVmV0vg9OG10Lj/HiLu1myr
         kTvB5xNdibLV/IQtV6jwVaHr/jbO3hdLa7tHo/bQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.14 051/125] drm/amd/display: Fix prefetch bandwidth calculation for DCN3.1
Date:   Mon,  1 Nov 2021 10:17:04 +0100
Message-Id: <20211101082542.870911309@linuxfoundation.org>
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

commit c938aed88f8259dc913b717a32319101c66e87a9 upstream.

[Why]
Prefetch BW calculated is lower than the DML reference because of a
porting error that's excluding cursor and row bandwidth from the
pixel data bandwidth.

[How]
Change the dml_max4 to dml_max3 and include cursor and row bandwidth
in the same calculation as the rest of the pixel data during vactive.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Agustin Gutierrez Sanchez <agustin.gutierrez@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn31/display_mode_vba_31.c
@@ -5399,9 +5399,9 @@ void dml31_ModeSupportAndSystemConfigura
 
 					v->MaximumReadBandwidthWithPrefetch =
 							v->MaximumReadBandwidthWithPrefetch
-									+ dml_max4(
-											v->VActivePixelBandwidth[i][j][k],
-											v->VActiveCursorBandwidth[i][j][k]
+									+ dml_max3(
+											v->VActivePixelBandwidth[i][j][k]
+													+ v->VActiveCursorBandwidth[i][j][k]
 													+ v->NoOfDPP[i][j][k]
 															* (v->meta_row_bandwidth[i][j][k]
 																	+ v->dpte_row_bandwidth[i][j][k]),


